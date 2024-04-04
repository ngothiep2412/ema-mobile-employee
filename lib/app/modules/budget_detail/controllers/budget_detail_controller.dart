import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_employee/app/base/base_controller.dart';
import 'package:hrea_mobile_employee/app/modules/budget/controllers/budget_controller.dart';
import 'package:hrea_mobile_employee/app/modules/budget/model/budget_model.dart';
import 'package:hrea_mobile_employee/app/modules/budget_detail/api/budget_detail_api.dart';
import 'package:hrea_mobile_employee/app/modules/budget_detail/model/upload_evidence_model.dart';
import 'package:hrea_mobile_employee/app/resources/response_api_model.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:open_file/open_file.dart';

class BudgetDetailController extends BaseController {
  BudgetDetailController({required this.transactionID, required this.isNotiNavigate, required this.statusTask});
  String transactionID = '';

  Rx<Transaction> transactionView = Transaction().obs;
  RxList<Evidence> listAttachmentEvidence = <Evidence>[].obs;

  String jwt = '';
  String idUser = '';
  bool isNotiNavigate = false;
  RxBool errorUpdateBudget = false.obs;
  RxString errorUpdateBudgetText = ''.obs;

  bool statusTask;

  RxBool isLoading = false.obs;
  RxBool checkView = true.obs;

