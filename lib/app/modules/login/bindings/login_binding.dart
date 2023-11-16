import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_bindings.dart';

import '../controllers/login_controller.dart';

class LoginBinding extends BaseBindings {
  @override
  void injectService() {
    Get.lazyPut<LoginController>(
      () => LoginController(),
    );
  }
}
