import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_view.dart';
import 'package:hrea_mobile_employee/app/resources/color_manager.dart';
import 'package:hrea_mobile_employee/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_employee/app/resources/style_manager.dart';
import 'package:intl/intl.dart';
import '../controllers/create_request_controller.dart';

class CreateRequestView extends BaseView<CreateRequestController> {
  const CreateRequestView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      backgroundColor: ColorsManager.backgroundContainer,
      body: SafeArea(
        child: Column(children: [
          SizedBox(
            height: UtilsReponsive.heightv2(context, 15),
          ),
          Text(
            "Tạo đơn",
            style: GetTextStyle.getTextStyle(20, 'Nunito', FontWeight.w600, ColorsManager.textColor),
          ),
          SizedBox(
            height: UtilsReponsive.heightv2(context, 10),
          ),
          Expanded(
            flex: 10,
            child: Padding(
              padding: UtilsReponsive.paddingHorizontal(context, padding: 20),
              child: ListView(
                children: [
                  Text(
                    'Tiêu đề',
                    style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, ColorsManager.primary),
                  ),
                  SizedBox(
                    height: UtilsReponsive.heightv2(context, 10),
                  ),
                  buildTextField(context, "Tiêu đề", "Ví dụ: Xin nghỉ phép", controller.titleController),
                  Text(
                    'Nội dung',
                    style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, ColorsManager.primary),
                  ),
                  SizedBox(
                    height: UtilsReponsive.heightv2(context, 10),
                  ),
                  buildTextField(context, "Nội dung", "Ví dụ: Bị bệnh", controller.contentController),
                  Text(
                    'Loại kiểu nghỉ',
                    style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, ColorsManager.primary),
                  ),
                  DropdownButtonFormField(
                    items: controller.leaveType
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w400, ColorsManager.textColor),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      controller.setLeaveType(value as String);
                    },
                    value: controller.selectedLeaveTypeVal.value,
                    icon: Icon(
                      Icons.arrow_drop_down_circle,
                      color: ColorsManager.primary,
                    ),
                    decoration: const InputDecoration(
                        // labelText: 'Giới tính',
                        errorBorder: InputBorder.none,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        fillColor: ColorsManager.textInput,
                        filled: true),
                  ),
                  SizedBox(
                    height: UtilsReponsive.heightv2(context, 10),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kiểu ngày nghỉ',
                              style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, ColorsManager.primary),
                            ),
                            DropdownButtonFormField(
                              items: controller.dayType
                                  .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(
                                          e,
                                          style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w400, ColorsManager.textColor),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                controller.setDayType(value as String);
                              },
                              value: controller.selectedDayTypeVal.value,
                              icon: Icon(
                                Icons.arrow_drop_down_circle,
                                color: ColorsManager.primary,
                              ),
                              decoration: const InputDecoration(
                                  // labelText: 'Giới tính',
                                  errorBorder: InputBorder.none,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  fillColor: ColorsManager.textInput,
                                  filled: true),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: UtilsReponsive.heightv2(context, 10),
                      ),
                      Expanded(
                        child: Obx(
                          () => controller.selectedDayTypeVal.value == 'Nguyên ngày'
                              ? SizedBox()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Kiểu buổi nghỉ',
                                      style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, ColorsManager.primary),
                                    ),
                                    DropdownButtonFormField(
                                      items: controller.timeType
                                          .map((e) => DropdownMenuItem(
                                                value: e,
                                                child: Text(
                                                  e,
                                                  style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w400, ColorsManager.textColor),
                                                ),
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        controller.setTimeType(value as String);
                                      },
                                      value: controller.selectedTimeTypeVal.value,
                                      icon: Icon(
                                        Icons.arrow_drop_down_circle,
                                        color: ColorsManager.primary,
                                      ),
                                      decoration: const InputDecoration(
                                          // labelText: 'Giới tính',
                                          errorBorder: InputBorder.none,
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                          ),
                                          fillColor: ColorsManager.textInput,
                                          filled: true),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: UtilsReponsive.heightv2(context, 10),
                  ),
                  Text(
                    'Ngày bắt đầu',
                    style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, ColorsManager.primary),
                  ),
                  SizedBox(
                    height: UtilsReponsive.heightv2(context, 10),
                  ),
                  buildTextFieldDate(context, "Ngày bắt đầu", "Ví dụ: 2001/24/12", true),
                  SizedBox(
                    height: UtilsReponsive.heightv2(context, 10),
                  ),
                  Text(
                    'Ngày kết thúc',
                    style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, ColorsManager.primary),
                  ),
                  SizedBox(
                    height: UtilsReponsive.heightv2(context, 10),
                  ),
                  buildTextFieldDate(context, "Ngày kết thúc", "Ví dụ: 2001/24/12", false),
                  SizedBox(
                    height: UtilsReponsive.heightv2(context, 10),
                  ),
                  SizedBox(
                    height: UtilsReponsive.heightv2(context, 20),
                  ),
                  Obx(
                    () => Container(
                      height: UtilsReponsive.heightv2(context, 60),
                      child: ElevatedButton(
                        onPressed: () async {
                          await controller.createLeaveRequest();
                          controller.errorCreateRequest.value ? _errorMessage(Get.context!) : _successMessage(Get.context!);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        child: controller.isLoading.value
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: ColorsManager.backgroundWhite,
                                ),
                              )
                            : Text(
                                "Tạo đơn",
                                style: GetTextStyle.getTextStyle(
                                  14,
                                  'Nunito',
                                  FontWeight.w800,
                                  ColorsManager.backgroundWhite,
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: UtilsReponsive.height(10, context),
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget buildTextField(
    BuildContext context,
    String labelText,
    String hintText,
    TextEditingController? nameTextEditingController,
  ) {
    return Padding(
      padding: UtilsReponsive.paddingOnly(context, bottom: 10),
      child: TextField(
        controller: nameTextEditingController,
        decoration: InputDecoration(
          errorBorder: InputBorder.none,
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: ColorsManager.textInput,
          // labelText: labelText,
          // labelStyle: TextStyle(color: ColorsManager.primary, fontSize: 20),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: hintText,
          hintStyle: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w400, ColorsManager.textColor2),
        ),
      ),
    );
  }

  Widget buildTextFieldDate(
    BuildContext context,
    String labelText,
    String hintText,
    bool isStartDate,
  ) {
    return Padding(
      padding: UtilsReponsive.paddingOnly(context, bottom: 10),
      child: TextField(
        controller: isStartDate ? controller.startDateController : controller.endDateController,
        decoration: InputDecoration(
          errorBorder: InputBorder.none,
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              if (isStartDate) {
                chooseStartDate();
              } else {
                chooseEndDate();
              }
            },
            icon: Icon(
              Icons.calendar_today_rounded,
              color: Colors.grey[600]!,
            ),
          ),
          filled: true,
          fillColor: ColorsManager.textInput,
          // labelText: labelText,
          // labelStyle: TextStyle(color: ColorsManager.primary, fontSize: 20),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: hintText,
          hintStyle: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w400, ColorsManager.textColor2),
        ),
      ),
    );
  }

  chooseStartDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: controller.selectedStartDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      //initialEntryMode: DatePickerEntryMode.input,
      // initialDatePickerMode: DatePickerMode.year,
      helpText: 'Chọn ngày bắt đầu',
      cancelText: 'Đóng',
      confirmText: 'Xác nhận',
      errorFormatText: 'Nhập ngày hợp lệ',
      errorInvalidText: 'Nhập phạm vi ngày hợp lệ',
      fieldLabelText: 'Ngày Bắt Đầu',
      fieldHintText: 'Ngày/Tháng/Năm',
    );
    if (pickedDate != null && pickedDate != controller.selectedStartDate.value) {
      controller.selectedStartDate.value = pickedDate;
      controller.startDateController.text = DateFormat('dd/MM/yyyy').format(controller.selectedStartDate.value).toString();
      print(' dateController!.text ${controller.startDateController.text}');
    }
  }

  chooseEndDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: controller.selectedEndDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      //initialEntryMode: DatePickerEntryMode.input,
      // initialDatePickerMode: DatePickerMode.year,
      helpText: 'Chọn ngày kết thúc',
      cancelText: 'Đóng',
      confirmText: 'Xác nhận',
      errorFormatText: 'Nhập ngày hợp lệ',
      errorInvalidText: 'Nhập phạm vi ngày hợp lệ',
      fieldLabelText: 'Ngày Kết Thúc',
      fieldHintText: 'Ngày/Tháng/Năm',
    );
    if (pickedDate != null && pickedDate != controller.selectedEndDate.value) {
      if (pickedDate.year < controller.selectedStartDate.value.year ||
          (pickedDate.year == controller.selectedStartDate.value.year && pickedDate.month < controller.selectedStartDate.value.month) ||
          (pickedDate.year == controller.selectedStartDate.value.year &&
              pickedDate.month == controller.selectedStartDate.value.month &&
              pickedDate.day < controller.selectedStartDate.value.day)) {
        Get.snackbar('Lỗi', 'Ngày kết thúc không được chọn sau ngày bắt đầu',
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.transparent, colorText: ColorsManager.textColor);
      } else {
        controller.selectedEndDate.value = pickedDate;
        controller.endDateController.text = DateFormat('dd/MM/yyyy').format(controller.selectedEndDate.value).toString();
        print(' dateController!.text ${controller.endDateController.text}');
      }
    }
  }

  _successMessage(BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        content: Container(
          padding: UtilsReponsive.paddingAll(context, padding: 8),
          height: UtilsReponsive.heightv2(context, 80),
          decoration: const BoxDecoration(color: Color.fromARGB(255, 81, 146, 83), borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Row(children: [
            const Icon(
              Icons.check_circle,
              color: ColorsManager.backgroundWhite,
              size: 40,
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Thành công',
                  style: GetTextStyle.getTextStyle(18, 'Nunito', FontWeight.w800, Colors.white),
                ),
                Spacer(),
                Text(
                  'Thay đổi thông tin đơn thành công',
                  style: GetTextStyle.getTextStyle(12, 'Nunito', FontWeight.w500, Colors.white),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ))
          ]),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      ),
    );
  }

  _errorMessage(BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        content: Container(
          padding: UtilsReponsive.paddingAll(context, padding: 8),
          height: UtilsReponsive.heightv2(context, 80),
          decoration: const BoxDecoration(color: Color.fromARGB(255, 219, 90, 90), borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Row(children: [
            const Icon(
              Icons.error_outline,
              color: ColorsManager.backgroundWhite,
              size: 40,
            ),
            SizedBox(
              width: UtilsReponsive.widthv2(context, 12),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Thất bại',
                    style: GetTextStyle.getTextStyle(18, 'Nunito', FontWeight.w800, Colors.white),
                  ),
                  const Spacer(),
                  Obx(
                    () => Text(
                      controller.errorCreateRequestText.value,
                      style: GetTextStyle.getTextStyle(12, 'Nunito', FontWeight.w500, Colors.white),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            )
          ]),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: ColorsManager.backgroundContainer,
      leading: IconButton(
        onPressed: () {
          Get.back();
          controller.onDelete();
        },
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: ColorsManager.primary,
        ),
      ),
    );
  }
}
