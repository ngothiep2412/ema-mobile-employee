import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_bindings.dart';

import '../controllers/subtask_detail_view_controller.dart';

class SubtaskDetailViewBinding extends BaseBindings {
  String taskID = '';
  bool isNavigateDetail = false;
  DateTime? endDateTaskParent;
  DateTime? startDateTaskParent;

  @override
  void injectService() {
    taskID = Get.arguments["taskID"] as String;
    isNavigateDetail = Get.arguments["isNavigateDetail"] as bool;
    endDateTaskParent = Get.arguments["endDate"] as DateTime;
    startDateTaskParent = Get.arguments["startDate"] as DateTime;
    Get.put(
      SubtaskDetailViewController(
          taskID: taskID, isNavigateDetail: isNavigateDetail, endDateTaskParent: endDateTaskParent!, startDateTaskParent: startDateTaskParent!),
    );
  }
}
