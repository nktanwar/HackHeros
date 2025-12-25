import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:veersa_health/data/repository/home_repository.dart';
import 'package:veersa_health/features/home/controllers/home_controller.dart';
import 'package:veersa_health/features/home/models/doctor_model.dart';

enum SortOption { lowestFees, nearest }

class SearchLogicController extends GetxController {
  final _repo = HomeRepository();
  final _homeController = Get.find<HomeController>();

  // --- Observables ---
  var searchText = ''.obs;
  var selectedSpeciality = Rxn<String>(); 
  var selectedSort = Rxn<SortOption>(); 
  var isLoading = false.obs;

  // 1. Raw Results from API (The "Master" List)
  var _apiResults = <DoctorModel>[].obs;
  
  // 2. Final Filtered List for UI (After local Search & Sort)
  var filteredDoctors = <DoctorModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Load initial data from Home Controller (so screen isn't empty)
    _apiResults.assignAll(_homeController.nearbyDoctors);
    applyClientSideFilters(); // Initial sort/filter

    // Listeners: 
    // If Specialty changes -> Call API
    ever(selectedSpeciality, (_) => fetchFromApi());
    
    // If Text or Sort changes -> Filter Locally
    everAll([searchText, selectedSort, _apiResults], (_) => applyClientSideFilters());
  }

  // --- Getters ---
  int get activeFilterCount {
    int count = 0;
    if (selectedSpeciality.value != null) count++;
    if (selectedSort.value != null) count++;
    return count;
  }

  bool get showResultsView => searchText.value.isNotEmpty || activeFilterCount > 0;

  // --- Actions ---
  void updateSearchQuery(String query) {
    searchText.value = query;
  }

  void setSpeciality(String? speciality) {
    selectedSpeciality.value = speciality;
  }

  void setSortOption(SortOption? option) {
    selectedSort.value = option;
  }

  void clearAllFilters() {
    searchText.value = '';
    selectedSpeciality.value = null;
    selectedSort.value = null;
    // Reset to home data
    _apiResults.assignAll(_homeController.nearbyDoctors);
  }

  // --- CORE LOGIC 1: Server Side (Fetch Data) ---
  Future<void> fetchFromApi() async {
    if (_homeController.currentLat == null) return;

    isLoading.value = true;
    try {
      // API Filter: Only handles Location & Specialty
      List<DoctorModel> doctors = await _repo.getNearbyDoctors(
        _homeController.currentLat!, 
        _homeController.currentLng!,
        specialty: selectedSpeciality.value
      );
      
      _apiResults.assignAll(doctors); // Update Master List
      
    } catch (e) {
      debugPrint("API Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // --- CORE LOGIC 2: Client Side (Search & Sort) ---
  void applyClientSideFilters() {
    List<DoctorModel> temp = List.from(_apiResults);

    // 1. Filter by Name (Search Text)
    if (searchText.value.isNotEmpty) {
      temp = temp.where((d) => 
        d.clinicName.toLowerCase().contains(searchText.value.toLowerCase()) || 
        d.specialty.toLowerCase().contains(searchText.value.toLowerCase())
      ).toList();
    }

    // 2. Sort (Fees or Distance)
    if (selectedSort.value == SortOption.lowestFees) {
      temp.sort((a, b) => a.fees.compareTo(b.fees));
    } else if (selectedSort.value == SortOption.nearest) {
      temp.sort((a, b) => a.distanceInKm.compareTo(b.distanceInKm));
    }

    filteredDoctors.assignAll(temp);
  }
}