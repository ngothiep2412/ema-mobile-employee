import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_view.dart';
import 'package:hrea_mobile_employee/app/modules/check_in_detail/model/timesheet_model.dart';
import 'package:hrea_mobile_employee/app/resources/assets_manager.dart';
import 'package:hrea_mobile_employee/app/resources/color_manager.dart';
import 'package:hrea_mobile_employee/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_employee/app/resources/style_manager.dart';

import '../controllers/check_in_detail_controller.dart';

class CheckInDetailView extends BaseView<CheckInDetailController> {
  const CheckInDetailView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      backgroundColor: ColorsManager.backgroundContainer,
      body: Obx(
        () => controller.isLoading.value
            ? Center(
                child: SpinKitFadingCircle(
                  color: ColorsManager.primary,
                ),
              )
            : SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: UtilsReponsive.height(20, context)),
                  child: Column(children: [
                    SizedBox(
                      height: UtilsReponsive.height(20, context),
                    ),
                    Text(
                      'Lịch sử check in',
                      style: GetTextStyle.getTextStyle(20, 'Nunito', FontWeight.w600, ColorsManager.primary),
                    ),
                    SizedBox(
                      height: UtilsReponsive.height(20, context),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          controller.eventName,
                          style: GetTextStyle.getTextStyle(20, 'Nunito', FontWeight.w600, ColorsManager.textColor),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: UtilsReponsive.height(10, context),
                    ),
                    Expanded(
                        child: RefreshIndicator(
                      onRefresh: controller.refreshPage,
                      child: controller.listTimesheet.isEmpty
                          ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Image.asset(
                                ImageAssets.noCheckIn,
                                height: 150,
                              ),
                              SizedBox(
                                height: UtilsReponsive.height(20, context),
                              ),
                              Text(
                                'Bạn chưa check in ở sự kiện này này',
                                style: GetTextStyle.getTextStyle(18, 'Nunito', FontWeight.w600, ColorsManager.primary),
                              ),
                            ])
                          : ListView.separated(
                              padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
                              itemBuilder: (context, index) => _itemData(controller.listTimesheet[index], context),
                              separatorBuilder: (context, index) => SizedBox(
                                    height: UtilsReponsive.height(10, context),
                                  ),
                              itemCount: controller.listTimesheet.length),
                    ))
                  ]),
                ),
              ),
      ),
    );
  }

  Card _itemData(TimesheetModel timeSheetModel, BuildContext context) {
    return Card(
      child: Container(
          padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
          // height: UtilsReponsive.height(60, context),
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Ngày check-in",
                    style: TextStyle(
                        letterSpacing: 1.5,
                        fontFamily: 'Nunito',
                        color: ColorsManager.textColor,
                        fontSize: UtilsReponsive.height(16, context),
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: UtilsReponsive.height(10, context),
                  ),
                  Text(
                    timeSheetModel.date.toString(),
                    style: TextStyle(
                        letterSpacing: 1.5,
                        fontFamily: 'Nunito',
                        color: ColorsManager.primary,
                        fontSize: UtilsReponsive.height(16, context),
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Giờ check-in",
                    style: TextStyle(
                        letterSpacing: 1.5,
                        fontFamily: 'Nunito',
                        color: ColorsManager.textColor,
                        fontSize: UtilsReponsive.height(16, context),
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: UtilsReponsive.height(10, context),
                  ),
                  Text(
                    timeSheetModel.checkinTime!,
                    style: TextStyle(
                        letterSpacing: 1.5,
                        fontFamily: 'Nunito',
                        color: ColorsManager.primary,
                        fontSize: UtilsReponsive.height(16, context),
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ],
          )),
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
      actions: [
        IconButton(
          onPressed: () async {
            await controller.refreshPage();
          },
          icon: const Icon(
            Icons.refresh,
            // Icons.notification_add_outlined,
            color: ColorsManager.textColor2,
          ),
        ),
      ],
    );
  }
}
