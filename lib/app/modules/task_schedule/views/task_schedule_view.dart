import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_view.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/task.dart';
import 'package:hrea_mobile_employee/app/resources/assets_manager.dart';
import 'package:hrea_mobile_employee/app/resources/calendar_custom.dart';
import 'package:hrea_mobile_employee/app/resources/color_manager.dart';
import 'package:hrea_mobile_employee/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_employee/app/resources/style_manager.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';

import '../controllers/task_schedule_controller.dart';

class TaskScheduleView extends BaseView<TaskScheduleController> {
  const TaskScheduleView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.blue.withOpacity(0.9),
        body: SafeArea(
          child: controller.checkView.value == false
              ? Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Row(
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
                            child: Text(
                              'Lịch thực hiện công việc',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: 'Nunito',
                                  color: ColorsManager.backgroundWhite,
                                  fontSize: UtilsReponsive.height(20, context),
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 7,
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
                      child: Row(
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
                            child: Text(
                              'Lịch thực hiện công việc',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: 'Nunito',
                                  color: ColorsManager.backgroundWhite,
                                  fontSize: UtilsReponsive.height(20, context),
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: UtilsReponsive.height(15, context),
                    ),
                    Expanded(
                      flex: 2,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // GestureDetector(
                              //   onTap: () {
                              //     _showDateTimePicker(context);
                              //   },
                              //   child: Obx(
                              //     () => Text(
                              //       controller.dateTimeString.toString(),
                              //       style: TextStyle(fontFamily: 'Nunito', fontSize: 20, fontWeight: FontWeight.w800, color: ColorsManager.primary),
                              //     ),
                              //   ),
                              // ),

                              SizedBox(
                                height: UtilsReponsive.height(70, context),
                                child: HorizontalCalendar(
                                  lastDate: DateTime(2030),
                                  date: controller.dateTime,
                                  initialDate: controller.dateTime,
                                  textColor: ColorsManager.textColor,
                                  backgroundColor: Colors.blueAccent,
                                  selectedColor: Colors.blueGrey,
                                  showMonth: true,
                                  locale: Localizations.localeOf(context),
                                  onDateSelected: (date) async {
                                    await controller.getListTask(date.toString());
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Trạng thái: ",
                            style: GetTextStyle.getTextStyle(18, 'Nunito', FontWeight.w800, ColorsManager.backgroundWhite),
                          ),
                          SizedBox(
                            height: UtilsReponsive.height(10, context),
                          ),
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: ColorsManager.grey.withOpacity(0.7),
                                radius: UtilsReponsive.height(10, context),
                              ),
                              SizedBox(
                                width: UtilsReponsive.width(5, context),
                              ),
                              Text(
                                'Đang chuẩn bị',
                                overflow: TextOverflow.ellipsis,
                                style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, ColorsManager.backgroundWhite),
                              ),
                              SizedBox(
                                width: UtilsReponsive.width(5, context),
                              ),
                              CircleAvatar(
                                backgroundColor: ColorsManager.blue.withOpacity(0.7),
                                radius: UtilsReponsive.height(10, context),
                              ),
                              SizedBox(
                                width: UtilsReponsive.width(5, context),
                              ),
                              Text(
                                'Đang diễn ra',
                                overflow: TextOverflow.ellipsis,
                                style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, ColorsManager.backgroundWhite),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: ColorsManager.red.withOpacity(0.7),
                                radius: UtilsReponsive.height(10, context),
                              ),
                              SizedBox(
                                width: UtilsReponsive.width(5, context),
                              ),
                              Text(
                                'Quá hạn',
                                overflow: TextOverflow.ellipsis,
                                style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, ColorsManager.backgroundWhite),
                              ),
                              SizedBox(
                                width: UtilsReponsive.width(5, context),
                              ),
                              CircleAvatar(
                                backgroundColor: ColorsManager.green.withOpacity(0.7),
                                radius: UtilsReponsive.height(10, context),
                              ),
                              SizedBox(
                                width: UtilsReponsive.width(5, context),
                              ),
                              Text(
                                'Hoàn thành',
                                overflow: TextOverflow.ellipsis,
                                style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, ColorsManager.backgroundWhite),
                              ),
                              SizedBox(
                                width: UtilsReponsive.width(5, context),
                              ),
                              CircleAvatar(
                                backgroundColor: ColorsManager.purple.withOpacity(0.7),
                                radius: UtilsReponsive.height(10, context),
                              ),
                              SizedBox(
                                width: UtilsReponsive.width(5, context),
                              ),
                              Text(
                                'Đã xác thực',
                                overflow: TextOverflow.ellipsis,
                                style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, ColorsManager.backgroundWhite),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: UtilsReponsive.height(10, context),
                          ),
                          Text(
                            "Độ ưu tiên: ",
                            style: GetTextStyle.getTextStyle(18, 'Nunito', FontWeight.w800, ColorsManager.backgroundWhite),
                          ),
                          Row(children: [
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
                            )
                          ]),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: UtilsReponsive.height(10, context),
                    ),
                    Obx(
                      () => Expanded(
                        flex: 6,
                        child: Container(
                            padding: EdgeInsets.only(top: controller.listTask.isNotEmpty ? UtilsReponsive.height(30, context) : 0),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                              color: Color(0xffFAFAFA),
                            ),
                            child: controller.isLoading.value == true
                                ? Center(
                                    child: SpinKitFadingCircle(
                                      color: ColorsManager.primary,
                                      // size: 50.0,
                                    ),
                                  )
                                : RefreshIndicator(
                                    onRefresh: controller.refreshPage,
                                    child: controller.listTask.isNotEmpty
                                        ? ListView.separated(
                                            separatorBuilder: (context, index) => SizedBox(
                                              height: UtilsReponsive.height(20, context),
                                            ),
                                            itemCount: controller.listTask.length,
                                            shrinkWrap: true,
                                            padding: EdgeInsets.symmetric(horizontal: UtilsReponsive.height(16, context)),
                                            // physics: NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return itemTask(index: index, context: context, taskModel: controller.listTask[index]);
                                            },
                                          )
                                        : Column(
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
                                                  style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w800, ColorsManager.primary),
                                                ),
                                              ),
                                            ],
                                          ),
                                  )),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget itemTask({required int index, required BuildContext context, required TaskModel taskModel}) {
    return GestureDetector(
      onTap: () {
        // Get.toNamed(Routes.SUBTASK_DETAIL_VIEW,
        //     arguments: {"eventID": taskModel.eventDivision!.event!.id, "eventName": taskModel.eventDivision!.event!.eventName});

        Get.toNamed(Routes.SUBTASK_DETAIL_VIEW, arguments: {
          "taskID": taskModel.id,
          "isNavigateDetail": false,
          "isScheduleOverall": true,
        });
      },
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white, boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Màu của shadow và độ mờ
            spreadRadius: 2, // Độ lan rộng của shadow
            blurRadius: 5, // Độ mờ của shadow
            offset: const Offset(0, 1), // Độ dịch chuyển của shadow
          ),
        ]),
        padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 45,
                width: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: taskModel.priority! == Priority.LOW
                      ? ColorsManager.green
                      : taskModel.priority! == Priority.MEDIUM
                          ? ColorsManager.yellow
                          : ColorsManager.red,
                ),
              ),
              SizedBox(
                width: UtilsReponsive.height(30, context),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sự kiện: ${taskModel.eventDivision!.event!.eventName!}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, ColorsManager.primary),
                    ),
                    SizedBox(
                      height: UtilsReponsive.height(10, context),
                    ),
                    Text(
                      'Hạng mục: ${taskModel.parent!.title!}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, ColorsManager.textColor),
                    ),
                    SizedBox(
                      height: UtilsReponsive.height(10, context),
                    ),
                    Text(
                      taskModel.title!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w700, ColorsManager.textColor),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    taskModel.status! == Status.CONFIRM
                        ? CircleAvatar(
                            backgroundColor: ColorsManager.grey.withOpacity(0.2),
                            radius: UtilsReponsive.height(20, context),
                            child: Icon(
                              Icons.check_circle,
                              color: ColorsManager.purple.withOpacity(0.7),
                              size: 40,
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
                            radius: UtilsReponsive.height(20, context),
                          ),
                  ],
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }

  // void _showDateTimePicker(BuildContext context) {
  //   showDatePicker(context: context, initialDate: controller.dateTime, firstDate: DateTime(2000), lastDate: DateTime(2030))
  //       .then((value) => controller.check(value!));
  // }
}
