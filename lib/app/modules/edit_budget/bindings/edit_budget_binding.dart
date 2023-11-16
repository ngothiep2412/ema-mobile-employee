import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_bindings.dart';
import 'package:hrea_mobile_employee/app/modules/budget/model/budget_model.dart';

import '../controllers/edit_budget_controller.dart';

class EditBudgetBinding extends BaseBindings {
  Rx<BudgetModel> budget = BudgetModel().obs;
  String eventID = '';
  @override
  void injectService() {
    eventID = Get.arguments["eventID"] as String;
    budget = Get.arguments["budget"] as Rx<BudgetModel>;
    Get.lazyPut<EditBudgetController>(
      () => EditBudgetController(budget: budget, eventID: eventID),
    );
  }
}
