import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_view.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/task.dart';
import 'package:hrea_mobile_employee/app/modules/timeline_reassign/views/timeline_title_ui.dart';
import 'package:hrea_mobile_employee/app/resources/assets_manager.dart';
import 'package:hrea_mobile_employee/app/resources/color_manager.dart';
import 'package:hrea_mobile_employee/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_employee/app/resources/style_manager.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';
import 'package:intl/intl.dart';
import 'package:flutter/gestures.dart';
import '../controllers/timeline_reassign_controller.dart';

class TimelineReassignView extends BaseView<TimelineReassignController> {
  const TimelineReassignView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Lịch sử giao việc công việc',
          style: TextStyle(color: ColorsManager.backgroundWhite, fontSize: UtilsReponsive.height(22, context), fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        backgroundColor: ColorsManager.primary,
      ),
      body: Obx(
        () => Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0),
            child: controller.isLoading.value == true
                ? Center(
                    child: SpinKitFadingCircle(
                      color: ColorsManager.primary,
                      // size: 30.0,
                    ),
                  )
                : controller.checkView.value == false
                    ? Expanded(
                        flex: 4,
                        child: Container(
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
                    : controller.taskModel.value.assignTasks!.isEmpty
                        ? Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(UtilsReponsive.height(30, context)),
                                  topRight: Radius.circular(UtilsReponsive.height(30, context)),
                                ),
                                color: Colors.white,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: UtilsReponsive.height(200, context),
                                    child: Image.asset(
                                      ImageAssets.noAssign,
                                    ),
                                  ),
                                  SizedBox(
                                    height: UtilsReponsive.height(20, context),
                                  ),
                                  Center(
                                    child: Text(
                                      'Chưa ai được giao trong công việc này',
                                      style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w800, Colors.blueAccent),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: controller.refreshPage,
                            child: ListView.builder(
                                itemCount: controller.taskModel.value.assignTasks!.length,
                                itemBuilder: (context, index) {
                                  return (timeLine(controller.taskModel.value.assignTasks![index], context, index,
                                      controller.taskModel.value.assignTasks!.length));
                                }),
                          )),
      ),
    );
  }

  Widget timeLine(AssignTask assignTask, BuildContext context, int index, int length) {
    return TimeLineTileUI(
      // isFirst: index == 0 ? true : false,
      isFirst: false,
      isLast: index == length - 1 ? true : false,
      isPast: true,
      isActive: assignTask.status == 'active' ? true : false,
      eventChild: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.edit,
                color: Colors.white,
                size: UtilsReponsive.height(22, context),
              ),
              SizedBox(
                width: UtilsReponsive.width(10, context),
              ),
              const Text(
                'Chỉnh sửa công việc',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white, fontFamily: 'Nunito'),
              ),
            ],
          ),
          assignTask.status == "active"
              ? RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: [
                      const TextSpan(
                          text: 'Nhân viên ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: 'Nunito')),
                      TextSpan(
                        text: '${assignTask.user!.profile!.fullName}',
                        style: const TextStyle(fontWeight: FontWeight.w800, color: ColorsManager.textColor, fontFamily: 'Nunito'),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.toNamed(Routes.PROFILE_CHAT, arguments: {"idUserChat": assignTask.user!.id});
                          },
                      ),
                      const TextSpan(
                          text: ' được thêm vào công việc ',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: 'Nunito')),
                      TextSpan(
                        text: '${controller.taskModel.value.title}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, color: ColorsManager.textColor, fontFamily: 'Nunito'), // Ví dụ: Đặt nghiêng cho tiêu đề
                      ),
                    ],
                  ),
                )
              : RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: [
                      const TextSpan(
                          text: 'Nhân viên ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: 'Nunito')),
                      TextSpan(
                        text: '${assignTask.user!.profile!.fullName}',
                        style: const TextStyle(fontWeight: FontWeight.w800, color: ColorsManager.textColor, fontFamily: 'Nunito'),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.toNamed(Routes.PROFILE_CHAT, arguments: {"idUserChat": assignTask.user!.id});
                          },
                      ),
                      const TextSpan(
                          text: ' không còn làm công việc ',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: 'Nunito')),
                      TextSpan(
                        text: '${controller.taskModel.value.title}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, color: ColorsManager.textColor, fontFamily: 'Nunito'), // Ví dụ: Đặt nghiêng cho tiêu đề
                      ),
                    ],
                  ),
                ),
          Text(DateFormat('EEEE, dd MMM yy', 'vi_VN').format(assignTask.createdAt!),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: 'Nunito')),
        ],
      ),
    );
  }
}
