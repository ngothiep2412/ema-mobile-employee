import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_bindings.dart';

import '../controllers/request_detail_controller.dart';

class RequestDetailBinding extends BaseBindings {
  String requestID = '';

  @override
  void injectService() {
    requestID = Get.arguments["requestID"] as String;
    Get.put(
      RequestDetailController(requestID: requestID),
    );
  }
}
