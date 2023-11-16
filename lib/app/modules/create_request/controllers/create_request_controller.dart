import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_employee/app/base/base_controller.dart';
import 'package:hrea_mobile_employee/app/modules/create_request/api/create_request_api.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/controllers/tab_request_controller/tab_request_controller.dart';
import 'package:hrea_mobile_employee/app/resources/response_api_model.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';

class CreateRequestController extends BaseController {
  final count = 0.obs;

  RxBool isLoading = false.obs;
  RxBool errorCreateRequest = false.obs;
  RxString errorCreateRequestText = ''.obs;

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  var selectedStartDate = DateTime.now().obs;
  var selectedEndDate = DateTime.now().obs;

  final dayType = ["Nữa ngày", "Nguyên ngày"];
  RxString selectedDayTypeVal = 'Nữa ngày'.obs;

  final timeType = ["Buổi sáng", "Buổi chiều"];
  RxString selectedTimeTypeVal = 'Buổi sáng'.obs;

  final leaveType = ["A: Nghỉ có lương", "L: Nghỉ không lương", "M: Đi công tác"];
  RxString selectedLeaveTypeVal = 'A: Nghỉ có lương'.obs;

  String jwt = '';

  RxBool isPM = false.obs;
  RxBool isFull = false.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  bool isDateValid(String date) {
    const pattern = r'^\d{2}/\d{2}/\d{4}$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(date)) {
      return false;
    }
    final parts = date.split('/');
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) {
      return false;
    }

    if (month < 1 || month > 12) {
      return false;
    }

    if (day < 1 || day > 31) {
      return false;
    }

    return true;
  }

  bool isValidPhoneNumber(String phoneNumber) {
    RegExp regex = RegExp(r'^(0|\+84)[1-9]\d{8,9}$');
    if (!regex.hasMatch(phoneNumber)) {
      return false;
    }
    return true;
  }

  setDayType(String value) {
    selectedDayTypeVal.value = value;
  }

  setTimeType(String value) {
    selectedTimeTypeVal.value = value;
  }

  setLeaveType(String value) {
    selectedLeaveTypeVal.value = value;
  }

  void checkToken() {
    if (GetStorage().read('JWT') != null) {
      jwt = GetStorage().read('JWT');
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  Future<void> createLeaveRequest() async {
    isLoading.value = true;
    if (titleController.text == '') {
      errorCreateRequest.value = true;
      errorCreateRequestText.value = "Vui lòng nhập tiêu đề";
      isLoading.value = false;
    } else if (contentController.text == '') {
      errorCreateRequest.value = true;
      errorCreateRequestText.value = "Vui lòng nhập nội dung";
      isLoading.value = false;
    } else if (isDateValid(startDateController.text) != true) {
      errorCreateRequest.value = true;
      errorCreateRequestText.value = "Ngày bắt đầu không hợp lệ, nhập đúng định dạng dd/mm/yyyy";
      isLoading.value = false;
    } else if (isDateValid(endDateController.text) != true) {
      errorCreateRequest.value = true;
      errorCreateRequestText.value = "Ngày kết thúc không hợp lệ, nhập đúng định dạng dd/mm/yyyy";
      isLoading.value = false;
    } else {
      try {
        checkToken();

        if (selectedDayTypeVal.value == 'Nguyên ngày') {
          isFull.value = true;
          isPM.value = false;
        } else {
          isFull.value = false;
          if (selectedTimeTypeVal.value == "Buổi sáng") {
            isPM.value = false;
          } else {
            isPM.value = true;
          }
        }
        List<String> startDateparts = startDateController!.text.split('/');
        String formattedStartDate = '${startDateparts[2]}-${startDateparts[1]}-${startDateparts[0]}';
        List<String> endDateparts = endDateController!.text.split('/');
        String formattedEndDate = '${endDateparts[2]}-${endDateparts[1]}-${endDateparts[0]}';
        ResponseApi responseApi = await CreateRequestApi.createLeaveRequest(titleController.text, contentController.text,
            DateTime.parse(formattedStartDate), DateTime.parse(formattedEndDate), isFull.value, isPM.value, selectedLeaveTypeVal.value[0], jwt);
        if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
          errorCreateRequest.value = false;
          await Get.find<TabRequestController>().getAllLeaveRequest(1);
        } else {
          errorCreateRequest.value = true;
          errorCreateRequestText.value = "Không thể tạo đơn";
        }

        isLoading.value = false;
      } catch (e) {
        log(e.toString());
        errorCreateRequest.value = true;
        isLoading.value = false;
        errorCreateRequestText.value = "Có lỗi xảy ra";
      }
    }
  }
}
