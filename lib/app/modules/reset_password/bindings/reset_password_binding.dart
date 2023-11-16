import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_bindings.dart';

import '../controllers/reset_password_controller.dart';

class ResetPasswordBinding extends BaseBindings {
  @override
  void injectService() {
    Get.lazyPut<ResetPasswordController>(
      () => ResetPasswordController(),
    );
  }
}
