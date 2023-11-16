import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_bindings.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/request.dart';

import '../controllers/edit_request_controller.dart';

class EditRequestBinding extends BaseBindings {
  String requestID = '';
  Rx<RequestModel> requestModel = RequestModel().obs;
  @override
  void injectService() {
    requestID = Get.arguments["requestID"] as String;
    requestModel = Get.arguments["request"] as Rx<RequestModel>;
    Get.lazyPut<EditRequestController>(
      () => EditRequestController(requestID: requestID, requestModel: requestModel),
    );
  }
}
