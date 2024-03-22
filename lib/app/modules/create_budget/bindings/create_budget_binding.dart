import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_bindings.dart';
import '../controllers/create_budget_controller.dart';

class CreateBudgetBinding extends BaseBindings {
  String taskID = '';
  @override
  void injectService() {
    taskID = Get.arguments["taskID"] as String;
    Get.lazyPut<CreateBudgetController>(
      () => CreateBudgetController(taskID: taskID),
    );
  }
}
