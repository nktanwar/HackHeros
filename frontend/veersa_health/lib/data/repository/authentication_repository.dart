import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:veersa_health/features/authentication/screens/login/login_screen.dart';
import 'package:veersa_health/features/authentication/screens/onboarding/onboarding_screen.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  //Variables
  final deviceStorage = GetStorage();

  //Called from main.dart
  @override
  void onReady() async {
    super.onReady();
    FlutterNativeSplash.remove();
    await screenRedirect();
  }

  Future<void> screenRedirect() async {
    // final user = authUser;
    // if (user != null) {
    //   //Check if email is verified
    //   if (user.emailVerified) {
    //     //Initialize User specific storage
    //     await LocalStorageUtility.init(user.uid);
    //     //Email is verified
    //     Get.offAll(() => const NavigationMenu());
    //   } else {
    //     Get.offAll(() => VerifyEmailScreen(email: authUser?.email));
    //   }
    // } else {

    deviceStorage.writeIfNull('isFirstTime', true);
    //Check if user is already logged in
    deviceStorage.read('isFirstTime') != true
        ? Get.offAll(() => const LoginScreen())
        : Get.offAll(() => const OnBoardingScreen());
  }


  

    Future<void> sendOTP(String email) async {
      try {
      } catch(e){}
    }

    Future<void> login(String email, String password) async{
      try {
        
      } catch (e) {}
    }
    
    


    // Logout User
    Future<void> logout() async {
      try {
        Get.offAll(() => const LoginScreen());
      } catch(e){}
    }

   
  }
