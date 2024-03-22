import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_bindings.dart';
import 'package:hrea_mobile_employee/app/modules/budget/model/budget_model.dart';
import '../controllers/budget_detail_controller.dart';

class BudgetDetailBinding extends BaseBindings {
  String transactionID = '';
  bool isNotiNavigate = false;
  @override
  void injectService() {
    transactionID = Get.arguments["transactionID"] as String;
    isNotiNavigate = Get.arguments["isNotiNavigate"] as bool;

    Get.put(
      BudgetDetailController(transactionID: transactionID, isNotiNavigate: isNotiNavigate),
    );
  }
}
