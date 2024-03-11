import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_view.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/task.dart';
import 'package:hrea_mobile_employee/app/resources/color_manager.dart';
import 'package:hrea_mobile_employee/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_employee/app/resources/style_manager.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hrea_mobile_employee/app/utils/calculate_time_difference.dart';
import '../controllers/task_overall_view_controller.dart';

class TaskOverallViewView extends BaseView<TaskOverallViewController> {
  const TaskOverallViewView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue.withOpacity(0.9),
        body: SafeArea(
          child: Column(
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
                                  color: ColorsManager.backgroundWhite, fontSize: UtilsReponsive.height(28, context), fontWeight: FontWeight.w800),
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
                                      size: 15,
                                    )),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: UtilsReponsive.width(10, context),
                        ),
                        // IconButton(
                        //     onPressed: () {
                        //       Get.toNamed(Routes.EVENT_DETAIL, arguments: {"eventID": controller.eventID});
                        //     },
                        //     icon: Icon(
                        //       Icons.info_rounded,
                        //       color: ColorsManager.orange,
                        //       size: 35,
                        //     )),
                        // CircleAvatar(
                        //   backgroundColor: ColorsManager.backgroundWhite,
                        //   radius: UtilsReponsive.height(20, context),
                        //   child: IconButton(
                        //       onPressed: () {
                        //         Get.toNamed(Routes.BUDGET, arguments: {"eventID": controller.eventID});
                        //       },
                        //       icon: Icon(
                        //         Icons.request_page_rounded,
                        //         color: ColorsManager.green,
                        //       )),
                        // )
                      ],
                    ),
                    SizedBox(
                      height: UtilsReponsive.width(10, context),
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
                                    Container(
                                      height: UtilsReponsive.height(200, context),
                                      width: UtilsReponsive.width(150, context),
                                      child: CachedNetworkImage(
                                        imageBuilder: (context, imageProvider) =>
                                            Container(decoration: BoxDecoration(image: DecorationImage(fit: BoxFit.cover, image: imageProvider))),
                                        imageUrl:
                                            'https://cdni.iconscout.com/illustration/premium/thumb/businessman-completed-tasks-5037983-4202464.png?f=webp',
                                        placeholder: (context, url) => CircularProgressIndicator(),
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                        'Không có công việc trong ngày này',
                                        style: GetTextStyle.getTextStyle(15, 'Nunito', FontWeight.w800, ColorsManager.textColor2),
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
        onTap: () {
          controller.getTaskDetail(taskModel);
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
                        backgroundColor: ColorsManager.primary.withOpacity(0.8),
                        radius: UtilsReponsive.height(15, context),
                        child: const Icon(
                          Icons.info,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      SizedBox(
                        width: UtilsReponsive.width(10, context),
                      ),
                      taskModel.status == Status.DONE || taskModel.status == Status.CONFIRM
                          ? Text(
                              taskModel.title!.length > 28 ? '${taskModel.title!.substring(0, 28)}...' : taskModel.title!,
                              style: TextStyle(
                                letterSpacing: 0.5,
                                fontFamily: 'Nunito',
                                color: ColorsManager.textColor,
                                fontSize: UtilsReponsive.height(20, context),
                                fontWeight: FontWeight.w800,
                                // decoration: TextDecoration.lineThrough,
                              ),
                            )
                          : Text(
                              taskModel.title!.length > 28 ? '${taskModel.title!.substring(0, 28)}...' : taskModel.title!,
                              style: TextStyle(
                                  letterSpacing: 0.5,
                                  fontFamily: 'Nunito',
                                  color: ColorsManager.textColor,
                                  fontSize: UtilsReponsive.height(20, context),
                                  fontWeight: FontWeight.w800),
                            )
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: UtilsReponsive.height(10, context),
                      ),
                      Row(children: [
                        // Icon(
                        //   Icons.priority_high,
                        //   color: taskModel.priority! == Priority.LOW
                        //       ? ColorsManager.green
                        //       : taskModel.priority! == Priority.MEDIUM
                        //           ? ColorsManager.yellow
                        //           : ColorsManager.red,
                        //   size: 20,
                        // ),
                        // SizedBox(
                        //   width: UtilsReponsive.width(15, context),
                        // ),
                        // Text(
                        //     taskModel.priority! == Priority.LOW
                        //         ? "Thấp"
                        //         : taskModel.priority! == Priority.MEDIUM
                        //             ? "Trung bình"
                        //             : "Cao",
                        //     style: GetTextStyle.getTextStyle(
                        //         14,
                        //         'Nunito',
                        //         FontWeight.w600,
                        //         taskModel.priority! == Priority.LOW
                        //             ? ColorsManager.green
                        //             : taskModel.priority! == Priority.MEDIUM
                        //                 ? ColorsManager.yellow
                        //                 : ColorsManager.red)),
                        // SizedBox(
                        //   width: UtilsReponsive.width(15, context),
                        // ),
                        // Row(
                        //   children: [
                        //     CircleAvatar(
                        //       backgroundColor: ColorsManager.backgroundGrey,
                        //       radius: UtilsReponsive.height(15, context),
                        //       child: Icon(
                        //         Icons.check_circle,
                        //         color: taskModel.status! == Status.PENDING
                        //             ? ColorsManager.grey
                        //             : taskModel.status! == Status.PROCESSING
                        //                 ? ColorsManager.blue
                        //                 : taskModel.status! == Status.DONE
                        //                     ? ColorsManager.green
                        //                     : taskModel.status! == Status.OVERDUE
                        //                         ? ColorsManager.red
                        //                         : ColorsManager.purple,
                        //         size: 18,
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       width: UtilsReponsive.width(5, context),
                        //     ),
                        //     Text(
                        //         taskModel.status! == Status.PENDING
                        //             ? "Đang chuẩn bị"
                        //             : taskModel.status! == Status.PROCESSING
                        //                 ? "Đang thực hiện"
                        //                 : taskModel.status! == Status.DONE
                        //                     ? "Hoàn thành"
                        //                     : taskModel.status == Status.OVERDUE
                        //                         ? 'Quá hạn'
                        //                         : "Đã xác thực",
                        //         style: GetTextStyle.getTextStyle(
                        //           14,
                        //           'Nunito',
                        //           FontWeight.w600,
                        //           taskModel.status! == Status.PENDING
                        //               ? ColorsManager.grey
                        //               : taskModel.status! == Status.PROCESSING
                        //                   ? ColorsManager.blue
                        //                   : taskModel.status! == Status.DONE
                        //                       ? ColorsManager.green
                        //                       : taskModel.status! == Status.OVERDUE
                        //                           ? ColorsManager.red
                        //                           : ColorsManager.purple,
                        //         ))
                        //   ],
                        // ),
                        Row(
                          children: [
                            taskModel.status! == Status.DONE
                                ? CircleAvatar(
                                    backgroundColor: ColorsManager.grey.withOpacity(0.7),
                                    radius: UtilsReponsive.height(15, context),
                                    child: Icon(
                                      Icons.check_circle,
                                      color: ColorsManager.green.withOpacity(0.7),
                                      size: 20,
                                    ),
                                  )
                                : CircleAvatar(
                                    backgroundColor: taskModel.status! == Status.PENDING
                                        ? ColorsManager.grey.withOpacity(0.7)
                                        : taskModel.status! == Status.PROCESSING
                                            ? ColorsManager.blue.withOpacity(0.7)
                                            : taskModel.status! == Status.OVERDUE
                                                ? ColorsManager.red.withOpacity(0.7)
                                                : ColorsManager.purple.withOpacity(0.7),
                                    radius: UtilsReponsive.height(15, context),
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
                            Icons.calendar_month_rounded,
                            color: taskModel.status! == Status.PENDING
                                ? ColorsManager.grey
                                : taskModel.status! == Status.PROCESSING
                                    ? ColorsManager.blue
                                    : taskModel.status! == Status.DONE
                                        ? ColorsManager.green
                                        : taskModel.status! == Status.OVERDUE
                                            ? ColorsManager.red
                                            : ColorsManager.purple,
                            size: 20,
                          ),
                          SizedBox(
                            width: UtilsReponsive.width(10, context),
                          ),
                          taskModel.endDate != null
                              ? Text(
                                  'Hạn: ${controller.dateFormat.format(taskModel.startDate!)} - ${controller.dateFormat.format(taskModel.endDate!)}',
                                  style: GetTextStyle.getTextStyle(
                                    14,
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

  Widget _itemTask({
    required BuildContext context,
    required TaskModel taskModel,
    required int index,
  }) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.SUBTASK_DETAIL_VIEW, arguments: {
          "taskID": taskModel.id,
          "isNavigateDetail": false,
        });
      },
      child: Padding(
        padding: UtilsReponsive.paddingAll(context, padding: 10),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: ColorsManager.grey,
              blurRadius: 2,
            ),
          ], color: Colors.white, borderRadius: BorderRadius.circular(UtilsReponsive.height(5, context))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: UtilsReponsive.heightv2(context, 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(UtilsReponsive.height(5, context)), topRight: Radius.circular(UtilsReponsive.height(5, context))),
                  boxShadow: [
                    BoxShadow(
                      color: taskModel.status! == Status.PENDING
                          ? ColorsManager.grey
                          : taskModel.status! == Status.PROCESSING
                              ? ColorsManager.blue
                              : taskModel.status! == Status.DONE
                                  ? ColorsManager.green
                                  : taskModel.status! == Status.OVERDUE
                                      ? ColorsManager.red
                                      : ColorsManager.purple,
                      spreadRadius: 0.5,
                      blurRadius: 0.5,
                    ),
                  ],
                  color: taskModel.status! == Status.PENDING
                      ? ColorsManager.grey
                      : taskModel.status! == Status.PROCESSING
                          ? ColorsManager.blue
                          : taskModel.status! == Status.DONE
                              ? ColorsManager.green
                              : taskModel.status! == Status.OVERDUE
                                  ? ColorsManager.red
                                  : ColorsManager.purple,
                ),
                child: Center(
                    child: Text(
                        taskModel.status! == Status.PENDING
                            ? "Đang chuẩn bị"
                            : taskModel.status! == Status.PROCESSING
                                ? "Đang thực hiện"
                                : taskModel.status! == Status.DONE
                                    ? "Hoàn thành"
                                    : taskModel.status == Status.OVERDUE
                                        ? "Quá hạn"
                                        : "Đã xác nhận",
                        style: TextStyle(
                            letterSpacing: 1.2,
                            fontFamily: 'Nunito',
                            color: Colors.white,
                            fontSize: UtilsReponsive.heightv2(context, 14),
                            fontWeight: FontWeight.w800))),
              ),
              SizedBox(
                height: UtilsReponsive.height(15, context),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      margin: EdgeInsets.only(left: UtilsReponsive.width(15, context)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          taskModel.status == Status.DONE || taskModel.status == Status.CONFIRM
                              ? Text(
                                  taskModel.title!.length > 28 ? '${taskModel.title!.substring(0, 28)}...' : taskModel.title!,
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    letterSpacing: 0.5,
                                    color: ColorsManager.textColor,
                                    fontSize: UtilsReponsive.height(17, context),
                                    fontWeight: FontWeight.w800,
                                    // decoration: TextDecoration.lineThrough,
                                  ),
                                )
                              : Text(
                                  taskModel.title!.length > 28 ? '${taskModel.title!.substring(0, 28)}...' : taskModel.title!,
                                  style: TextStyle(
                                      fontFamily: 'Nunito',
                                      letterSpacing: 0.5,
                                      color: ColorsManager.textColor,
                                      fontSize: UtilsReponsive.height(17, context),
                                      fontWeight: FontWeight.w800),
                                ),
                          SizedBox(
                            height: UtilsReponsive.height(5, context),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_month_rounded,
                                color: taskModel.status! == Status.PENDING
                                    ? ColorsManager.grey
                                    : taskModel.status! == Status.PROCESSING
                                        ? ColorsManager.blue
                                        : taskModel.status! == Status.DONE
                                            ? ColorsManager.green
                                            : taskModel.status! == Status.OVERDUE
                                                ? ColorsManager.red
                                                : ColorsManager.purple,
                                size: 20,
                              ),
                              SizedBox(
                                width: UtilsReponsive.width(5, context),
                              ),
                              taskModel.endDate == null
                                  ? Text(
                                      'Hạn hoàn thành',
                                      style: TextStyle(
                                          letterSpacing: 1.5,
                                          fontFamily: 'Nunito',
                                          color: ColorsManager.textColor2,
                                          fontSize: UtilsReponsive.height(14, context),
                                          fontWeight: FontWeight.w800),
                                    )
                                  : taskModel.startDate != null && taskModel.endDate != null
                                      ? Text(
                                          " ${controller.dateFormat.format(taskModel.endDate!)} ${getCurrentTime(taskModel.endDate!)}",
                                          style: GetTextStyle.getTextStyle(
                                            14,
                                            'Nunito',
                                            FontWeight.w600,
                                            taskModel.status! == Status.PENDING
                                                ? ColorsManager.grey
                                                : taskModel.status! == Status.PROCESSING
                                                    ? ColorsManager.blue
                                                    : taskModel.status! == Status.DONE
                                                        ? ColorsManager.green
                                                        : taskModel.status! == Status.OVERDUE
                                                            ? ColorsManager.red
                                                            : Colors.purpleAccent,
                                          ),
                                        )
                                      : taskModel.startDate != null
                                          ? Text(
                                              controller.dateFormat.format(taskModel.startDate!),
                                              style: GetTextStyle.getTextStyle(
                                                14,
                                                'Nunito',
                                                FontWeight.w600,
                                                taskModel.status! == Status.PENDING
                                                    ? ColorsManager.grey
                                                    : taskModel.status! == Status.PROCESSING
                                                        ? ColorsManager.blue
                                                        : taskModel.status! == Status.DONE
                                                            ? ColorsManager.green
                                                            : taskModel.status! == Status.OVERDUE
                                                                ? ColorsManager.red
                                                                : ColorsManager.orange,
                                              ),
                                            )
                                          : taskModel.endDate != null
                                              ? Text(
                                                  controller.dateFormat.format(taskModel.endDate!),
                                                  style: GetTextStyle.getTextStyle(
                                                    14,
                                                    'Nunito',
                                                    FontWeight.w600,
                                                    taskModel.status! == Status.PENDING
                                                        ? ColorsManager.grey
                                                        : taskModel.status! == Status.PROCESSING
                                                            ? ColorsManager.primary
                                                            : taskModel.status! == Status.DONE
                                                                ? ColorsManager.green
                                                                : taskModel.status! == Status.OVERDUE
                                                                    ? ColorsManager.red
                                                                    : ColorsManager.orange,
                                                  ),
                                                )
                                              : const SizedBox(),
                            ],
                          ),
                          SizedBox(
                            height: UtilsReponsive.height(5, context),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: taskModel.assignTasks!.isNotEmpty && taskModel.assignTasks!.length > 1
                        ? Row(
                            children: [
                              CachedNetworkImage(
                                // fit: BoxFit.contain,
                                imageUrl: taskModel.assignTasks![0].user!.profile!.avatar!,
                                imageBuilder: (context, imageProvider) => Container(
                                    width: UtilsReponsive.width(35, context),
                                    height: UtilsReponsive.height(35, context),
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 1, color: ColorsManager.textColor2),
                                        boxShadow: [
                                          BoxShadow(
                                              spreadRadius: 2, blurRadius: 10, color: Colors.black.withOpacity(0.1), offset: const Offset(0, 10))
                                        ],
                                        shape: BoxShape.circle,
                                        image: DecorationImage(fit: BoxFit.cover, image: imageProvider))),
                                progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                                  padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
                                  height: UtilsReponsive.height(5, context),
                                  width: UtilsReponsive.height(5, context),
                                  child: CircularProgressIndicator(
                                    color: ColorsManager.primary,
                                  ),
                                ),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                              Container(
                                width: UtilsReponsive.height(35, context),
                                height: UtilsReponsive.height(35, context),
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1, color: ColorsManager.textColor2),
                                  color: Colors.blueGrey,
                                  shape: BoxShape.circle,
                                ),
                                child: const Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '...',
                                    style: TextStyle(color: Colors.white, fontSize: 18),
                                  ),
                                ),
                              )
                            ],
                          )
                        : taskModel.assignTasks!.isNotEmpty && taskModel.assignTasks!.length == 1
                            ? Row(children: [
                                SizedBox(
                                  width: UtilsReponsive.width(20, context),
                                ),
                                CachedNetworkImage(
                                  // fit: BoxFit.contain,
                                  imageUrl: taskModel.assignTasks![0].user!.profile!.avatar!,
                                  imageBuilder: (context, imageProvider) => Container(
                                      width: UtilsReponsive.width(35, context),
                                      height: UtilsReponsive.height(35, context),
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 1, color: ColorsManager.textColor2),
                                          boxShadow: [
                                            BoxShadow(
                                                spreadRadius: 2, blurRadius: 10, color: Colors.black.withOpacity(0.1), offset: const Offset(0, 10))
                                          ],
                                          shape: BoxShape.circle,
                                          image: DecorationImage(fit: BoxFit.cover, image: imageProvider))),
                                  progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                                    padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
                                    height: UtilsReponsive.height(5, context),
                                    width: UtilsReponsive.height(5, context),
                                    child: CircularProgressIndicator(
                                      color: ColorsManager.primary,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                              ])
                            : Row(
                                children: [
                                  SizedBox(
                                    width: UtilsReponsive.width(20, context),
                                  ),
                                  CachedNetworkImage(
                                    // fit: BoxFit.contain,
                                    imageUrl: "https://t4.ftcdn.net/jpg/03/49/49/79/360_F_349497933_Ly4im8BDmHLaLzgyKg2f2yZOvJjBtlw5.webp",
                                    imageBuilder: (context, imageProvider) => Container(
                                        width: UtilsReponsive.width(35, context),
                                        height: UtilsReponsive.height(35, context),
                                        decoration: BoxDecoration(
                                            border: Border.all(width: 1, color: ColorsManager.textColor2),
                                            boxShadow: [
                                              BoxShadow(
                                                  spreadRadius: 2, blurRadius: 10, color: Colors.black.withOpacity(0.1), offset: const Offset(0, 10))
                                            ],
                                            shape: BoxShape.circle,
                                            image: DecorationImage(fit: BoxFit.cover, image: imageProvider))),
                                    progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                                      padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
                                      height: UtilsReponsive.height(5, context),
                                      width: UtilsReponsive.height(5, context),
                                      child: CircularProgressIndicator(
                                        color: ColorsManager.primary,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                ],
                              ),
                  ),
                ],
              ),
              SizedBox(
                height: UtilsReponsive.height(10, context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
