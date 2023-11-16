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
        backgroundColor: ColorsManager.backgroundContainer,
        body: SafeArea(
          child: Obx(
            () => controller.isLoading.value == true
                ? Center(
                    child: SpinKitFadingCircle(
                      color: ColorsManager.primary,
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () => Get.back(),
                                icon: Icon(
                                  Icons.arrow_back_ios_new,
                                  color: ColorsManager.primary,
                                )),
                            SizedBox(
                              width: UtilsReponsive.width(5, context),
                            ),
                            Expanded(
                              child: Text(
                                controller.eventName,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    letterSpacing: 0.5,
                                    color: ColorsManager.textColor2,
                                    fontSize: UtilsReponsive.height(20, context),
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            IconButton(
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
                                                style: GetTextStyle.getTextStyle(18, 'Roboto', FontWeight.bold, ColorsManager.primary),
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
                                  Icons.filter_alt_outlined,
                                  color: ColorsManager.primary,
                                )),
                            IconButton(
                                onPressed: () {
                                  Get.toNamed(Routes.EVENT_DETAIL, arguments: {"eventID": controller.eventID});
                                },
                                icon: Icon(
                                  Icons.info_rounded,
                                  color: ColorsManager.orange,
                                )),
                          ],
                        ),
                      ),
                      Obx(
                        () => Expanded(
                            flex: 10,
                            child: controller.listTask.isEmpty
                                ? Center(
                                    child: Text(
                                      'Event này hiện chưa có công việc dành cho bạn',
                                      style: GetTextStyle.getTextStyle(16, 'Roboto', FontWeight.w600, ColorsManager.primary),
                                    ),
                                  )
                                : Obx(
                                    () => RefreshIndicator(
                                      onRefresh: controller.refreshPage,
                                      child: ListView.separated(
                                          padding: UtilsReponsive.paddingAll(context, padding: 15),
                                          itemBuilder: (context, index) => _taskCommon(context, controller.listTask[index], index),
                                          separatorBuilder: (context, index) => SizedBox(
                                                height: UtilsReponsive.height(15, context),
                                              ),
                                          itemCount: controller.listTask.length),
                                    ),
                                  )),
                      )
                    ],
                  ),
          ),
        ));
  }

  GestureDetector _taskCommon(BuildContext context, TaskModel taskModel, int index) {
    return GestureDetector(
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
                              fontFamily: 'Roboto',
                              color: ColorsManager.textColor,
                              fontSize: UtilsReponsive.height(18, context),
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.lineThrough,
                            ),
                          )
                        : Text(
                            taskModel.title!.length > 28 ? '${taskModel.title!.substring(0, 28)}...' : taskModel.title!,
                            style: TextStyle(
                                letterSpacing: 0.5,
                                fontFamily: 'Roboto',
                                color: ColorsManager.textColor,
                                fontSize: UtilsReponsive.height(18, context),
                                fontWeight: FontWeight.w600),
                          )
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      height: UtilsReponsive.height(10, context),
                    ),
                    Row(children: [
                      Icon(
                        Icons.priority_high,
                        color: taskModel.priority! == Priority.LOW
                            ? ColorsManager.green
                            : taskModel.priority! == Priority.MEDIUM
                                ? ColorsManager.yellow
                                : ColorsManager.red,
                        size: 20,
                      ),
                      SizedBox(
                        width: UtilsReponsive.width(15, context),
                      ),
                      Text(
                          taskModel.priority! == Priority.LOW
                              ? "Thấp"
                              : taskModel.priority! == Priority.MEDIUM
                                  ? "Trung bình"
                                  : "Cao",
                          style: GetTextStyle.getTextStyle(
                              14,
                              'Roboto',
                              FontWeight.w600,
                              taskModel.priority! == Priority.LOW
                                  ? ColorsManager.green
                                  : taskModel.priority! == Priority.MEDIUM
                                      ? ColorsManager.yellow
                                      : ColorsManager.red)),
                      SizedBox(
                        width: UtilsReponsive.width(15, context),
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: ColorsManager.backgroundGrey,
                            radius: UtilsReponsive.height(15, context),
                            child: Icon(
                              Icons.check_circle,
                              color: taskModel.status! == Status.PENDING
                                  ? ColorsManager.grey
                                  : taskModel.status! == Status.PROCESSING
                                      ? ColorsManager.blue
                                      : taskModel.status! == Status.DONE
                                          ? ColorsManager.green
                                          : taskModel.status! == Status.OVERDUE
                                              ? ColorsManager.red
                                              : ColorsManager.purple,
                              size: 18,
                            ),
                          ),
                          SizedBox(
                            width: UtilsReponsive.width(5, context),
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
                                14,
                                'Roboto',
                                FontWeight.w600,
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
                          width: UtilsReponsive.width(15, context),
                        ),
                        taskModel.endDate != null
                            ? Text('${controller.dateFormat.format(taskModel.endDate!)} ${getCurrentTime(taskModel.endDate!)} ',
                                style: GetTextStyle.getTextStyle(
                                  14,
                                  'Roboto',
                                  FontWeight.w600,
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
                  ],
                ),
              ]),
            ),
          )),
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
          "endDate": controller.listTask[index].endDate,
          "startDate": controller.listTask[index].startDate
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
                            fontFamily: 'Roboto',
                            color: Colors.white,
                            fontSize: UtilsReponsive.heightv2(context, 14),
                            fontWeight: FontWeight.bold))),
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
                                    fontFamily: 'Roboto',
                                    letterSpacing: 0.5,
                                    color: ColorsManager.textColor,
                                    fontSize: UtilsReponsive.height(17, context),
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                )
                              : Text(
                                  taskModel.title!.length > 28 ? '${taskModel.title!.substring(0, 28)}...' : taskModel.title!,
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      letterSpacing: 0.5,
                                      color: ColorsManager.textColor,
                                      fontSize: UtilsReponsive.height(17, context),
                                      fontWeight: FontWeight.bold),
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
                                          fontFamily: 'Roboto',
                                          color: ColorsManager.textColor2,
                                          fontSize: UtilsReponsive.height(14, context),
                                          fontWeight: FontWeight.bold),
                                    )
                                  : taskModel.startDate != null && taskModel.endDate != null
                                      ? Text(
                                          " ${controller.dateFormat.format(taskModel.endDate!)} ${getCurrentTime(taskModel.endDate!)}",
                                          style: GetTextStyle.getTextStyle(
                                            14,
                                            'Roboto',
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
                                                'Roboto',
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
                                                    'Roboto',
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
