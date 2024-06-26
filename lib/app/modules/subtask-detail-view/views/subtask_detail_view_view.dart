import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_quill/flutter_quill.dart' as Quil;
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
import '../controllers/subtask_detail_view_controller.dart';

class SubtaskDetailViewView extends BaseView<SubtaskDetailViewController> {
  const SubtaskDetailViewView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Obx(
      () => Scaffold(
          backgroundColor: Colors.white,
          appBar: _appBar(context),
          body: Obx(
            () => controller.isLoading.value
                ? Center(
                    child: SpinKitFadingCircle(
                      color: ColorsManager.primary,
                    ),
                  )
                : controller.taskModel.value.status == null || controller.checkView.value == false
                    ? SafeArea(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: RefreshIndicator(
                                  onRefresh: controller.refreshPage,
                                  child: ListView(
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: UtilsReponsive.height(100, context),
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
                                            'Đang có lỗi xảy ra',
                                            style: GetTextStyle.getTextStyle(20, 'Nunito', FontWeight.w800, ColorsManager.primary),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        height: double.infinity,
                        color: ColorsManager.backgroundContainer,
                        child: Stack(
                          children: [
                            RefreshIndicator(
                              onRefresh: controller.refreshPage,
                              child: SingleChildScrollView(
                                padding: EdgeInsets.all(UtilsReponsive.height(15, context)),
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
                                      () => Row(
                                        children: [
                                          Text(
                                            'Độ ưu tiên',
                                            style: TextStyle(
                                              fontFamily: 'Nunito',
                                              color: ColorsManager.textColor2,
                                              fontSize: UtilsReponsive.height(18, context),
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          controller.taskModel.value.priority == null
                                              ? priorityBuilder(context: context, objectStatusTask: "--", taskID: controller.taskModel.value.id!)
                                              : priorityBuilder(
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
                                      height: UtilsReponsive.height(15, context),
                                    ),

                                    Row(
                                      children: [
                                        Text(
                                          'Trạng thái',
                                          style: TextStyle(
                                            fontFamily: 'Nunito',
                                            color: ColorsManager.textColor2,
                                            fontSize: UtilsReponsive.height(18, context),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        _statusBuilder(
                                          taskID: controller.taskModel.value.id,
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
                                        ),
                                      ],
                                    ),

                                    SizedBox(
                                      height: UtilsReponsive.height(15, context),
                                    ),
                                    Obx(
                                      () => Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: UtilsReponsive.height(5, context), vertical: UtilsReponsive.height(10, context)),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Colors.white,
                                        ),
                                        child: controller.taskModel.value.endDate != null
                                            ? _timeBuilder(
                                                context: context,
                                                startTime: controller.dateFormat.format(controller.taskModel.value.startDate!.toLocal()),
                                                endTime: controller.dateFormat.format(controller.taskModel.value.endDate!.toLocal()))
                                            : Row(children: [
                                                Icon(size: 25, Icons.calendar_month, color: Colors.grey.withOpacity(0.8)),
                                                SizedBox(
                                                  width: UtilsReponsive.width(15, context),
                                                ),
                                                Text(
                                                  'Hạn hoàn thành',
                                                  style: TextStyle(
                                                      fontFamily: 'Nunito',
                                                      color: Colors.grey.withOpacity(0.8),
                                                      fontSize: UtilsReponsive.height(16, context),
                                                      fontWeight: FontWeight.w800),
                                                ),
                                              ]),
                                      ),
                                    ),
                                    SizedBox(
                                      height: UtilsReponsive.width(10, context),
                                    ),
                                    // Obx(
                                    //   () => Container(
                                    //     padding: EdgeInsets.symmetric(
                                    //       horizontal: UtilsReponsive.height(10, context),
                                    //     ),
                                    //     decoration: BoxDecoration(
                                    //       borderRadius: BorderRadius.circular(8),
                                    //       color: Colors.white,
                                    //     ),
                                    //     child: Row(
                                    //       children: [
                                    //         Row(children: [
                                    //           Text('Ước tính (giờ):',
                                    //               style: GetTextStyle.getTextStyle(12, 'Nunito', FontWeight.w800, ColorsManager.textColor)),
                                    //           SizedBox(
                                    //             width: UtilsReponsive.width(5, context),
                                    //           ),
                                    //           TextButton(
                                    //             style: TextButton.styleFrom(
                                    //                 backgroundColor: ColorsManager.backgroundContainer,
                                    //                 side: const BorderSide(color: ColorsManager.backgroundGrey, width: 1)),
                                    //             onPressed: () {},
                                    //             child: Text(controller.est.toString(),
                                    //                 style: GetTextStyle.getTextStyle(12, 'Nunito', FontWeight.w700, ColorsManager.primary)),
                                    //           )
                                    //         ]),
                                    //         SizedBox(
                                    //           width: UtilsReponsive.width(10, context),
                                    //         ),
                                    //         controller.taskModel.value.assignTasks![0].user!.profile!.profileId == controller.idUser
                                    //             ? Row(
                                    //                 children: [
                                    //                   Text('Công sức (giờ):',
                                    //                       style: GetTextStyle.getTextStyle(12, 'Nunito', FontWeight.w800, ColorsManager.textColor)),
                                    //                   SizedBox(
                                    //                     width: UtilsReponsive.width(5, context),
                                    //                   ),
                                    //                   TextButton(
                                    //                       style: TextButton.styleFrom(
                                    //                         backgroundColor: ColorsManager.backgroundContainer,
                                    //                         side: BorderSide(color: ColorsManager.primary, width: 1),
                                    //                       ),
                                    //                       onPressed: () {
                                    //                         showDialog(
                                    //                             context: context,
                                    //                             builder: (BuildContext context) {
                                    //                               return AlertDialog(
                                    //                                 title: Text('Nhập con số thời gian công sức',
                                    //                                     style: GetTextStyle.getTextStyle(
                                    //                                         18, 'Nunito', FontWeight.w700, ColorsManager.primary)),
                                    //                                 content: TextField(
                                    //                                   keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    //                                   inputFormatters: <TextInputFormatter>[
                                    //                                     FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                                    //                                   ],
                                    //                                   onChanged: (value) => {controller.effortController.text = value},
                                    //                                   controller: controller.effortController,
                                    //                                 ),
                                    //                                 actions: [
                                    //                                   TextButton(
                                    //                                     child: Text('Hủy',
                                    //                                         style: GetTextStyle.getTextStyle(
                                    //                                             16, 'Nunito', FontWeight.w700, ColorsManager.textColor2)),
                                    //                                     onPressed: () {
                                    //                                       Navigator.of(context).pop();
                                    //                                     },
                                    //                                   ),
                                    //                                   TextButton(
                                    //                                     child: Text('Lưu',
                                    //                                         style: GetTextStyle.getTextStyle(
                                    //                                             16, 'Nunito', FontWeight.w700, ColorsManager.primary)),
                                    //                                     onPressed: () async {
                                    //                                       if (controller.effortController.text.isEmpty) {
                                    //                                         Get.snackbar('Lỗi', 'Không được để trống thời gian công sức',
                                    //                                             snackPosition: SnackPosition.TOP,
                                    //                                             backgroundColor: Colors.transparent,
                                    //                                             colorText: ColorsManager.textColor);
                                    //                                       } else {
                                    //                                         await controller.updateEffort(controller.taskModel.value.id!,
                                    //                                             double.parse(controller.effortController.text));

                                    //                                         Navigator.of(Get.context!).pop();
                                    //                                       }
                                    //                                     },
                                    //                                   ),
                                    //                                 ],
                                    //                               );
                                    //                             });
                                    //                       },
                                    //                       child: Text(controller.effort.toString(),
                                    //                           style: GetTextStyle.getTextStyle(12, 'Nunito', FontWeight.w700, ColorsManager.primary))),
                                    //                 ],
                                    //               )
                                    //             : Row(
                                    //                 children: [
                                    //                   Text('Công sức (giờ):',
                                    //                       style: GetTextStyle.getTextStyle(12, 'Nunito', FontWeight.w800, ColorsManager.textColor)),
                                    //                   SizedBox(
                                    //                     width: UtilsReponsive.width(5, context),
                                    //                   ),
                                    //                   TextButton(
                                    //                       style: TextButton.styleFrom(
                                    //                           backgroundColor: ColorsManager.backgroundContainer,
                                    //                           side: const BorderSide(color: ColorsManager.backgroundGrey, width: 1)),
                                    //                       onPressed: () {},
                                    //                       child: Text(controller.effort.toString(),
                                    //                           style: GetTextStyle.getTextStyle(12, 'Nunito', FontWeight.w700, ColorsManager.primary))),
                                    //                 ],
                                    //               ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // ),
                                    // SizedBox(
                                    //   height: UtilsReponsive.width(10, context),
                                    // ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: UtilsReponsive.height(5, context), vertical: UtilsReponsive.height(10, context)),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.white,
                                      ),
                                      child:
                                          // Thiệp
                                          Row(
                                        children: [
                                          CachedNetworkImage(
                                            // fit: BoxFit.contain,
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
                                                getTheAbbreviation(controller.taskModel.value.parent!.assignTasks![0].user!.profile!.fullName!),
                                                style: TextStyle(
                                                    letterSpacing: 1,
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
                                                controller.taskModel.value.parent!.assignTasks![0].user!.profile!.fullName!.length > 20
                                                    ? '${controller.taskModel.value.parent!.assignTasks![0].user!.profile!.fullName!.substring(0, 20)}...'
                                                    : controller.taskModel.value.parent!.assignTasks![0].user!.profile!.fullName!,
                                                overflow: TextOverflow.clip,
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
                                                    fontWeight: FontWeight.w700),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    // ),
                                    SizedBox(
                                      height: UtilsReponsive.width(10, context),
                                    ),
                                    Obx(() => controller.taskModel.value.assignTasks!.isEmpty
                                        ? Column(
                                            children: [
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
                                                        Container(
                                                          width: UtilsReponsive.width(40, context),
                                                          height: UtilsReponsive.height(45, context),
                                                          decoration: const BoxDecoration(
                                                            boxShadow: [
                                                              BoxShadow(
                                                                blurRadius: 0.5,
                                                              )
                                                            ],
                                                            shape: BoxShape.circle,
                                                          ),
                                                          clipBehavior: Clip.antiAlias, // Đây là dòng quan trọng
                                                          child: Image.asset(ImageAssets.noUser, fit: BoxFit.fill),
                                                        ),
                                                        SizedBox(
                                                          width: UtilsReponsive.width(10, context),
                                                        ),
                                                        Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                'Người chịu trách nhiệm',
                                                                style: TextStyle(
                                                                    fontFamily: 'Nunito',
                                                                    color: ColorsManager.primary,
                                                                    fontSize: UtilsReponsive.height(16, context),
                                                                    fontWeight: FontWeight.w700),
                                                              ),
                                                            ])
                                                      ],
                                                    )
                                                  ],
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
                                                child: GestureDetector(
                                                  onTap: () async {},
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: UtilsReponsive.width(40, context),
                                                            height: UtilsReponsive.height(45, context),
                                                            decoration: const BoxDecoration(
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  blurRadius: 0.5,
                                                                )
                                                              ],
                                                              shape: BoxShape.circle,
                                                            ),
                                                            clipBehavior: Clip.antiAlias, // Đây là dòng quan trọng
                                                            child: Image.asset(ImageAssets.noUser, fit: BoxFit.fill),
                                                          ),
                                                          SizedBox(
                                                            width: UtilsReponsive.width(10, context),
                                                          ),
                                                          Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  'Những người tham gia khác',
                                                                  style: TextStyle(
                                                                      fontFamily: 'Nunito',
                                                                      color: ColorsManager.primary,
                                                                      fontSize: UtilsReponsive.height(16, context),
                                                                      fontWeight: FontWeight.w700),
                                                                ),
                                                              ])
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                        : controller.taskModel.value.assignTasks!.length > 1
                                            ? Column(
                                                children: [
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
                                                              // fit: BoxFit.contain,
                                                              imageUrl: controller.taskModel.value.assignTasks![0].user!.profile!.avatar!,
                                                              imageBuilder: (context, imageProvider) => Container(
                                                                  width: UtilsReponsive.width(40, context),
                                                                  height: UtilsReponsive.height(45, context),
                                                                  decoration: BoxDecoration(
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          spreadRadius: 0.5,
                                                                          blurRadius: 0.5,
                                                                          color: Colors.black.withOpacity(0.1),
                                                                        )
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
                                                              errorWidget: (context, url, error) => CircleAvatar(
                                                                radius: UtilsReponsive.height(20, context),
                                                                child: Text(
                                                                  getTheAbbreviation(
                                                                      controller.taskModel.value.assignTasks![0].user!.profile!.fullName!),
                                                                  style: TextStyle(
                                                                      letterSpacing: 1,
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
                                                                      fontSize: UtilsReponsive.height(17, context),
                                                                      fontWeight: FontWeight.w800),
                                                                ),
                                                                Text(
                                                                  'Người chịu trách nhiệm',
                                                                  style: TextStyle(
                                                                      fontFamily: 'Nunito',
                                                                      color: ColorsManager.primary,
                                                                      fontSize: UtilsReponsive.height(16, context),
                                                                      fontWeight: FontWeight.w700),
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
                                                        GestureDetector(
                                                          onTap: () async {
                                                            await controller.getEmployeeSupportView();
                                                            _showBottomAssign(context: Get.context!);
                                                          },
                                                          child: Row(
                                                            children: [
                                                              controller.taskModel.value.assignTasks!.length == 1
                                                                  ? Container(
                                                                      width: UtilsReponsive.width(40, context),
                                                                      height: UtilsReponsive.height(45, context),
                                                                      decoration: const BoxDecoration(
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                            blurRadius: 0.5,
                                                                          )
                                                                        ],
                                                                        shape: BoxShape.circle,
                                                                      ),
                                                                      clipBehavior: Clip.antiAlias, // Đây là dòng quan trọng
                                                                      child: Image.asset(ImageAssets.noUser, fit: BoxFit.fill),
                                                                    )
                                                                  : CachedNetworkImage(
                                                                      // fit: BoxFit.contain,
                                                                      imageUrl: controller.taskModel.value.assignTasks![1].user!.profile!.avatar!,
                                                                      imageBuilder: (context, imageProvider) => Container(
                                                                          width: UtilsReponsive.width(40, context),
                                                                          height: UtilsReponsive.height(45, context),
                                                                          decoration: BoxDecoration(
                                                                              boxShadow: [
                                                                                BoxShadow(
                                                                                  spreadRadius: 0.5,
                                                                                  blurRadius: 0.5,
                                                                                  color: Colors.black.withOpacity(0.1),
                                                                                )
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
                                                                      errorWidget: (context, url, error) => CircleAvatar(
                                                                        radius: UtilsReponsive.height(20, context),
                                                                        child: Text(
                                                                          getTheAbbreviation(
                                                                              controller.taskModel.value.assignTasks![1].user!.profile!.fullName!),
                                                                          style: TextStyle(
                                                                              letterSpacing: 1,
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
                                                                  controller.taskModel.value.assignTasks!.length == 1
                                                                      ? SizedBox()
                                                                      : Text(
                                                                          controller.taskModel.value.assignTasks![1].user!.profile!.fullName!,
                                                                          style: TextStyle(
                                                                              fontFamily: 'Nunito',
                                                                              color: ColorsManager.textColor,
                                                                              fontSize: UtilsReponsive.height(17, context),
                                                                              fontWeight: FontWeight.w800),
                                                                        ),
                                                                  controller.taskModel.value.assignTasks!.length >= 3
                                                                      ? Text(
                                                                          "${controller.taskModel.value.assignTasks![1].user!.profile!.fullName!.split(' ').last} và ${controller.taskModel.value.assignTasks!.length - 2} thành viên khác",
                                                                          style: TextStyle(
                                                                              fontFamily: 'Nunito',
                                                                              color: ColorsManager.primary,
                                                                              fontSize: UtilsReponsive.height(16, context),
                                                                              fontWeight: FontWeight.w700),
                                                                        )
                                                                      : Text(
                                                                          'Người tham gia',
                                                                          style: TextStyle(
                                                                              fontFamily: 'Nunito',
                                                                              color: ColorsManager.primary,
                                                                              fontSize: UtilsReponsive.height(16, context),
                                                                              fontWeight: FontWeight.w700),
                                                                        ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : Column(
                                                children: [
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
                                                        GestureDetector(
                                                          onTap: () {
                                                            // await controller.getAllEmployee();
                                                            // controller.listEmployeeChoose
                                                            //     .value = [];
                                                            // _showBottomLeader(context: Get.context!);
                                                          },
                                                          child: Row(
                                                            children: [
                                                              CachedNetworkImage(
                                                                // fit: BoxFit.contain,
                                                                imageUrl: controller.taskModel.value.assignTasks![0].user!.profile!.avatar!,
                                                                imageBuilder: (context, imageProvider) => Container(
                                                                    width: UtilsReponsive.width(40, context),
                                                                    height: UtilsReponsive.height(45, context),
                                                                    decoration: BoxDecoration(
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                            spreadRadius: 0.5,
                                                                            blurRadius: 0.5,
                                                                            color: Colors.black.withOpacity(0.1),
                                                                          )
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
                                                                errorWidget: (context, url, error) => CircleAvatar(
                                                                  radius: UtilsReponsive.height(20, context),
                                                                  child: Text(
                                                                    getTheAbbreviation(
                                                                        controller.taskModel.value.assignTasks![0].user!.profile!.fullName!),
                                                                    style: TextStyle(
                                                                        letterSpacing: 1,
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
                                                                        fontSize: UtilsReponsive.height(17, context),
                                                                        fontWeight: FontWeight.w800),
                                                                  ),
                                                                  Text(
                                                                    'Người chịu trách nhiệm',
                                                                    style: TextStyle(
                                                                        fontFamily: 'Nunito',
                                                                        color: ColorsManager.primary,
                                                                        fontSize: UtilsReponsive.height(16, context),
                                                                        fontWeight: FontWeight.w700),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: UtilsReponsive.height(10, context),
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
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (controller.taskModel.value.assignTasks!.isEmpty) {
                                                              Get.snackbar('Lỗi', 'Xin vui lòng chọn Người chịu trách nhiệm trước',
                                                                  snackPosition: SnackPosition.BOTTOM,
                                                                  backgroundColor: Colors.redAccent,
                                                                  colorText: Colors.white);
                                                            } else {
                                                              // await controller.getEmployeeSupport();
                                                              // _showBottomAddMore(context: Get.context!);
                                                            }
                                                          },
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    width: UtilsReponsive.width(40, context),
                                                                    height: UtilsReponsive.height(45, context),
                                                                    decoration: BoxDecoration(
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          blurRadius: 0.5,
                                                                        )
                                                                      ],
                                                                      shape: BoxShape.circle,
                                                                    ),
                                                                    clipBehavior: Clip.antiAlias, // Đây là dòng quan trọng
                                                                    child: Image.asset(ImageAssets.noUser, fit: BoxFit.fill),
                                                                  ),
                                                                  SizedBox(
                                                                    width: UtilsReponsive.width(10, context),
                                                                  ),
                                                                  Column(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          'Những người tham gia khác',
                                                                          style: TextStyle(
                                                                              fontFamily: 'Nunito',
                                                                              color: ColorsManager.primary,
                                                                              fontSize: UtilsReponsive.height(16, context),
                                                                              fontWeight: FontWeight.w700),
                                                                        ),
                                                                      ])
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )),
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
                            controller.taskModel.value.parent!.status != Status.CONFIRM
                                ? Obx(
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
                                                              separatorBuilder: (context, index) =>
                                                                  SizedBox(width: UtilsReponsive.width(15, context)),
                                                              itemBuilder: (context, index) {
                                                                return attchfileComment(controller.filePicker[index], context, index);
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
                                                                    await controller.selectFileComment();
                                                                  },
                                                                  icon: const Icon(Icons.attach_file_outlined)),
                                                              suffixIcon: controller.isLoadingComment.value != true
                                                                  ? IconButton(
                                                                      onPressed: () async {
                                                                        await controller.createComment();
                                                                      },
                                                                      icon: const Icon(Icons.double_arrow_sharp))
                                                                  : Container(
                                                                      width: 10,
                                                                      height: 10,
                                                                      child: SpinKitFadingCircle(
                                                                        color: ColorsManager.primary,
                                                                        size: 20,
                                                                      ),
                                                                    ),
                                                              contentPadding: EdgeInsets.all(UtilsReponsive.width(15, context)),
                                                              hintText: 'Nhập bình luận',
                                                              focusedBorder: const UnderlineInputBorder(
                                                                borderSide: BorderSide(color: Colors.grey), // Màu gạch dưới khi TextField được chọn
                                                              ),
                                                              enabledBorder: const UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(color: Colors.grey), // Màu gạch dưới khi TextField không được chọn
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Container(
                                                      color: Colors.white,
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
                                                                    await controller.selectFileComment();
                                                                  },
                                                                  icon: const Icon(
                                                                    Icons.attach_file_outlined,
                                                                  )),
                                                              suffixIcon: controller.isLoadingComment.value != true
                                                                  ? IconButton(
                                                                      onPressed: () async {
                                                                        await controller.createComment();
                                                                      },
                                                                      icon: const Icon(Icons.double_arrow_sharp))
                                                                  : Container(
                                                                      width: 10,
                                                                      height: 10,
                                                                      child: SpinKitFadingCircle(
                                                                        color: ColorsManager.primary,
                                                                        size: 20,
                                                                      ),
                                                                    ),
                                                              contentPadding: EdgeInsets.all(UtilsReponsive.width(15, context)),
                                                              hintText: 'Nhập bình luận',
                                                              focusedBorder: const UnderlineInputBorder(
                                                                borderSide: BorderSide(color: Colors.grey), // Màu gạch dưới khi TextField được chọn
                                                              ),
                                                              enabledBorder: const UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(color: Colors.grey), // Màu gạch dưới khi TextField không được chọn
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                            ),
                                          ),
                                  )
                                : SizedBox()
                          ],
                        ),
                      ),
          )),
    );
  }

  Container _header({required BuildContext context, required String objectTask}) {
    return Container(
      // padding: UtilsReponsive.paddingAll(context, padding: 5),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Text(
                objectTask,
                style: TextStyle(
                    letterSpacing: 1,
                    fontFamily: 'Nunito',
                    color: ColorsManager.textColor,
                    fontSize: UtilsReponsive.height(24, context),
                    fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBuilder({required BuildContext context, required String objectStatusTask, required taskID}) {
    return GestureDetector(
      onTap: () {
        if (controller.taskModel.value.status! != Status.CONFIRM && controller.taskModel.value.assignTasks![0].user!.id == controller.idUser) {
          _showBottomSheetStatus(context, taskID);
        } else if (controller.taskModel.value.assignTasks![0].user!.id != controller.idUser) {
          Get.snackbar(
            'Thông báo',
            'Bạn không phải là người chịu trách nhiệm',
            snackPosition: SnackPosition.TOP,
            margin: UtilsReponsive.paddingAll(Get.context!, padding: 10),
            backgroundColor: ColorsManager.backgroundGrey,
            colorText: ColorsManager.textColor2,
            duration: const Duration(seconds: 4),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(left: UtilsReponsive.width(10, context)),
        padding: controller.taskModel.value.status! != Status.CONFIRM && controller.taskModel.value.assignTasks![0].user!.id == controller.idUser
            ? EdgeInsets.symmetric(horizontal: UtilsReponsive.width(10, context), vertical: UtilsReponsive.width(5, context))
            : EdgeInsets.symmetric(horizontal: UtilsReponsive.width(20, context), vertical: UtilsReponsive.width(5, context)),
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
          borderRadius: BorderRadius.circular(UtilsReponsive.height(8, context)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              objectStatusTask,
              style: TextStyle(letterSpacing: 1, color: Colors.white, fontSize: UtilsReponsive.height(14, context), fontWeight: FontWeight.w800),
            ),
            controller.taskModel.value.status! != Status.CONFIRM && controller.taskModel.value.assignTasks![0].user!.id == controller.idUser
                ? Icon(
                    Icons.arrow_drop_down_rounded,
                    color: Colors.white,
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }

  void _showBottomSheetStatus(BuildContext context, String taskID) {
    Get.bottomSheet(Container(
      // height: 150,
      decoration: const BoxDecoration(
        color: ColorsManager.backgroundGrey,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      constraints: BoxConstraints(maxHeight: UtilsReponsive.width(400, context)),
      child: ListView(
        shrinkWrap: true,
        children: [
          // "Đang chuẩn bị",
          "Đang thực hiện",
          "Hoàn thành",
          // "Quá hạn",
        ]
            .map(
              (e) => Padding(
                padding: EdgeInsets.only(top: 5, right: 10, left: 10, bottom: 5),
                child: GestureDetector(
                  onTap: () {
                    // if (e == "Đang chuẩn bị") {
                    //   controller.updateStatusTask("PENDING", taskID);
                    //   Navigator.of(context).pop();
                    // } else
                    if (e == "Đang thực hiện") {
                      controller.updateStatusTask("PROCESSING", taskID);
                      Navigator.of(context).pop();
                    } else if (e == "Hoàn thành") {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              "Xác nhận",
                              style: TextStyle(fontFamily: 'Nunito', fontSize: 20, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
                            ),
                            content: const Text(
                              "Bạn có muốn đổi trạng thái công việc này là hoàn thành",
                              style: TextStyle(fontFamily: 'Nunito', fontSize: 15, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Đóng hộp thoại
                                },
                                child: Text(
                                  "Hủy",
                                  style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w700, color: ColorsManager.primary),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  await controller.updateStatusTask("DONE", taskID);
                                },
                                child: Text(
                                  "Có",
                                  style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w700, color: ColorsManager.red),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                    // else if (e == "Quá hạn") {
                    //   controller.updateStatusTask("OVERDUE", taskID);
                    //   Navigator.of(context).pop();
                    // }
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
                                    : ColorsManager.red,
                        child: Text(e[0],
                            style: TextStyle(
                                letterSpacing: 1, color: Colors.white, fontSize: UtilsReponsive.height(16, context), fontWeight: FontWeight.w800)),
                      ),
                      title: Text(
                        e,
                        style: TextStyle(
                            fontFamily: 'Nunito',
                            letterSpacing: 1,
                            color: ColorsManager.textColor2,
                            fontSize: UtilsReponsive.height(18, context),
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    ));
  }

  Widget priorityBuilder({required BuildContext context, required String objectStatusTask, required String taskID}) {
    return controller.taskModel.value.assignTasks!.isEmpty
        ? SizedBox()
        : Container(
            padding: controller.taskModel.value.status! != Status.CONFIRM && controller.taskModel.value.assignTasks![0].user!.id == controller.idUser
                ? EdgeInsets.symmetric(horizontal: UtilsReponsive.width(20, context), vertical: UtilsReponsive.width(9, context))
                : EdgeInsets.symmetric(horizontal: UtilsReponsive.width(20, context), vertical: UtilsReponsive.width(5, context)),
            decoration: controller.taskModel.value.priority != null
                ? BoxDecoration(
                    color: controller.taskModel.value.priority! == Priority.LOW
                        ? ColorsManager.green
                        : controller.taskModel.value.priority! == Priority.MEDIUM
                            ? ColorsManager.yellow
                            : ColorsManager.red,
                    borderRadius: BorderRadius.circular(UtilsReponsive.height(5, context)),
                  )
                : BoxDecoration(
                    color: ColorsManager.grey,
                    borderRadius: BorderRadius.circular(UtilsReponsive.height(5, context)),
                  ),
            margin: EdgeInsets.only(left: UtilsReponsive.width(10, context)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                controller.taskModel.value.priority != null
                    ? Text(
                        objectStatusTask,
                        style: TextStyle(
                            letterSpacing: 1,
                            fontFamily: 'Nunito',
                            color: Colors.white,
                            fontSize: UtilsReponsive.height(14, context),
                            fontWeight: FontWeight.w800),
                      )
                    : Text(
                        '--',
                        style: TextStyle(
                            letterSpacing: 1,
                            fontFamily: 'Nunito',
                            color: Colors.white,
                            fontSize: UtilsReponsive.height(14, context),
                            fontWeight: FontWeight.w800),
                      ),
              ],
            ));
  }

  Row _timeBuilder({required BuildContext context, required String startTime, required String endTime}) {
    return Row(
      children: [
        Icon(
          size: 25,
          Icons.calendar_month,
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
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: UtilsReponsive.width(10, context)),
            child: Text(
              '$startTime ${getCurrentTime(controller.taskModel.value.startDate!.toLocal())} - $endTime ${getCurrentTime(controller.taskModel.value.endDate!.toLocal())}',
              style: TextStyle(
                  // letterSpacing: 1,
                  fontFamily: 'Nunito',
                  overflow: TextOverflow.clip,
                  color: controller.taskModel.value.status == Status.PENDING
                      ? ColorsManager.grey
                      : controller.taskModel.value.status! == Status.PROCESSING
                          ? ColorsManager.blue
                          : controller.taskModel.value.status! == Status.DONE
                              ? ColorsManager.green
                              : controller.taskModel.value.status! == Status.CONFIRM
                                  ? ColorsManager.purple
                                  : ColorsManager.red,
                  // fontSize: UtilsReponsive.height(5, context),
                  fontWeight: FontWeight.w800),
            ),
          ),
        )
      ],
    );
  }

  _showBottomAssign({required BuildContext context}) {
    Get.bottomSheet(Container(
      constraints: BoxConstraints(maxHeight: UtilsReponsive.width(250, context)),
      padding: EdgeInsetsDirectional.symmetric(horizontal: UtilsReponsive.width(15, context), vertical: UtilsReponsive.height(20, context)),
      decoration: BoxDecoration(
        color: ColorsManager.backgroundWhite,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(UtilsReponsive.height(10, context)), topRight: Radius.circular(UtilsReponsive.height(10, context))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: controller.listEmployeeSupportView.length,
              separatorBuilder: (context, index) => SizedBox(
                height: UtilsReponsive.height(10, context),
              ),
              itemBuilder: (context, index) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.blue.shade100, // Đặt màu border xung quanh Container
                    width: 1.0, // Đặt độ dày của border
                  ),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                      radius: UtilsReponsive.height(20, context),
                      backgroundColor: Colors.transparent, // Đảm bảo nền trong suốt
                      child: controller.listEmployeeSupportView[index].avatar == null || controller.listEmployeeSupportView[index].avatar == ''
                          ? Container(
                              width: UtilsReponsive.width(60, context),
                              height: UtilsReponsive.height(60, context),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 0.5,
                                  )
                                ],
                                shape: BoxShape.circle,
                              ),
                              clipBehavior: Clip.antiAlias, // Đây là dòng quan trọng
                              child: Image.asset(ImageAssets.noUser, fit: BoxFit.fill),
                            )
                          : ClipOval(
                              child: Image.network(
                                controller.listEmployeeSupportView[index].avatar!,
                                fit: BoxFit.cover,
                                width: UtilsReponsive.widthv2(context, 60),
                                height: UtilsReponsive.heightv2(context, 60),
                              ),
                            )),
                  title: GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.PROFILE_CHAT, arguments: {"idUserChat": controller.listEmployeeSupportView[index].id});
                    },
                    child: Text(
                      controller.listEmployeeSupportView[index].fullName!,
                      style: TextStyle(
                          fontFamily: 'Nunito',
                          color: ColorsManager.textColor,
                          fontSize: UtilsReponsive.height(17, context),
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                  subtitle: Text(
                    '${controller.listEmployeeSupportView[index].email}',
                    style: TextStyle(
                        fontFamily: 'Nunito',
                        color: ColorsManager.primary,
                        fontSize: UtilsReponsive.height(15, context),
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ),
          ),
        ],
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
        actions: controller.checkView.value == false
            ? []
            : [
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: ColorsManager.primary,
                  ),
                  onSelected: (choice) {
                    if (choice == 'progress') {
                      // if (controller.taskModel.value.status! != Status.CONFIRM && controller.taskModel.value.assignTasks![0].user!.id == controller.idUser) {
                      // controller.progressView.value = controller.progress.value;
                      _showProgress(context: context);
                      // }
                    } else if (choice == 'viewReassign') {
                      Get.toNamed(Routes.TIMELINE_REASSIGN, arguments: {"taskID": controller.taskModel.value.id});
                    } else if (choice == 'viewBudget') {
                      Get.toNamed(Routes.BUDGET, arguments: {
                        "taskID": controller.taskModel.value.id,
                        "statusTask": controller.taskModel.value.status == Status.CONFIRM ? true : false,
                      });
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'progress',
                        child: Obx(
                          () => Text(
                            'Tiến độ ${controller.progress.value}',
                            style: TextStyle(
                                fontFamily: 'Nunito',
                                wordSpacing: 1.2,
                                color: ColorsManager.textColor2,
                                fontSize: UtilsReponsive.height(18, context),
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'viewReassign',
                        child: Text(
                          'Xem lịch sử giao việc',
                          style: TextStyle(
                              fontFamily: 'Nunito',
                              wordSpacing: 1.2,
                              color: ColorsManager.textColor2,
                              fontSize: UtilsReponsive.height(18, context),
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'viewBudget',
                        child: Text(
                          'Xem danh sách khoản chi',
                          style: TextStyle(
                              fontFamily: 'Nunito',
                              wordSpacing: 1.2,
                              color: ColorsManager.textColor2,
                              fontSize: UtilsReponsive.height(18, context),
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      // Các mục menu khác nếu cần
                    ];
                  },
                ),
              ]);
  }

  _showProgress({required BuildContext context}) {
    Get.bottomSheet(Container(
      height: UtilsReponsive.height(200, context),
      constraints: BoxConstraints(maxHeight: UtilsReponsive.width(200, context)),
      padding: EdgeInsetsDirectional.symmetric(horizontal: UtilsReponsive.width(15, context), vertical: UtilsReponsive.height(20, context)),
      decoration: BoxDecoration(
        color: ColorsManager.backgroundWhite,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(UtilsReponsive.height(20, context)), topRight: Radius.circular(UtilsReponsive.height(20, context))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(() {
            // controller.listEmployee;
            return Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: UtilsReponsive.height(10, context),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            wordSpacing: 1.2,
                            fontSize: UtilsReponsive.height(24, context),
                            fontWeight: FontWeight.w700,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Tiến độ: ',
                              style: TextStyle(
                                color: ColorsManager.textColor,
                              ),
                            ),
                            TextSpan(
                              text: '${controller.progressView.value} %',
                              style: TextStyle(
                                color: ColorsManager.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (controller.taskModel.value.assignTasks![0].user!.id == controller.idUser &&
                              controller.taskModel.value.status! != Status.CONFIRM) {
                            controller.updateProgress(controller.progressView.value);
                          } else if (controller.taskModel.value.assignTasks![0].user!.id != controller.idUser) {
                            Get.snackbar(
                              'Thông báo',
                              'Bạn không phải là người chịu trách nhiệm',
                              snackPosition: SnackPosition.TOP,
                              margin: UtilsReponsive.paddingAll(Get.context!, padding: 10),
                              backgroundColor: ColorsManager.backgroundGrey,
                              colorText: ColorsManager.textColor2,
                              duration: const Duration(seconds: 4),
                            );
                          } else if (controller.taskModel.value.status! == Status.CONFIRM) {
                            Get.snackbar(
                              'Thông báo',
                              'Công việc đã xác thực',
                              snackPosition: SnackPosition.TOP,
                              margin: UtilsReponsive.paddingAll(Get.context!, padding: 10),
                              backgroundColor: ColorsManager.backgroundGrey,
                              colorText: ColorsManager.textColor2,
                              duration: const Duration(seconds: 4),
                            );
                          }

                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Lưu',
                          style: TextStyle(
                              fontFamily: 'Nunito',
                              wordSpacing: 1.2,
                              color: ColorsManager.primary,
                              fontSize: UtilsReponsive.height(24, context),
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: UtilsReponsive.height(10, context),
                  ),
                  Slider(
                      value: controller.progressView.value,
                      max: 100,
                      divisions: 10,
                      label: controller.progressView.value.round().toString(),
                      onChanged: (value) {
                        controller.progressView.value = value;
                      }),
                ],
              ),
            );
          })
        ],
      ),
    ));
  }

  Container _commentList(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
      decoration: BoxDecoration(
          color: Colors.white,
          // boxShadow: const [
          //   BoxShadow(
          //     color: Colors.white,
          //     spreadRadius: 0.5,
          //     blurRadius: 7,
          //     offset: Offset(0, 3),
          //   ),
          // ],
          borderRadius: BorderRadius.circular(UtilsReponsive.height(10, context))),
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
                          return comment(controller.listComment[index], context, index);
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
                              style: GetTextStyle.getTextStyle(15, 'Nunito', FontWeight.w700, ColorsManager.primary),
                            ),
                            SizedBox(
                              height: UtilsReponsive.height(10, context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  StatefulBuilder comment(CommentModel commentModel, BuildContext context, int index) {
    // bool isEditComment = false;
    // TextEditingController commentTextController = TextEditingController(text: commentModel.text);
    String commentText = commentModel.text!;
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
                          letterSpacing: 1,
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
                          fontWeight: FontWeight.w700),
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
                              print('commentModel.commentFiles![index] ${commentModel.commentFiles![index].fileUrl}');
                              return _filesComment(
                                commentModel.commentFiles![index],
                                context,
                                controller.listComment[index].isEditComment!,
                              );
                            },
                          ),
                        )
                      : SizedBox(),
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
                            fontWeight: FontWeight.w700),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: UtilsReponsive.height(8, context)),
                        height: UtilsReponsive.height(150, context),
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: filePickerEditCommentFile.length,
                          separatorBuilder: (context, index) => SizedBox(width: UtilsReponsive.width(15, context)),
                          itemBuilder: (context, index) {
                            return editFileComment(filePickerEditCommentFile[index], context, index, controller.listComment[index].isEditComment!,
                                setStateX, filePickerEditCommentFile);
                          },
                        ),
                      ),
                    ],
                  )
                : SizedBox(),
            SizedBox(height: UtilsReponsive.height(10, context)),
            controller.listComment[index].isEditComment == true
                ? Container(
                    constraints: BoxConstraints(maxHeight: UtilsReponsive.height(300, context), minHeight: UtilsReponsive.height(100, context)),
                    child: FormFieldWidget(
                      setValueFunc: (value) {
                        print(commentText);
                        commentText = value;
                      },
                      // controllerEditting: controller.commentTextController,
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
                        fontWeight: FontWeight.w700),
                  ),
            SizedBox(height: UtilsReponsive.width(10, context)),
            controller.listComment[index].isEditComment == false
                ? Row(
                    children: [
                      InkWell(
                          onTap: () {
                            controller.isCheckEditComment.value = true;
                            setStateX(() {
                              controller.listComment[index].isEditComment = true;
                            });
                          },
                          child: commentModel.user!.id == controller.idUser
                              ? Align(
                                  alignment: Alignment.topLeft,
                                  child: controller.taskModel.value.parent!.status != Status.CONFIRM
                                      ? Text(
                                          'Chỉnh sửa',
                                          style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w700, ColorsManager.primary),
                                        )
                                      : SizedBox())
                              : SizedBox()),
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
                                          style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w700, ColorsManager.primary),
                                        ),
                                        content: Text(
                                          'Xóa một bình luận là vĩnh viễn. Không có cách hoàn tác',
                                          style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w700, ColorsManager.textColor2),
                                        ),
                                        actions: [
                                          TextButton(
                                            child: Text(
                                              'Hủy',
                                              style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w700, ColorsManager.primary),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text(
                                              'Xác nhận',
                                              style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w700, ColorsManager.red),
                                            ),
                                            onPressed: () {
                                              controller.deleteComment(commentModel);
                                              setStateX(() {
                                                controller.listComment[index].isEditComment = true;
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
                                  child: controller.taskModel.value.parent!.status != Status.CONFIRM
                                      ? Text(
                                          'Xóa',
                                          style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w700, ColorsManager.red),
                                        )
                                      : SizedBox()))
                          : SizedBox(),
                    ],
                  )
                : Row(
                    children: [
                      InkWell(
                          onTap: () async {
                            if (commentText == "") {
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
                              await controller.editComment(commentModel, commentText, commentModel.id!, filePickerEditCommentFile);
                              setStateX(() {
                                controller.listComment[index].isEditComment = false;
                              });
                              controller.isCheckEditComment.value = false;
                            }
                          },
                          child: Obx(
                            () => Align(
                                alignment: Alignment.topLeft,
                                child: controller.isLoadingCommentV2.value
                                    ? Container(
                                        width: 30,
                                        height: 30,
                                        child: SpinKitFadingCircle(
                                          color: ColorsManager.primary,
                                          size: 20,
                                        ),
                                      )
                                    : Text(
                                        'Lưu',
                                        style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w700, ColorsManager.primary),
                                      )),
                          )),
                      SizedBox(
                        width: UtilsReponsive.width(10, context),
                      ),
                      InkWell(
                          onTap: () async {
                            await controller.cancel(commentModel.id!);
                            filePickerEditCommentFile.clear();
                            setStateX(() {
                              controller.listComment[index].isEditComment = false;
                            });
                            controller.isCheckEditComment.value = false;
                          },
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Hủy',
                                style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w700, ColorsManager.red),
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
                                style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w700, ColorsManager.textColor2),
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

  Obx _documentV2(BuildContext context) {
    return Obx(
      () => Container(
          // height: controller.listAttachment.isEmpty
          //     ? 50
          //     : UtilsReponsive.height(200, context),
          // padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
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
                                letterSpacing: 1,
                                color: ColorsManager.backgroundWhite,
                                fontSize: UtilsReponsive.height(15, context),
                                fontWeight: FontWeight.w800),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
              children: [
                controller.listAttachment.isEmpty
                    ? Container(
                        padding: EdgeInsets.only(
                            left: UtilsReponsive.height(20, context),
                            right: UtilsReponsive.height(15, context),
                            bottom: UtilsReponsive.height(10, context)),
                        // height: UtilsReponsive.height(120, context),
                      )
                    : Column(
                        children: [
                          Container(
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
                          SizedBox(
                            height: UtilsReponsive.height(10, context),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: UtilsReponsive.height(20, context),
                                right: UtilsReponsive.height(15, context),
                                bottom: UtilsReponsive.height(10, context)),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    await controller.selectFile();
                                  },
                                  child: Text(
                                    '+  Thêm tệp',
                                    style: GetTextStyle.getTextStyle(15, 'Nunito', FontWeight.w700, ColorsManager.primary),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          )),
    );
  }

  void _showOptionsDocumentPopup(BuildContext context, AttachmentModel attachmentModel, int mode) {
    BuildContext _popupContext = context;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Tùy chọn",
            style: TextStyle(fontFamily: 'Nunito', fontSize: 18, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  'Xóa',
                  style: TextStyle(fontFamily: 'Nunito', fontSize: 17, fontWeight: FontWeight.w700, color: ColorsManager.red),
                ),
                onTap: () {
                  if (mode != 2) {
                    _showDeleteDocumentConfirmation(context, attachmentModel, _popupContext);
                  } else {
                    Get.snackbar(
                      'Thông báo',
                      'Bạn khổng thể xóa tệp tài liệu của bình luận',
                      snackPosition: SnackPosition.TOP,
                      margin: UtilsReponsive.paddingAll(Get.context!, padding: 10),
                      backgroundColor: ColorsManager.backgroundGrey,
                      colorText: ColorsManager.textColor2,
                      duration: const Duration(seconds: 4),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteDocumentConfirmation(BuildContext context, AttachmentModel attachmentModel, BuildContext popupContext) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Xóa tệp này?",
            style: TextStyle(fontFamily: 'Nunito', fontSize: 20, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
          ),
          content: const Text(
            "Một khi nó đã mất, thì nó đã mất.",
            style: TextStyle(fontFamily: 'Nunito', fontSize: 15, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text(
                "Hủy",
                style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w700, color: ColorsManager.primary),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                Navigator.of(popupContext).pop();
                await controller.deleteTaskFile(attachmentModel);
              },
              child: Text(
                "Xóa",
                style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w700, color: ColorsManager.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showOptionsFileCommentPopup(BuildContext context, CommentFile commentFile) {
    BuildContext _popupContext = context;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Tùy chọn",
            style: TextStyle(fontFamily: 'Nunito', fontSize: 18, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  'Xóa',
                  style: TextStyle(fontFamily: 'Nunito', fontSize: 17, fontWeight: FontWeight.w700, color: ColorsManager.red),
                ),
                onTap: () {
                  _showDeleteFileCommentConfirmation(context, commentFile, _popupContext);
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
            style: TextStyle(fontFamily: 'Nunito', fontSize: 20, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
          ),
          content: const Text(
            "Một khi nó đã mất, thì nó đã mất.",
            style: TextStyle(fontFamily: 'Nunito', fontSize: 15, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text(
                "Hủy",
                style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w700, color: ColorsManager.primary),
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
                style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w700, color: ColorsManager.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showOptionsAttachmentCommentPopup(BuildContext context, int index) {
    BuildContext _popupContext = context;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Tùy chọn",
            style: TextStyle(fontFamily: 'Nunito', fontSize: 18, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  'Xóa',
                  style: TextStyle(fontFamily: 'Nunito', fontSize: 17, fontWeight: FontWeight.w700, color: ColorsManager.red),
                ),
                onTap: () {
                  _showDeleteAttachmentCommentConfirmation(context, index, _popupContext);
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
            style: TextStyle(fontFamily: 'Nunito', fontSize: 20, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
          ),
          content: const Text(
            "Một khi nó đã mất, thì nó đã mất.",
            style: TextStyle(fontFamily: 'Nunito', fontSize: 15, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text(
                "Hủy",
                style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w700, color: ColorsManager.primary),
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
                style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w700, color: ColorsManager.red),
              ),
            ),
          ],
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
            style: TextStyle(fontFamily: 'Nunito', fontSize: 18, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  'Xóa',
                  style: TextStyle(fontFamily: 'Nunito', fontSize: 17, fontWeight: FontWeight.w700, color: ColorsManager.red),
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

  void _showDeleteAttachmentCommentConfirmationV2(
      BuildContext context, int index, BuildContext popupContext, setStateX, List<PlatformFile> filePickerEditCommentFile) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Xóa tệp này?",
            style: TextStyle(fontFamily: 'Nunito', fontSize: 20, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
          ),
          content: const Text(
            "Một khi nó đã mất, thì nó đã mất.",
            style: TextStyle(fontFamily: 'Nunito', fontSize: 15, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text(
                "Hủy",
                style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w700, color: ColorsManager.primary),
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
                style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w700, color: ColorsManager.red),
              ),
            ),
          ],
        );
      },
    );
  }

  InkWell attchfileComment(PlatformFile attachCommentFile, BuildContext context, int index) {
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
              color: ColorsManager.backgroundGrey,
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
              width: UtilsReponsive.width(120, context),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(
                    flex: 4,
                    // child: Text('hiii'),
                    child: fileName.length > 35
                        ? Text(
                            fileName.length > 35 ? '${fileName.substring(0, 35)}...' : fileName,
                            style: const TextStyle(fontFamily: 'Nunito', fontSize: 12, fontWeight: FontWeight.w700, color: ColorsManager.textColor),
                          )
                        : Text(
                            fileName,
                            style: const TextStyle(fontFamily: 'Nunito', fontSize: 12, fontWeight: FontWeight.w700, color: ColorsManager.textColor),
                          ),
                  ),
                  Expanded(
                      child: Text(
                    fileSize,
                    style: const TextStyle(fontFamily: 'Nunito', fontSize: 12, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
                  )),
                ]),
              ),
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
                  // child: Text('hiii'),
                  child: fileName.length > 35
                      ? Text(
                          fileName.length > 35 ? '${fileName.substring(0, 35)}...' : fileName,
                          style: const TextStyle(fontFamily: 'Nunito', fontSize: 12, fontWeight: FontWeight.w700, color: ColorsManager.textColor),
                        )
                      : Text(
                          fileName,
                          style: const TextStyle(fontFamily: 'Nunito', fontSize: 12, fontWeight: FontWeight.w700, color: ColorsManager.textColor),
                        ),
                ),
                Expanded(
                    child: Text(
                  fileSize,
                  style: const TextStyle(fontFamily: 'Nunito', fontSize: 12, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
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
                      style: const TextStyle(fontFamily: 'Nunito', fontSize: 14, fontWeight: FontWeight.w700, color: ColorsManager.textColor),
                    )
                  : Text(
                      commentFile.fileName!,
                      style: const TextStyle(fontFamily: 'Nunito', fontSize: 14, fontWeight: FontWeight.w700, color: ColorsManager.textColor),
                    ),
            ),
            // const Expanded(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //       Text(
            //         'Kích thước',
            //         style: TextStyle(fontFamily: 'Nunito', fontSize: 14, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
            //       ),
            //     ],
            //   ),
            // ),
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
      onLongPress: () {
        _showOptionsDocumentPopup(context, attachmentModel, attachmentModel.mode!);
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
              // child: Text('hiii'),
              child: attachmentModel.fileName!.length > 35
                  ? Text(
                      attachmentModel.fileName!.length > 35 ? '${attachmentModel.fileName!.substring(0, 35)}...' : attachmentModel.fileName!,
                      style: const TextStyle(fontFamily: 'Nunito', fontSize: 11, fontWeight: FontWeight.w700, color: ColorsManager.textColor),
                    )
                  : Text(
                      attachmentModel.fileName!,
                      style: const TextStyle(fontFamily: 'Nunito', fontSize: 11, fontWeight: FontWeight.w700, color: ColorsManager.textColor),
                    ),
            ),
            // const Expanded(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //       Text(
            //         'Kích thước',
            //         style: TextStyle(fontFamily: 'Nunito', fontSize: 14, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
            //       ),
            //     ],
            //   ),
            // ),
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
                      padding: EdgeInsets.symmetric(horizontal: UtilsReponsive.height(20, context), vertical: UtilsReponsive.height(10, context)),
                      child: IgnorePointer(
                          ignoring: true,
                          child: Quil.QuillEditor.basic(
                            // controller: controller,
                            configurations: const Quil.QuillEditorConfigurations(autoFocus: false, readOnly: false),

                            // embedBuilders: FlutterQuillEmbeds.builders(),
                          )),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: UtilsReponsive.height(20, context), vertical: UtilsReponsive.height(10, context)),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
