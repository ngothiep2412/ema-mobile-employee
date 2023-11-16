import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_bindings.dart';

import '../controllers/reset_password_successfully_controller.dart';

class ResetPasswordSuccessfullyBinding extends BaseBindings {
  @override
  void injectService() {
    Get.lazyPut<ResetPasswordSuccessfullyController>(
      () => ResetPasswordSuccessfullyController(),
    );
  }
}
