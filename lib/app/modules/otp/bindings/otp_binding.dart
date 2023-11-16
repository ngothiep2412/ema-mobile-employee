import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_bindings.dart';

import '../controllers/otp_controller.dart';

class OtpBinding extends BaseBindings {
  @override
  void injectService() {
    Get.lazyPut<OtpController>(
      () => OtpController(),
    );
  }
}