  RxList<PlatformFile> filePicker = <PlatformFile>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await getBudgetDetail(transactionID);
    print(transactionID);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  String formatCurrency(int amount) {
    String formattedAmount = amount.toString();
    final length = formattedAmount.length;

    if (length > 3) {
      for (var i = length - 3; i > 0; i -= 3) {
        formattedAmount = formattedAmount.replaceRange(i, i, ',');
      }
    }

    return formattedAmount;
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

  Future<void> deleteBudget() async {
    isLoading.value = true;
    try {
      checkToken();
      ResponseApi responseApi = await BudgetDetailApi.deleteBudget(transactionID, jwt);
      if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
        errorUpdateBudget.value = false;
        if (isNotiNavigate == false) {
          await Get.find<BudgetController>().getAllRequestBudget(1);
        }

        Get.back();
      } else {
        errorUpdateBudget.value = true;
        errorUpdateBudgetText.value = 'Đang có lỗi xảy ra';
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorUpdateBudget.value = true;
      errorUpdateBudgetText.value = 'Đang có lỗi xảy ra';
      print(e);
    }
  }

  Future<void> refreshPage() async {
    checkView.value = true;
    print('transactionID ${transactionID}');
    await getBudgetDetail(transactionID);
  }

  Future<void> getBudgetDetail(String transactionID) async {
    isLoading.value = true;
    try {
      checkToken();
      Transaction transaction = await BudgetDetailApi.getBudgetDetail(transactionID, jwt);
      transactionView.value = transaction;
      if (transaction.evidences!.isNotEmpty) {
        listAttachmentEvidence.value = transactionView.value.evidences!;
      }
      isLoading.value = false;
    } catch (e) {
      checkView.value = false;
      isLoading.value = false;
      print(e);
    }
  }

  Future<void> selectFile() async {
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

  Future<void> uploadFileEvidence() async {
    isLoading.value = true;
    try {
      checkToken();
      // List<FileModel> listFile = [];
      if (filePicker.isNotEmpty) {
        // for (var item in filePicker) {
        //   File fileResult = File(item.path!);
        //   UploadEvidenceModel responseApi = await BudgetDetailApi.uploadFile(jwt, fileResult, item.extension ?? '', transactionID);
        //   if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
        //     listAttachmentEvidence.add(Evidence(
        //         evidenceFileName: responseApi.result![0].fileName,
        //         evidenceFileSize: responseApi.result![0].fileSize,
        //         evidenceFileType: responseApi.result![0].fileType,
        //         evidenceUrl: responseApi.result![0].downloadUrl));
        //   } else {
        //     checkView.value = false;
        //   }
        // }
        // File fileResult = File(item.path!);
        UploadEvidenceModel responseApi = await BudgetDetailApi.uploadFile(jwt, filePicker, transactionID);
        if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
          if (responseApi.result!.isNotEmpty) {
            for (var item in responseApi.result!) {
              listAttachmentEvidence.add(Evidence(
                  evidenceFileName: item.fileName, evidenceFileSize: item.fileSize, evidenceFileType: item.fileType, evidenceUrl: item.downloadUrl));
            }
            Get.snackbar('Thông báo', 'Cập nhật tài liệu hóa đơn thành công',
                snackPosition: SnackPosition.TOP, backgroundColor: Colors.white, colorText: Color.fromARGB(255, 81, 146, 83));
          } else {
            checkView.value = false;
          }
        }
      }
      // ResponseApi responseApi = await SubTaskDetailApi.createComment(jwt, taskID, commentController.text, listFile);
      // if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
      //   listComment.value = await SubTaskDetailApi.getAllComment(jwt, taskModel.value.id!);
      //   listComment.sort((comment1, comment2) {
      //     return comment2.createdAt!.compareTo(comment1.createdAt!);
      //   });
      //   getAllAttachment();
      // } else {
      //   checkView.value = false;
      // }
      // } else {
      // ResponseApi responseApi = await SubTaskDetailApi.createComment(jwt, taskID, commentController.text, listFile);
      // if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
      //   listComment.value = await SubTaskDetailApi.getAllComment(jwt, taskModel.value.id!);
      //   listComment.sort((comment1, comment2) {
      //     return comment2.createdAt!.compareTo(comment1.createdAt!);
      //   });
      //   getAllAttachment();
      // } else {
      //   checkView.value = false;
      // }
      // }
      // filePicker.value = [];
      // } else {
      //   Get.snackbar('Thông báo', 'Công việc này không khả dụng nữa',
      //       snackPosition: SnackPosition.TOP, backgroundColor: Colors.transparent, colorText: ColorsManager.textColor);
      // }
      isLoading.value = false;
    } catch (e) {
      print(e);
      isLoading.value = false;
      checkView.value = false;
    }
  }

  Future<void> editBudget(List<PlatformFile> filePickerFile) async {
    try {
      // List<Evidence> list = [];
      if (filePickerFile.isNotEmpty) {
        // for (var item in filePickerFile) {
        //   File fileResult = File(item.path!);
        //   UploadEvidenceModel responseApi = await BudgetDetailApi.uploadFile(jwt, fileResult, item.extension ?? '', transactionID);
        //   if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
        //     listAttachmentEvidence.add(Evidence(
        //         evidenceFileName: responseApi.result![0].fileName,
        //         evidenceFileSize: responseApi.result![0].fileSize,
        //         evidenceFileType: responseApi.result![0].fileType,
        //         evidenceUrl: responseApi.result![0].downloadUrl));
        //   } else {
        //     checkView.value = false;
        //   }
        // }
        ResponseApi responseApi = await BudgetDetailApi.replaceEvidence(jwt, filePickerFile, transactionID);
        if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
          Get.snackbar('Cập nhật thành công', 'Cập nhật hóa đơn thành công',
              snackPosition: SnackPosition.TOP, backgroundColor: Colors.white, colorText: Colors.green);
          await refreshPage();
        } else {
          checkView.value = false;
        }
      }

      // listAttachmentEvidence.value = listAttachmentEvidence + list;
    } catch (e) {
      print(e);
      checkView.value = false;
    }
  }

  void deleteAttachmentCommentFile(int index) {
    isLoading.value = true;
    try {
      if (listAttachmentEvidence.isEmpty) {
        filePicker.removeAt(index);
      } else {
        listAttachmentEvidence.removeAt(index);
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
    }
  }

  void openFile(PlatformFile file) {
    OpenFile.open(file.path!);
  }
}
