import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_bindings.dart';

import '../controllers/policy_controller.dart';

class PolicyBinding extends BaseBindings {
  @override
  void injectService() {
    Get.lazyPut<PolicyController>(
      () => PolicyController(),
    );
  }
}
