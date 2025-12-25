import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:veersa_health/bindings/general_bindings.dart';
import 'package:veersa_health/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:veersa_health/features/authentication/screens/login/login_screen.dart';
import 'package:veersa_health/utils/theme/theme.dart';

Future<void> main() async {
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();
      Get.put(OnBoardingController());
  if (!kIsWeb) {
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  }
  await GetStorage.init();
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Veersa Health',
      initialBinding: GeneralBindings(),
      theme: CustomAppTheme.appTheme,
      home:LoginScreen(),
    );
  }
}

