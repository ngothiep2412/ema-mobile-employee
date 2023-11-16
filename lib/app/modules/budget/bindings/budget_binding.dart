import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_bindings.dart';
import '../controllers/budget_controller.dart';

class BudgetBinding extends BaseBindings {
  String eventID = '';
  @override
  void injectService() {
    eventID = Get.arguments["eventID"] as String;
    Get.put(
      BudgetController(eventID: eventID),
    );
  }
}
