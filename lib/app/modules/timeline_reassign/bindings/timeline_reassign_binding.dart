import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_bindings.dart';

import '../controllers/timeline_reassign_controller.dart';

class TimelineReassignBinding extends BaseBindings {
  String taskID = '';

  @override
  void injectService() {
    taskID = Get.arguments["taskID"] as String;
    Get.lazyPut<TimelineReassignController>(
      () => TimelineReassignController(taskID: taskID),
    );
  }
}
