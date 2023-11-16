import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_employee/app/base/base_controller.dart';
import 'package:hrea_mobile_employee/app/modules/edit_request/api/edit_request_api.dart';
import 'package:hrea_mobile_employee/app/modules/request_detail/controllers/request_detail_controller.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/controllers/tab_request_controller/tab_request_controller.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/request.dart';
import 'package:hrea_mobile_employee/app/resources/response_api_model.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';
import 'package:intl/intl.dart';

class EditRequestController extends BaseController {
  EditRequestController({required this.requestID, required this.requestModel});
  Rx<RequestModel> requestModel = RequestModel().obs;
  String requestID = '';
  final count = 0.obs;

  RxBool isLoading = false.obs;
  RxBool isLoadingUpdate = false.obs;

  RxBool errorUpdateRequest = false.obs;
  RxString errorUpdateRequestText = ''.obs;

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
  DateFormat dateFormat = DateFormat('dd/MM/yyyy', 'vi');
  RxBool isPM = false.obs;
  RxBool isFull = false.obs;
  @override
  void onInit() {
    super.onInit();
    titleController.text = requestModel.value.title!;
    contentController.text = requestModel.value.content!;
    selectedLeaveTypeVal.value = requestModel.value.type == "A"
        ? "A: Nghỉ có lương"
        : requestModel.value.type == "L"
            ? "L: Nghỉ không lương"
            : "M: Đi công tác";
    selectedDayTypeVal.value = requestModel.value.isFull! ? "Nguyên ngày" : "Nữa ngày";
    selectedTimeTypeVal.value = requestModel.value.isPm! ? "PM" : "AM";
    startDateController.text = dateFormat.format(requestModel.value.startDate!);
    endDateController.text = dateFormat.format(requestModel.value.endDate!);
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

  Future<void> updateLeaveRequest() async {
    isLoadingUpdate.value = true;
    if (titleController.text == '') {
      errorUpdateRequest.value = true;
      errorUpdateRequestText.value = "Vui lòng nhập tiêu đề";
      isLoadingUpdate.value = false;
    } else if (contentController.text == '') {
      errorUpdateRequest.value = true;
      errorUpdateRequestText.value = "Vui lòng nhập nội dung";
      isLoadingUpdate.value = false;
    } else if (isDateValid(startDateController.text) != true) {
      errorUpdateRequest.value = true;
      errorUpdateRequestText.value = "Ngày bắt đầu không hợp lệ, nhập đúng định dạng dd/mm/yyyy";
      isLoadingUpdate.value = false;
    } else if (isDateValid(endDateController.text) != true) {
      errorUpdateRequest.value = true;
      errorUpdateRequestText.value = "Ngày kết thúc không hợp lệ, nhập đúng định dạng dd/mm/yyyy";
      isLoadingUpdate.value = false;
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
        List<String> startDateparts = startDateController.text.split('/');
        String formattedStartDate = '${startDateparts[2]}-${startDateparts[1]}-${startDateparts[0]}';
        List<String> endDateparts = endDateController.text.split('/');
        String formattedEndDate = '${endDateparts[2]}-${endDateparts[1]}-${endDateparts[0]}';
        ResponseApi responseApi = await EditRequestApi.updateRequest(requestID, titleController.text, contentController.text,
            DateTime.parse(formattedStartDate), DateTime.parse(formattedEndDate), isFull.value, isPM.value, selectedLeaveTypeVal.value[0], jwt);
        if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
          errorUpdateRequest.value = false;
          await Get.find<TabRequestController>().getAllLeaveRequest(1);
          await Get.find<RequestDetailController>().getLeaveRequestDetail(requestID);
        } else {
          errorUpdateRequest.value = true;
          errorUpdateRequestText.value = "Không thể tạo đơn";
        }

        isLoadingUpdate.value = false;
      } catch (e) {
        log(e.toString());
        errorUpdateRequest.value = true;
        isLoadingUpdate.value = false;
        errorUpdateRequestText.value = "Có lỗi xảy ra";
      }
    }
  }
}
