import 'package:get/get.dart';
import 'package:veersa_health/data/repository/authentication_repository.dart';
import 'package:veersa_health/data/repository/user_repository.dart';
import 'package:veersa_health/features/authentication/screens/login/login_screen.dart';
import 'package:veersa_health/features/personalisation/models/user_model.dart';
import 'package:veersa_health/utils/constants/image_string_constants.dart';
import 'package:veersa_health/utils/loaders/loaders.dart';
import 'package:veersa_health/utils/loaders/full_screen_loader.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  final _userRepo = Get.put(UserRepository());
  final _authRepo = AuthenticationRepository.instance;

  var isLoading = false.obs;
  var user = UserModel.empty().obs;

  String get name =>
      user.value.name.isNotEmpty ? user.value.name : "Veersa User";
  String get email =>
      user.value.email.isNotEmpty ? user.value.email : "user@veersa.com";
  String get phone =>
      user.value.phoneNumber.isNotEmpty ? "+91 ${user.value.phoneNumber}" : "";

  final profileImage = ImageStringsConstants.avatar5.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;
      final userDetails = await _userRepo.getUserDetails();
      user.value = userDetails;
    } catch (e) {
      CustomLoaders.warningSnackBar(
        title: 'Data Error',
        message: 'Could not load profile data',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void logout() async {
    try {
      CustomFullScreenLoader.openLoadingDialog(
        "Logging you out...",
        ImageStringsConstants.loadingImage,
      );

      await _authRepo.logout();

      CustomFullScreenLoader.closeLoadingDialog();
      Get.offAll(() => LoginScreen());
    } catch (e) {
      CustomFullScreenLoader.closeLoadingDialog();
      CustomLoaders.errorSnackBar(title: "Error", message: e.toString());
    }
  }
}
