import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_bindings.dart';

import '../controllers/task_detail_view_controller.dart';

class TaskDetailViewBinding extends BaseBindings {
  String taskID = '';
  @override
  void injectService() {
    taskID = Get.arguments["taskID"] as String;
    Get.put(
      TaskDetailViewController(taskID: taskID),
    );
  }
}
