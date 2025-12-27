import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:veersa_health/data/repository/home_repository.dart';
import 'package:veersa_health/features/home/controllers/home_controller.dart';
import 'package:veersa_health/features/home/models/doctor_model.dart';

enum SortOption { nearest }

class SearchLogicController extends GetxController {
  final _repo = HomeRepository();

  var searchText = ''.obs;
  var selectedSpeciality = Rxn<String>();
  var selectedSort = Rxn<SortOption>();
  var searchRadius = 100.0.obs;

  var _cachedAllDoctors = <DoctorModel>[];
  var filteredDoctors = <DoctorModel>[].obs;
  var errorMessage = ''.obs;

  var isLoading = true.obs;
  var isFiltering = false.obs;
  var forceShowList = false.obs;

  Timer? _debounceTimer;

  bool get showResultsView =>
      searchText.value.isNotEmpty ||
      selectedSpeciality.value != null ||
      selectedSort.value != null ||
      forceShowList.value;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      List<DoctorModel> doctors = [];

      try {
        doctors = await _repo.getAllDoctors(page: 0, size: 50);
      } catch (e) {
        debugPrint("SearchController: API fetch failed: $e");
      }

      if (doctors.isEmpty) {
        if (Get.isRegistered<HomeController>()) {
          final homeCtrl = Get.find<HomeController>();
          if (homeCtrl.nearbyDoctors.isNotEmpty) {
            debugPrint(
              "SearchController: Recovering data from HomeController...",
            );
            doctors = List.from(homeCtrl.nearbyDoctors);
          }
        }
      }

    if (doctors.isNotEmpty) {
        debugPrint("--- DEBUG: DOCTORS IN CACHE ---");
        for (var d in doctors) {
          debugPrint("Doc: ${d.clinicName} | Speciality: '${d.specialty}'");
        }
        debugPrint("-------------------------------");
      } else {
        debugPrint("--- DEBUG: NO DOCTORS FOUND IN CACHE ---");
      }
      try {
        Position userPos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        for (var doc in doctors) {
          double distMeters = Geolocator.distanceBetween(
            userPos.latitude,
            userPos.longitude,
            doc.latitude,
            doc.longitude,
          );
          doc.distanceInKm = distMeters / 1000;
        }
        doctors.sort((a, b) => a.distanceInKm.compareTo(b.distanceInKm));
      } catch (locationError) {
        debugPrint("Location error: $locationError");
      }

      _cachedAllDoctors = doctors;

      _processArguments();

      filteredDoctors.assignAll(_cachedAllDoctors);

      if (forceShowList.value || selectedSpeciality.value != null) {
        applyFilters();
      }
    } catch (e) {
      debugPrint("CRITICAL: Initial Data Load Failed: $e");
      errorMessage.value = "Could not load doctors.";
    } finally {
      isLoading.value = false;
    }
  }

  void _processArguments() {
    final args = Get.arguments;
    if (args != null) {
      if (args['speciality'] != null) {
        selectedSpeciality.value = args['speciality'];
        forceShowList.value = true;
      }
      if (args['showList'] == true) forceShowList.value = true;
      if (args['sortBy'] == 'distance') selectedSort.value = SortOption.nearest;
    }
  }

  void updateSearchQuery(String query) {
    searchText.value = query;
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(
      const Duration(milliseconds: 300),
      () => applyFilters(),
    );
  }

  void setSpeciality(String? speciality) {
    selectedSpeciality.value = speciality;
    applyFilters();
  }

  void setSortOption(SortOption? option) {
    selectedSort.value = option;
    applyFilters();
  }

  void updateRadius(double val) {
    searchRadius.value = val;
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(
      const Duration(milliseconds: 300),
      () => applyFilters(),
    );
  }

  void clearAllFilters() {
    searchText.value = '';
    selectedSpeciality.value = null;
    selectedSort.value = null;
    searchRadius.value = 100.0;
    forceShowList.value = false;
    errorMessage.value = '';
    applyFilters();
  }

  int get activeFilterCount {
    int count = 0;
    if (selectedSpeciality.value != null) count++;
    if (selectedSort.value != null) count++;
    if (searchRadius.value != 100.0) count++;
    return count;
  }

  Future<void> applyFilters() async {
    isFiltering.value = true;
    errorMessage.value = '';
    try {
      List<DoctorModel> results = List.from(_cachedAllDoctors);
      debugPrint("FILTER START: Cache size: ${_cachedAllDoctors.length}");

      bool needsApiCall =
          selectedSpeciality.value != null || searchRadius.value < 100.0;

      if (needsApiCall) {
        try {
          Position userPos = await Geolocator.getCurrentPosition();

          final apiResults = await _repo.searchDoctors(
            latitude: userPos.latitude,
            longitude: userPos.longitude,
            maxDistanceKm: searchRadius.value,
            specialty: selectedSpeciality.value,
          );

          debugPrint("API SUCCESS: Found ${apiResults.length} matches");
          
          if (apiResults.isEmpty && selectedSpeciality.value != null) {
             debugPrint("API returned 0. Checking local cache for match...");
             var localMatches = _fallbackLocalFilter(_cachedAllDoctors);
             
             if (localMatches.isNotEmpty) {
               debugPrint("Local cache found ${localMatches.length} matches! Ignoring API result.");
               results = localMatches;
             } else {
               results = []; 
             }
          } else {
             final Set<String> validIds = apiResults.map((e) => e.doctorId).toSet();
             final Map<String, double> distanceMap = {
                for (var e in apiResults) e.doctorId: e.distanceInKm,
             };
             
             results = results.where((doc) => validIds.contains(doc.doctorId)).toList();

             for (var doc in results) {
               if (distanceMap.containsKey(doc.doctorId)) {
                 doc.distanceInKm = distanceMap[doc.doctorId]!;
               }
             }
          }

        } catch (e) {
          debugPrint("API Failed ($e). Falling back to local filtering.");
          results = _fallbackLocalFilter(_cachedAllDoctors);
          debugPrint(
            "FALLBACK RESULT: ${results.length} doctors found locally",
          );
        }
      } else {
        results = results
            .where((d) => d.distanceInKm <= searchRadius.value)
            .toList();
      }

      if (searchText.value.isNotEmpty) {
        String query = searchText.value.toLowerCase();
        results = results.where((d) {
          return d.clinicName.toLowerCase().contains(query) ||
              d.specialty.toLowerCase().contains(query);
        }).toList();
      }

      if (selectedSort.value == SortOption.nearest) {
        results.sort((a, b) => a.distanceInKm.compareTo(b.distanceInKm));
      }

      filteredDoctors.assignAll(results);
    } catch (e) {
      debugPrint("Filter Logic Error: $e");
      errorMessage.value = "Something went wrong";
    } finally {
      isFiltering.value = false;
    }
  }

  List<DoctorModel> _fallbackLocalFilter(List<DoctorModel> sourceList) {
    var temp = List<DoctorModel>.from(sourceList);

    if (searchRadius.value < 100.0) {
      temp = temp.where((d) => d.distanceInKm <= searchRadius.value).toList();
    }

    if (selectedSpeciality.value != null) {
      temp = temp
          .where(
            (d) =>
                d.specialty.toLowerCase() ==
                selectedSpeciality.value!.toLowerCase(),
          )
          .toList();
    }
    return temp;
  }
}
