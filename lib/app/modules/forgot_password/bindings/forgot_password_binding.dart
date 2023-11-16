import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_bindings.dart';

import '../controllers/forgot_password_controller.dart';

class ForgotPasswordBinding extends BaseBindings {
  @override
  void injectService() {
    Get.lazyPut<ForgotPasswordController>(
      () => ForgotPasswordController(),
    );
  }
}
