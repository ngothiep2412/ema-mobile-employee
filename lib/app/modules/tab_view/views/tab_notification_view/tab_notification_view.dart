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
import 'package:line_icons/line_icons.dart';

class TabNotificationView extends BaseView<TabNotificationController> {
  const TabNotificationView({Key? key}) : super(key: key);
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
            : Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Thông báo',
                          style: GetTextStyle.getTextStyle(20, 'Roboto', FontWeight.w600, ColorsManager.primary),
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
                        onPressed: () async {
                          await controller.refreshPage();
                        },
                        icon: const Icon(
                          Icons.refresh,
                          // Icons.notification_add_outlined,
                          color: ColorsManager.textColor2,
                        ),
                      ),
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
                      child: controller.listNotifications.isEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                  style: GetTextStyle.getTextStyle(18, 'Roboto', FontWeight.w500, ColorsManager.primary),
                                ),
                              ],
                            )
                          : RefreshIndicator(
                              onRefresh: controller.refreshPage,
                              child: ListView.separated(
                                  controller: controller.scrollController,
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
                                            await controller.markSeen(controller.listNotifications[index].id!);
                                            if (controller.listNotifications[index].type == "REQUEST") {
                                              Get.toNamed(Routes.REQUEST_DETAIL,
                                                  arguments: {"requestID": controller.listNotifications[index].commonId});
                                            } else if (controller.listNotifications[index].type == "TASK") {
                                              Get.toNamed(Routes.TASK_DETAIL_VIEW,
                                                  arguments: {"taskID": controller.listNotifications[index].commonId});
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: controller.listNotifications[index].readFlag != 0 ? Colors.white : Colors.blue.withOpacity(0.7),
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
                                                                'Roboto',
                                                                FontWeight.w700,
                                                                controller.listNotifications[index].readFlag != 0
                                                                    ? ColorsManager.textColor2
                                                                    : ColorsManager.textInput)),
                                                      ),
                                                      SizedBox(
                                                        height: UtilsReponsive.height(10, context),
                                                      ),
                                                      Text(calculateTimeDifference(controller.listNotifications[index].createdAt.toString()),
                                                          style: GetTextStyle.getTextStyle(12, 'Roboto', FontWeight.w600, ColorsManager.textColor)),
                                                    ],
                                                  ))
                                            ]),
                                          ),
                                        ),
                                        Positioned(
                                          top: -10,
                                          right: -10,
                                          child: GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text('Xác nhận xóa',
                                                        style: TextStyle(
                                                            fontFamily: 'Roboto',
                                                            wordSpacing: 1.2,
                                                            color: ColorsManager.primary,
                                                            fontSize: UtilsReponsive.height(20, context),
                                                            fontWeight: FontWeight.bold)),
                                                    content: Text(
                                                      'Bạn có muốn xóa thông báo này?',
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
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
                                                                fontFamily: 'Roboto',
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
                                                                fontFamily: 'Roboto',
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
    ));
  }
}
