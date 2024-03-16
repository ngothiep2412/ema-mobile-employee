import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as Quil;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_view.dart';
import 'package:hrea_mobile_employee/app/modules/subtask-detail-view/model/attachment_model.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/task.dart';
import 'package:hrea_mobile_employee/app/modules/task-detail-view/model/comment_model.dart';
import 'package:hrea_mobile_employee/app/resources/assets_manager.dart';
import 'package:hrea_mobile_employee/app/resources/color_manager.dart';
import 'package:hrea_mobile_employee/app/resources/form_field_widget.dart';
import 'package:hrea_mobile_employee/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_employee/app/resources/style_manager.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';
import 'package:hrea_mobile_employee/app/utils/calculate_time_difference.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/task_detail_view_controller.dart';

class TaskDetailViewView extends BaseView<TaskDetailViewController> {
  const TaskDetailViewView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorsManager.backgroundContainer,
        appBar: _appBar(context),
        body: Obx(
          () => controller.isLoading.value
              ? Center(
                  child: SpinKitFadingCircle(
                    color: ColorsManager.primary,
                  ),
                )
              : SafeArea(
                  child: Container(
                    height: double.infinity,
                    color: ColorsManager.backgroundContainer,
                    child: Stack(
                      children: [
                        RefreshIndicator(
                          onRefresh: controller.refreshPage,
                          child: SingleChildScrollView(
                            padding: EdgeInsets.all(UtilsReponsive.height(8, context)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(
                                  () => _header(context: context, objectTask: controller.taskModel.value.title!),
                                ),
                                SizedBox(
                                  height: UtilsReponsive.height(15, context),
                                ),
                                Obx(
                                  () => _statusBuilder(
                                      context: context,
                                      objectStatusTask: controller.taskModel.value.status == Status.PENDING
                                          ? "Đang chuẩn bị"
                                          : controller.taskModel.value.status! == Status.PROCESSING
                                              ? "Đang thực hiện"
                                              : controller.taskModel.value.status! == Status.DONE
                                                  ? "Hoàn thành"
                                                  : controller.taskModel.value.status! == Status.CONFIRM
                                                      ? "Đã xác thực"
                                                      : "Quá hạn",
                                      taskID: controller.taskModel.value.id!),
                                ),
                                SizedBox(
                                  height: UtilsReponsive.height(15, context),
                                ),
                                Obx(
                                  () => Row(
                                    children: [
                                      Icon(
                                        Icons.priority_high,
                                        color: controller.taskModel.value.priority! == Priority.LOW
                                            ? ColorsManager.green
                                            : controller.taskModel.value.priority! == Priority.MEDIUM
                                                ? ColorsManager.yellow
                                                : ColorsManager.red,
                                      ),
                                      priorityBuilder(
                                          context: context,
                                          objectStatusTask: controller.taskModel.value.priority! == Priority.LOW
                                              ? "Thấp"
                                              : controller.taskModel.value.priority! == Priority.MEDIUM
                                                  ? "Trung bình"
                                                  : "Cao",
                                          taskID: controller.taskModel.value.id!)
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: UtilsReponsive.width(10, context),
                                ),
                                Obx(
                                  () => Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: UtilsReponsive.height(5, context), vertical: UtilsReponsive.height(10, context)),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                    ),
                                    child: _timeBuilder(
                                      context: context,
                                      startTime: controller.dateFormat.format(controller.taskModel.value.startDate!),
                                      endTime: controller.dateFormat.format(controller.taskModel.value.endDate!),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: UtilsReponsive.width(10, context),
                                ),
                                Obx(
                                  () => Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: UtilsReponsive.height(10, context),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      children: [
                                        Row(children: [
                                          Text('Ước tính (giờ):',
                                              style: GetTextStyle.getTextStyle(12, 'Nunito', FontWeight.w800, ColorsManager.textColor)),
                                          SizedBox(
                                            width: UtilsReponsive.width(5, context),
                                          ),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                                backgroundColor: ColorsManager.backgroundContainer,
                                                side: const BorderSide(color: ColorsManager.backgroundGrey, width: 1)),
                                            onPressed: () {},
                                            child: Text(controller.est.toString(),
                                                style: GetTextStyle.getTextStyle(12, 'Nunito', FontWeight.w700, ColorsManager.primary)),
                                          )
                                        ]),
                                        SizedBox(
                                          width: UtilsReponsive.width(15, context),
                                        ),
                                        Row(
                                          children: [
                                            Text('Công sức (giờ):',
                                                style: GetTextStyle.getTextStyle(12, 'Nunito', FontWeight.w800, ColorsManager.textColor)),
                                            SizedBox(
                                              width: UtilsReponsive.width(5, context),
                                            ),
                                            TextButton(
                                                style: TextButton.styleFrom(
                                                  backgroundColor: ColorsManager.backgroundContainer,
                                                  side: BorderSide(color: ColorsManager.primary, width: 1),
                                                ),
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: Text('Nhập con số công sức',
                                                              style: GetTextStyle.getTextStyle(18, 'Nunito', FontWeight.w500, ColorsManager.primary)),
                                                          content: TextField(
                                                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                                            inputFormatters: <TextInputFormatter>[
                                                              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                                                            ],
                                                            onChanged: (value) => {controller.effortController.text = value},
                                                            controller: controller.effortController,
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              child: Text('Hủy',
                                                                  style: GetTextStyle.getTextStyle(
                                                                      16, 'Nunito', FontWeight.w500, ColorsManager.textColor2)),
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                              },
                                                            ),
                                                            TextButton(
                                                              child: Text('Lưu',
                                                                  style: GetTextStyle.getTextStyle(
                                                                      16, 'Nunito', FontWeight.w500, ColorsManager.primary)),
                                                              onPressed: () async {
                                                                await controller.updateEffort(
                                                                    controller.taskModel.value.id!, double.parse(controller.effortController.text));
                                                                Navigator.of(Get.context!).pop();
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                },
                                                child: Text(controller.effort.toString(),
                                                    style: GetTextStyle.getTextStyle(12, 'Nunito', FontWeight.w700, ColorsManager.primary))),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: UtilsReponsive.width(10, context),
                                ),
                                Obx(
                                  () => Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: UtilsReponsive.height(5, context), vertical: UtilsReponsive.height(10, context)),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: controller.taskModel.value.parent!.assignTasks![0].user!.profile!.avatar!,
                                          imageBuilder: (context, imageProvider) => Container(
                                              width: UtilsReponsive.width(40, context),
                                              height: UtilsReponsive.height(45, context),
                                              decoration: BoxDecoration(boxShadow: [
                                                BoxShadow(
                                                  spreadRadius: 0.5,
                                                  blurRadius: 0.5,
                                                  color: Colors.black.withOpacity(0.1),
                                                )
                                              ], shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.cover, image: imageProvider))),
                                          progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                                            padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
                                            height: UtilsReponsive.height(5, context),
                                            width: UtilsReponsive.height(5, context),
                                            child: CircularProgressIndicator(
                                              color: ColorsManager.primary,
                                            ),
                                          ),
                                          errorWidget: (context, url, error) => CircleAvatar(
                                            radius: UtilsReponsive.height(20, context),
                                            child: Text(
                                              getTheAbbreviation(
                                                controller.taskModel.value.parent!.assignTasks![0].user!.profile!.fullName!,
                                              ),
                                              style: TextStyle(
                                                  letterSpacing: 1.5,
                                                  color: ColorsManager.textColor,
                                                  fontSize: UtilsReponsive.height(17, context),
                                                  fontWeight: FontWeight.w800),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: UtilsReponsive.width(10, context),
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              controller.taskModel.value.parent!.assignTasks![0].user!.profile!.fullName!,
                                              style: TextStyle(
                                                  fontFamily: 'Nunito',
                                                  color: ColorsManager.textColor,
                                                  fontSize: UtilsReponsive.height(17, context),
                                                  fontWeight: FontWeight.w800),
                                            ),
                                            Text(
                                              "Người giao việc",
                                              style: TextStyle(
                                                  fontFamily: 'Nunito',
                                                  color: ColorsManager.primary,
                                                  fontSize: UtilsReponsive.height(16, context),
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: UtilsReponsive.width(10, context),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: UtilsReponsive.height(5, context), vertical: UtilsReponsive.height(10, context)),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: controller.taskModel.value.assignTasks![0].user!.profile!.avatar!,
                                            imageBuilder: (context, imageProvider) => Container(
                                                width: UtilsReponsive.width(40, context),
                                                height: UtilsReponsive.height(45, context),
                                                decoration: BoxDecoration(boxShadow: [
                                                  BoxShadow(
                                                    spreadRadius: 0.5,
                                                    blurRadius: 0.5,
                                                    color: Colors.black.withOpacity(0.1),
                                                  )
                                                ], shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.cover, image: imageProvider))),
                                            progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                                              padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
                                              height: UtilsReponsive.height(5, context),
                                              width: UtilsReponsive.height(5, context),
                                              child: CircularProgressIndicator(
                                                color: ColorsManager.primary,
                                              ),
                                            ),
                                            errorWidget: (context, url, error) => CircleAvatar(
                                              radius: UtilsReponsive.height(20, context),
                                              child: Text(
                                                getTheAbbreviation(controller.taskModel.value.assignTasks![0].user!.profile!.fullName!),
                                                style: TextStyle(
                                                    letterSpacing: 1.5,
                                                    color: ColorsManager.primary,
                                                    fontSize: UtilsReponsive.height(17, context),
                                                    fontWeight: FontWeight.w800),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: UtilsReponsive.width(10, context),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                controller.taskModel.value.assignTasks![0].user!.profile!.fullName!,
                                                style: TextStyle(
                                                    fontFamily: 'Nunito',
                                                    color: ColorsManager.textColor,
                                                    fontSize: UtilsReponsive.height(18, context),
                                                    fontWeight: FontWeight.w800),
                                              ),
                                              Text(
                                                'Người chịu trách nhiệm',
                                                style: TextStyle(
                                                    fontFamily: 'Nunito',
                                                    color: ColorsManager.primary,
                                                    fontSize: UtilsReponsive.height(17, context),
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: UtilsReponsive.height(10, context),
                                ),
                                Obx(() => _description(context)),
                                SizedBox(
                                  height: UtilsReponsive.height(15, context),
                                ),
                                _documentV2(context),
                                SizedBox(
                                  height: UtilsReponsive.height(15, context),
                                ),
                                _subTask(context),
                                SizedBox(
                                  height: UtilsReponsive.height(15, context),
                                ),
                                _commentList(context),
                                Obx(
                                  () => SizedBox(
                                    height: controller.filePicker.isNotEmpty
                                        ? UtilsReponsive.height(70 + 200, context)
                                        : UtilsReponsive.height(70, context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Obx(
                          () => controller.isCheckEditComment.value
                              ? SizedBox()
                              : Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Obx(
                                    () => controller.filePicker.isNotEmpty
                                        ? Container(
                                            decoration: const BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: ColorsManager.textColor,
                                                  blurRadius: 1.0,
                                                ),
                                              ],
                                              color: Colors.white,
                                            ),
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: UtilsReponsive.height(170, context),
                                                  padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
                                                  child: ListView.separated(
                                                    scrollDirection: Axis.horizontal,
                                                    itemCount: controller.filePicker.length,
                                                    separatorBuilder: (context, index) => SizedBox(width: UtilsReponsive.width(15, context)),
                                                    itemBuilder: (context, index) {
                                                      return attchFileComment(controller.filePicker[index], context, index);
                                                    },
                                                  ),
                                                ),
                                                TextField(
                                                  onChanged: (value) => {controller.commentController.text = value},
                                                  controller: controller.commentController,
                                                  focusNode: controller.focusNodeComment,
                                                  keyboardType: TextInputType.text,
                                                  maxLines: 5,
                                                  minLines: 1,
                                                  cursorColor: Colors.black,
                                                  decoration: InputDecoration(
                                                    prefixIcon: IconButton(
                                                        onPressed: () async {
                                                          await controller.selectFile();
                                                        },
                                                        icon: const Icon(
                                                          Icons.attach_file_outlined,
                                                        )),
                                                    suffixIcon: IconButton(
                                                        onPressed: () async {
                                                          await controller.createComment();
                                                        },
                                                        icon: const Icon(Icons.double_arrow_sharp)),
                                                    contentPadding: EdgeInsets.all(UtilsReponsive.width(15, context)),
                                                    hintText: 'Nhập bình luận',
                                                    focusedBorder: UnderlineInputBorder(
                                                      borderSide: BorderSide(color: ColorsManager.grey),
                                                    ),
                                                    enabledBorder: UnderlineInputBorder(
                                                      borderSide:
                                                          BorderSide(color: ColorsManager.grey), // Màu gạch dưới khi TextField không được chọn
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container(
                                            decoration: const BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: ColorsManager.textColor,
                                                  blurRadius: 1.0,
                                                ),
                                              ],
                                              color: Colors.white,
                                            ),
                                            child: Column(
                                              children: [
                                                TextField(
                                                  onChanged: (value) => {controller.commentController.text = value},
                                                  controller: controller.commentController,
                                                  focusNode: controller.focusNodeComment,
                                                  keyboardType: TextInputType.text,
                                                  maxLines: 5,
                                                  minLines: 1,
                                                  cursorColor: Colors.black,
                                                  decoration: InputDecoration(
                                                    prefixIcon: IconButton(
                                                        onPressed: () async {
                                                          await controller.selectFile();
                                                        },
                                                        icon: const Icon(
                                                          Icons.attach_file_outlined,
                                                        )),
                                                    suffixIcon: IconButton(
                                                        onPressed: () async {
                                                          await controller.createComment();
                                                        },
                                                        icon: const Icon(Icons.double_arrow_sharp)),
                                                    contentPadding: EdgeInsets.all(UtilsReponsive.width(15, context)),
                                                    hintText: 'Nhập bình luận',
                                                    focusedBorder: UnderlineInputBorder(
                                                      borderSide: BorderSide(color: ColorsManager.grey), // Màu gạch dưới khi TextField được chọn
                                                    ),
                                                    enabledBorder: UnderlineInputBorder(
                                                      borderSide:
                                                          BorderSide(color: ColorsManager.grey), // Màu gạch dưới khi TextField không được chọn
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ),
                                ),
                        )
                      ],
                    ),
                  ),
                ),
          // ),
        ));
  }

  Row _timeBuilder({required BuildContext context, required String startTime, required String endTime}) {
    return Row(
      children: [
        Icon(
          Icons.calendar_month,
          size: 25,
          color: controller.taskModel.value.status == Status.PENDING
              ? ColorsManager.grey
              : controller.taskModel.value.status! == Status.PROCESSING
                  ? ColorsManager.blue
                  : controller.taskModel.value.status! == Status.DONE
                      ? ColorsManager.green
                      : controller.taskModel.value.status! == Status.CONFIRM
                          ? ColorsManager.purple
                          : ColorsManager.red,
        ),
        Container(
          margin: EdgeInsets.only(left: UtilsReponsive.width(10, context)),
          child: Text(
            '$startTime ${getCurrentTime(controller.taskModel.value.startDate!)} - $endTime ${getCurrentTime(controller.taskModel.value.endDate!)}',
            style: TextStyle(
                letterSpacing: 1.5,
                fontFamily: 'Nunito',
                color: controller.taskModel.value.status == Status.PENDING
                    ? ColorsManager.grey
                    : controller.taskModel.value.status! == Status.PROCESSING
                        ? ColorsManager.blue
                        : controller.taskModel.value.status! == Status.DONE
                            ? ColorsManager.green
                            : controller.taskModel.value.status! == Status.CONFIRM
                                ? ColorsManager.purple
                                : ColorsManager.red,
                // fontSize: UtilsReponsive.height(17, context),
                fontWeight: FontWeight.w800),
          ),
        )
      ],
    );
  }

  void _showBottomSheetStatusSubtask(BuildContext context, String taskID) {
    Get.bottomSheet(Container(
      decoration: const BoxDecoration(
        color: ColorsManager.backgroundGrey,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      constraints: BoxConstraints(maxHeight: UtilsReponsive.width(400, context)),
      child: ListView(
        shrinkWrap: true,
        children: [
          "Đang chuẩn bị",
          "Đang thực hiện",
          "Hoàn thành",
          "Đã xác thực",
          "Quá hạn",
        ]
            .map(
              (e) => GestureDetector(
                onTap: () {
                  if (e == "Đang chuẩn bị") {
                    controller.updateStatusTask("PENDING", taskID);
                    Navigator.of(context).pop();
                  } else if (e == "Đang thực hiện") {
                    controller.updateStatusTask("PROCESSING", taskID);
                    Navigator.of(context).pop();
                  } else if (e == "Hoàn thành") {
                    controller.updateStatusTask("DONE", taskID);
                    Navigator.of(context).pop();
                  } else if (e == "Đã xác thực") {
                    controller.updateStatusTask("CONFIRM", taskID);
                    Navigator.of(context).pop();
                  } else if (e == "Quá hạn") {
                    controller.updateStatusTask("OVERDUE", taskID);
                    Navigator.of(context).pop();
                  }
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: e == "Đang chuẩn bị"
                          ? ColorsManager.grey
                          : e == "Đang thực hiện"
                              ? ColorsManager.primary
                              : e == "Hoàn thành"
                                  ? ColorsManager.green
                                  : e == "Đã xác thực"
                                      ? ColorsManager.purple
                                      : ColorsManager.red,
                      child: Text(e[0],
                          style: TextStyle(
                              letterSpacing: 1.5, color: Colors.white, fontSize: UtilsReponsive.height(16, context), fontWeight: FontWeight.w800)),
                    ),
                    title: Text(
                      e,
                      style: TextStyle(
                          fontFamily: 'Nunito',
                          letterSpacing: 1.5,
                          color: ColorsManager.textColor,
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

  void _showBottomSheetStatus(BuildContext context, String taskID) {
    Get.bottomSheet(Container(
      decoration: const BoxDecoration(
        color: ColorsManager.backgroundContainer,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      constraints: BoxConstraints(maxHeight: UtilsReponsive.width(400, context)),
      child: ListView(
        shrinkWrap: true,
        children: [
          "Đang chuẩn bị",
          "Đang thực hiện",
          "Hoàn thành",
          "Quá hạn",
        ]
            .map(
              (e) => GestureDetector(
                onTap: () {
                  if (e == "Đang chuẩn bị") {
                    controller.updateStatusTask("PENDING", taskID);
                    Navigator.of(context, rootNavigator: true).pop();
                  } else if (e == "Đang thực hiện") {
                    controller.updateStatusTask("PROCESSING", taskID);
                    Navigator.of(context, rootNavigator: true).pop();
                  } else if (e == "Hoàn thành") {
                    controller.updateStatusTask("DONE", taskID);
                    Navigator.of(context, rootNavigator: true).pop();
                  } else if (e == "Quá hạn") {
                    controller.updateStatusTask("OVERDUE", taskID);
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: e == "Đang chuẩn bị"
                          ? ColorsManager.grey
                          : e == "Đang thực hiện"
                              ? ColorsManager.blue
                              : e == "Hoàn thành"
                                  ? ColorsManager.green
                                  : ColorsManager.red,
                      child: Text(e[0],
                          style: TextStyle(
                              letterSpacing: 1.5, color: Colors.white, fontSize: UtilsReponsive.height(16, context), fontWeight: FontWeight.w800)),
                    ),
                    title: Text(
                      e,
                      style: TextStyle(
                          fontFamily: 'Nunito',
                          letterSpacing: 1.5,
                          color: ColorsManager.textColor2,
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

  Widget _statusBuilder({required BuildContext context, required String objectStatusTask, required String taskID}) {
    return GestureDetector(
      onTap: () {
        if (controller.taskModel.value.status != Status.CONFIRM) {
          _showBottomSheetStatus(context, taskID);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: UtilsReponsive.width(10, context), vertical: UtilsReponsive.width(5, context)),
        decoration: BoxDecoration(
          color: controller.taskModel.value.status == Status.PENDING
              ? ColorsManager.grey
              : controller.taskModel.value.status! == Status.PROCESSING
                  ? ColorsManager.blue
                  : controller.taskModel.value.status! == Status.DONE
                      ? ColorsManager.green
                      : controller.taskModel.value.status! == Status.CONFIRM
                          ? ColorsManager.purple
                          : ColorsManager.red,
          borderRadius: BorderRadius.circular(UtilsReponsive.height(10, context)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              objectStatusTask,
              style: TextStyle(letterSpacing: 1, color: Colors.white, fontSize: UtilsReponsive.height(14, context), fontWeight: FontWeight.w800),
            ),
            const Icon(
              Icons.arrow_drop_down_rounded,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }

  Widget priorityBuilder({required BuildContext context, required String objectStatusTask, required String taskID}) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(left: UtilsReponsive.width(10, context)),
        child: controller.taskModel.value.endDate != null
            ? Text(
                objectStatusTask,
                style: TextStyle(
                    letterSpacing: 1,
                    fontFamily: 'Nunito',
                    color: controller.taskModel.value.priority! == Priority.LOW
                        ? ColorsManager.green
                        : controller.taskModel.value.priority! == Priority.MEDIUM
                            ? ColorsManager.yellow
                            : ColorsManager.red,
                    fontSize: UtilsReponsive.height(16, context),
                    fontWeight: FontWeight.w800),
              )
            : Text(
                '--',
                style: TextStyle(
                    letterSpacing: 1,
                    fontFamily: 'Nunito',
                    color: Colors.white,
                    fontSize: UtilsReponsive.height(16, context),
                    fontWeight: FontWeight.w800),
              ),
      ),
    );
  }

  Container _header({required BuildContext context, required String objectTask}) {
    return Container(
      padding: UtilsReponsive.paddingAll(context, padding: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              objectTask,
              style: TextStyle(
                  letterSpacing: 1,
                  fontFamily: 'Nunito',
                  color: ColorsManager.textColor,
                  fontSize: UtilsReponsive.height(22, context),
                  fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
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
        Obx(
          () => controller.isCheckin.value == false
              ? IconButton(
                  onPressed: () {
                    if (controller.taskModel.value.startDate!.year == controller.taskModel.value.endDate!.year) {
                      DateTime startDate = controller.taskModel.value.startDate!;
                      DateTime adjustedTime = startDate.subtract(const Duration(minutes: 15));
                      if (DateTime.now().toLocal().add(const Duration(hours: 7)).isAfter(adjustedTime) &&
                          DateTime.now().toLocal().add(const Duration(hours: 7)).isBefore(controller.taskModel.value.endDate!)) {
                        Get.toNamed(Routes.CHECK_IN);
                      } else if (DateTime.now().toLocal().add(const Duration(hours: 7)).isAfter(controller.taskModel.value.endDate!)) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Thông báo',
                                  style: TextStyle(
                                      fontFamily: 'Nunito',
                                      wordSpacing: 1.2,
                                      color: ColorsManager.primary,
                                      fontSize: UtilsReponsive.height(20, context),
                                      fontWeight: FontWeight.w800)),
                              content: Text(
                                'Bạn đã bị quá giờ để check in',
                                style: TextStyle(
                                    fontFamily: 'Nunito',
                                    wordSpacing: 1.2,
                                    color: ColorsManager.red,
                                    fontSize: UtilsReponsive.height(18, context),
                                    fontWeight: FontWeight.w800),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Đồng ý',
                                      style: TextStyle(
                                          fontFamily: 'Nunito',
                                          wordSpacing: 1.2,
                                          color: ColorsManager.primary,
                                          fontSize: UtilsReponsive.height(18, context),
                                          fontWeight: FontWeight.w800)),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Thông báo',
                                  style: TextStyle(
                                      fontFamily: 'Nunito',
                                      wordSpacing: 1.2,
                                      color: ColorsManager.primary,
                                      fontSize: UtilsReponsive.height(20, context),
                                      fontWeight: FontWeight.w800)),
                              content: Text(
                                'Bạn chưa thể check in tại thời điểm lúc này',
                                style: TextStyle(
                                    fontFamily: 'Nunito',
                                    wordSpacing: 1.2,
                                    color: ColorsManager.textColor2,
                                    fontSize: UtilsReponsive.height(18, context),
                                    fontWeight: FontWeight.w800),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Đồng ý',
                                      style: TextStyle(
                                          fontFamily: 'Nunito',
                                          wordSpacing: 1.2,
                                          color: ColorsManager.primary,
                                          fontSize: UtilsReponsive.height(18, context),
                                          fontWeight: FontWeight.w800)),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } else {
                      print('task Created At: ${controller.taskModel.value.startDate}');
                      print('task Created At: ${DateTime.now().toLocal().add(const Duration(hours: 7))}');
                      DateTime startDate = controller.taskModel.value.startDate!;
                      DateTime adjustedTime = startDate.subtract(const Duration(minutes: 15));
                      if (DateTime.now().toLocal().add(const Duration(hours: 7)).isAfter(adjustedTime)) {
                        Get.toNamed(Routes.CHECK_IN);
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Thông báo',
                                  style: TextStyle(
                                      fontFamily: 'Nunito',
                                      wordSpacing: 1.2,
                                      color: ColorsManager.primary,
                                      fontSize: UtilsReponsive.height(20, context),
                                      fontWeight: FontWeight.w800)),
                              content: Text(
                                'Bạn chưa thể check in tại thời điểm lúc này',
                                style: TextStyle(
                                    fontFamily: 'Nunito',
                                    wordSpacing: 1.2,
                                    color: ColorsManager.textColor2,
                                    fontSize: UtilsReponsive.height(18, context),
                                    fontWeight: FontWeight.w800),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Đồng ý',
                                      style: TextStyle(
                                          fontFamily: 'Nunito',
                                          wordSpacing: 1.2,
                                          color: ColorsManager.primary,
                                          fontSize: UtilsReponsive.height(18, context),
                                          fontWeight: FontWeight.w800)),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                  icon: Icon(
                    Icons.qr_code_scanner,
                    color: ColorsManager.primary,
                  ),
                )
              : Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: ColorsManager.green,
                    ),
                    SizedBox(
                      width: UtilsReponsive.width(10, context),
                    ),
                    Text(
                      'Bạn đã Check In',
                      style: TextStyle(
                          fontFamily: 'Nunito',
                          wordSpacing: 1.2,
                          color: ColorsManager.green,
                          fontSize: UtilsReponsive.height(18, context),
                          fontWeight: FontWeight.w800),
                    ),
                    SizedBox(
                      width: UtilsReponsive.width(10, context),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Container _commentList(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(UtilsReponsive.height(10, context))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: UtilsReponsive.height(10, context)),
            child: Text('Bình luận',
                style: TextStyle(
                    fontFamily: 'Nunito',
                    wordSpacing: 1.2,
                    color: Colors.black,
                    fontSize: UtilsReponsive.height(18, context),
                    fontWeight: FontWeight.w800)),
          ),
          SizedBox(
            height: UtilsReponsive.height(10, context),
          ),
          Obx(
            () => controller.listComment.isNotEmpty
                ? Container(
                    padding: EdgeInsets.only(left: UtilsReponsive.height(10, context)),
                    margin: EdgeInsets.only(top: UtilsReponsive.height(10, context)),
                    child: ListView.separated(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: controller.listComment.length,
                        separatorBuilder: (context, index) => SizedBox(height: UtilsReponsive.height(30, context)),
                        itemBuilder: (context, index) {
                          return comment(controller.listComment[index], context);
                        }),
                  )
                : GestureDetector(
                    onTap: () {
                      FocusScope.of(context).requestFocus(controller.focusNodeComment);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Image.asset(
                              ImageAssets.comments,
                              fit: BoxFit.contain,
                              width: UtilsReponsive.widthv2(context, 100),
                              height: UtilsReponsive.heightv2(context, 120),
                            ),
                            SizedBox(
                              height: UtilsReponsive.height(10, context),
                            ),
                            Text(
                              'Để lại bình luận đầu tiên',
                              style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w500, ColorsManager.primary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          )
        ],
      ),
    );
  }

  StatefulBuilder comment(CommentModel commentModel, BuildContext context) {
    bool isEditComment = false;
    TextEditingController commentTextController = TextEditingController(text: commentModel.text);
    List<PlatformFile> filePickerEditCommentFile = [];
    return StatefulBuilder(builder: (context, setStateX) {
      return SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                    radius: UtilsReponsive.height(20, context),
                    backgroundColor: Colors.transparent, // Đảm bảo nền trong suốt
                    child: commentModel.user!.profile!.avatar == null || commentModel.user!.profile!.avatar == ''
                        ? ClipOval(
                            child: Image.network(
                              "https://t4.ftcdn.net/jpg/03/49/49/79/360_F_349497933_Ly4im8BDmHLaLzgyKg2f2yZOvJjBtlw5.webp",
                              fit: BoxFit.cover,
                              width: UtilsReponsive.widthv2(context, 60),
                              height: UtilsReponsive.heightv2(context, 60),
                            ),
                          )
                        : ClipOval(
                            child: Image.network(
                              commentModel.user!.profile!.avatar!,
                              fit: BoxFit.cover,
                              width: UtilsReponsive.widthv2(context, 60),
                              height: UtilsReponsive.heightv2(context, 60),
                            ),
                          )),
                SizedBox(width: UtilsReponsive.width(10, context)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      commentModel.user!.profile!.fullName!,
                      style: TextStyle(
                          fontFamily: 'Nunito',
                          letterSpacing: 1.5,
                          color: ColorsManager.textColor,
                          fontSize: UtilsReponsive.height(17, context),
                          fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: UtilsReponsive.width(5, context)),
                    Text(
                      calculateTimeDifference(commentModel.createdAt.toString()),
                      style: TextStyle(
                          fontFamily: 'Nunito',
                          letterSpacing: 1,
                          color: ColorsManager.textColor,
                          fontSize: UtilsReponsive.height(14, context),
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: UtilsReponsive.height(10, context)),
            Obx(
              () => controller.isLoadingDeleteComment.value
                  ? SpinKitFadingCircle(
                      color: ColorsManager.primary,
                      // size: 50.0,
                    )
                  : commentModel.commentFiles!.isNotEmpty
                      ? Container(
                          margin: EdgeInsets.only(top: UtilsReponsive.height(8, context)),
                          height: UtilsReponsive.height(150, context),
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: commentModel.commentFiles!.length,
                            separatorBuilder: (context, index) => SizedBox(width: UtilsReponsive.width(15, context)),
                            itemBuilder: (context, index) {
                              return _filesComment(
                                commentModel.commentFiles![index],
                                context,
                                isEditComment,
                              );
                            },
                          ),
                        )
                      : const SizedBox(),
            ),
            filePickerEditCommentFile.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: UtilsReponsive.height(15, context),
                      ),
                      Text(
                        'Tệp đã thêm',
                        style: TextStyle(
                            fontFamily: 'Nunito',
                            letterSpacing: 1,
                            color: ColorsManager.textColor2,
                            fontSize: UtilsReponsive.height(14, context),
                            fontWeight: FontWeight.w500),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: UtilsReponsive.height(8, context)),
                        height: UtilsReponsive.height(150, context),
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: filePickerEditCommentFile.length,
                          separatorBuilder: (context, index) => SizedBox(width: UtilsReponsive.width(15, context)),
                          itemBuilder: (context, index) {
                            return editFileComment(
                                filePickerEditCommentFile[index], context, index, isEditComment, setStateX, filePickerEditCommentFile);
                          },
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
            SizedBox(height: UtilsReponsive.height(10, context)),
            isEditComment == true
                ? Container(
                    constraints: BoxConstraints(maxHeight: UtilsReponsive.height(300, context), minHeight: UtilsReponsive.height(100, context)),
                    child: FormFieldWidget(
                      setValueFunc: (value) {
                        commentTextController.text = value;
                      },
                      maxLine: 4,
                      initValue: commentModel.text,
                    ),
                  )
                : Text(
                    commentModel.text!,
                    style: TextStyle(
                        fontFamily: 'Nunito',
                        letterSpacing: 1,
                        color: ColorsManager.textColor,
                        fontSize: UtilsReponsive.height(18, context),
                        fontWeight: FontWeight.w500),
                  ),
            SizedBox(height: UtilsReponsive.width(10, context)),
            isEditComment == false
                ? Row(
                    children: [
                      InkWell(
                          onTap: () {
                            controller.isCheckEditComment.value = true;
                            setStateX(() {
                              isEditComment = true;
                            });
                          },
                          child: commentModel.user!.id == controller.idUser
                              ? Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Chỉnh sửa',
                                    style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w500, ColorsManager.primary),
                                  ))
                              : const SizedBox()),
                      SizedBox(
                        width: UtilsReponsive.width(10, context),
                      ),
                      commentModel.user!.id == controller.idUser
                          ? InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                          'Xác nhận xóa bình luận',
                                          style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w500, ColorsManager.primary),
                                        ),
                                        content: Text(
                                          'Bạn có chắc chắn muốn xóa bình luận này không?',
                                          style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w500, ColorsManager.textColor2),
                                        ),
                                        actions: [
                                          TextButton(
                                            child: Text(
                                              'Không',
                                              style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w500, ColorsManager.primary),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text(
                                              'Có',
                                              style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w500, ColorsManager.red),
                                            ),
                                            onPressed: () {
                                              controller.deleteComment(commentModel);
                                              setStateX(() {
                                                isEditComment = true;
                                              });
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Xóa',
                                    style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w500, ColorsManager.red),
                                  )))
                          : const SizedBox(),
                    ],
                  )
                : Row(
                    children: [
                      InkWell(
                          onTap: () async {
                            if (commentTextController.text == "") {
                              Get.snackbar(
                                'Thông báo',
                                'Bạn phải nhập ít nhất 1 kí tự',
                                snackPosition: SnackPosition.TOP,
                                margin: UtilsReponsive.paddingAll(Get.context!, padding: 10),
                                backgroundColor: ColorsManager.backgroundGrey,
                                colorText: ColorsManager.textColor2,
                                duration: const Duration(seconds: 4),
                              );
                            } else {
                              await controller.editComment(commentModel, commentTextController.text, commentModel.id!, filePickerEditCommentFile);
                              setStateX(() {
                                isEditComment = false;
                              });
                              controller.isCheckEditComment.value = false;
                            }
                          },
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Lưu',
                                style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w500, ColorsManager.primary),
                              ))),
                      SizedBox(
                        width: UtilsReponsive.width(10, context),
                      ),
                      InkWell(
                          onTap: () async {
                            await controller.cancel(commentModel.id!);
                            filePickerEditCommentFile.clear();
                            setStateX(() {
                              isEditComment = false;
                            });
                            controller.isCheckEditComment.value = false;
                          },
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Hủy',
                                style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w500, ColorsManager.red),
                              ))),
                      SizedBox(
                        width: UtilsReponsive.width(10, context),
                      ),
                      InkWell(
                          onTap: () async {
                            final result = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['jpg', 'pdf', 'doc', 'xlsx', 'docx', 'png', 'jpeg'],
                            );
                            if (result == null) {
                              return;
                            }

                            final file = result.files.first;
                            double fileLength = File(result.files[0].path!).lengthSync() / 1024 / 1024;
                            if (fileLength > 10) {
                              Get.snackbar('Lỗi', 'Không thể lấy tài liệu lớn hơn 10mb',
                                  snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);

                              return;
                            }
                            setStateX(() {
                              filePickerEditCommentFile.add(file);
                            });
                          },
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Thêm tệp',
                                style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w500, ColorsManager.textColor2),
                              ))),
                      SizedBox(
                        width: UtilsReponsive.width(10, context),
                      ),
                    ],
                  )
          ],
        ),
      );
    });
  }

  Obx _subTask(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          controller.isExpanded.value = !controller.isExpanded.value;
        },
        child: Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(UtilsReponsive.height(10, context))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: UtilsReponsive.height(15, context), right: UtilsReponsive.height(5, context)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Công việc',
                          style: TextStyle(
                              fontFamily: 'Nunito',
                              wordSpacing: 1.2,
                              color: Colors.black,
                              fontSize: UtilsReponsive.height(18, context),
                              fontWeight: FontWeight.w800),
                        ),
                        SizedBox(
                          width: UtilsReponsive.width(5, context),
                        ),
                        controller.taskModel.value.subTask!.where((element) => element.status != Status.CANCEL).isNotEmpty
                            ? CircleAvatar(
                                radius: UtilsReponsive.height(10, context),
                                child: Text(
                                  controller.taskModel.value.subTask!.where((element) => element.status != Status.CANCEL).length.toString(),
                                  style: TextStyle(
                                      letterSpacing: 1.5,
                                      color: ColorsManager.backgroundWhite,
                                      fontSize: UtilsReponsive.height(15, context),
                                      fontWeight: FontWeight.w800),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                    ExpandIcon(
                      isExpanded: controller.isExpanded.value,
                      size: 25,
                      color: controller.isExpanded.value ? ColorsManager.primary : ColorsManager.textColor2,
                      onPressed: (bool isExpanded) {
                        controller.isExpanded.value = !isExpanded;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: UtilsReponsive.height(10, context),
              ),
              Container(
                margin: EdgeInsets.only(left: UtilsReponsive.height(15, context), right: UtilsReponsive.height(15, context)),
                clipBehavior: Clip.hardEdge,
                height: UtilsReponsive.height(10, context),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ColorsManager.grey,
                  borderRadius: BorderRadius.circular(UtilsReponsive.height(5, context)),
                ),
                child: Row(
                  children: [
                    Container(
                      height: double.infinity,
                      width: MediaQuery.of(context).size.width * controller.progressSubTaskDone.value,
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: UtilsReponsive.height(10, context),
              ),
              if (controller.isExpanded.value)
                Padding(
                  padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: UtilsReponsive.height(10, context),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Thêm công việc con',
                                        style: GetTextStyle.getTextStyle(18, 'Nunito', FontWeight.w500, ColorsManager.primary)),
                                    content: TextField(
                                      onChanged: (value) => {controller.titleSubTaskController.text = value},
                                      controller: controller.titleSubTaskController,
                                    ),
                                    actions: [
                                      TextButton(
                                        child:
                                            Text('Hủy', style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w500, ColorsManager.textColor2)),
                                        onPressed: () {
                                          controller.titleSubTaskController.text = '';
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Lưu', style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w500, ColorsManager.primary)),
                                        onPressed: () {
                                          controller.createSubTask();
                                          controller.errorUpdateTask.value == true ? _errorMessage(context) : _successMessage(context);
                                          Navigator.of(context).pop();
                                          controller.titleSubTaskController.text = '';
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text(
                              '+  Thêm công việc con',
                              style: GetTextStyle.getTextStyle(15, 'Nunito', FontWeight.w500, ColorsManager.primary),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: UtilsReponsive.height(10, context),
                      ),
                      controller.taskModel.value.subTask!.where((element) => element.status != Status.CANCEL).isEmpty
                          ? const SizedBox()
                          : Column(
                              children: controller.taskModel.value.subTask!
                                  .where((element) => element.status != Status.CANCEL)
                                  .map((e) => GestureDetector(
                                        onTap: () {
                                          Get.toNamed(Routes.SUBTASK_DETAIL_VIEW, arguments: {
                                            "taskID": e.id,
                                            "isNavigateDetail": true,
                                            "isScheduleOverall": false,
                                          });
                                        },
                                        child: Card(
                                          child: Container(
                                            padding: EdgeInsets.only(
                                              top: UtilsReponsive.height(5, context),
                                              bottom: UtilsReponsive.height(5, context),
                                              left: UtilsReponsive.height(5, context),
                                              right: UtilsReponsive.height(5, context),
                                            ),
                                            width: double.infinity,
                                            height: UtilsReponsive.height(60, context),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    flex: 6,
                                                    child: e.status == Status.DONE || e.status == Status.CONFIRM
                                                        ? Text(
                                                            e.title!.length > 20 ? '${e.title!.substring(0, 10)}...' : e.title!,
                                                            style: TextStyle(
                                                              fontFamily: 'Nunito',
                                                              letterSpacing: 1.5,
                                                              color: ColorsManager.textColor,
                                                              fontSize: UtilsReponsive.height(16, context),
                                                              fontWeight: FontWeight.w800,
                                                              decoration: TextDecoration.lineThrough,
                                                            ),
                                                          )
                                                        : Text(
                                                            e.title!.length > 20 ? '${e.title!.substring(0, 10)}...' : e.title!,
                                                            style: TextStyle(
                                                                fontFamily: 'Nunito',
                                                                letterSpacing: 1.5,
                                                                color: ColorsManager.textColor,
                                                                fontSize: UtilsReponsive.height(16, context),
                                                                fontWeight: FontWeight.w800),
                                                          )),
                                                SizedBox(
                                                  width: UtilsReponsive.width(10, context),
                                                ),
                                                Expanded(
                                                  flex: 5,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      _showBottomSheetStatusSubtask(context, e.id!);
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(horizontal: UtilsReponsive.height(5, context)),
                                                      height: UtilsReponsive.height(40, context),
                                                      decoration: BoxDecoration(
                                                        color: e.status == Status.PENDING
                                                            ? ColorsManager.grey
                                                            : e.status == Status.PROCESSING
                                                                ? ColorsManager.blue
                                                                : e.status == Status.DONE
                                                                    ? ColorsManager.green
                                                                    : e.status == Status.CONFIRM
                                                                        ? Colors.purpleAccent
                                                                        : ColorsManager.red,
                                                        borderRadius: BorderRadius.circular(UtilsReponsive.height(5, context)),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Expanded(
                                                            flex: 3,
                                                            child: Text(
                                                              e.status == Status.PENDING
                                                                  ? "Đang chuẩn bị"
                                                                  : e.status == Status.PROCESSING
                                                                      ? "Đang thực hiện"
                                                                      : e.status == Status.DONE
                                                                          ? "Hoàn thành"
                                                                          : e.status == Status.CONFIRM
                                                                              ? "Đã xác thực"
                                                                              : "Quá hạn",
                                                              style: TextStyle(
                                                                  fontFamily: 'Nunito',
                                                                  letterSpacing: 1.5,
                                                                  color: Colors.white,
                                                                  fontSize: UtilsReponsive.height(14, context),
                                                                  fontWeight: FontWeight.w800),
                                                            ),
                                                          ),
                                                          const Expanded(
                                                            child: Icon(
                                                              Icons.arrow_drop_down_rounded,
                                                              color: Colors.white,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Obx _documentV2(BuildContext context) {
    return Obx(
      () => Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(UtilsReponsive.height(10, context))),
          child: Theme(
            data: ThemeData().copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Row(
                children: [
                  Text('Tài liệu',
                      style: TextStyle(
                          fontFamily: 'Nunito',
                          wordSpacing: 1.2,
                          color: Colors.black,
                          fontSize: UtilsReponsive.height(18, context),
                          fontWeight: FontWeight.w800)),
                  SizedBox(
                    width: UtilsReponsive.width(5, context),
                  ),
                  controller.listAttachment.isNotEmpty
                      ? CircleAvatar(
                          radius: controller.listAttachment.length >= 100
                              ? 15
                              : controller.listAttachment.length >= 10
                                  ? 15
                                  : 10,
                          child: Text(
                            controller.listAttachment.length.toString(),
                            style: TextStyle(
                                letterSpacing: 1.5,
                                color: ColorsManager.backgroundWhite,
                                fontSize: UtilsReponsive.height(15, context),
                                fontWeight: FontWeight.w800),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
              children: [
                controller.listAttachment.isEmpty
                    ? const SizedBox()
                    : Container(
                        padding: EdgeInsets.only(
                            left: UtilsReponsive.height(15, context),
                            right: UtilsReponsive.height(15, context),
                            bottom: UtilsReponsive.height(10, context)),
                        height: UtilsReponsive.height(120, context),
                        child: ListView.separated(
                          primary: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.listAttachment.length,
                          separatorBuilder: (context, index) => SizedBox(width: UtilsReponsive.width(10, context)),
                          itemBuilder: (context, index) {
                            return _files(controller.listAttachment[index], context);
                          },
                        ),
                      ),
              ],
            ),
          )),
    );
  }

  void _showOptionsFileCommentPopup(BuildContext context, CommentFile commentFile) {
    BuildContext popupContext = context;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Tùy chọn",
            style: TextStyle(fontFamily: 'Nunito', fontSize: 18, fontWeight: FontWeight.w600, color: ColorsManager.textColor2),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  'Xóa',
                  style: TextStyle(fontFamily: 'Nunito', fontSize: 17, fontWeight: FontWeight.w500, color: ColorsManager.red),
                ),
                onTap: () {
                  _showDeleteFileCommentConfirmation(context, commentFile, popupContext);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteFileCommentConfirmation(BuildContext context, CommentFile commentFile, BuildContext popupContext) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Xóa tệp này?",
            style: TextStyle(fontFamily: 'Nunito', fontSize: 20, fontWeight: FontWeight.w600, color: ColorsManager.textColor2),
          ),
          content: const Text(
            "Một khi nó đã mất, thì nó đã mất.",
            style: TextStyle(fontFamily: 'Nunito', fontSize: 15, fontWeight: FontWeight.w600, color: ColorsManager.textColor2),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text(
                "Hủy",
                style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w600, color: ColorsManager.primary),
              ),
            ),
            TextButton(
              onPressed: () {
                controller.deleteCommentFile(commentFile);
                Navigator.of(context).pop();
                Navigator.of(popupContext).pop();
              },
              child: Text(
                "Xóa",
                style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w600, color: ColorsManager.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showOptionsAttachmentCommentPopup(BuildContext context, int index) {
    BuildContext popupContext = context;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Tùy chọn",
            style: TextStyle(fontFamily: 'Nunito', fontSize: 18, fontWeight: FontWeight.w600, color: ColorsManager.textColor2),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  'Xóa',
                  style: TextStyle(fontFamily: 'Nunito', fontSize: 17, fontWeight: FontWeight.w500, color: ColorsManager.red),
                ),
                onTap: () {
                  _showDeleteAttachmentCommentConfirmation(context, index, popupContext);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showOptionsAttachmentCommentPopupV2(BuildContext context, int index, setStateX, List<PlatformFile> filePickerEditCommentFile) {
    BuildContext popupContext = context;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Tùy chọn",
            style: TextStyle(fontFamily: 'Nunito', fontSize: 18, fontWeight: FontWeight.w600, color: ColorsManager.textColor2),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  'Xóa',
                  style: TextStyle(fontFamily: 'Nunito', fontSize: 17, fontWeight: FontWeight.w500, color: ColorsManager.red),
                ),
                onTap: () {
                  _showDeleteAttachmentCommentConfirmationV2(context, index, popupContext, setStateX, filePickerEditCommentFile);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteAttachmentCommentConfirmation(BuildContext context, int index, BuildContext popupContext) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Xóa tệp này?",
            style: TextStyle(fontFamily: 'Nunito', fontSize: 20, fontWeight: FontWeight.w600, color: ColorsManager.textColor2),
          ),
          content: const Text(
            "Một khi nó đã mất, thì nó đã mất.",
            style: TextStyle(fontFamily: 'Nunito', fontSize: 15, fontWeight: FontWeight.w600, color: ColorsManager.textColor2),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text(
                "Hủy",
                style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w600, color: ColorsManager.primary),
              ),
            ),
            TextButton(
              onPressed: () {
                controller.deleteAttachmentCommentFile(index);
                Navigator.of(context).pop();
                Navigator.of(popupContext).pop();
              },
              child: Text(
                "Xóa",
                style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w600, color: ColorsManager.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAttachmentCommentConfirmationV2(
      BuildContext context, int index, BuildContext popupContext, setStateX, List<PlatformFile> filePickerEditCommentFile) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Xóa tệp này?",
            style: TextStyle(fontFamily: 'Nunito', fontSize: 20, fontWeight: FontWeight.w600, color: ColorsManager.textColor2),
          ),
          content: const Text(
            "Một khi nó đã mất, thì nó đã mất.",
            style: TextStyle(fontFamily: 'Nunito', fontSize: 15, fontWeight: FontWeight.w600, color: ColorsManager.textColor2),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text(
                "Hủy",
                style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w600, color: ColorsManager.primary),
              ),
            ),
            TextButton(
              onPressed: () {
                setStateX(() => {filePickerEditCommentFile.removeAt(index)});
                Navigator.of(context).pop();
                Navigator.of(popupContext).pop();
              },
              child: Text(
                "Xóa",
                style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w600, color: ColorsManager.red),
              ),
            ),
          ],
        );
      },
    );
  }

  InkWell attchFileComment(PlatformFile attachCommentFile, BuildContext context, int index) {
    final fileName = attachCommentFile.path!.split('/').last;
    final kb = attachCommentFile.size / 1024;
    final mb = kb / 1024;
    final fileSize = mb >= 1 ? '${mb.toStringAsFixed(2)} MB' : '${kb.toStringAsFixed(2)} KB';
    final extension = attachCommentFile.extension;
    return InkWell(
      onTap: () {
        controller.openFile(attachCommentFile);
      },
      onLongPress: () {
        _showOptionsAttachmentCommentPopup(context, index);
      },
      child: extension == 'jpg' || extension == 'png' || extension == 'jpeg'
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorsManager.backgroundGrey,
              ),
              width: UtilsReponsive.width(120, context),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File(attachCommentFile.path!),
                  fit: BoxFit.cover,
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorsManager.backgroundGrey,
              ),
              width: UtilsReponsive.width(125, context),
              padding: UtilsReponsive.paddingOnly(context, top: 10, left: 10, bottom: 5, right: 10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                  flex: 4,
                  child: fileName.length > 35
                      ? Text(
                          fileName.length > 35 ? '${fileName.substring(0, 35)}...' : fileName,
                          style: const TextStyle(fontFamily: 'Nunito', fontSize: 12, fontWeight: FontWeight.w500, color: ColorsManager.textColor),
                        )
                      : Text(
                          fileName,
                          style: const TextStyle(fontFamily: 'Nunito', fontSize: 12, fontWeight: FontWeight.w500, color: ColorsManager.textColor),
                        ),
                ),
                Expanded(
                    child: Text(
                  fileSize,
                  style: const TextStyle(fontFamily: 'Nunito', fontSize: 12, fontWeight: FontWeight.w500, color: ColorsManager.textColor2),
                )),
              ]),
            ),
    );
  }

  InkWell editFileComment(
      PlatformFile attachCommentFile, BuildContext context, int index, bool isEditComment, setStateX, List<PlatformFile> filePickerEditCommentFile) {
    final fileName = attachCommentFile.path!.split('/').last;
    final kb = attachCommentFile.size / 1024;
    final mb = kb / 1024;
    final fileSize = mb >= 1 ? '${mb.toStringAsFixed(2)} MB' : '${kb.toStringAsFixed(2)} KB';
    final extension = attachCommentFile.extension;
    return InkWell(
      onTap: () {
        controller.openFile(attachCommentFile);
      },
      onLongPress: () {
        if (isEditComment) {
          _showOptionsAttachmentCommentPopupV2(context, index, setStateX, filePickerEditCommentFile);
        }
      },
      child: extension == 'jpg' || extension == 'png' || extension == 'jpeg'
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorsManager.backgroundGrey,
              ),
              width: UtilsReponsive.width(120, context),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File(attachCommentFile.path!),
                  fit: BoxFit.cover,
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorsManager.backgroundGrey,
              ),
              width: UtilsReponsive.width(125, context),
              padding: UtilsReponsive.paddingOnly(context, top: 10, left: 10, bottom: 5, right: 10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                  flex: 4,
                  child: fileName.length > 35
                      ? Text(
                          fileName.length > 35 ? '${fileName.substring(0, 35)}...' : fileName,
                          style: const TextStyle(fontFamily: 'Nunito', fontSize: 12, fontWeight: FontWeight.w500, color: ColorsManager.textColor),
                        )
                      : Text(
                          fileName,
                          style: const TextStyle(fontFamily: 'Nunito', fontSize: 12, fontWeight: FontWeight.w500, color: ColorsManager.textColor),
                        ),
                ),
                Expanded(
                    child: Text(
                  fileSize,
                  style: const TextStyle(fontFamily: 'Nunito', fontSize: 12, fontWeight: FontWeight.w500, color: ColorsManager.textColor2),
                )),
              ]),
            ),
    );
  }

  InkWell _filesComment(CommentFile commentFile, BuildContext context, bool isEditComment) {
    return InkWell(
      onTap: () async {
        final url = Uri.parse(commentFile.fileUrl!);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      },
      onLongPress: () {
        if (isEditComment) {
          _showOptionsFileCommentPopup(context, commentFile);
        }
      },
      child: CachedNetworkImage(
        imageUrl: commentFile.fileUrl!,
        imageBuilder: (context, imageProvider) => Container(
            width: UtilsReponsive.width(110, context),
            padding: UtilsReponsive.paddingAll(context, padding: 5),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(fit: BoxFit.cover, image: imageProvider))),
        progressIndicatorBuilder: (context, url, downloadProgress) => Container(
          padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
          height: UtilsReponsive.height(5, context),
          width: UtilsReponsive.height(5, context),
          child: CircularProgressIndicator(
            color: ColorsManager.primary,
          ),
        ),
        errorWidget: (context, url, error) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ColorsManager.backgroundGrey,
          ),
          width: UtilsReponsive.width(120, context),
          padding: UtilsReponsive.paddingOnly(context, top: 10, left: 10, bottom: 5, right: 10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: commentFile.fileName!.length > 35
                  ? Text(
                      commentFile.fileName!.length > 35 ? '${commentFile.fileName!.substring(0, 35)}...' : commentFile.fileName!,
                      style: const TextStyle(fontFamily: 'Nunito', fontSize: 14, fontWeight: FontWeight.w500, color: ColorsManager.textColor),
                    )
                  : Text(
                      commentFile.fileName!,
                      style: const TextStyle(fontFamily: 'Nunito', fontSize: 14, fontWeight: FontWeight.w500, color: ColorsManager.textColor),
                    ),
            ),
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Kích thước',
                    style: TextStyle(fontFamily: 'Nunito', fontSize: 14, fontWeight: FontWeight.w500, color: ColorsManager.textColor2),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  InkWell _files(AttachmentModel attachmentModel, BuildContext context) {
    return InkWell(
      onTap: () async {
        final url = Uri.parse(attachmentModel.fileUrl!);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      },
      child: CachedNetworkImage(
        imageUrl: attachmentModel.fileUrl!,
        imageBuilder: (context, imageProvider) => Container(
            width: UtilsReponsive.width(110, context),
            padding: UtilsReponsive.paddingAll(context, padding: 5),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(fit: BoxFit.cover, image: imageProvider))),
        progressIndicatorBuilder: (context, url, downloadProgress) => Container(
          padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
          height: UtilsReponsive.height(5, context),
          width: UtilsReponsive.height(5, context),
          child: CircularProgressIndicator(
            color: ColorsManager.primary,
          ),
        ),
        errorWidget: (context, url, error) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ColorsManager.backgroundGrey,
          ),
          width: UtilsReponsive.width(110, context),
          padding: UtilsReponsive.paddingOnly(context, top: 10, left: 10, bottom: 5, right: 10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              flex: 2,
              child: attachmentModel.fileName!.length > 35
                  ? Text(
                      attachmentModel.fileName!.length > 35 ? '${attachmentModel.fileName!.substring(0, 35)}...' : attachmentModel.fileName!,
                      style: const TextStyle(fontFamily: 'Nunito', fontSize: 11, fontWeight: FontWeight.w500, color: ColorsManager.textColor),
                    )
                  : Text(
                      attachmentModel.fileName!,
                      style: const TextStyle(fontFamily: 'Nunito', fontSize: 11, fontWeight: FontWeight.w500, color: ColorsManager.textColor),
                    ),
            ),
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Kích thước',
                    style: TextStyle(fontFamily: 'Nunito', fontSize: 14, fontWeight: FontWeight.w500, color: ColorsManager.textColor2),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Quil.QuillProvider _description(BuildContext context) {
    return Quil.QuillProvider(
      configurations: Quil.QuillConfigurations(controller: controller.quillController.value),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            UtilsReponsive.height(10, context),
          ),
        ),
        child: Theme(
          data: ThemeData().copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(
              'Mô tả',
              style: TextStyle(
                  fontFamily: 'Nunito',
                  wordSpacing: 1.2,
                  color: ColorsManager.textColor,
                  fontSize: UtilsReponsive.height(18, context),
                  fontWeight: FontWeight.w800),
            ),
            children: [
              controller.taskModel.value.description != null &&
                      controller.taskModel.value.description != '' &&
                      controller.taskModel.value.description!.trim() != '[{\"insert\":\"\\n\"}]'
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: UtilsReponsive.height(20, context)),
                      child: IgnorePointer(
                        ignoring: true,
                        child: Quil.QuillEditor.basic(
                          // controller: controller,
                          configurations: const Quil.QuillEditorConfigurations(autoFocus: false, readOnly: false),

                          // embedBuilders: FlutterQuillEmbeds.builders(),
                        ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: UtilsReponsive.height(20, context)),
                      child: Row(
                        children: [
                          Text(
                            'Thêm mô tả...',
                            style: GetTextStyle.getTextStyle(15, 'Nunito', FontWeight.w500, ColorsManager.textColor2),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
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
                const Spacer(),
                Text(
                  'Thay đổi thông tin công việc thành công',
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
                      controller.errorUpdateTaskText.value,
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
