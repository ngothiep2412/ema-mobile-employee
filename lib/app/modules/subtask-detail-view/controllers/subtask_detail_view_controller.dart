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
import 'package:hrea_mobile_employee/app/modules/tab_view/model/user_model.dart';
import 'package:hrea_mobile_employee/app/modules/task-detail-view/controllers/task_detail_view_controller.dart';
import 'package:hrea_mobile_employee/app/modules/task-detail-view/model/comment_model.dart';
import 'package:hrea_mobile_employee/app/modules/task-detail-view/model/file_model.dart';
import 'package:hrea_mobile_employee/app/modules/task-detail-view/model/uploadfile_model.dart';
import 'package:hrea_mobile_employee/app/modules/task-overall-view/controllers/task_overall_view_controller.dart';
import 'package:hrea_mobile_employee/app/resources/color_manager.dart';
import 'package:hrea_mobile_employee/app/resources/response_api_model.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';
import 'package:hrea_mobile_employee/app/utils/check_vietnamese.dart';

import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class SubtaskDetailViewController extends BaseController {
  SubtaskDetailViewController(
      {required this.taskID, required this.isNavigateDetail, required this.endDateTaskParent, required this.startDateTaskParent});
  String taskID = '';
  Rx<TaskModel> taskModel = TaskModel().obs;
  bool isNavigateDetail = false;

  final isLoading = false.obs;
  final isLoadingDeleteComment = false.obs;
  RxBool isCheckEditComment = false.obs;

  TextEditingController textSearchController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController estController = TextEditingController();
  TextEditingController effortController = TextEditingController();
  // TextEditingController commentTextController = TextEditingController();

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
  DateFormat dateFormat = DateFormat('dd/MM/yyyy', 'vi');

  DateTime endDateTaskParent;
  DateTime startDateTaskParent;

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

  // RxBool isEditComment = false.obs;

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

      if (taskModel.value.assignTasks != null && taskModel.value.assignTasks!.isNotEmpty) {
        // for (int index = 0;
        //     index < taskModel.value.assignTasks!.length;
        //     index++) {
        String assignTaskId = taskModel.value.assignTasks![0].user!.id!;
        employeeLeader.value.id = assignTaskId;
      } else {
        employeeLeader.value = EmployeeModel();
      }
      UserModel assigner = await SubTaskDetailApi.getAssignerDetail(jwt, taskModel.value.createdBy!);
      if (assigner.statusCode == 200 || assigner.statusCode == 201) {
        taskModel.value.nameAssigner = assigner.result!.fullName;
        taskModel.value.avatarAssigner = assigner.result!.avatar;
      }
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

      if (taskModel.value.estimationTime != null) {
        est.value = taskModel.value.estimationTime!.toDouble();
        estController.text = taskModel.value.estimationTime.toString();
      } else {
        estController.text = '0.0';
      }
      if (taskModel.value.effort != null) {
        effort.value = taskModel.value.effort!.toDouble();
        effortController.text = taskModel.value.effort.toString();
      } else {
        effortController.text = '0.0';
      }

      getAllAttachment();

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print(e);
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
    // if (listComment.isNotEmpty) {
    //   for (var item in listComment) {
    //     if (item.commentFiles!.isNotEmpty) {
    //       for (var file in item.commentFiles!) {
    //         list.add(AttachmentModel(
    //             id: file.id,
    //             fileName: file.fileName,
    //             fileUrl: file.fileUrl,
    //             mode: 2));
    //       }
    //     }
    //   }
    // }

    listAttachment.value = list;
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

  Future<void> getAllEmployee() async {
    isLoadingFetchUser.value = true;
    try {
      checkToken();
      Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt);
      listEmployee.value = await SubTaskDetailApi.getAllEmployee(jwt, decodedToken['divisionID']);

      if (taskModel.value.assignTasks != null && taskModel.value.assignTasks!.isNotEmpty) {
        // for (int index = 0;
        //     index < taskModel.value.assignTasks!.length;
        //     index++) {
        // String assignTaskId = taskModel.value.assignTasks![index].user!.id!;
        if (taskModel.value.assignTasks!.isNotEmpty) {
          for (int i = 0; i < listEmployee.length; i++) {
            // String assignTaskId = taskModel.value.assignTasks![index].user!.id!;
            // bool isIdExist = listEmployeeChoose
            //     .any((employee) => employee.id == assignTaskId);
            // if (isIdExist) {
            //   listEmployeeChoose
            //       .removeWhere((employee) => employee.id == assignTaskId);
            //   listEmployeeChoose.addIf(employee.id == assignTaskId);
            // } else {
            //   if (listEmployee[i].id == assignTaskId) {
            //     listEmployeeChoose.add(listEmployee[i]);
            //   }
            // }
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

      // UserModel assigner = await TaskDetailApi.getAssignerDetail(
      //     jwt, taskModel.value.createdBy!);
      // if (assigner.statusCode == 200 || assigner.statusCode == 201) {
      //   taskModel.value.nameAssigner = assigner.result!.fullName;
      //   taskModel.value.avatarAssigner = assigner.result!.avatar;
      // }
      print(taskModel.value.description);
      isLoadingFetchUser.value = false;
      print('taskModel ${taskModel.value.endDate}');
    } catch (e) {
      isLoadingFetchUser.value = false;
      print(e);
    }
  }

  Future<void> getEmployeeSupportView() async {
    isLoadingFetchUser.value = true;
    try {
      // checkToken();
      Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt);
      // listEmployee.value = await SubTaskDetailApi.getAllEmployee(jwt, decodedToken['divisionID']);
      List<EmployeeModel> list = [];
      for (var item in taskModel.value.assignTasks!) {
        if (taskModel.value.assignTasks![0].user!.profile!.profileId == decodedToken['id']) {
          if (item.user!.profile!.profileId != decodedToken['id']) {
            list.add(EmployeeModel(fullName: item.user!.profile!.fullName, avatar: item.user!.profile!.avatar, id: item.user!.profile!.profileId));
          }
        } else {
          list.add(EmployeeModel(fullName: item.user!.profile!.fullName, avatar: item.user!.profile!.avatar, id: item.user!.profile!.profileId));
        }
      }
      listEmployeeSupportView.value = list;
      // if (taskModel.value.assignTasks != null && taskModel.value.assignTasks!.isNotEmpty) {
      //   for (int index = 1; index < taskModel.value.assignTasks!.length; index++) {
      //     String assignTaskId = taskModel.value.assignTasks![index].user!.id!;

      //     for (int i = 0; i < listEmployee.length; i++) {
      //       if (listEmployee[i].id == assignTaskId) {
      //         list.add(listEmployee[i]);
      //         listEmployeeSupportView.value = list;
      //       }
      //     }
      //   }
      // }

      // UserModel assigner = await TaskDetailApi.getAssignerDetail(
      //     jwt, taskModel.value.createdBy!);
      // if (assigner.statusCode == 200 || assigner.statusCode == 201) {
      //   taskModel.value.nameAssigner = assigner.result!.fullName;
      //   taskModel.value.avatarAssigner = assigner.result!.avatar;
      // }
      print(taskModel.value.description);
      isLoadingFetchUser.value = false;
      print('taskModel ${taskModel.value.endDate}');
    } catch (e) {
      isLoadingFetchUser.value = false;
      print(e);
    }
  }

  Future<void> getEmployeeSupport() async {
    isLoadingFetchUser.value = true;
    listEmployeeChoose.value = [];
    try {
      checkToken();
      Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt);
      listEmployee.value = await SubTaskDetailApi.getAllEmployee(jwt, decodedToken['divisionID']);
      List<EmployeeModel> list = [];
      if (taskModel.value.assignTasks != null && taskModel.value.assignTasks!.length > 1) {
        listEmployee.removeWhere((employee) => employee.id == taskModel.value.assignTasks![0].user!.id!);
        for (int index = 1; index < taskModel.value.assignTasks!.length; index++) {
          String assignTaskId = taskModel.value.assignTasks![index].user!.id!;
          if (taskModel.value.assignTasks!.isNotEmpty) {
            for (int i = 0; i < listEmployee.length; i++) {
              // String assignTaskId = taskModel.value.assignTasks![0].user!.id!;
              // bool isIdExist = listEmployeeChoose
              //     .any((employee) => employee.id == assignTaskId);
              // if (isIdExist) {

              // listEmployeeChoose.addIf(employee.id == assignTaskId);
              // } else {
              if (listEmployee[i].id == assignTaskId) {
                list.add(listEmployee[i]);
                listEmployee[i].check = true;
              }
            }
            // String assignTaskId = taskModel.value.assignTasks![0].user!.id!;

            // if (listEmployee[i].id == assignTaskId) {
            // employeeLeader.value = listEmployee[i];
            // }
          }
        }
        listEmployeeChoose.value = list;
      } else if (taskModel.value.assignTasks != null && taskModel.value.assignTasks!.length == 1) {
        String assignTaskId = taskModel.value.assignTasks![0].user!.id!;
        listEmployee.removeWhere((employee) => employee.id == assignTaskId);
      }
      // String assignTaskId = taskModel.value.assignTasks![0].user!.id!;

      // if (listEmployee[i].id == assignTaskId) {
      // employeeLeader.value = listEmployee[i];
      // }

      // UserModel assigner = await TaskDetailApi.getAssignerDetail(
      //     jwt, taskModel.value.createdBy!);
      // if (assigner.statusCode == 200 || assigner.statusCode == 201) {
      //   taskModel.value.nameAssigner = assigner.result!.fullName;
      //   taskModel.value.avatarAssigner = assigner.result!.avatar;
      // }
      print(taskModel.value.description);
      isLoadingFetchUser.value = false;
      print('taskModel ${taskModel.value.endDate}');
    } catch (e) {
      isLoadingFetchUser.value = false;
      print(e);
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    // await getAllEmployee();
    await getTaskDetail();

    // var myJSON = jsonDecode(
    //     r'[{"insert": "The Two Towers"}, {"insert": "\n", "attributes": {"header": 1}}, {"insert": "Aragorn sped on up the hill.\n"}]');
    if (taskModel.value.description != null && taskModel.value.description != "") {
      var myJSON = jsonDecode(taskModel.value.description!);
      quillController.value = QuillController(
        document: Document.fromJson(myJSON),
        selection: const TextSelection.collapsed(offset: 0),
      );
    }

    // print('asd ${quillServerController.value}');
    focusNodeComment.addListener(() {
      if (focusNodeComment.hasFocus) {
        log('Comment is focus');
        isEditDescription.value = false;
      }
    });
    // focusNodeDetail.addListener(() {
    //   if (focusNodeDetail.hasFocus) {
    //     log('Detail is focus');
    //     focusNodeComment.unfocus();
    //   } else {
    //     log('Detail is not focus');
    //     if (isEditDescription.value) {
    //       Get.snackbar('Thông báo', 'Làm hàm lưu thay đổi');
    //     }
    //     // isEditDescription.value = false;
    //   }
    // });
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

  searchEmployee(String value) async {
    isLoadingFetchUser.value = true;
    List<EmployeeModel> originalList = [];
    try {
      checkToken();
      Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt);
      listEmployee.value = await SubTaskDetailApi.getAllEmployee(jwt, decodedToken['divisionID']);
      originalList = listEmployee;
      if (value.isEmpty) {
        listEmployee.value = await SubTaskDetailApi.getAllEmployee(jwt, decodedToken['divisionID']);
      } else {
        listEmployee.value = originalList
            .where((employee) => removeVietnameseAccent(employee.fullName!.toLowerCase()).contains(removeVietnameseAccent(value.toLowerCase())))
            .toList();
      }
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
      }
      print(taskModel.value.description);
      isLoadingFetchUser.value = false;
      print('taskModel ${taskModel.value.endDate}');
    } catch (e) {
      isLoadingFetchUser.value = false;
      print(e);
    }
  }

  searchEmployeeSupport(String value) async {
    isLoadingFetchUser.value = true;
    List<EmployeeModel> originalList = [];
    try {
      checkToken();
      Map<String, dynamic> decodedToken = JwtDecoder.decode(jwt);
      listEmployee.value = await SubTaskDetailApi.getAllEmployee(jwt, decodedToken['divisionID']);
      originalList = listEmployee;
      if (value.isEmpty) {
        if (taskModel.value.assignTasks != null && taskModel.value.assignTasks!.length > 1) {
          listEmployee.removeWhere((employee) => employee.id == taskModel.value.assignTasks![0].user!.id!);
          for (int index = 1; index < taskModel.value.assignTasks!.length; index++) {
            String assignTaskId = taskModel.value.assignTasks![index].user!.id!;
            if (taskModel.value.assignTasks!.isNotEmpty) {
              for (int i = 0; i < listEmployee.length; i++) {
                // String assignTaskId = taskModel.value.assignTasks![0].user!.id!;
                // bool isIdExist = listEmployeeChoose
                //     .any((employee) => employee.id == assignTaskId);
                // if (isIdExist) {

                // listEmployeeChoose.addIf(employee.id == assignTaskId);
                // } else {
                if (listEmployee[i].id == assignTaskId) {
                  listEmployeeChoose.add(listEmployee[i]);
                  listEmployee[i].check = true;
                }
              }
              // String assignTaskId = taskModel.value.assignTasks![0].user!.id!;

              // if (listEmployee[i].id == assignTaskId) {
              // employeeLeader.value = listEmployee[i];
              // }
            }
          }
        } else if (taskModel.value.assignTasks != null && taskModel.value.assignTasks!.length == 1) {
          String assignTaskId = taskModel.value.assignTasks![0].user!.id!;
          listEmployee.removeWhere((employee) => employee.id == assignTaskId);
        }
      } else {
        listEmployee.value = originalList
            .where((employee) => removeVietnameseAccent(employee.fullName!.toLowerCase()).contains(removeVietnameseAccent(value.toLowerCase())))
            .toList();
      }
      if (taskModel.value.assignTasks != null && taskModel.value.assignTasks!.length > 1) {
        listEmployee.removeWhere((employee) => employee.id == taskModel.value.assignTasks![0].user!.id!);
        for (int index = 1; index < taskModel.value.assignTasks!.length; index++) {
          String assignTaskId = taskModel.value.assignTasks![index].user!.id!;
          if (taskModel.value.assignTasks!.isNotEmpty) {
            for (int i = 0; i < listEmployee.length; i++) {
              // String assignTaskId = taskModel.value.assignTasks![0].user!.id!;
              // bool isIdExist = listEmployeeChoose
              //     .any((employee) => employee.id == assignTaskId);
              // if (isIdExist) {

              // listEmployeeChoose.addIf(employee.id == assignTaskId);
              // } else {
              if (listEmployee[i].id == assignTaskId) {
                listEmployeeChoose.add(listEmployee[i]);
                listEmployee[i].check = true;
              }
            }
            // String assignTaskId = taskModel.value.assignTasks![0].user!.id!;

            // if (listEmployee[i].id == assignTaskId) {
            // employeeLeader.value = listEmployee[i];
            // }
          }
        }
      } else if (taskModel.value.assignTasks != null && taskModel.value.assignTasks!.length == 1) {
        String assignTaskId = taskModel.value.assignTasks![0].user!.id!;
        listEmployee.removeWhere((employee) => employee.id == assignTaskId);
      }
      print(taskModel.value.description);
      isLoadingFetchUser.value = false;
      print('taskModel ${taskModel.value.endDate}');
    } catch (e) {
      isLoadingFetchUser.value = false;
      print(e);
    }
  }

  addData(String value) {
    listFind.add(value);
  }

  onTapEditDescription() {
    // isEditDescription.value = true;

    Get.toNamed(Routes.EDIT_DESCRIPTION, arguments: {
      // "quillController": quillController,
      "description": taskModel.value.description,
      "taskModel": taskModel,
      "isSubtask": true,
    });
  }

  // saveDescription() {
  //   isEditDescription.value = false;
  //   quillServerController.value = coppyController(quillController.value);

  //   print('quillController.value ${quillController.value.toString()}');
  // }

  // discardDescription() {
  //   quillController.value = coppyController(quillServerController.value);
  //   isEditDescription.value = false;
  //   print(
  //       'quillController.value 2 ${quillServerController.value.document.toDelta()}');
  // }

  // QuillController coppyController(QuillController controller) {
  //   QuillController abc = QuillController(
  //     document: Document.fromDelta(controller.document.toDelta()),
  //     selection: const TextSelection.collapsed(offset: 0),
  //   );
  //   return abc;
  // }

  getTimeRange(List<DateTime?> listTime) {
    listChange = listTime;
  }

  Future<void> updateStatusTask(String status, String taskID) async {
    isLoading.value = true;
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();

      checkToken();

      ResponseApi responseApi = await SubTaskDetailApi.updateStatusTask(jwt, taskID, status);
      if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
        // taskModel.value = await TaskDetailApi.getTaskDetail(jwt, taskID);
        // UserModel assigner = await TaskDetailApi.getAssignerDetail(
        //     jwt, taskModel.value.createdBy!);
        // if (assigner.statusCode == 200 || assigner.statusCode == 201) {
        //   taskModel.value.nameAssigner = assigner.result!.fullName;
        //   taskModel.value.avatarAssigner = assigner.result!.avatar;

        // }

        await updatePageOverall();
        errorUpdateSubTask.value = false;
      }
      if (responseApi.statusCode == 400 || responseApi.statusCode == 500) {
        errorUpdateSubTask.value = true;
        print('responseApi.message ${responseApi.message}');
        errorUpdateSubTaskText.value = responseApi.message!;
      }
      isLoading.value = false;
    } catch (e) {
      errorUpdateSubTask.value = true;
      errorUpdateSubTaskText.value = 'Có lỗi xảy ra';
      isLoading.value = false;
      print(e);
    }
  }

  Future<void> deleteTask(String status, String taskID) async {
    isLoading.value = true;
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();

      checkToken();

      ResponseApi responseApi = await SubTaskDetailApi.updateStatusTask(jwt, taskID, status);
      if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
        // taskModel.value = await TaskDetailApi.getTaskDetail(jwt, taskID);
        // UserModel assigner = await TaskDetailApi.getAssignerDetail(
        //     jwt, taskModel.value.createdBy!);
        // if (assigner.statusCode == 200 || assigner.statusCode == 201) {
        //   taskModel.value.nameAssigner = assigner.result!.fullName;
        //   taskModel.value.avatarAssigner = assigner.result!.avatar;

        // }

        await updatePageOverall();
        errorUpdateSubTask.value = false;
        Get.back();
      }
      if (responseApi.statusCode == 400 || responseApi.statusCode == 500) {
        errorUpdateSubTask.value = true;
        print('responseApi.message ${responseApi.message}');
        errorUpdateSubTaskText.value = responseApi.message!;
      }
      isLoading.value = false;
    } catch (e) {
      errorUpdateSubTask.value = true;
      errorUpdateSubTaskText.value = 'Có lỗi xảy ra';
      isLoading.value = false;
      print(e);
    }
  }

  Future<void> updatePriority(String priority, String taskID) async {
    isLoading.value = true;
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();

      checkToken();

      ResponseApi responseApi = await SubTaskDetailApi.updatePriority(jwt, taskID, taskModel.value.eventId!, priority);
      if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
        // taskModel.value = await TaskDetailApi.getTaskDetail(jwt, taskID);
        // UserModel assigner = await TaskDetailApi.getAssignerDetail(
        //     jwt, taskModel.value.createdBy!);
        // if (assigner.statusCode == 200 || assigner.statusCode == 201) {
        //   taskModel.value.nameAssigner = assigner.result!.fullName;
        //   taskModel.value.avatarAssigner = assigner.result!.avatar;

        // }

        await updatePageOverall();
        errorUpdateSubTask.value = false;
      }
      if (responseApi.statusCode == 400 || responseApi.statusCode == 500) {
        errorUpdateSubTask.value = true;
        print('responseApi.message ${responseApi.message}');
        errorUpdateSubTaskText.value = responseApi.message!;
      }
      isLoading.value = false;
    } catch (e) {
      errorUpdateSubTask.value = true;
      errorUpdateSubTaskText.value = 'Có lỗi xảy ra';
      isLoading.value = false;
      print(e);
    }
  }

  Future<void> updateTitleTask(String title, String taskID) async {
    isLoading.value = true;
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();

      checkToken();

      ResponseApi responseApi = await SubTaskDetailApi.updateTitleTask(jwt, taskID, taskModel.value.eventId!, title);
      if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
        // taskModel.value = await TaskDetailApi.getTaskDetail(jwt, taskID);
        // UserModel assigner = await TaskDetailApi.getAssignerDetail(
        //     jwt, taskModel.value.createdBy!);
        // if (assigner.statusCode == 200 || assigner.statusCode == 201) {
        //   taskModel.value.nameAssigner = assigner.result!.fullName;
        //   taskModel.value.avatarAssigner = assigner.result!.avatar;

        // }

        await updatePageOverall();
        errorUpdateSubTask.value = false;
      }
      if (responseApi.statusCode == 400 || responseApi.statusCode == 500) {
        errorUpdateSubTask.value = true;
        print('responseApi.message ${responseApi.message}');
        errorUpdateSubTaskText.value = responseApi.message!;
      }
      isLoading.value = false;
    } catch (e) {
      errorUpdateSubTask.value = true;
      errorUpdateSubTaskText.value = 'Có lỗi xảy ra';
      isLoading.value = false;
      print(e);
    }
  }

  Future<void> updateDateTime(
    String taskID,
    DateTime startDate,
    DateTime endDate,
  ) async {
    isLoading.value = true;

    // if (listChange.isEmpty) {
    //   startDate.value = DateTime.now().toUtc().add(Duration(hours: 7));
    //   endDate.value = DateTime.now().toUtc().add(Duration(hours: 7));
    // } else {
    //   startDate.value = listChange.first!;
    //   endDate.value = listChange.last!;
    // }
    // startDate.value = startDate.value.copyWith(hour: 0);
    // startDate.value = startDate.value.copyWith(minute: 0);
    // endDate.value = endDate.value.copyWith(hour: 0);
    // endDate.value = endDate.value.copyWith(minute: 0);
    if (startDate.isAfter(endDate)) {
      errorUpdateSubTask.value = true;
      errorUpdateSubTaskText.value = 'Ngày kết thúc phải nhỏ hơn ngày bắt đầu';
      isLoading.value = false;
    } else {
      try {
        checkToken();
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        if (endDate.difference(startDate).inMinutes / 60.0 < est.value) {
          await SubTaskDetailApi.updateEstimationTime(jwt, taskID, taskModel.value.eventId!, est.value);
        }
        ResponseApi responseApi = await SubTaskDetailApi.updateDateTimeTask(jwt, taskID, startDate, endDate, taskModel.value.eventId!);
        if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
          // taskModel.value = await TaskDetailApi.getTaskDetail(jwt, taskID);
          // UserModel assigner = await TaskDetailApi.getAssignerDetail(
          //     jwt, taskModel.value.createdBy!);
          // if (assigner.statusCode == 200 || assigner.statusCode == 201) {
          //   taskModel.value.nameAssigner = assigner.result!.fullName;
          //   taskModel.value.avatarAssigner = assigner.result!.avatar;

          // }

          await updatePageOverall();
          errorUpdateSubTask.value = false;
        }
        if (responseApi.statusCode == 400 || responseApi.statusCode == 500) {
          errorUpdateSubTask.value = true;
          print('responseApi.message ${responseApi.message}');
          errorUpdateSubTaskText.value = responseApi.message!;
        }
        isLoading.value = false;
      } catch (e) {
        errorUpdateSubTask.value = true;
        errorUpdateSubTaskText.value = 'Có lỗi xảy ra';
        isLoading.value = false;
        print(e);
      }
    }
  }

  Future<void> updateEstimateTime(String taskID, double estimateTime) async {
    if (endDate.value.difference(startDate.value).inMinutes / 60.0 < estimateTime) {
      Get.snackbar('Lỗi', 'Phải nhập thời gian ước lượng trong khoảng hạn của công việc',
          snackPosition: SnackPosition.TOP, backgroundColor: Colors.transparent, colorText: ColorsManager.textColor);
      estController.text = est.value.toString();
    } else {
      try {
        checkToken();

        ResponseApi responseApi = await SubTaskDetailApi.updateEstimationTime(jwt, taskID, taskModel.value.eventId!, estimateTime);
        if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
          est.value = estimateTime;
          estController.text = estimateTime.toString();
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> updateEffort(String taskID, double effortInput) async {
    try {
      checkToken();

      ResponseApi responseApi = await SubTaskDetailApi.updateEffort(jwt, taskID, taskModel.value.eventId!, effortInput);
      if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
        effort.value = effortInput;
        effortController.text = effortInput.toString();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updatePageOverall() async {
    Get.put(TaskDetailViewController(taskID: taskID));
    // Get.put(TaskOverallViewController);
    // print(
    //     'Get.find<TaskDetailViewController>() ${Get.find<TaskDetailViewController>()}');
    // if (Get.find<TaskDetailViewController>()) {
    // }
    if (isNavigateDetail) {
      Get.find<TaskDetailViewController>().getTaskDetail();
    }

    Get.find<TaskOverallViewController>().getListTask();

    await getTaskDetail();
  }

  Future<void> refreshPage() async {
    String jwt = GetStorage().read('JWT');
    print('1: ${isLoading.value}');
    isLoading.value = true;
    // taskModel.value = await TaskDetailApi.getTaskDetail(jwt, taskID);
    // UserModel assigner =
    //     await TaskDetailApi.getAssignerDetail(jwt, taskModel.value.createdBy!);
    // if (assigner.statusCode == 200 || assigner.statusCode == 201) {
    //   taskModel.value.nameAssigner = assigner.result!.fullName;
    //   taskModel.value.avatarAssigner = assigner.result!.avatar;
    // }
    await getTaskDetail();
    isLoading.value = false;
  }

  Future<void> assignLeader(String taskID, EmployeeModel employeeLeader, String leaderID) async {
    isLoading.value = true;
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();

      checkToken();
      List<String> assignee = [];
      // for (var item in assigneeChoose) {
      //   assignee.add(item.id!);
      // }
      assignee.add(employeeLeader.id!);
      ResponseApi responseApi = await SubTaskDetailApi.updateAssigneeLeader(jwt, taskID, assignee, leaderID);
      if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
        // taskModel.value = await TaskDetailApi.getTaskDetail(jwt, taskID);
        // UserModel assigner = await TaskDetailApi.getAssignerDetail(
        //     jwt, taskModel.value.createdBy!);
        // if (assigner.statusCode == 200 || assigner.statusCode == 201) {
        //   taskModel.value.nameAssigner = assigner.result!.fullName;
        //   taskModel.value.avatarAssigner = assigner.result!.avatar;

        // }

        await updatePageOverall();
        errorUpdateSubTask.value = false;
      }
      if (responseApi.statusCode == 400 || responseApi.statusCode == 500) {
        errorUpdateSubTask.value = true;
        print('responseApi.message ${responseApi.message}');
        errorUpdateSubTaskText.value = responseApi.message!;
      }
      isLoading.value = false;
    } catch (e) {
      errorUpdateSubTask.value = true;
      errorUpdateSubTaskText.value = 'Có lỗi xảy ra';
      isLoading.value = false;
      print(e);
    }
  }

  Future<void> assignSupporter(String taskID, List<EmployeeModel> listSupporter, String leaderID) async {
    isLoading.value = true;
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();

      checkToken();
      List<String> assignee = [];
      if (employeeLeader.value.id == null || employeeLeader.value.id == '') {
        for (var item in listSupporter) {
          assignee.add(item.id!);
        }
      } else {
        assignee.add(leaderID);
        for (var item in listSupporter) {
          if (item.id != leaderID) {
            assignee.add(item.id!);
          }
        }
      }

      ResponseApi responseApi = await SubTaskDetailApi.updateAssigneeLeader(jwt, taskID, assignee, leaderID);
      if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
        // taskModel.value = await TaskDetailApi.getTaskDetail(jwt, taskID);
        // UserModel assigner = await TaskDetailApi.getAssignerDetail(
        //     jwt, taskModel.value.createdBy!);
        // if (assigner.statusCode == 200 || assigner.statusCode == 201) {
        //   taskModel.value.nameAssigner = assigner.result!.fullName;
        //   taskModel.value.avatarAssigner = assigner.result!.avatar;

        // }

        await updatePageOverall();
        errorUpdateSubTask.value = false;
      }
      if (responseApi.statusCode == 400 || responseApi.statusCode == 500) {
        errorUpdateSubTask.value = true;
        print('responseApi.message ${responseApi.message}');
        errorUpdateSubTaskText.value = responseApi.message!;
      }
      isLoading.value = false;
    } catch (e) {
      errorUpdateSubTask.value = true;
      errorUpdateSubTaskText.value = 'Có lỗi xảy ra';
      isLoading.value = false;
      print(e);
    }
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
      print(e);
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
        checkToken();
        List<FileModel> listFile = [];
        if (filePicker.isNotEmpty) {
          for (var item in filePicker) {
            File fileResult = File(item.path!);
            UploadFileModel responseApi = await SubTaskDetailApi.uploadFile(jwt, fileResult, item.extension ?? '', 'comment');
            if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
              listFile.add(FileModel(fileName: responseApi.result!.fileName, fileUrl: responseApi.result!.downloadUrl));
            }
          }
          ResponseApi responseApi = await SubTaskDetailApi.createComment(jwt, taskID, commentController.text, listFile);
          if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
            listComment.value = await SubTaskDetailApi.getAllComment(jwt, taskModel.value.id!);
            listComment.sort((comment1, comment2) {
              return comment2.createdAt!.compareTo(comment1.createdAt!);
            });
            getAllAttachment();
          }
        } else {
          ResponseApi responseApi = await SubTaskDetailApi.createComment(jwt, taskID, commentController.text, listFile);
          if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
            listComment.value = await SubTaskDetailApi.getAllComment(jwt, taskModel.value.id!);
            listComment.sort((comment1, comment2) {
              return comment2.createdAt!.compareTo(comment1.createdAt!);
            });
            getAllAttachment();
          }
        }
        commentController.text = '';
        filePicker.value = [];
      } catch (e) {
        print(e);
      }
    }
  }

  void openFile(PlatformFile file) {
    OpenFile.open(file.path!);
  }

  Future<void> deleteTaskFile(AttachmentModel attachmentModel) async {
    // isLoading.value = true;
    try {
      if (attachmentModel.mode == 1) {
        listAttachment.removeWhere((element) => element.id == attachmentModel.id);
        List<TaskFile> list = [];
        for (var item in listAttachment) {
          if (item.mode == 1) {
            list.add(TaskFile(fileName: item.fileName, fileUrl: item.fileUrl));
          }
        }
        ResponseApi deleteFileTask = await SubTaskDetailApi.updateTaskFile(jwt, taskID, list);
        if (deleteFileTask.statusCode == 200 || deleteFileTask.statusCode == 201) {
        } else {}
        // } else {
        //   listAttachment
        //       .removeWhere((element) => element.id == attachmentModel.id);
        //   List<CommentFile> list = [];
        //   for (var item in listAttachment) {
        //     if (item.mode == 2) {
        //       list.add(
        //           CommentFile(fileName: item.fileName, fileUrl: item.fileUrl));
        //     }
        //   }
        //   ResponseApi deleteFileTask =
        //       await SubTaskDetailApi.updateCommentFile(jwt, taskID, list);
        //   if (deleteFileTask.statusCode == 200 ||
        //       deleteFileTask.statusCode == 201) {
        //   } else {}
      }
      // getAllAttachment();
      // isLoading.value = false;
    } catch (e) {
      print(e);
      // isLoading.value = false;
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
      // isLoadingDeleteComment.value = false;
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
      ResponseApi responseApi = await SubTaskDetailApi.deleteComment(jwt, commentModel.id!);
      if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
        listComment.value = await SubTaskDetailApi.getAllComment(jwt, taskModel.value.id!);
        listComment.sort((comment1, comment2) {
          return comment2.createdAt!.compareTo(comment1.createdAt!);
        });
        getAllAttachment();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> editComment(CommentModel commentModel, String content, String commentID, List<PlatformFile> filePickerEditCommentFile) async {
    try {
      checkToken();
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
        // getAllAttachment();
      }
    } catch (e) {
      print(e);
    }
  }
}
