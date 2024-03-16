import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_employee/app/base/base_controller.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/task.dart';
import 'package:hrea_mobile_employee/app/modules/task-detail-view/api/task_detail_api.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TimelineReassignController extends BaseController {
  TimelineReassignController({required this.taskID});
  String taskID = '';

  String jwt = '';
  String idUser = '';

  RxBool isLoading = false.obs;
  RxBool checkView = true.obs;

  Rx<TaskModel> taskModel = TaskModel().obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await getListTask();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void checkToken() {
    if (GetStorage().read('JWT') != null) {
      jwt = GetStorage().read('JWT');
      Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt);
      idUser = decodedToken['id'];
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  Future<void> getListTask() async {
    try {
      isLoading.value = true;
      checkToken();

      taskModel.value = await TaskDetailApi.getTaskDetail(jwt, taskID);
      taskModel.value.assignTasks!
          // Sắp xếp các công việc từ mới nhất đến cũ nhất dựa trên createdAt
          .sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      checkView.value = false;
    }
  }

  Future<void> refreshPage() async {
    checkView.value = true;
    isLoading.value = true;
    await getListTask();
    isLoading.value = false;
  }
}
