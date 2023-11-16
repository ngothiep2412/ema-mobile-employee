import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_bindings.dart';

import '../controllers/check_in_controller.dart';

class CheckInBinding extends BaseBindings {
  @override
  void injectService() {
    Get.lazyPut<CheckInController>(
      () => CheckInController(),
    );
  }
}
