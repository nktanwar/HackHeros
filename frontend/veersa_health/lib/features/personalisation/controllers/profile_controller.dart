import 'package:get/get.dart';
import 'package:veersa_health/data/repository/authentication_repository.dart';
import 'package:veersa_health/data/repository/user_repository.dart';
import 'package:veersa_health/features/personalisation/models/user_model.dart';
import 'package:veersa_health/utils/constants/image_string_constants.dart';
import 'package:veersa_health/utils/loaders/loaders.dart';
import 'package:veersa_health/utils/popups/full_screen_loader.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  // Repositories
  final _userRepo = Get.put(UserRepository());
  final _authRepo = AuthenticationRepository.instance;

  // Observables
  var isLoading = false.obs;
  var user = UserModel.empty().obs;
  
  // UI Helpers (Getters to keep UI clean)
  String get name => user.value.name.isNotEmpty ? user.value.name : "Veersa User";
  String get email => user.value.email.isNotEmpty ? user.value.email : "user@veersa.com";
  String get phone => user.value.phoneNumber.isNotEmpty ? "+91 ${user.value.phoneNumber}" : "";
  
  // Profile Image (Static for now as API doesn't return one)
  final profileImage = ImageStringsConstants.avatar5.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  /// 1. Fetch Profile Data from Backend
  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;
      final userDetails = await _userRepo.getUserDetails();
      user.value = userDetails;
    } catch (e) {
      // Silent error or show snackbar
      // CustomLoaders.warningSnackBar(title: 'Data Error', message: 'Could not load profile data');
    } finally {
      isLoading.value = false;
    }
  }

  /// 2. Logout Logic
  void logout() async {
    try {
      CustomFullScreenLoader.openLoadingDialog(
        "Logging you out...",
        ImageStringsConstants.loadingImage,
      );

      // Call repository logout to clear tokens/storage
      await _authRepo.logout(); 

      CustomFullScreenLoader.closeLoadingDialog();
      // Navigation is handled inside AuthenticationRepository usually, 
      // but if not, Get.offAll(() => LoginScreen()) happens there.
      
    } catch (e) {
      CustomFullScreenLoader.closeLoadingDialog();
      CustomLoaders.errorSnackBar(title: "Error", message: e.toString());
    }
  }
}