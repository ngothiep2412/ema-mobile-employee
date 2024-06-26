import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_view.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/controllers/tab_notification_controller/tab_notification_controller.dart';
import 'package:hrea_mobile_employee/app/resources/assets_manager.dart';
import 'package:hrea_mobile_employee/app/resources/color_manager.dart';
import 'package:hrea_mobile_employee/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_employee/app/resources/style_manager.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';
import 'package:hrea_mobile_employee/app/utils/calculate_time_difference.dart';

class TabNotificationView extends BaseView<TabNotificationController> {
  const TabNotificationView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Obx(
      () => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(UtilsReponsive.height(20, context)),
          child: controller.checkInView.value == false
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: controller.refreshPage,
                        child: ListView(children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center, // Đặt crossAxisAlignment thành center
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 4,
                              ),
                              Image.asset(
                                ImageAssets.noInternet,
                                fit: BoxFit.cover,
                                width: UtilsReponsive.widthv2(context, 200),
                                height: UtilsReponsive.heightv2(context, 200),
                              ),
                              SizedBox(
                                height: UtilsReponsive.height(20, context),
                              ),
                              Text(
                                'Đang có lỗi xảy ra',
                                style: GetTextStyle.getTextStyle(20, 'Nunito', FontWeight.w800, ColorsManager.primary),
                              ),
                            ],
                          ),
                        ]),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Thông báo',
                            style: GetTextStyle.getTextStyle(22, 'Nunito', FontWeight.w800, ColorsManager.primary),
                          ),
                        ),
                        // Icon(
                        //   Icons.filter_alt_outlined,
                        //   color: ColorsManager.primary,
                        // ),
                        // SizedBox(
                        //   width: UtilsReponsive.width(10, context),
                        // ),

                        IconButton(
                          onPressed: () {
                            controller.markAllRead();
                          },
                          icon: const Icon(
                            Icons.mark_as_unread_rounded,
                            // Icons.notification_add_outlined,
                            color: ColorsManager.textColor2,
                          ),
                        ),

                        IconButton(
                          onPressed: () {
                            controller.deleteAllNotification();
                          },
                          icon: const Icon(
                            Icons.delete,
                            // Icons.notification_add_outlined,
                            color: ColorsManager.textColor2,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: UtilsReponsive.height(10, context),
                    ),
                    Obx(
                      () => Expanded(
                        child: controller.isLoading.value == true
                            ? Center(
                                child: SpinKitFadingCircle(
                                  color: ColorsManager.primary,
                                  // size: 30.0,
                                ),
                              )
                            : controller.listNotifications.isEmpty
                                ? RefreshIndicator(
                                    onRefresh: controller.refreshPage,
                                    child: ListView(
                                      children: [
                                        SizedBox(
                                          height: UtilsReponsive.height(100, context),
                                        ),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center, // Center children horizontally
                                          mainAxisSize: MainAxisSize.min, // Take up minimum vertical space
                                          children: [
                                            Image.asset(
                                              ImageAssets.noNoti,
                                              fit: BoxFit.contain,
                                              width: UtilsReponsive.widthv2(context, 200),
                                              height: UtilsReponsive.heightv2(context, 200),
                                            ),
                                            SizedBox(
                                              height: UtilsReponsive.height(20, context),
                                            ),
                                            Text(
                                              'Bạn chưa có thông báo nào',
                                              style: GetTextStyle.getTextStyle(18, 'Nunito', FontWeight.w800, ColorsManager.primary),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                : RefreshIndicator(
                                    onRefresh: controller.refreshPage,
                                    child: ListView.separated(
                                        controller: controller.scrollController.value,
                                        separatorBuilder: (context, index) => SizedBox(
                                              height: UtilsReponsive.height(20, context),
                                            ),
                                        shrinkWrap: false,
                                        padding: const EdgeInsets.all(8),
                                        itemCount: controller.listNotifications.length,
                                        itemBuilder: (context, index) {
                                          if (index == controller.listNotifications.length - 1 && controller.isMoreDataAvailable.value == true) {
                                            return const Center(
                                              child: CircularProgressIndicator(),
                                            );
                                          }
                                          return Obx(
                                            () => Stack(clipBehavior: Clip.none, children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  if (controller.listNotifications[index].isRead == 0) {
                                                    controller.markSeen(controller.listNotifications[index].id!, index);
                                                  }

                                                  // await controller.getAllNotification(controller.page);
                                                  if (controller.listNotifications[index].type == "SUBTASK") {
                                                    Get.toNamed(Routes.SUBTASK_DETAIL_VIEW, arguments: {
                                                      "taskID": controller.listNotifications[index].commonId,
                                                      "isNavigateDetail": false,
                                                      "isScheduleOverall": false,
                                                    });
                                                  } else if (controller.listNotifications[index].type == "COMMENT_SUBTASK") {
                                                    Get.toNamed(Routes.SUBTASK_DETAIL_VIEW, arguments: {
                                                      "taskID": controller.listNotifications[index].commonId,
                                                      "isNavigateDetail": false,
                                                      "isScheduleOverall": false,
                                                    });
                                                  } else if (controller.listNotifications[index].type == "TASK") {
                                                    Get.toNamed(Routes.SUBTASK_DETAIL_VIEW, arguments: {
                                                      "taskID": controller.listNotifications[index].commonId,
                                                      "isNavigateDetail": false,
                                                      "isScheduleOverall": false,
                                                    });
                                                  } else if (controller.listNotifications[index].type == "BUDGET") {
                                                    Get.toNamed(Routes.BUDGET_DETAIL, arguments: {
                                                      "transactionID": controller.listNotifications[index].commonId,
                                                      "isNotiNavigate": true,
                                                      "statusTask": false,
                                                    });
                                                  }
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: controller.listNotifications[index].isRead != 0
                                                        ? Colors.blue.withOpacity(0.2)
                                                        : Colors.blue.withOpacity(0.7),
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  padding: UtilsReponsive.paddingAll(context, padding: 10),
                                                  child: Row(children: [
                                                    Expanded(
                                                        flex: 1,
                                                        child: CircleAvatar(
                                                          radius: UtilsReponsive.height(25, context),
                                                          child: ClipOval(
                                                            child: Image.network(
                                                              controller.listNotifications[index].avatarSender!,
                                                              fit: BoxFit.cover,
                                                              width: UtilsReponsive.height(50, context), // Đảm bảo hình ảnh là hình tròn
                                                              height: UtilsReponsive.height(50, context), // Đảm bảo hình ảnh là hình tròn
                                                            ),
                                                          ),
                                                        )),
                                                    SizedBox(
                                                      width: UtilsReponsive.width(10, context),
                                                    ),
                                                    Expanded(
                                                        flex: 5,
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Obx(
                                                              () => Text(controller.listNotifications[index].content!,
                                                                  style: GetTextStyle.getTextStyle(
                                                                      14,
                                                                      'Nunito',
                                                                      FontWeight.w700,
                                                                      controller.listNotifications[index].isRead != 0
                                                                          ? ColorsManager.textColor2
                                                                          : ColorsManager.textInput)),
                                                            ),
                                                            SizedBox(
                                                              height: UtilsReponsive.height(10, context),
                                                            ),
                                                            Text(calculateTimeDifference(controller.listNotifications[index].createdAt.toString()),
                                                                style: GetTextStyle.getTextStyle(
                                                                    12, 'Nunito', FontWeight.w700, ColorsManager.textColor)),
                                                          ],
                                                        ))
                                                  ]),
                                                ),
                                              ),
                                              Positioned(
                                                top: -10,
                                                right: -5,
                                                child: GestureDetector(
                                                  onTap: () {
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
                                                            'Bạn có muốn xóa thông báo này?',
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
                                                                await controller.deleteNotification(controller.listNotifications[index].id!);
                                                                Navigator.of(Get.context!).pop();
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
                                                  },
                                                  child: Container(
                                                    padding: UtilsReponsive.paddingAll(context, padding: 5),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: ColorsManager.red,
                                                    ),
                                                    child: const Icon(
                                                      Icons.close,
                                                      color: ColorsManager.backgroundWhite,
                                                      size: 18,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                          );
                                        }),
                                  ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
