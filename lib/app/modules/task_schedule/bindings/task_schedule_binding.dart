import 'package:get/get.dart';

import '../controllers/task_schedule_controller.dart';

class TaskScheduleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskScheduleController>(
      () => TaskScheduleController(),
    );
  }
}
