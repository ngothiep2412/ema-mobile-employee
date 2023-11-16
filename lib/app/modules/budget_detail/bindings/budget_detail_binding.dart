import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_bindings.dart';
import 'package:hrea_mobile_employee/app/modules/budget/model/budget_model.dart';
import '../controllers/budget_detail_controller.dart';

class BudgetDetailBinding extends BaseBindings {
  String eventID = '';
  BudgetModel budget = BudgetModel();
  @override
  void injectService() {
    eventID = Get.arguments["eventID"] as String;
    budget = Get.arguments["budget"] as BudgetModel;
    Get.put(
      BudgetDetailController(eventID: eventID, budget: budget),
    );
  }
}
