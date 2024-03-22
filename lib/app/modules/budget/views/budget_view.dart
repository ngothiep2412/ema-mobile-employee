import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_view.dart';
import 'package:hrea_mobile_employee/app/resources/assets_manager.dart';
import 'package:hrea_mobile_employee/app/resources/color_manager.dart';
import 'package:hrea_mobile_employee/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_employee/app/resources/style_manager.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';
import '../controllers/budget_controller.dart';

class BudgetView extends BaseView<BudgetController> {
  const BudgetView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      // appBar: _appBar(context),
      backgroundColor: ColorsManager.backgroundContainer,
      body: SafeArea(
        child: Obx(
          () => Padding(
            padding: EdgeInsets.all(UtilsReponsive.height(15, context)),
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
                        IconButton(
                            onPressed: () => Get.back(),
                            icon: Icon(
                              Icons.arrow_back_ios_new,
                              color: ColorsManager.primary,
                            )),
                        Text(
                          'Danh sách khoản chi',
                          style: GetTextStyle.getTextStyle(20, 'Nunito', FontWeight.w800, ColorsManager.primary),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            controller.isFilter.value
                                ? IconButton(
                                    onPressed: () {
                                      controller.isFilter.value = !controller.isFilter.value;
                                    },
                                    icon: const Icon(
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
                                Get.toNamed(Routes.CREATE_BUDGET, arguments: {"taskID": controller.taskID});
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
                                  style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w700, ColorsManager.calendar),
                                ),
                                InkWell(
                                  onTap: () async {
                                    controller.clearFilter();
                                  },
                                  child: Text(
                                    'Đặt lại',
                                    style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w700, ColorsManager.calendar),
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
                                          style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w700, ColorsManager.textColor),
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
                                                      style: GetTextStyle.getTextStyle(15, 'Nunito', FontWeight.w600, ColorsManager.textColor),
                                                    ),
                                                  ))
                                              .toList(),
                                          onChanged: (value) {
                                            controller.setTimeType(value as String);
                                          },
                                          value: controller.selectedTimeTypeVal.value,
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(
                                                  left: UtilsReponsive.height(10, context), right: UtilsReponsive.height(10, context)),
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
                                            style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w700, ColorsManager.textColor),
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
                                              color: controller.status.value == "Chờ duyệt"
                                                  ? ColorsManager.grey.withOpacity(0.5)
                                                  : controller.status.value == "Chấp nhận"
                                                      ? ColorsManager.green.withOpacity(0.5)
                                                      : controller.status.value == "Tất cả"
                                                          ? ColorsManager.primary
                                                          : controller.status.value == "Thành công"
                                                              ? Colors.purple.withOpacity(0.5)
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
                                                      color: controller.status.value == "Chờ duyệt"
                                                          ? ColorsManager.textColor2
                                                          : controller.status.value == "Chấp nhận"
                                                              ? Colors.green[800]
                                                              : controller.status.value == "Tất cả"
                                                                  ? ColorsManager.backgroundWhite
                                                                  : controller.status.value == "Thành công"
                                                                      ? Colors.purple[800]
                                                                      : Colors.red[800],
                                                      fontSize: 15),
                                                ),
                                                Icon(
                                                  Icons.arrow_drop_down,
                                                  color: controller.status.value == "Chờ duyệt"
                                                      ? ColorsManager.textColor2
                                                      : controller.status.value == "Chấp nhận"
                                                          ? Colors.green[800]
                                                          : controller.status.value == "Tất cả"
                                                              ? ColorsManager.backgroundWhite
                                                              : controller.status.value == "Thành công"
                                                                  ? Colors.purple[800]
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
                          ])
                        : const SizedBox(),
                    SizedBox(
                      height: UtilsReponsive.height(20, context),
                    ),
                    Expanded(
                      flex: 2,
                      child: RefreshIndicator(
                        onRefresh: controller.refreshPage,
                        child: controller.listTransaction.isEmpty
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
                                        'Bạn chưa có đơn yêu cầu khoản chi nào',
                                        style: GetTextStyle.getTextStyle(18, 'Nunito', FontWeight.w700, ColorsManager.primary),
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
                                itemCount: controller.listTransaction.length,
                                itemBuilder: (context, index) {
                                  if (index == controller.listTransaction.length - 1 && controller.isMoreDataAvailable.value == true) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  return GestureDetector(
                                    onTap: () {
                                      Get.toNamed(Routes.BUDGET_DETAIL,
                                          arguments: {"transactionID": controller.listTransaction[index].id, "isNotiNavigate": false});
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: UtilsReponsive.paddingAll(context, padding: 10),
                                      child: Row(children: [
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Mã: ${controller.listTransaction[index].transactionCode!}',
                                              overflow: TextOverflow.clip,
                                              style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w800, ColorsManager.textColor2),
                                            ),
                                            SizedBox(
                                              height: UtilsReponsive.height(10, context),
                                            ),
                                            Text(
                                              'Tên: ${controller.listTransaction[index].transactionName!}',
                                              overflow: TextOverflow.clip,
                                              style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w800, ColorsManager.textColor),
                                            ),
                                            SizedBox(
                                              height: UtilsReponsive.height(10, context),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Ngày nộp đơn: ',
                                                  style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w600, ColorsManager.textColor2),
                                                ),
                                                Text(
                                                    controller.dateFormat
                                                        .format(controller.listTransaction[index].createdAt!.toLocal().add(const Duration(hours: 7)))
                                                        .toString(),
                                                    style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.bold, ColorsManager.textColor)),
                                              ],
                                            ),
                                            SizedBox(
                                              height: UtilsReponsive.height(10, context),
                                            ),
                                            Row(
                                              children: [
                                                Text('Tiền: ',
                                                    style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w600, ColorsManager.textColor2)),
                                                Text('${controller.formatCurrency(controller.listTransaction[index].amount!)} VNĐ',
                                                    style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w700, ColorsManager.primary))
                                              ],
                                            ),
                                            SizedBox(
                                              height: UtilsReponsive.height(10, context),
                                            ),
                                            Row(
                                              children: [
                                                Text('Trạng thái: ',
                                                    style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w600, ColorsManager.textColor2)),
                                                Text(
                                                    controller.listTransaction[index].status! == "REJECTED"
                                                        ? "Từ chối"
                                                        : controller.listTransaction[index].status! == "ACCEPTED"
                                                            ? "Chấp nhận"
                                                            : controller.listTransaction[index].status! == "PENDING"
                                                                ? "Chờ duyệt"
                                                                : "Thành công",
                                                    style: GetTextStyle.getTextStyle(
                                                        14,
                                                        'Nunito',
                                                        FontWeight.bold,
                                                        controller.listTransaction[index].status == 'REJECTED'
                                                            ? ColorsManager.red
                                                            : controller.listTransaction[index].status == 'PENDING'
                                                                ? ColorsManager.textColor2
                                                                : controller.listTransaction[index].status == 'ACCEPTED'
                                                                    ? ColorsManager.green
                                                                    : ColorsManager.purple)),
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
      ),
    );
  }

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
          "Chờ duyệt",
          "Chấp nhận",
          "Từ chối",
          "Thành công",
        ]
            .map(
              (e) => GestureDetector(
                onTap: () async {
                  Get.back();
                  if (e == 'Chờ duyệt') {
                    await controller.changeStatus(e);
                  } else if (e == 'Chấp nhận') {
                    await controller.changeStatus(e);
                  } else if (e == 'Từ chối') {
                    await controller.changeStatus(e);
                  } else if (e == 'Tất cả') {
                    await controller.changeStatus(e);
                  } else if (e == 'Thành công') {
                    await controller.changeStatus(e);
                  }
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: e == "Chờ duyệt"
                          ? ColorsManager.grey.withOpacity(0.5)
                          : e == "Chấp nhận"
                              ? ColorsManager.green.withOpacity(0.5)
                              : e == "Tất cả"
                                  ? ColorsManager.primary
                                  : e == "Thành công"
                                      ? Colors.purple.withOpacity(0.5)
                                      : ColorsManager.red.withOpacity(0.5),
                      child: Text(e[0],
                          style: TextStyle(
                              fontFamily: 'Nunito',
                              color: e == "Chờ duyệt"
                                  ? ColorsManager.textColor2
                                  : e == "Chấp nhận"
                                      ? Colors.green[900]
                                      : e == "Tất cả"
                                          ? ColorsManager.backgroundWhite
                                          : e == "Thành công"
                                              ? Colors.purple[900]
                                              : Colors.red[900],
                              fontSize: UtilsReponsive.height(18, context),
                              fontWeight: FontWeight.w800)),
                    ),
                    title: Text(
                      e,
                      style: TextStyle(
                          fontFamily: 'Nunito',
                          color: e == "Chờ duyệt"
                              ? ColorsManager.textColor2
                              : e == "Chấp nhận"
                                  ? Colors.green[900]
                                  : e == "Tất cả"
                                      ? ColorsManager.primary
                                      : e == "Thành công"
                                          ? Colors.purple[900]
                                          : Colors.red[900],
                          fontSize: UtilsReponsive.height(18, context),
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
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
        IconButton(
            onPressed: () {
              controller.refreshPage();
            },
            icon: const Icon(
              Icons.refresh,
              color: ColorsManager.textColor2,
            )),
        IconButton(
            onPressed: () {
              controller.createBudget();
            },
            icon: Icon(
              Icons.add,
              color: ColorsManager.primary,
            )),
      ],
    );
  }
}
