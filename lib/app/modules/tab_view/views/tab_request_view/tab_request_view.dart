import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_view.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/controllers/tab_request_controller/tab_request_controller.dart';
import 'package:hrea_mobile_employee/app/resources/assets_manager.dart';
import 'package:hrea_mobile_employee/app/resources/color_manager.dart';
import 'package:hrea_mobile_employee/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_employee/app/resources/style_manager.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';

class TabRequestView extends BaseView<TabRequestController> {
  const TabRequestView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return SafeArea(
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
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Đơn yêu cầu',
                        style: GetTextStyle.getTextStyle(22, 'Roboto', FontWeight.w600, ColorsManager.primary),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          controller.isFilter.value
                              ? IconButton(
                                  onPressed: () {
                                    controller.isFilter.value = !controller.isFilter.value;
                                  },
                                  icon: Icon(
                                    Icons.filter_alt_off_outlined,
                                    color: ColorsManager.calendar,
                                  ))
                              : IconButton(
                                  onPressed: () {
                                    controller.isFilter.value = !controller.isFilter.value;
                                  },
                                  icon: const Icon(
                                    Icons.filter_alt_outlined,
                                    color: ColorsManager.calendar,
                                  )),
                          InkWell(
                            onTap: () {
                              Get.toNamed(Routes.CREATE_REQUEST);
                            },
                            child: Container(
                              width: UtilsReponsive.width(40, context),
                              height: UtilsReponsive.height(40, context),
                              decoration:
                                  BoxDecoration(color: ColorsManager.primary, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(8)),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  controller.isFilter.value
                      ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          SizedBox(
                            height: UtilsReponsive.height(10, context),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Bộ lọc',
                                style: GetTextStyle.getTextStyle(16, 'Roboto', FontWeight.w700, ColorsManager.calendar),
                              ),
                              InkWell(
                                onTap: () async {
                                  controller.clearFilter();
                                },
                                child: Text(
                                  'Đặt lại',
                                  style: GetTextStyle.getTextStyle(16, 'Roboto', FontWeight.w700, ColorsManager.calendar),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: UtilsReponsive.height(15, context),
                          ),
                          Row(
                            children: [
                              Obx(
                                () => Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Năm',
                                        style: GetTextStyle.getTextStyle(14, 'Roboto', FontWeight.w700, ColorsManager.textColor),
                                      ),
                                      SizedBox(
                                        height: UtilsReponsive.height(10, context),
                                      ),
                                      DropdownButtonFormField(
                                        items: controller.timeType
                                            .map((e) => DropdownMenuItem(
                                                  value: e,
                                                  child: Text(
                                                    e,
                                                    style: GetTextStyle.getTextStyle(15, 'Roboto', FontWeight.w600, ColorsManager.textColor),
                                                  ),
                                                ))
                                            .toList(),
                                        onChanged: (value) {
                                          controller.setTimeType(value as String);
                                        },
                                        value: controller.selectedTimeTypeVal.value,
                                        decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.only(left: UtilsReponsive.height(10, context), right: UtilsReponsive.height(10, context)),
                                            // labelText: 'Giới tính',
                                            errorBorder: InputBorder.none,
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            fillColor: ColorsManager.textInput,
                                            filled: true),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: UtilsReponsive.height(10, context),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    _showBottomSheetStatus(context);
                                  },
                                  child: Obx(
                                    () => Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Trạng thái',
                                          style: GetTextStyle.getTextStyle(14, 'Roboto', FontWeight.w700, ColorsManager.textColor),
                                        ),
                                        SizedBox(
                                          height: UtilsReponsive.height(10, context),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: UtilsReponsive.height(10, context),
                                            vertical: UtilsReponsive.height(15, context),
                                          ),
                                          decoration: BoxDecoration(
                                            color: controller.status.value == "Đang xử lí"
                                                ? ColorsManager.yellow.withOpacity(0.5)
                                                : controller.status.value == "Đồng ý"
                                                    ? ColorsManager.green.withOpacity(0.5)
                                                    : controller.status.value == "Tất cả"
                                                        ? ColorsManager.grey
                                                        : ColorsManager.red.withOpacity(0.5),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          // width: UtilsReponsive.width(100, context),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            // mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                controller.status.value,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: controller.status.value == "Đang xử lí"
                                                        ? Colors.yellow[800]
                                                        : controller.status.value == "Đồng ý"
                                                            ? Colors.green[800]
                                                            : controller.status.value == "Tất cả"
                                                                ? ColorsManager.textColor2
                                                                : Colors.red[800],
                                                    fontSize: 15),
                                              ),
                                              Icon(
                                                Icons.arrow_drop_down,
                                                color: controller.status.value == "Đang xử lí"
                                                    ? Colors.yellow[800]
                                                    : controller.status.value == "Đồng ý"
                                                        ? Colors.green[800]
                                                        : controller.status.value == "Tất cả"
                                                            ? ColorsManager.textColor2
                                                            : Colors.red[800],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: UtilsReponsive.height(10, context),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    _showBottomSheetLeave(context);
                                  },
                                  child: Obx(
                                    () => Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Loại nghỉ',
                                          style: GetTextStyle.getTextStyle(14, 'Roboto', FontWeight.w700, ColorsManager.textColor),
                                        ),
                                        SizedBox(
                                          height: UtilsReponsive.height(10, context),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: UtilsReponsive.height(10, context),
                                            vertical: UtilsReponsive.height(15, context),
                                          ),
                                          decoration: BoxDecoration(
                                            color: controller.leaveStatus.value == "Nghỉ có lương"
                                                ? ColorsManager.purple.withOpacity(0.5)
                                                : controller.leaveStatus.value == "Nghỉ không lương"
                                                    ? ColorsManager.blue.withOpacity(0.5)
                                                    : controller.leaveStatus.value == "Tất cả"
                                                        ? ColorsManager.grey
                                                        : ColorsManager.red.withOpacity(0.5),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          // width: UtilsReponsive.width(100, context),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            // mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                controller.leaveStatus.value,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: controller.leaveStatus.value == "Nghỉ có lương"
                                                        ? Colors.purple[800]
                                                        : controller.leaveStatus.value == "Nghỉ không lương"
                                                            ? Colors.blue[800]
                                                            : controller.leaveStatus.value == "Tất cả"
                                                                ? ColorsManager.textColor2
                                                                : Colors.red[800],
                                                    fontSize: 15),
                                              ),
                                              Icon(
                                                Icons.arrow_drop_down,
                                                color: controller.leaveStatus.value == "Nghỉ có lương"
                                                    ? Colors.purple[800]
                                                    : controller.leaveStatus.value == "Nghỉ không lương"
                                                        ? Colors.blue[800]
                                                        : controller.leaveStatus.value == "Tất cả"
                                                            ? ColorsManager.textColor2
                                                            : Colors.red[800],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ])
                      : SizedBox(),
                  SizedBox(
                    height: UtilsReponsive.height(20, context),
                  ),
                  Expanded(
                    flex: 2,
                    child: RefreshIndicator(
                      onRefresh: controller.refreshPage,
                      child: controller.listRequest.isEmpty
                          ? ListView(children: [
                              SizedBox(
                                height: UtilsReponsive.height(100, context),
                              ),
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center, // Center children horizontally
                                  mainAxisSize: MainAxisSize.min, // Take up minimum vertical space
                                  children: [
                                    Image.asset(
                                      ImageAssets.noRequest,
                                      fit: BoxFit.contain,
                                      width: UtilsReponsive.widthv2(context, 200),
                                      height: UtilsReponsive.heightv2(context, 200),
                                    ),
                                    SizedBox(
                                      height: UtilsReponsive.height(20, context),
                                    ),
                                    Text(
                                      'Bạn chưa có đơn yêu cầu nào',
                                      style: GetTextStyle.getTextStyle(18, 'Roboto', FontWeight.w500, ColorsManager.primary),
                                    ),
                                  ])
                            ])
                          : ListView.separated(
                              controller: controller.scrollController,
                              separatorBuilder: (context, index) => SizedBox(
                                    height: UtilsReponsive.height(20, context),
                                  ),
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(8),
                              itemCount: controller.listRequest.length,
                              // itemCount: 10,
                              itemBuilder: (context, index) {
                                if (index == controller.listRequest.length - 1 && controller.isMoreDataAvailable.value == true) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return GestureDetector(
                                  onTap: () {
                                    Get.toNamed(Routes.REQUEST_DETAIL, arguments: {"requestID": controller.listRequest[index].id});
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: UtilsReponsive.paddingAll(context, padding: 10),
                                    child: Row(children: [
                                      Expanded(
                                          flex: 2,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                controller.listRequest[index].isFull! ? "Nghỉ nguyên ngày" : "Nghỉ nữa ngày",
                                                style: GetTextStyle.getTextStyle(13, 'Roboto', FontWeight.w700, ColorsManager.textColor2),
                                              ),
                                              SizedBox(
                                                height: UtilsReponsive.height(10, context),
                                              ),
                                              Text(controller.vietnameseDateFormat.format(controller.listRequest[index].createdAt!),
                                                  style: GetTextStyle.getTextStyle(15, 'Roboto', FontWeight.bold, ColorsManager.textColor)),
                                              SizedBox(
                                                height: UtilsReponsive.height(10, context),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                      // controller
                                                      //             .listBudget[
                                                      //                 index]
                                                      //             .status! ==
                                                      //         "REJECT"
                                                      //     ? "Từ chối"
                                                      //     : controller
                                                      //                 .listBudget[
                                                      //                     index]
                                                      //                 .status! ==
                                                      //             "ACCEPT"
                                                      //         ? "Chấp nhận"
                                                      //         : "Đang xử lí",
                                                      controller.listRequest[index].title!,
                                                      style: GetTextStyle.getTextStyle(
                                                          13,
                                                          'Roboto',
                                                          FontWeight.bold,
                                                          controller.listRequest[index].type == 'A'
                                                              ? ColorsManager.purple
                                                              : controller.listRequest[index].type == 'L'
                                                                  ? ColorsManager.blue
                                                                  : ColorsManager.red)),
                                                ],
                                              ),
                                            ],
                                          )),
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: UtilsReponsive.width(10, context), vertical: UtilsReponsive.width(5, context)),
                                                decoration: BoxDecoration(
                                                  color: controller.listRequest[index].status == "PENDING"
                                                      ? ColorsManager.yellow.withOpacity(0.5)
                                                      : controller.listRequest[index].status == "ACCEPT"
                                                          ? ColorsManager.green.withOpacity(0.5)
                                                          : ColorsManager.red.withOpacity(0.5),
                                                  borderRadius: BorderRadius.circular(UtilsReponsive.height(5, context)),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      controller.listRequest[index].status == "PENDING"
                                                          ? "Đang xử lí"
                                                          : controller.listRequest[index].status == "ACCEPT"
                                                              ? "Chấp nhận"
                                                              : "Từ chối",
                                                      style: TextStyle(
                                                          letterSpacing: 1,
                                                          color: controller.listRequest[index].status == "PENDING"
                                                              ? Colors.yellow[800]
                                                              : controller.listRequest[index].status == "ACCEPT"
                                                                  ? Colors.green[800]
                                                                  : Colors.red[800],
                                                          fontSize: UtilsReponsive.height(14, context),
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: UtilsReponsive.height(10, context),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                width: UtilsReponsive.width(28, context),
                                                height: UtilsReponsive.height(28, context),
                                                decoration: BoxDecoration(
                                                    color: ColorsManager.backgroundContainer,
                                                    shape: BoxShape.rectangle,
                                                    borderRadius: BorderRadius.circular(5)),
                                                child: const Icon(
                                                  Icons.chevron_right_outlined,
                                                  color: ColorsManager.textColor2,
                                                  size: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ))
                                    ]),
                                  ),
                                );
                              }),
                    ),
                  ),
                ]),
        ),
      ),
    );
  }

  // selectYear(context) async {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text("Chọn năm"),
  //         content: SizedBox(
  //             width: UtilsReponsive.width(300, context),
  //             height: UtilsReponsive.height(300, context),
  //             child: YearPicker(
  //               firstDate: DateTime(DateTime.now().year - 10, 1),
  //               lastDate: DateTime(DateTime.now().year + 1),
  //               initialDate: DateTime.now(),
  //               selectedDate: controller.selectedYear,
  //               onChanged: (DateTime dateTime) {
  //                 controller.selectedYear = dateTime;
  //                 controller.showYear.value = "${dateTime.year}";
  //                 Navigator.pop(context);
  //               },
  //             )),
  //       );
  //     },
  //   );
  // }

  void _showBottomSheetStatus(BuildContext context) {
    Get.bottomSheet(Container(
      decoration: const BoxDecoration(
        color: ColorsManager.backgroundGrey,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      constraints: BoxConstraints(maxHeight: UtilsReponsive.width(400, context)),
      child: ListView(
        shrinkWrap: true,
        children: [
          "Tất cả",
          "Đang xử lí",
          "Đồng ý",
          "Từ chối",
        ]
            .map(
              (e) => GestureDetector(
                onTap: () async {
                  if (e == 'Đang xử lí') {
                    await controller.changeStatus(e);
                  } else if (e == 'Đồng ý') {
                    await controller.changeStatus(e);
                  } else if (e == 'Từ chối') {
                    await controller.changeStatus(e);
                  } else if (e == 'Tất cả') {
                    await controller.changeStatus(e);
                  }
                  Get.back();
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: e == "Đang xử lí"
                          ? ColorsManager.yellow.withOpacity(0.5)
                          : e == "Đồng ý"
                              ? ColorsManager.green.withOpacity(0.5)
                              : e == "Tất cả"
                                  ? ColorsManager.grey
                                  : ColorsManager.red.withOpacity(0.5),
                      child: Text(e[0],
                          style: TextStyle(
                              letterSpacing: 1.5,
                              color: e == "Đang xử lí"
                                  ? Colors.yellow[900]
                                  : e == "Đồng ý"
                                      ? Colors.green[900]
                                      : e == "Tất cả"
                                          ? ColorsManager.textColor2
                                          : Colors.red[900],
                              fontSize: UtilsReponsive.height(16, context),
                              fontWeight: FontWeight.bold)),
                    ),
                    title: Text(
                      e,
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          letterSpacing: 1.5,
                          color: e == "Đang xử lí"
                              ? Colors.yellow[900]
                              : e == "Đồng ý"
                                  ? Colors.green[900]
                                  : e == "Tất cả"
                                      ? ColorsManager.textColor2
                                      : Colors.red[900],
                          fontSize: UtilsReponsive.height(16, context),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    ));
  }

  void _showBottomSheetLeave(BuildContext context) {
    Get.bottomSheet(Container(
      decoration: const BoxDecoration(
        color: ColorsManager.backgroundGrey,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      constraints: BoxConstraints(maxHeight: UtilsReponsive.width(400, context)),
      child: ListView(
        shrinkWrap: true,
        children: [
          "Tất cả",
          "Nghỉ có lương",
          "Nghỉ không lương",
          "Đi công tác",
        ]
            .map(
              (e) => GestureDetector(
                onTap: () async {
                  if (e == 'Nghỉ có lương') {
                    await controller.changeLeaveStatus(e);
                  } else if (e == 'Nghỉ không lương') {
                    await controller.changeLeaveStatus(e);
                  } else if (e == 'Đi công tác') {
                    await controller.changeLeaveStatus(e);
                  } else {
                    await controller.changeLeaveStatus(e);
                  }
                  Get.back();
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: e == "Nghỉ có lương"
                          ? ColorsManager.purple.withOpacity(0.5)
                          : e == "Nghỉ không lương"
                              ? ColorsManager.blue.withOpacity(0.5)
                              : e == "Tất cả"
                                  ? ColorsManager.grey
                                  : ColorsManager.red.withOpacity(0.5),
                      child: Text(e[0],
                          style: TextStyle(
                              letterSpacing: 1.5,
                              color: e == "Nghỉ có lương"
                                  ? Colors.purple[900]
                                  : e == "Nghỉ không lương"
                                      ? Colors.blue[900]
                                      : e == "Tất cả"
                                          ? ColorsManager.textColor2
                                          : Colors.red[900],
                              fontSize: UtilsReponsive.height(16, context),
                              fontWeight: FontWeight.bold)),
                    ),
                    title: Text(
                      e,
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          letterSpacing: 1.5,
                          color: e == "Nghỉ có lương"
                              ? Colors.purple[900]
                              : e == "Nghỉ không lương"
                                  ? Colors.blue[900]
                                  : e == "Tất cả"
                                      ? ColorsManager.textColor2
                                      : Colors.red[900],
                          fontSize: UtilsReponsive.height(16, context),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    ));
  }
}
