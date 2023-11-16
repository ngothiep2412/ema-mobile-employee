import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_bindings.dart';

import '../controllers/splash_screen_controller.dart';

class SplashScreenBinding extends BaseBindings {
  @override
  void injectService() {
    Get.put(
      SplashScreenController(),
    );
  }
}
