import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_employee/app/base/base_controller.dart';
import 'package:hrea_mobile_employee/app/modules/budget/controllers/budget_controller.dart';
import 'package:hrea_mobile_employee/app/modules/budget/model/budget_model.dart';
import 'package:hrea_mobile_employee/app/modules/budget_detail/controllers/budget_detail_controller.dart';
import 'package:hrea_mobile_employee/app/modules/edit_budget/api/edit_budget_api.dart';
import 'package:hrea_mobile_employee/app/modules/task-detail-view/model/uploadfile_model.dart';
import 'package:hrea_mobile_employee/app/resources/response_api_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';

class EditBudgetController extends BaseController {
  EditBudgetController({required this.eventID, required this.budget});
  String eventID = '';
  Rx<BudgetModel> budget = BudgetModel().obs;

  TextEditingController budgetNameController = TextEditingController();
  TextEditingController estExpenseController = TextEditingController();
  TextEditingController realExpenseController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController supplierController = TextEditingController();
  ImagePicker imagePicker = ImagePicker();
  RxString imageUrl = "".obs;
  File? imageFile;
  XFile? file;

  RxBool isLoading = false.obs;

  String jwt = '';
  String idUser = '';

  RxString selectImagePath = ''.obs;
  RxString selectImageSize = ''.obs;

  RxBool errorUpdateBudget = false.obs;
  RxString errorUpdateBudgetText = ''.obs;

  ResponseApi? responseApi;

  @override
  void onInit() {
    super.onInit();

    String formatValueEstExp = NumberFormat("#,##0", "vi_VN").format(budget.value.estExpense);
    String formatValueRealExp = NumberFormat("#,##0", "vi_VN").format(budget.value.realExpense);
    budgetNameController.text = budget.value.budgetName!;
    estExpenseController.text = formatValueEstExp;
    realExpenseController.text = formatValueRealExp;
    descriptionController.text = budget.value.description!;
    supplierController.text = budget.value.supplier!;
    if (budget.value.urlImage != null) {
      imageUrl.value = budget.value.urlImage;
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> updateBudget() async {
    isLoading.value = true;
    String estExpense = estExpenseController.text;
    String cleanedEstExpense = estExpense.replaceAll('.', '');
    int amountEstExpense = int.tryParse(cleanedEstExpense) ?? 0;

    String realExpense = realExpenseController.text;
    String cleanedRealExpense = realExpense.replaceAll('.', '');
    int amountRealExpense = int.tryParse(cleanedRealExpense) ?? 0;
    if (budgetNameController.text == '') {
      print(budgetNameController.text);
      errorUpdateBudget.value = true;
      errorUpdateBudgetText.value = "Vui lòng nhập tên khoản chi";
      isLoading.value = false;
    } else if (estExpenseController.text.isEmpty) {
      errorUpdateBudget.value = true;
      errorUpdateBudgetText.value = "Vui lòng nhập số tiền chi phí ước tính";
      isLoading.value = false;
    } else if (estExpenseController.text.isNotEmpty && amountEstExpense < 999) {
      errorUpdateBudget.value = true;
      errorUpdateBudgetText.value = "Vui lòng nhập số tiền chi phí ước tính lớn hơn 999 đồng";
      isLoading.value = false;
    } else if (realExpenseController.text.isNotEmpty && amountRealExpense < 999) {
      errorUpdateBudget.value = true;
      errorUpdateBudgetText.value = "Vui lòng nhập số tiền chi phí thực tế lớn hơn 999 đồng";
      isLoading.value = false;
    } else if (supplierController.text.isEmpty) {
      errorUpdateBudget.value = true;
      errorUpdateBudgetText.value = "Vui lòng nhập tên nhà cung cấp";
      isLoading.value = false;
    } else {
      try {
        // String? jwtToken = pref.getString('JWT');
        String? jwtToken = GetStorage().read('JWT');

        if (jwtToken != null) {
          if (imageFile == null) {
            responseApi = await EditBudgetApi.updateBudget(eventID, budgetNameController.text, amountEstExpense, amountRealExpense,
                descriptionController.text, imageUrl.value, supplierController.text, budget.value.id!, jwtToken);
            if (responseApi!.statusCode == 200 || responseApi!.statusCode == 201) {
              errorUpdateBudget.value = false;
              await Get.find<BudgetController>().getAllRequestBudget(1);
              await Get.find<BudgetDetailController>().getBudgetDetail(budget.value.id!);
            } else {
              errorUpdateBudget.value = true;
              errorUpdateBudgetText.value = "Không thể cập nhật thông tin";
            }
          } else {
            UploadFileModel responseApi = await EditBudgetApi.uploadFile(jwtToken, file!);
            if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
              ResponseApi responseApiv2 = await EditBudgetApi.updateBudget(eventID, budgetNameController.text, amountEstExpense, amountRealExpense,
                  descriptionController.text, responseApi.result!.downloadUrl!, supplierController.text, budget.value.id!, jwtToken);
              if (responseApiv2.statusCode == 200 || responseApiv2.statusCode == 201) {
                errorUpdateBudget.value = false;
                await Get.find<BudgetController>().getAllRequestBudget(1);
                await Get.find<BudgetDetailController>().getBudgetDetail(budget.value.id!);
              } else {
                errorUpdateBudget.value = true;
                errorUpdateBudgetText.value = "Không thể cập nhật khoản chi";
              }
            } else {
              errorUpdateBudget.value = true;
              errorUpdateBudgetText.value = "Kích thước file phải nhỏ hơn 10mb";
            }
          }
          isLoading.value = false;
        }
      } catch (e) {
        log(e.toString());
        errorUpdateBudget.value = true;
        isLoading.value = false;
        errorUpdateBudgetText.value = "Có lỗi xảy ra";
      }
    }
  }

  void openFile(String filePath) {
    OpenFile.open(filePath);
  }

  Future selectImage(ImageSource source) async {
    file = await imagePicker.pickImage(source: source);
    if (file != null) {
      imageFile = File(file!.path);
      selectImagePath.value = file!.path;
      selectImageSize.value = "${((File(selectImagePath.value)).lengthSync() / 1024 / 1024).toStringAsFixed(2)}Mb";
      double fileLength = File(selectImagePath.value).lengthSync() / 1024 / 1024;
      if (fileLength > 10) {
        Get.snackbar('Lỗi', 'Không thể lấy hình lớn hơn 10mb',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
        isLoading.value = false;
        return;
      }
      // imageFile = File(file!.path);
      // selectImagePath.value = file!.path;
      // selectImageSize.value =
      //     "${((File(selectImagePath.value)).lengthSync() / 1024 / 1024).toStringAsFixed(2)}Mb";
    } else {
      Get.snackbar('Lỗi', 'Không thể lấy hình ảnh',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }
}
