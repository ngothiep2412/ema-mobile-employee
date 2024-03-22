import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_employee/app/base/base_controller.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/task.dart';
import 'package:hrea_mobile_employee/app/modules/task-overall-view/api/task_overall_api.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TaskOverallViewController extends BaseController {
  TaskOverallViewController({required this.eventID, required this.eventName});

  DateFormat dateFormat = DateFormat('dd/MM/yyyy', 'vi');

  String eventID = '';
  String eventName = '';

  RxList<TaskModel> listTask = <TaskModel>[].obs;

  RxBool isLoading = false.obs;

  RxBool checkView = true.obs;

  RxList<String> filterList = <String>[
    "Không chọn",
    "Ngày tạo (Tăng dần)",
    "Ngày tạo (Giảm dần)",
    "Hạn hoàn thành (Tăng dần)",
    "Hạn hoàn thành (Giảm dần)",
    "Mức độ ưu tiên (Tăng dần)",
    "Mức độ ưu tiên (Giảm dần)",
  ].obs;

  RxString filterChoose = ''.obs;
  String jwt = '';

  Future<void> refreshPage() async {
    listTask.clear();
    checkView.value = true;
    jwt = GetStorage().read('JWT');
    isLoading.value = true;
    await getListTask();
    isLoading.value = false;
  }

  Future<void> getTaskDetail(TaskModel taskModel) async {
    // Get.put(SubtaskDetailViewController(taskID: taskModel.id!, isNavigateDetail: false));

    // bool check = await Get.find<SubtaskDetailViewController>().checkTaskForUser();
    // if (check) {
    // print('taskMOdel id ${taskModel.id}');
    Get.toNamed(Routes.SUBTASK_DETAIL_VIEW, arguments: {"taskID": taskModel.id, "isNavigateDetail": true, "isScheduleOverall": false});
    // } else {
    // Get.snackbar('Thông báo', 'Công việc này không khả dụng nữa',
    // snackPosition: SnackPosition.TOP, backgroundColor: Colors.transparent, colorText: ColorsManager.textColor);
    // }
  }

  Future<void> getListTask() async {
    try {
      String jwt = GetStorage().read('JWT');
      isLoading.value = true;
      Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt);
      listTask.clear();
      List<TaskModel> list = [];
      list = await TaskOverallApi.getTask(jwt, eventID);
      if (list.isNotEmpty) {
        for (var item in list) {
          // if (item.assignTasks!.isNotEmpty) {
          //   if (item.parent == null && item.status != Status.CANCEL && item.assignTasks![0].user!.id == decodedToken['id']) {
          //     listTask.add(item);
          //   }
          // }

          if (item.assignTasks!.isNotEmpty) {
            if (item.parent == null && item.status != Status.CANCEL) {
              if (item.subTask!.isNotEmpty) {
                for (var subTask in item.subTask!) {
                  subTask.parent = TaskModel();
                  subTask.parent!.title = item.title;
                  for (var assignee in subTask.assignTasks!) {
                    if (assignee.user!.id == decodedToken['id'] && assignee.status == 'active') {
                      listTask.add(subTask);
                    }
                  }
                }
              }
            }
          }
          // listTask.add(item);
        }
        // listTask.sort((a, b) => a.endDate!.compareTo(b.endDate!));
        // filterChoose.value = '';
        listTask.sort((a, b) {
          // Xử lý trường hợp startDate là null
          if (a.startDate == null && b.startDate != null) {
            return -1; // Đưa a lên đầu nếu a.startDate là null và b.startDate không phải là null.
          } else if (a.startDate != null && b.startDate == null) {
            return 1; // Đưa b lên đầu nếu b.startDate là null và a.startDate không phải là null.
          } else if (a.startDate == null && b.startDate == null) {
            return 0; // Nếu cả hai đều là null, không cần sắp xếp.
          }

          // So sánh ngày nếu cả hai đều không phải là null
          int dateComparison = a.startDate!.compareTo(b.startDate!);
          if (dateComparison != 0) {
            return dateComparison; // Trả về kết quả nếu ngày không giống nhau.
          } else {
            // Sắp xếp theo độ ưu tiên nếu ngày giống nhau
            final priorityOrder = {Priority.HIGH: 0, Priority.MEDIUM: 1, Priority.LOW: 2};
            final priorityA = priorityOrder[a.priority] ?? 2;
            final priorityB = priorityOrder[b.priority] ?? 2;
            return priorityA.compareTo(priorityB);
          }
        });
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      checkView.value = false;
    }
  }

  filter(String value) {
    filterChoose.value = value;
    isLoading.value = true;
    if (filterChoose.value.contains("Không chọn")) {
      listTask.value = List.from(listTask)..sort((a, b) => a.endDate!.compareTo(b.endDate!));
    } else if (filterChoose.value.contains("Ngày tạo (Tăng dần)")) {
      listTask.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
    } else if (filterChoose.value.contains("Ngày tạo (Giảm dần)")) {
      listTask.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    } else if (filterChoose.value.contains("Hạn hoàn thành (Tăng dần)")) {
      listTask.sort((a, b) => a.endDate!.compareTo(b.endDate!));
    } else if (filterChoose.value.contains("Hạn hoàn thành (Giảm dần)")) {
      listTask.sort((a, b) => b.endDate!.compareTo(a.endDate!));
    } else if (filterChoose.value.contains("Mức độ ưu tiên (Giảm dần)")) {
      listTask.sort((a, b) {
        final priorityOrder = {Priority.HIGH: 0, Priority.MEDIUM: 1, Priority.LOW: 2};

        final priorityA = priorityOrder[a.priority] ?? 2;
        final priorityB = priorityOrder[b.priority] ?? 2;

        return priorityA.compareTo(priorityB);
      });
    } else if (filterChoose.value.contains("Mức độ ưu tiên (Tăng dần)")) {
      listTask.sort((a, b) {
        final priorityOrder = {Priority.LOW: 0, Priority.MEDIUM: 1, Priority.HIGH: 2};

        final priorityA = priorityOrder[a.priority] ?? 2;
        final priorityB = priorityOrder[b.priority] ?? 2;
        return priorityA.compareTo(priorityB);
      });
    } else if (filterChoose.value == '') {
      listTask.value = List.from(listTask)..sort((a, b) => a.endDate!.compareTo(b.endDate!));
    }
    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
    });
  }

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
}
