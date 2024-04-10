import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_employee/app/base/base_controller.dart';
import 'package:hrea_mobile_employee/app/modules/subtask-detail-view/api/subtask_detail_api.dart';
import 'package:hrea_mobile_employee/app/modules/subtask-detail-view/model/attachment_model.dart';
import 'package:hrea_mobile_employee/app/modules/subtask-detail-view/model/employee_model.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/task.dart';
import 'package:hrea_mobile_employee/app/modules/task-detail-view/model/comment_model.dart';
import 'package:hrea_mobile_employee/app/modules/task-detail-view/model/file_model.dart';
import 'package:hrea_mobile_employee/app/modules/task-detail-view/model/uploadfile_model.dart';
import 'package:hrea_mobile_employee/app/modules/task-overall-view/controllers/task_overall_view_controller.dart';
import 'package:hrea_mobile_employee/app/modules/task_schedule/controllers/task_schedule_controller.dart';
import 'package:hrea_mobile_employee/app/resources/color_manager.dart';
import 'package:hrea_mobile_employee/app/resources/response_api_model.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';

import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class SubtaskDetailViewController extends BaseController {
  SubtaskDetailViewController({required this.taskID, required this.isNavigateDetail, required this.isScheduleOverall});
  String taskID;
  Rx<TaskModel> taskModel = TaskModel().obs;
  bool isNavigateDetail = false;
  bool isScheduleOverall = false;

  final isLoading = false.obs;
  final isLoadingDeleteComment = false.obs;
  RxBool isCheckEditComment = false.obs;

  TextEditingController textSearchController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController estController = TextEditingController();
  TextEditingController effortController = TextEditingController();

  final testList = 0.obs;

  final isLoadingFetchUser = false.obs;
  RxList<String> listFind = <String>[].obs;
  RxList<EmployeeModel> listEmployee = <EmployeeModel>[].obs;
  RxList<EmployeeModel> listEmployeeChoose = <EmployeeModel>[].obs;
  RxList<EmployeeModel> listEmployeeSupport = <EmployeeModel>[].obs;

  RxList<EmployeeModel> listEmployeeSupportView = <EmployeeModel>[].obs;

  Rx<EmployeeModel> employeeLeader = EmployeeModel().obs;

  TextEditingController titleSubTaskController = TextEditingController();
  RxList<CommentModel> listComment = <CommentModel>[].obs;

  Rx<QuillController> quillController = QuillController.basic().obs;

  Rx<QuillController> quillServerController = QuillController.basic().obs;

  RxList<String> dataAssign = <String>['Nguyễn Văn A', 'Nguyễn Văn B'].obs;
  final isEditDescription = false.obs;

  RxList<PlatformFile> filePicker = <PlatformFile>[].obs;

  Rx<DateTime> startDate = DateTime.now().toUtc().add(const Duration(hours: 7)).obs;
  Rx<DateTime> endDate = DateTime.now().toUtc().add(const Duration(hours: 7)).obs;
  DateFormat dateFormat = DateFormat('dd-MM-yyyy', 'vi');
  DateFormat dateFormatv2 = DateFormat('yyyy-MM-dd', 'vi');

  List<DateTime?> listChange = [DateTime.now().toUtc().add(const Duration(hours: 7)), DateTime.now().toUtc().add(const Duration(hours: 7))];

  FocusNode focusNodeDetail = FocusNode();
  FocusNode focusNodeComment = FocusNode();

  RxBool errorUpdateSubTask = false.obs;
  RxString errorUpdateSubTaskText = ''.obs;

  RxList<AttachmentModel> listAttachment = <AttachmentModel>[].obs;

  RxString descriptionString = ''.obs;
  String jwt = '';

  String idUser = '';

  RxDouble est = 0.0.obs;
  RxDouble effort = 0.0.obs;

  RxBool isCheckin = false.obs;

  RxDouble progress = 0.0.obs;
  RxDouble progressView = 0.0.obs;

  RxBool checkView = false.obs;

  RxBool isLoadingComment = false.obs;

  Future<bool> checkTaskForUser() async {
    try {
      checkToken();
      Rx<TaskModel> taskModelCheck = TaskModel().obs;
      taskModelCheck.value = await SubTaskDetailApi.getTaskDetail(jwt, taskID);
      if (taskModelCheck.value.status == null || taskModelCheck.value.priority == null) {
        return false;
      }
      taskModelCheck.value.assignTasks = taskModelCheck.value.assignTasks!.where((task) => task.status == "active").toList();

      bool isCheckTask = false;
      if (taskModelCheck.value.assignTasks != null && taskModelCheck.value.assignTasks!.isNotEmpty) {
        // for (var item in taskModelCheck.value.assignTasks!) {
        //   if (item.user!.id == idUser && item.status == "active") {
        //     isCheckTask = true;
        //     break;
        //   }
        // }
        // taskModelCheck.value.assignTasks![0].user!.id == idUser
        for (var index = 0; index < taskModelCheck.value.assignTasks!.length; index++) {
          if (taskModelCheck.value.assignTasks![index].user!.id == idUser) {
            isCheckTask = true;
            break;
          }
        }
        // if (taskModelCheck.value.assignTasks![0].status == "active") {
        //   isCheckTask = true;
        // }
      }
      if (isCheckTask) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkTaskForUserV2() async {
    try {
      checkToken();
      Rx<TaskModel> taskModelCheck = TaskModel().obs;
      taskModelCheck.value = await SubTaskDetailApi.getTaskDetail(jwt, taskID);
      if (taskModelCheck.value.status == null || taskModelCheck.value.priority == null) {
        return false;
      }
      taskModelCheck.value.assignTasks = taskModelCheck.value.assignTasks!.where((task) => task.status == "active").toList();

      bool isCheckTask = false;
      if (taskModelCheck.value.assignTasks != null && taskModelCheck.value.assignTasks!.isNotEmpty) {
        // item.user!.id == idUser &&
        for (var item in taskModelCheck.value.assignTasks!) {
          // if (item.status == "active") {
          //   isCheckTask = true;
          //   break;
          // }
          if (item.user!.id == idUser) {
            isCheckTask = true;
            break;
          }
        }
      }
      if (isCheckTask) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  void getAllAttachment() {
    List<AttachmentModel> list = [];

    if (taskModel.value.taskFiles!.isNotEmpty) {
      taskModel.value.taskFiles!.sort((taskFile1, taskFile2) {
        return taskFile2.createdAt!.compareTo(taskFile1.createdAt!);
      });
      for (var item in taskModel.value.taskFiles!) {
        list.add(AttachmentModel(id: item.id, fileName: item.fileName, fileUrl: item.fileUrl, mode: 1));
      }
    }

    listAttachment.value = list;
  }

  void checkToken() {
    DateTime now = DateTime.now().toLocal();
    if (GetStorage().read('JWT') != null) {
      jwt = GetStorage().read('JWT');
      Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt);
      print('decodedToken ${decodedToken}');
      print('now ${now}');

      DateTime expTime = DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000);
      print(expTime.toLocal());
      idUser = decodedToken['id'];
      // if (JwtDecoder.isExpired(jwt)) {
      //   Get.offAllNamed(Routes.LOGIN);
      //   return;
      // }
      if (expTime.toLocal().isBefore(now)) {
        Get.offAllNamed(Routes.LOGIN);
        return;
      }
    } else {
      Get.offAllNamed(Routes.LOGIN);
      return;
    }
  }

  Future<void> getAllEmployee() async {
    isLoadingFetchUser.value = true;
    try {
      checkToken();
      listEmployee.value = await SubTaskDetailApi.getAllEmployee(
          jwt, idUser, dateFormatv2.format(taskModel.value.startDate!), dateFormatv2.format(taskModel.value.endDate!));
      listEmployee.value = listEmployee.sublist(1);

      if (taskModel.value.assignTasks != null && taskModel.value.assignTasks!.isNotEmpty) {
        if (taskModel.value.assignTasks!.isNotEmpty) {
          for (int i = 0; i < listEmployee.length; i++) {
            String assignTaskId = taskModel.value.assignTasks![0].user!.id!;

            if (listEmployee[i].id == assignTaskId) {
              employeeLeader.value = listEmployee[i];
            }
          }

          // }
        }
      } else {
        employeeLeader.value = EmployeeModel();
      }

      isLoadingFetchUser.value = false;
    } catch (e) {
      isLoadingFetchUser.value = false;
      checkView.value = false;
    }
  }

  Future<void> getEmployeeSupportView() async {
    isLoadingFetchUser.value = true;
    try {
      // checkToken();
      Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt);
      List<EmployeeModel> list = [];
      for (var item in taskModel.value.assignTasks!.sublist(1)) {
        if (taskModel.value.assignTasks![0].user!.id == decodedToken['id']) {
          if (item.user!.id != decodedToken['id']) {
            list.add(EmployeeModel(
                fullName: item.user!.profile!.fullName, avatar: item.user!.profile!.avatar, id: item.user!.id, email: item.user!.email));
          }
        } else {
          list.add(
              EmployeeModel(fullName: item.user!.profile!.fullName, avatar: item.user!.profile!.avatar, id: item.user!.id, email: item.user!.email));
        }
      }
      listEmployeeSupportView.value = list;

      isLoadingFetchUser.value = false;
    } catch (e) {
      isLoadingFetchUser.value = false;
      checkView.value = false;
    }
  }

  Future<void> updateProgress(double value) async {
    try {
      checkToken();
      bool checkTask = await checkTaskForUser();
      String status = taskModel.value.status.toString();
      if (value == 100) {
        status = 'DONE';
      } else {
        status = 'PROCESSING';
      }
      if (checkTask) {
        DateTime now = DateTime.now().toLocal();
        print('now $now');
        print('taskModel.value.startDate!.toLocal() ${taskModel.value.startDate!.toLocal()}');
        if (taskModel.value.startDate!.toLocal().isAfter(now)
            // || taskModel.value.endDate!.toLocal().isBefore(now)
            ) {
          Get.snackbar('Thông báo', 'Công việc này có thời hạn công việc không cho phép cập nhật',
              snackPosition: SnackPosition.TOP, backgroundColor: Colors.transparent, colorText: ColorsManager.textColor);
          // return;
        } else {
          ResponseApi responseApi = await SubTaskDetailApi.updateProgressTask(jwt, taskID, value, status);
          if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
            progress.value = value;
            Get.snackbar('Thành công', 'Cập nhật trạng thái thành công',
                snackPosition: SnackPosition.BOTTOM, backgroundColor: const Color.fromARGB(255, 81, 146, 83), colorText: Colors.white);
          } else {
            checkView.value = false;
          }
        }
      } else {
        Get.snackbar('Thông báo', 'Công việc này không khả dụng nữa',
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.transparent, colorText: ColorsManager.textColor);
      }
    } catch (e) {
      checkView.value = false;
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    // await getAllEmployee();
    isLoading.value = true;
    checkView.value = await checkTaskForUserV2();
    if (checkView.value) {
      await getTaskDetail();
    }
    isLoading.value = false;

    // var myJSON = jsonDecode(
    //     r'[{"insert": "The Two Towers"}, {"insert": "\n", "attributes": {"header": 1}}, {"insert": "Aragorn sped on up the hill.\n"}]');
    if (taskModel.value.description != null && taskModel.value.description != "") {
      var myJSON = jsonDecode(taskModel.value.description!);
      quillController.value = QuillController(
        document: Document.fromJson(myJSON),
        selection: const TextSelection.collapsed(offset: 0),
      );
    }

    focusNodeComment.addListener(() {
      if (focusNodeComment.hasFocus) {
        log('Comment is focus');
        isEditDescription.value = false;
      }
    });

    isLoading(false);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    quillController.value.dispose();
    textSearchController.dispose();
    super.onClose();
  }

  Future<void> getTaskDetail() async {
    isLoading.value = true;

    try {
      checkToken();
      List<DateTime> listDateTime = [];
      taskModel.value = await SubTaskDetailApi.getTaskDetail(jwt, taskID);

      titleSubTaskController.text = taskModel.value.title!;
      if (taskModel.value.startDate != null) {
        startDate.value = taskModel.value.startDate!;
        listDateTime.add(taskModel.value.startDate!);
      }
      if (taskModel.value.endDate != null) {
        endDate.value = taskModel.value.endDate!;
        listDateTime.add(taskModel.value.endDate!);
      }

      listChange = listDateTime;

      taskModel.value.assignTasks = taskModel.value.assignTasks!.where((task) => task.status == "active").toList();

      if (taskModel.value.assignTasks != null && taskModel.value.assignTasks!.isNotEmpty) {
        // for (int index = 0;
        //     index < taskModel.value.assignTasks!.length;
        //     index++) {
        String assignTaskId = taskModel.value.assignTasks![0].user!.id!;
        employeeLeader.value.id = assignTaskId;
      } else {
        employeeLeader.value = EmployeeModel();
      }
      // UserModel assigner = await SubTaskDetailApi.getAssignerDetail(jwt, taskModel.value.createdBy!);
      // if (assigner.statusCode == 200 || assigner.statusCode == 201) {
      //   taskModel.value.nameAssigner = assigner.result!.fullName;
      //   taskModel.value.avatarAssigner = assigner.result!.avatar;
      // }
      if (taskModel.value.description == null || taskModel.value.description == '') {
        quillController.value = QuillController(
          document: Document(),
          selection: const TextSelection.collapsed(offset: 0),
        );
      } else {
        quillController.value = QuillController(
          document: Document.fromJson(jsonDecode(taskModel.value.description!)),
          selection: const TextSelection.collapsed(offset: 0),
        );
      }

      listComment.value = await SubTaskDetailApi.getAllComment(jwt, taskModel.value.id!);
      if (listComment.isNotEmpty) {
        listComment.sort((comment1, comment2) {
          return comment2.createdAt!.compareTo(comment1.createdAt!);
        });
      }

      // if (taskModel.value.estimationTime != null) {
      //   est.value = taskModel.value.estimationTime!.toDouble();
      //   estController.text = taskModel.value.estimationTime.toString();
      // } else {
      //   estController.text = '0.0';
      // }
      // if (taskModel.value.effort != null) {
      //   effort.value = taskModel.value.effort!.toDouble();
      //   effortController.text = taskModel.value.effort.toString();
      // } else {
      //   effortController.text = '0.0';
      // }

      progress.value = double.parse(taskModel.value.progress.toString());
      progressView.value = double.parse(taskModel.value.progress.toString());

      getAllAttachment();

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      checkView.value = false;
    }
  }

  addData(String value) {
    listFind.add(value);
  }

  Future<void> updateStatusTask(String status, String taskID) async {
    try {
      checkToken();
      bool checkTask = await checkTaskForUser();
      if (checkTask) {
        isLoading.value = true;

        // ResponseApi responseApi = await SubTaskDetailApi.updateStatusTask(jwt, taskID, status);
        // if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
        if (status == 'DONE') {
          DateTime now = DateTime.now().toLocal();
          print('now $now');
          print('taskModel.value.startDate!.toLocal() ${taskModel.value.startDate!.toLocal()}');
          if (taskModel.value.startDate!.toLocal().isAfter(now)
              // || taskModel.value.endDate!.toLocal().isBefore(now)
              ) {
            Get.snackbar('Thông báo', 'Công việc này có thời hạn công việc không cho phép cập nhật',
                snackPosition: SnackPosition.TOP, backgroundColor: Colors.transparent, colorText: ColorsManager.textColor);
            // return;
          } else {
            ResponseApi responseApi = await SubTaskDetailApi.updateProgressTask(jwt, taskID, 100, status);
            if (responseApi.statusCode == 400 || responseApi.statusCode == 500) {
              checkView.value = false;
            } else if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
              Get.snackbar('Thành công', 'Cập nhật trạng thái thành công',
                  snackPosition: SnackPosition.BOTTOM, backgroundColor: const Color.fromARGB(255, 81, 146, 83), colorText: Colors.white);
            }
          }
        } else {
          DateTime now = DateTime.now().toLocal();
          print('now $now');
          print('taskModel.value.startDate!.toLocal() ${taskModel.value.startDate!.toLocal()}');
          if (taskModel.value.startDate!.toLocal().isAfter(now)
              // || taskModel.value.endDate!.toLocal().isBefore(now)
              ) {
            Get.snackbar('Thông báo', 'Công việc này có thời hạn công việc không cho phép cập nhật',
                snackPosition: SnackPosition.TOP, backgroundColor: Colors.transparent, colorText: ColorsManager.textColor);
            // return;
          } else {
            ResponseApi responseApi = await SubTaskDetailApi.updateStatusTask(jwt, taskID, status);
            if (responseApi.statusCode == 400 || responseApi.statusCode == 500) {
              checkView.value = false;
            } else if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
              Get.snackbar('Thành công', 'Cập nhật trạng thái thành công',
                  snackPosition: SnackPosition.BOTTOM, backgroundColor: const Color.fromARGB(255, 81, 146, 83), colorText: Colors.white);
            }
          }
        }
        await updatePageOverall();
        errorUpdateSubTask.value = false;
        // } else {
        // checkView.value = false;
        // }
      } else {
        Get.snackbar('Thông báo', 'Công việc này không khả dụng nữa',
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.transparent, colorText: ColorsManager.textColor);
      }
      isLoading.value = false;
    } catch (e) {
      errorUpdateSubTask.value = true;
      errorUpdateSubTaskText.value = 'Có lỗi xảy ra';
      isLoading.value = false;
      //  checkView.value = true;
    }
  }

  Future<void> updatePriority(String priority, String taskID) async {
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();

      checkToken();
      bool checkTask = await checkTaskForUser();
      if (checkTask) {
        isLoading.value = true;
        ResponseApi responseApi = await SubTaskDetailApi.updatePriority(jwt, taskID, taskModel.value.eventDivision!.event!.id!, priority);
        if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
          await updatePageOverall();
          errorUpdateSubTask.value = false;
        } else {
          checkView.value = false;
        }
      } else {
        Get.snackbar('Thông báo', 'Công việc này không khả dụng nữa',
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.transparent, colorText: ColorsManager.textColor);
      }
      isLoading.value = false;
    } catch (e) {
      errorUpdateSubTask.value = true;
      errorUpdateSubTaskText.value = 'Có lỗi xảy ra';
      isLoading.value = false;
      print(e);
    }
  }

  Future<void> updatePageOverall() async {
    if (isNavigateDetail) {
      // Get.find<TaskDetailViewController>().getTaskDetail();
      Get.find<TaskOverallViewController>().getListTask();
    }

    if (isScheduleOverall) {
      Get.find<TaskScheduleController>().refreshPage();
    }

    await getTaskDetail();
  }

  Future<void> refreshPage() async {
    checkView.value = true;
    isLoading.value = true;

    bool checkTask = await checkTaskForUserV2();
    if (checkTask) {
      await getTaskDetail();
    } else {
      Get.snackbar('Thông báo', 'Công việc này không khả dụng nữa',
          snackPosition: SnackPosition.TOP, backgroundColor: Colors.transparent, colorText: ColorsManager.textColor);
    }

    isLoading.value = false;
  }

  Future selectFile() async {
    try {
      checkToken();
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'doc', 'xlsx', 'docx', 'png', 'jpeg'],
        // allowedExtensions: ['pdf'],
      );
      if (result == null) {
        return;
      }
      final file = result.files.first;
      File fileResult = File(result.files[0].path!);
      double fileLength = File(result.files[0].path!).lengthSync() / 1024 / 1024;

      if (fileLength > 10) {
        Get.snackbar('Lỗi', 'Không thể lấy tài liệu lớn hơn 10mb',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.transparent, colorText: Colors.white);
        return;
      }
      UploadFileModel responseApi = await SubTaskDetailApi.uploadFile(jwt, fileResult, file.extension ?? '', 'task');
      if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
        String fileName = fileResult.path.split('/').last;
        ResponseApi updateFileTask = await SubTaskDetailApi.updateFileTask(jwt, taskID, responseApi.result!.downloadUrl!, fileName);
        if (updateFileTask.statusCode == 200 || updateFileTask.statusCode == 201) {
          TaskModel subTask = TaskModel();
          subTask = await SubTaskDetailApi.getTaskDetail(jwt, taskID);
          List<AttachmentModel> list = [];

          if (subTask.taskFiles!.isNotEmpty) {
            subTask.taskFiles!.sort((taskFile1, taskFile2) {
              return taskFile2.createdAt!.compareTo(taskFile1.createdAt!);
            });
            for (var item in subTask.taskFiles!) {
              list.add(AttachmentModel(id: item.id, fileName: item.fileName, fileUrl: item.fileUrl, mode: 1));
            }
          }
          if (listComment.isNotEmpty) {
            for (var item in listComment) {
              if (item.commentFiles!.isNotEmpty) {
                for (var file in item.commentFiles!) {
                  list.add(AttachmentModel(id: file.id, fileName: file.fileName, fileUrl: file.fileUrl, mode: 2));
                }
              }
            }
          }

          listAttachment.value = list;
        }
      }
    } catch (e) {
      checkView.value = false;
    }
  }

  Future selectFileComment() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc', 'xlsx', 'docx', 'png', 'jpeg'],
    );
    if (result == null) {
      isLoading.value = false;
      return;
    }
    final file = result.files.first;
    double fileLength = File(result.files[0].path!).lengthSync() / 1024 / 1024;
    if (fileLength > 10) {
      Get.snackbar('Lỗi', 'Không thể lấy tài liệu lớn hơn 10mb',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.transparent, colorText: Colors.white);
      isLoading.value = false;
      return;
    }
    filePicker.add(file);
  }

  Future<File> saveFilePermaently(PlatformFile file) async {
    final appStorage = await getApplicationCacheDirectory();

    final newFile = File('${appStorage.path}/${file.name}');

    return File(file.path!).copy(newFile.path);
  }

  Future<void> createComment() async {
    if (commentController.text.isEmpty) {
      Get.snackbar('Thông báo', 'Bạn phải nhập ít nhất 1 kí tự',
          snackPosition: SnackPosition.TOP, backgroundColor: Colors.transparent, colorText: ColorsManager.textColor);
    } else {
      try {
        isLoadingComment.value = true;

        checkToken();
        bool checkTask = await checkTaskForUser();
        if (checkTask) {
          List<FileModel> listFile = [];
          if (filePicker.isNotEmpty) {
            for (var item in filePicker) {
              File fileResult = File(item.path!);
              UploadFileModel responseApi = await SubTaskDetailApi.uploadFile(jwt, fileResult, item.extension ?? '', 'comment');
              if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
                listFile.add(FileModel(fileName: responseApi.result!.fileName, fileUrl: responseApi.result!.downloadUrl));
                print('responseApi.result!.downloadUrl ${responseApi.result!.downloadUrl}');
              } else {
                checkView.value = false;
              }
            }
            ResponseApi responseApi = await SubTaskDetailApi.createComment(jwt, taskID, commentController.text, listFile);
            if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
              listComment.value = await SubTaskDetailApi.getAllComment(jwt, taskModel.value.id!);
              listComment.sort((comment1, comment2) {
                return comment2.createdAt!.compareTo(comment1.createdAt!);
              });
              getAllAttachment();
            } else {
              checkView.value = false;
            }
          } else {
            ResponseApi responseApi = await SubTaskDetailApi.createComment(jwt, taskID, commentController.text, listFile);
            if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
              listComment.value = await SubTaskDetailApi.getAllComment(jwt, taskModel.value.id!);
              listComment.sort((comment1, comment2) {
                return comment2.createdAt!.compareTo(comment1.createdAt!);
              });
              getAllAttachment();
            } else {
              checkView.value = false;
            }
          }
          commentController.text = '';
          filePicker.value = [];
        } else {
          Get.snackbar('Thông báo', 'Công việc này không khả dụng nữa',
              snackPosition: SnackPosition.TOP, backgroundColor: Colors.transparent, colorText: ColorsManager.textColor);
        }
        isLoadingComment.value = false;
      } catch (e) {
        isLoadingComment.value = false;
        checkView.value = false;
      }
    }
  }

  void openFile(PlatformFile file) {
    OpenFile.open(file.path!);
  }

  Future<void> deleteTaskFile(AttachmentModel attachmentModel) async {
    try {
      if (attachmentModel.mode == 1) {
        listAttachment.removeWhere((element) => element.id == attachmentModel.id);
        List<TaskFile> list = [];
        for (var item in listAttachment) {
          if (item.mode == 1) {
            list.add(TaskFile(fileName: item.fileName, fileUrl: item.fileUrl));
          }
        }
        await SubTaskDetailApi.updateTaskFile(jwt, taskID, list);
      }
    } catch (e) {
      checkView.value = false;
    }
  }

  void deleteCommentFile(CommentFile commentFile) {
    isLoadingDeleteComment.value = true;
    try {
      for (var item in listComment) {
        item.commentFiles!.removeWhere(
          (element) => element.id == commentFile.id,
        );
      }

      // getAllAttachment();
      isLoadingDeleteComment.value = false;
    } catch (e) {
      isLoadingDeleteComment.value = false;
    }
  }

  Future<void> cancel(String commentID) async {
    // isLoadingDeleteComment.value = true;
    try {
      listComment.value = await SubTaskDetailApi.getAllComment(jwt, taskModel.value.id!);
      listComment.sort((comment1, comment2) {
        return comment2.createdAt!.compareTo(comment1.createdAt!);
      });
      // isLoadingDeleteComment.value = false;
    } catch (e) {
      checkView.value = false;
    }
  }

  void deleteAttachmentCommentFile(int index) {
    isLoading.value = true;
    try {
      filePicker.removeAt(index);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
    }
  }

  Future<void> deleteComment(CommentModel commentModel) async {
    try {
      checkToken();
      bool checkTask = await checkTaskForUser();
      if (checkTask) {
        ResponseApi responseApi = await SubTaskDetailApi.deleteComment(jwt, commentModel.id!);
        if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
          listComment.value = await SubTaskDetailApi.getAllComment(jwt, taskModel.value.id!);
          listComment.sort((comment1, comment2) {
            return comment2.createdAt!.compareTo(comment1.createdAt!);
          });
          getAllAttachment();
        } else {
          checkView.value = false;
        }
      } else {
        Get.snackbar('Thông báo', 'Công việc này không khả dụng nữa',
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.transparent, colorText: ColorsManager.textColor);
      }
    } catch (e) {
      checkView.value = false;
    }
  }

  Future<void> editComment(CommentModel commentModel, String content, String commentID, List<PlatformFile> filePickerEditCommentFile) async {
    try {
      checkToken();
      bool checkTask = await checkTaskForUser();
      if (checkTask) {
        List<CommentFile> list = [];
        for (var item in listComment) {
          if (item.id == commentID) {
            for (var files in item.commentFiles!) {
              list.add(files);
            }
          }
        }
        List<FileModel> listFile = [];
        if (filePickerEditCommentFile.isNotEmpty) {
          for (var item in filePickerEditCommentFile) {
            File fileResult = File(item.path!);
            UploadFileModel responseApi = await SubTaskDetailApi.uploadFile(jwt, fileResult, item.extension ?? '', 'comment');
            if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
              listFile.add(FileModel(fileName: responseApi.result!.fileName, fileUrl: responseApi.result!.downloadUrl));
            }
          }
          for (var fileNew in listFile) {
            list.add(CommentFile(fileName: fileNew.fileName, fileUrl: fileNew.fileUrl));
          }
        }
        ResponseApi responseApi = await SubTaskDetailApi.updateComment(jwt, commentModel.id!, content, list);
        if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
          listComment.value = await SubTaskDetailApi.getAllComment(jwt, taskModel.value.id!);
          listComment.sort((comment1, comment2) {
            return comment2.createdAt!.compareTo(comment1.createdAt!);
          });
        } else {
          checkView.value = false;
        }
      } else {
        Get.snackbar('Thông báo', 'Công việc này không khả dụng nữa',
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.transparent, colorText: ColorsManager.textColor);
      }
    } catch (e) {
      checkView.value = false;
    }
  }
}
