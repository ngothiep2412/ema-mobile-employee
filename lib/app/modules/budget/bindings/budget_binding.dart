import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_bindings.dart';
import '../controllers/budget_controller.dart';

class BudgetBinding extends BaseBindings {
  String taskID = '';
  bool statusTask = false;
  @override
  void injectService() {
    taskID = Get.arguments["taskID"] as String;
    statusTask = Get.arguments["statusTask"] as bool;
    Get.lazyPut<BudgetController>(
      () => BudgetController(taskID: taskID, statusTask: statusTask),
    );
  }
}
