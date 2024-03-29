import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_bindings.dart';
import '../controllers/budget_detail_controller.dart';

class BudgetDetailBinding extends BaseBindings {
  String transactionID = '';
  bool isNotiNavigate = false;
  bool statusTask = false;
  @override
  void injectService() {
    transactionID = Get.arguments["transactionID"] as String;
    isNotiNavigate = Get.arguments["isNotiNavigate"] as bool;
    statusTask = Get.arguments["statusTask"] as bool;

    Get.put(
      BudgetDetailController(transactionID: transactionID, isNotiNavigate: isNotiNavigate, statusTask: statusTask),
    );
  }
}
