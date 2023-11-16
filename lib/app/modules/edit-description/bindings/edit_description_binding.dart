import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_bindings.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/task.dart';

import '../controllers/edit_description_controller.dart';

class EditDescriptionBinding extends BaseBindings {
  // Rx<QuillController> quillController = QuillController.basic().obs;
  Rx<TaskModel> taskModel = TaskModel().obs;
  bool isSubTask = false;
  // String description = '';
  @override
  void injectService() {
    // quillController = Get.arguments['quillController'] as Rx<QuillController>;
    taskModel = Get.arguments['taskModel'] as Rx<TaskModel>;
    taskModel = Get.arguments['taskModel'] as Rx<TaskModel>;
    isSubTask = Get.arguments['isSubtask'] as bool;
    // description = Get.arguments['description'] as String;
    Get.put(
      EditDescriptionController(
          // description: description,
          // quillController: quillController,
          taskModel: taskModel,
          isSubTask: isSubTask),
    );
  }
}
