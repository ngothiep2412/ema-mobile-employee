import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_view.dart';
import 'package:hrea_mobile_employee/app/resources/color_manager.dart';
import 'package:hrea_mobile_employee/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_employee/app/resources/style_manager.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';
import '../controllers/request_detail_controller.dart';

class RequestDetailView extends BaseView<RequestDetailController> {
  const RequestDetailView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
        appBar: _appBar(context),
        backgroundColor: ColorsManager.backgroundContainer,
        body: SafeArea(
          child: Obx(
            () => Padding(
              padding: EdgeInsets.all(UtilsReponsive.height(20, context)),
              child: controller.isLoading.value == true
                  ? Center(
                      child: SpinKitFadingCircle(
                        color: ColorsManager.primary,
                        // size: 30.0,
                      ),
                    )
                  : Column(children: [
                      Center(
                        child: Text(
                          'Thông tin đơn chi tiết',
                          style: GetTextStyle.getTextStyle(20, 'Nunito', FontWeight.w600, ColorsManager.primary),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: UtilsReponsive.paddingHorizontal(context, padding: 5),
                          child: RefreshIndicator(
                            onRefresh: controller.refreshPage,
                            child: ListView(
                              children: [
                                SizedBox(
                                  height: UtilsReponsive.heightv2(context, 15),
                                ),
                                Text(
                                  'Trạng thái',
                                  style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, ColorsManager.textColor),
                                ),
                                SizedBox(
                                  height: UtilsReponsive.heightv2(context, 10),
                                ),
                                Container(
                                  padding: UtilsReponsive.paddingAll(context, padding: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      UtilsReponsive.height(10, context),
                                    ),
                                  ),
                                  child: Text(
                                    controller.requestModelView.value.status! == "REJECT"
                                        ? "Từ chối"
                                        : controller.requestModelView.value.status! == "ACCEPT"
                                            ? "Chấp nhận"
                                            : "Đang xử lí",
                                    style: GetTextStyle.getTextStyle(
                                        14,
                                        'Nunito',
                                        FontWeight.w700,
                                        controller.requestModelView.value.status! == "REJECT"
                                            ? ColorsManager.red
                                            : controller.requestModelView.value.status! == "ACCEPT"
                                                ? ColorsManager.green
                                                : ColorsManager.orange),
                                  ),
                                ),
                                SizedBox(
                                  height: UtilsReponsive.heightv2(context, 15),
                                ),
                                Text(
                                  'Tiêu đề',
                                  style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, ColorsManager.textColor),
                                ),
                                SizedBox(
                                  height: UtilsReponsive.heightv2(context, 10),
                                ),
                                Container(
                                  padding: UtilsReponsive.paddingAll(context, padding: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      UtilsReponsive.height(10, context),
                                    ),
                                  ),
                                  child: Text(
                                    controller.requestModelView.value.title!,
                                    style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w700, ColorsManager.textColor2),
                                  ),
                                ),
                                SizedBox(
                                  height: UtilsReponsive.heightv2(context, 20),
                                ),
                                Text(
                                  'Loại kiểu nghỉ',
                                  style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, ColorsManager.textColor),
                                ),
                                SizedBox(
                                  height: UtilsReponsive.heightv2(context, 10),
                                ),
                                Container(
                                  padding: UtilsReponsive.paddingAll(context, padding: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      UtilsReponsive.height(10, context),
                                    ),
                                  ),
                                  child: Text(
                                    controller.requestModelView.value.type! == "A"
                                        ? "A: Nghỉ có lương"
                                        : controller.requestModelView.value.type! == "L"
                                            ? "L: Nghỉ không lương"
                                            : "M: Đi công tác",
                                    // 'hi',
                                    style: GetTextStyle.getTextStyle(
                                        14,
                                        'Nunito',
                                        FontWeight.w700,
                                        controller.requestModelView.value.type! == "A"
                                            ? ColorsManager.purple
                                            : controller.requestModelView.value.type! == "L"
                                                ? ColorsManager.blue
                                                : ColorsManager.red),
                                  ),
                                ),
                                SizedBox(
                                  height: UtilsReponsive.heightv2(context, 20),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Kiểu ngày nghỉ',
                                            style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, ColorsManager.textColor),
                                          ),
                                          SizedBox(
                                            height: UtilsReponsive.heightv2(context, 10),
                                          ),
                                          Container(
                                            width: 500,
                                            padding: UtilsReponsive.paddingAll(context, padding: 10),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(
                                                UtilsReponsive.height(10, context),
                                              ),
                                            ),
                                            child: Text(
                                              controller.requestModelView.value.isFull! ? "Nguyên ngày" : "Nữa ngày",
                                              // 'hi',
                                              style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w700, ColorsManager.textColor2),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: UtilsReponsive.width(10, context),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'kiểu buổi nghỉ',
                                            style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, ColorsManager.textColor),
                                          ),
                                          SizedBox(
                                            height: UtilsReponsive.heightv2(context, 10),
                                          ),
                                          Obx(
                                            () => !controller.requestModelView.value.isFull!
                                                ? Container(
                                                    width: 500,
                                                    padding: UtilsReponsive.paddingAll(context, padding: 10),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(
                                                        UtilsReponsive.height(10, context),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      controller.requestModelView.value.isPm! ? "Buổi chiều" : "Buổi sáng",
                                                      style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w700, ColorsManager.textColor2),
                                                    ),
                                                  )
                                                : Container(
                                                    width: 500,
                                                    padding: UtilsReponsive.paddingAll(context, padding: 10),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(
                                                        UtilsReponsive.height(10, context),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      "--",
                                                      style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w700, ColorsManager.textColor2),
                                                    ),
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: UtilsReponsive.heightv2(context, 20),
                                ),
                                Text(
                                  'Ngày bắt đầu',
                                  style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, ColorsManager.textColor),
                                ),
                                SizedBox(
                                  height: UtilsReponsive.heightv2(context, 10),
                                ),
                                Container(
                                  padding: UtilsReponsive.paddingAll(context, padding: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      UtilsReponsive.height(10, context),
                                    ),
                                  ),
                                  child: Text(
                                    controller.dateFormat.format(controller.requestModelView.value.startDate!),
                                    // 'hi',
                                    style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w700, ColorsManager.textColor2),
                                  ),
                                ),
                                SizedBox(
                                  height: UtilsReponsive.heightv2(context, 20),
                                ),
                                Text(
                                  'Ngày kết thúc',
                                  style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, ColorsManager.textColor),
                                ),
                                SizedBox(
                                  height: UtilsReponsive.heightv2(context, 10),
                                ),
                                Container(
                                  padding: UtilsReponsive.paddingAll(context, padding: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      UtilsReponsive.height(10, context),
                                    ),
                                  ),
                                  child: Text(
                                    controller.dateFormat.format(controller.requestModelView.value.endDate!),
                                    style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w700, ColorsManager.textColor2),
                                  ),
                                ),
                                SizedBox(
                                  height: UtilsReponsive.heightv2(context, 20),
                                ),
                                Text(
                                  'Nội dung',
                                  style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, ColorsManager.textColor),
                                ),
                                SizedBox(
                                  height: UtilsReponsive.heightv2(context, 10),
                                ),
                                Container(
                                  constraints: BoxConstraints(minHeight: UtilsReponsive.width(150, context)),
                                  padding: UtilsReponsive.paddingAll(context, padding: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      UtilsReponsive.height(10, context),
                                    ),
                                  ),
                                  child: Text(
                                    controller.requestModelView.value.content!,
                                    style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w700, ColorsManager.textColor2),
                                  ),
                                ),
                                SizedBox(
                                  height: UtilsReponsive.heightv2(context, 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]),
            ),
          ),
        ));
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
      actions: [
        Obx(
          () => controller.requestModelView.value.status == "ACCEPT" || controller.requestModelView.value.status == "REJECT"
              ? PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: ColorsManager.primary,
                  ),
                  onSelected: (choice) {
                    if (choice == 'delete') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Xác nhận xóa',
                                style: TextStyle(
                                    fontFamily: 'Nunito',
                                    wordSpacing: 1.2,
                                    color: ColorsManager.primary,
                                    fontSize: UtilsReponsive.height(20, context),
                                    fontWeight: FontWeight.bold)),
                            content: Text(
                              'Bạn có muốn xóa đơn này?',
                              style: TextStyle(
                                  fontFamily: 'Nunito',
                                  wordSpacing: 1.2,
                                  color: ColorsManager.textColor2,
                                  fontSize: UtilsReponsive.height(18, context),
                                  fontWeight: FontWeight.bold),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  await controller.deleteLeaveRequest();
                                  Navigator.of(Get.context!).pop();
                                  controller.errorUpdateBudget.value ? _errorMessage(Get.context!) : _successMessage(Get.context!);
                                },
                                child: Text('Xóa',
                                    style: TextStyle(
                                        fontFamily: 'Nunito',
                                        wordSpacing: 1.2,
                                        color: ColorsManager.red,
                                        fontSize: UtilsReponsive.height(18, context),
                                        fontWeight: FontWeight.bold)),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Hủy',
                                    style: TextStyle(
                                        fontFamily: 'Nunito',
                                        wordSpacing: 1.2,
                                        color: ColorsManager.primary,
                                        fontSize: UtilsReponsive.height(18, context),
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Text(
                          'Xóa đơn này',
                          style: TextStyle(
                              fontFamily: 'Nunito',
                              wordSpacing: 1.2,
                              color: ColorsManager.textColor2,
                              fontSize: UtilsReponsive.height(18, context),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ];
                  },
                )
              : PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: ColorsManager.primary,
                  ),
                  onSelected: (choice) {
                    if (choice == 'delete') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Xác nhận xóa',
                                style: TextStyle(
                                    fontFamily: 'Nunito',
                                    wordSpacing: 1.2,
                                    color: ColorsManager.primary,
                                    fontSize: UtilsReponsive.height(20, context),
                                    fontWeight: FontWeight.bold)),
                            content: Text(
                              'Bạn có muốn xóa đơn này?',
                              style: TextStyle(
                                  fontFamily: 'Nunito',
                                  wordSpacing: 1.2,
                                  color: ColorsManager.textColor2,
                                  fontSize: UtilsReponsive.height(18, context),
                                  fontWeight: FontWeight.bold),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  await controller.deleteLeaveRequest();
                                  Navigator.of(Get.context!).pop();
                                  controller.errorUpdateBudget.value ? _errorMessage(Get.context!) : _successMessage(Get.context!);
                                },
                                child: Text('Xóa',
                                    style: TextStyle(
                                        fontFamily: 'Nunito',
                                        wordSpacing: 1.2,
                                        color: ColorsManager.red,
                                        fontSize: UtilsReponsive.height(18, context),
                                        fontWeight: FontWeight.bold)),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Hủy',
                                    style: TextStyle(
                                        fontFamily: 'Nunito',
                                        wordSpacing: 1.2,
                                        color: ColorsManager.primary,
                                        fontSize: UtilsReponsive.height(18, context),
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          );
                        },
                      );
                    }
                    if (choice == 'edit') {
                      Get.toNamed(Routes.EDIT_REQUEST, arguments: {"requestID": controller.requestID, "request": controller.requestModelView});
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Text(
                          'Xóa đơn này',
                          style: TextStyle(
                              fontFamily: 'Nunito',
                              wordSpacing: 1.2,
                              color: ColorsManager.textColor2,
                              fontSize: UtilsReponsive.height(18, context),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'edit',
                        child: Text(
                          'Chỉnh sửa thông tin đơn',
                          style: TextStyle(
                              fontFamily: 'Nunito',
                              wordSpacing: 1.2,
                              color: ColorsManager.textColor2,
                              fontSize: UtilsReponsive.height(18, context),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ];
                  },
                ),
        )
      ],
    );
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
                  'Xóa đơn thành công',
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
                      controller.errorUpdateBudgetText.value,
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
}
