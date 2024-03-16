import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_view.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/task.dart';
import 'package:hrea_mobile_employee/app/resources/assets_manager.dart';
import 'package:hrea_mobile_employee/app/resources/color_manager.dart';
import 'package:hrea_mobile_employee/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_employee/app/resources/style_manager.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../controllers/task_overall_view_controller.dart';

class TaskOverallViewView extends BaseView<TaskOverallViewController> {
  const TaskOverallViewView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue.withOpacity(0.9),
        body: Obx(
          () => SafeArea(
            child: controller.checkView.value == false
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () => Get.back(),
                              icon: const Icon(
                                Icons.arrow_back_ios_new,
                                color: ColorsManager.backgroundWhite,
                              )),
                          SizedBox(
                            width: UtilsReponsive.width(5, context),
                          ),
                          Expanded(
                            flex: 3,
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.EVENT_DETAIL, arguments: {"eventID": controller.eventID});
                              },
                              child: Text(
                                controller.eventName,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: ColorsManager.backgroundWhite, fontSize: UtilsReponsive.height(20, context), fontWeight: FontWeight.w800),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          padding: EdgeInsets.only(top: controller.listTask.isNotEmpty ? UtilsReponsive.height(30, context) : 0),
                          color: Colors.white,
                          child: (Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
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
                                  'Đang có lỗi xảy ra',
                                  style: GetTextStyle.getTextStyle(20, 'Nunito', FontWeight.w800, ColorsManager.primary),
                                ),
                              ],
                            ),
                          )),
                        ),
                      )
                    ],
                  )
                : Column(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () => Get.back(),
                                    icon: const Icon(
                                      Icons.arrow_back_ios_new,
                                      color: ColorsManager.backgroundWhite,
                                    )),
                                SizedBox(
                                  width: UtilsReponsive.width(5, context),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.toNamed(Routes.EVENT_DETAIL, arguments: {"eventID": controller.eventID});
                                    },
                                    child: Text(
                                      controller.eventName,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: ColorsManager.backgroundWhite,
                                          fontSize: UtilsReponsive.height(20, context),
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: UtilsReponsive.width(5, context),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: ColorsManager.backgroundWhite,
                                        radius: UtilsReponsive.height(20, context),
                                        child: IconButton(
                                            onPressed: () {
                                              Get.bottomSheet(Container(
                                                constraints: BoxConstraints(maxHeight: UtilsReponsive.width(250, context)),
                                                padding: EdgeInsetsDirectional.symmetric(
                                                    horizontal: UtilsReponsive.width(15, context), vertical: UtilsReponsive.height(20, context)),
                                                decoration: BoxDecoration(
                                                  color: ColorsManager.backgroundWhite,
                                                  borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(UtilsReponsive.height(20, context)),
                                                      topRight: Radius.circular(UtilsReponsive.height(20, context))),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: UtilsReponsive.height(10, context)),
                                                  child: Column(children: [
                                                    Row(
                                                      children: [
                                                        Center(
                                                          child: Text(
                                                            'Bộ lọc',
                                                            style: GetTextStyle.getTextStyle(18, 'Nunito', FontWeight.w700, ColorsManager.primary),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: UtilsReponsive.height(20, context),
                                                    ),
                                                    Obx(
                                                      () => Expanded(
                                                          child: ListView.separated(
                                                              shrinkWrap: true,
                                                              itemCount: controller.filterList.length,
                                                              separatorBuilder: (context, index) => SizedBox(
                                                                    height: UtilsReponsive.height(10, context),
                                                                  ),
                                                              itemBuilder: (context, index) {
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    if (!controller.filterChoose.contains(controller.filterList[index])) {
                                                                      controller.filter(controller.filterList[index]);
                                                                    } else {
                                                                      controller.filter('');
                                                                    }

                                                                    Get.back();
                                                                  },
                                                                  child: Padding(
                                                                    padding: UtilsReponsive.paddingAll(context, padding: 8),
                                                                    child: Text(
                                                                      controller.filterList[index],
                                                                      style: TextStyle(
                                                                        color: controller.filterChoose.contains(controller.filterList[index])
                                                                            ? ColorsManager.primary
                                                                            : ColorsManager.textColor,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              })),
                                                    )
                                                  ]),
                                                ),
                                              ));
                                            },
                                            icon: Icon(
                                              Icons.filter_alt_rounded,
                                              color: ColorsManager.primary,
                                              size: 20,
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: UtilsReponsive.width(10, context),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: UtilsReponsive.height(20, context),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // IconButton(
                                //     onPressed: () {
                                //       Get.toNamed(Routes.BUDGET, arguments: {"eventID": controller.eventID});
                                //     },
                                //     icon: Icon(
                                //       Icons.request_page_rounded,
                                //       color: ColorsManager.green,
                                //     )),
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(Routes.BUDGET, arguments: {"eventID": controller.eventID});
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        UtilsReponsive.height(10, context),
                                      ),
                                      color: Colors.green,
                                    ),
                                    child: Text(
                                      'Quản lý ngân sách',
                                      style: GetTextStyle.getTextStyle(15, 'Nunito', FontWeight.w800, ColorsManager.backgroundWhite),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: UtilsReponsive.width(10, context),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Độ ưu tiên: ",
                              style: GetTextStyle.getTextStyle(18, 'Nunito', FontWeight.w800, ColorsManager.backgroundWhite),
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 10,
                                  width: 50,
                                  color: ColorsManager.green.withOpacity(0.7),
                                ),
                                SizedBox(
                                  width: UtilsReponsive.width(5, context),
                                ),
                                Text(
                                  'Thấp',
                                  overflow: TextOverflow.ellipsis,
                                  style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, ColorsManager.backgroundWhite),
                                ),
                                SizedBox(
                                  width: UtilsReponsive.width(10, context),
                                ),
                                Container(
                                  height: 10,
                                  width: 50,
                                  color: Colors.orangeAccent,
                                ),
                                SizedBox(
                                  width: UtilsReponsive.width(5, context),
                                ),
                                Text(
                                  'Trung bình',
                                  overflow: TextOverflow.ellipsis,
                                  style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, ColorsManager.backgroundWhite),
                                ),
                                SizedBox(
                                  width: UtilsReponsive.width(10, context),
                                ),
                                Container(
                                  height: 10,
                                  width: 50,
                                  color: ColorsManager.red.withOpacity(0.7),
                                ),
                                SizedBox(
                                  width: UtilsReponsive.width(5, context),
                                ),
                                Text(
                                  'Cao',
                                  overflow: TextOverflow.ellipsis,
                                  style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, ColorsManager.backgroundWhite),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: UtilsReponsive.height(10, context),
                      ),
                      Obx(
                        () => controller.isLoading.value == true
                            ? Expanded(
                                flex: 4,
                                child: Container(
                                  padding: EdgeInsets.only(top: controller.listTask.isNotEmpty ? UtilsReponsive.height(30, context) : 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(UtilsReponsive.height(30, context)),
                                      topRight: Radius.circular(UtilsReponsive.height(30, context)),
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: SpinKitFadingCircle(
                                      color: ColorsManager.blue,
                                    ),
                                  ),
                                ),
                              )
                            : Expanded(
                                flex: 4,
                                child: controller.listTask.isEmpty
                                    ? Container(
                                        padding: EdgeInsets.only(top: controller.listTask.isNotEmpty ? UtilsReponsive.height(30, context) : 0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(UtilsReponsive.height(30, context)),
                                            topRight: Radius.circular(UtilsReponsive.height(30, context)),
                                          ),
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: UtilsReponsive.height(200, context),
                                              child: Image.asset(
                                                ImageAssets.noTask,
                                              ),
                                            ),
                                            Center(
                                              child: Text(
                                                'Không có công việc trong ngày này',
                                                style: GetTextStyle.getTextStyle(17, 'Nunito', FontWeight.w800, Colors.blueAccent),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Obx(
                                        () => Container(
                                          padding: EdgeInsets.only(top: controller.listTask.isNotEmpty ? UtilsReponsive.height(30, context) : 0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(UtilsReponsive.height(30, context)),
                                              topRight: Radius.circular(UtilsReponsive.height(30, context)),
                                            ),
                                            color: Colors.white,
                                          ),
                                          child: RefreshIndicator(
                                            onRefresh: controller.refreshPage,
                                            child: ListView.separated(
                                                padding: UtilsReponsive.paddingAll(context, padding: 15),
                                                itemBuilder: (context, index) => _taskCommon(context, controller.listTask[index], index),
                                                separatorBuilder: (context, index) => SizedBox(
                                                      height: UtilsReponsive.height(15, context),
                                                    ),
                                                itemCount: controller.listTask.length),
                                          ),
                                        ),
                                      )),
                      )
                    ],
                  ),
          ),
        ));
  }

  Container _taskCommon(BuildContext context, TaskModel taskModel, int index) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.4), // Màu của shadow và độ mờ
          spreadRadius: 1, // Độ lan rộng của shadow
          blurRadius: 3, // Độ mờ của shadow
          offset: const Offset(0, 1), // Độ dịch chuyển của shadow
        ),
      ]),
      child: GestureDetector(
        onTap: () async {
          await controller.getTaskDetail(taskModel);
        },
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                UtilsReponsive.height(10, context),
              ),
            ),
            child: Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        radius: UtilsReponsive.height(15, context),
                        child: const Icon(
                          Icons.info,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      SizedBox(
                        width: UtilsReponsive.width(10, context),
                      ),
                      Expanded(
                        child: Text(
                          taskModel.title!,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            color: ColorsManager.textColor2,
                            fontSize: UtilsReponsive.height(20, context),
                            fontWeight: FontWeight.w700,
                            // decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: UtilsReponsive.height(10, context),
                      ),
                      Row(children: [
                        Row(
                          children: [
                            taskModel.status! == Status.CONFIRM
                                ? CircleAvatar(
                                    backgroundColor: ColorsManager.grey.withOpacity(0.2),
                                    radius: UtilsReponsive.height(13, context),
                                    child: Icon(
                                      Icons.check_circle,
                                      color: ColorsManager.purple.withOpacity(0.7),
                                      size: 25,
                                    ),
                                  )
                                : CircleAvatar(
                                    backgroundColor: taskModel.status! == Status.PENDING
                                        ? ColorsManager.grey.withOpacity(0.7)
                                        : taskModel.status! == Status.PROCESSING
                                            ? ColorsManager.blue.withOpacity(0.7)
                                            : taskModel.status! == Status.OVERDUE
                                                ? ColorsManager.red.withOpacity(0.7)
                                                : ColorsManager.green.withOpacity(0.7),
                                    radius: UtilsReponsive.height(13, context),
                                  ),
                            SizedBox(
                              width: UtilsReponsive.width(10, context),
                            ),
                            Text(
                                taskModel.status! == Status.PENDING
                                    ? "Đang chuẩn bị"
                                    : taskModel.status! == Status.PROCESSING
                                        ? "Đang thực hiện"
                                        : taskModel.status! == Status.DONE
                                            ? "Hoàn thành"
                                            : taskModel.status == Status.OVERDUE
                                                ? 'Quá hạn'
                                                : "Đã xác thực",
                                style: GetTextStyle.getTextStyle(
                                  16,
                                  'Nunito',
                                  FontWeight.w700,
                                  taskModel.status! == Status.PENDING
                                      ? ColorsManager.grey
                                      : taskModel.status! == Status.PROCESSING
                                          ? ColorsManager.blue
                                          : taskModel.status! == Status.DONE
                                              ? ColorsManager.green
                                              : taskModel.status! == Status.OVERDUE
                                                  ? ColorsManager.red
                                                  : ColorsManager.purple,
                                ))
                          ],
                        ),
                      ]),
                      SizedBox(
                        height: UtilsReponsive.height(10, context),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month,
                            color: taskModel.status! == Status.PENDING
                                ? ColorsManager.grey
                                : taskModel.status! == Status.PROCESSING
                                    ? ColorsManager.blue
                                    : taskModel.status! == Status.DONE
                                        ? ColorsManager.green
                                        : taskModel.status! == Status.OVERDUE
                                            ? ColorsManager.red
                                            : ColorsManager.purple,
                            size: 22,
                          ),
                          SizedBox(
                            width: UtilsReponsive.width(10, context),
                          ),
                          taskModel.endDate != null
                              ? Expanded(
                                  child: Text(
                                      'Hạn: ${controller.dateFormat.format(taskModel.startDate!)} - ${controller.dateFormat.format(taskModel.endDate!)}',
                                      overflow: TextOverflow.clip,
                                      style: GetTextStyle.getTextStyle(
                                        15,
                                        'Nunito',
                                        FontWeight.w700,
                                        taskModel.status! == Status.PENDING
                                            ? ColorsManager.grey
                                            : taskModel.status! == Status.PROCESSING
                                                ? ColorsManager.blue
                                                : taskModel.status! == Status.DONE
                                                    ? ColorsManager.green
                                                    : taskModel.status! == Status.OVERDUE
                                                        ? ColorsManager.red
                                                        : ColorsManager.purple,
                                      )),
                                )
                              : const SizedBox(),
                        ],
                      ),
                      SizedBox(
                        height: UtilsReponsive.height(10, context),
                      ),
                      Container(
                        width: double.infinity,
                        height: 5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: taskModel.priority! == Priority.LOW
                              ? ColorsManager.green
                              : taskModel.priority! == Priority.MEDIUM
                                  ? ColorsManager.yellow
                                  : ColorsManager.red,
                        ),
                      )
                    ],
                  ),
                ]),
              ),
            )),
      ),
    );
  }
}
