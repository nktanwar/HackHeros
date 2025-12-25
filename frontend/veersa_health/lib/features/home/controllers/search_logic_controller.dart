
import 'package:get/get.dart';
import 'package:veersa_health/features/home/models/doctor_model.dart';
import 'package:veersa_health/utils/constants/image_string_constants.dart';

enum SortOption { lowestFees, nearest }

class SearchLogicController extends GetxController {
  
  var searchText = ''.obs;
  var selectedSpeciality = Rxn<String>(); 
  var selectedSort = Rxn<SortOption>(); 
  
  
  var allDoctors = <DoctorModel>[].obs;
  
  
  var filteredDoctors = <DoctorModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadMockData();
    
    everAll([searchText, selectedSpeciality, selectedSort], (_) => _applyFilters());
  }

  
  
  
  int get activeFilterCount {
    int count = 0;
    if (selectedSpeciality.value != null) count++;
    if (selectedSort.value != null) count++;
    return count;
  }

  
  
  
  bool get showResultsView => searchText.value.isNotEmpty || activeFilterCount > 0;

  

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
  }

  

  void _applyFilters() {
    List<DoctorModel> temp = List.from(allDoctors);

    
    if (selectedSpeciality.value != null) {
      temp = temp.where((d) => d.speciality == selectedSpeciality.value).toList();
    }

    
    if (searchText.value.isNotEmpty) {
      temp = temp.where((d) => d.name.toLowerCase().contains(searchText.value.toLowerCase())).toList();
    }

    
    if (selectedSort.value == SortOption.lowestFees) {
      temp.sort((a, b) => a.fees.compareTo(b.fees));
    } else if (selectedSort.value == SortOption.nearest) {
      temp.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    }

    filteredDoctors.assignAll(temp);
  }

  void _loadMockData() {
    
    allDoctors.assignAll([
      DoctorModel(id: '1', name: "Dr. Priya Garg", speciality: "Dentist", image: ImageStringsConstants.avatar4, distanceKm: 10, fees: 80),
      DoctorModel(id: '2', name: "Dr. Kanti", speciality: "Hepatologist", image: ImageStringsConstants.avatar2, distanceKm: 2, fees: 150),
      DoctorModel(id: '3', name: "Dr. John Doe", speciality: "Dentist", image: ImageStringsConstants.avatar3, distanceKm: 25, fees: 60),
      DoctorModel(id: '4', name: "Dr. Smith", speciality: "Oncology", image: ImageStringsConstants.avatar1, distanceKm: 5, fees: 200),
    ]);
    filteredDoctors.assignAll(allDoctors);
  }
}