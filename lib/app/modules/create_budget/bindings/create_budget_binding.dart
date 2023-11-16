import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_bindings.dart';
import '../controllers/create_budget_controller.dart';

class CreateBudgetBinding extends BaseBindings {
  String eventID = '';
  @override
  void injectService() {
    eventID = Get.arguments["eventID"] as String;
    Get.lazyPut<CreateBudgetController>(
      () => CreateBudgetController(eventID: eventID),
    );
  }
}
