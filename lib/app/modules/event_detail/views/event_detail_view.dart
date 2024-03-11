import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_quill/flutter_quill.dart' as Quil;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_view.dart';
import 'package:hrea_mobile_employee/app/resources/color_manager.dart';
import 'package:hrea_mobile_employee/app/resources/reponsive_utils.dart';
import '../controllers/event_detail_controller.dart';

class EventDetailView extends BaseView<EventDetailController> {
  const EventDetailView({Key? key}) : super(key: key);
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
                    // size: 50.0,
                  ),
                )
              : SafeArea(
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        // fit: BoxFit.contain,
                        imageUrl: controller.eventDetail.value.coverUrl!,
                        // imageUrl:
                        //     'https://preview.keenthemes.com/metronic-v4/theme/assets/pages/media/profile/profile_user.jpg',
                        imageBuilder: (context, imageProvider) => Container(
                            height: UtilsReponsive.height(400, context),
                            decoration: BoxDecoration(
                                border: Border.all(width: 4, color: Theme.of(context).scaffoldBackgroundColor),
                                boxShadow: [
                                  BoxShadow(spreadRadius: 2, blurRadius: 10, color: Colors.black.withOpacity(0.1), offset: const Offset(0, 10))
                                ],
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
                      scroll(),
                    ],
                  ),
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
    );
  }

  scroll() {
    return DraggableScrollableSheet(
        initialChildSize: 0.5,
        maxChildSize: 1.0,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return Obx(
            () => Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 10),
                  ),
                ],
                color: ColorsManager.backgroundWhite,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(UtilsReponsive.height(20, context)), topRight: Radius.circular(UtilsReponsive.height(20, context))),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 5,
                          width: 35,
                          color: Colors.black12,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    controller.eventDetail.value.eventName!.length > 30
                        ? '${controller.eventDetail.value.eventName!.substring(0, 30)}...'
                        : controller.eventDetail.value.eventName!,
                    style: TextStyle(
                        fontFamily: 'Nunito',
                        wordSpacing: 1.2,
                        color: ColorsManager.primary,
                        fontSize: UtilsReponsive.height(24, context),
                        fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Thời gian sự kiện',
                    style: TextStyle(
                        fontFamily: 'Nunito',
                        color: ColorsManager.primary,
                        fontSize: UtilsReponsive.height(20, context),
                        fontWeight: FontWeight.w800),
                  ),
                  SizedBox(
                    height: UtilsReponsive.height(10, context),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        size: 25,
                        color: controller.eventDetail.value.status == "PENDING"
                            ? Colors.grey.withOpacity(0.8)
                            : controller.eventDetail.value.status! == "PROCESSING"
                                ? ColorsManager.primary
                                : ColorsManager.green,
                      ),
                      Container(
                        // padding: EdgeInsets.symmetric(
                        //     horizontal: UtilsReponsive.width(5, context),
                        //     vertical: UtilsReponsive.height(10, context)),
                        // decoration: BoxDecoration(
                        //   color: Colors.white,
                        //   borderRadius:
                        //       BorderRadius.circular(UtilsReponsive.height(5, context)),
                        // ),
                        margin: EdgeInsets.only(left: UtilsReponsive.width(10, context)),
                        child: Text(
                          '${controller.dateFormat.format(controller.eventDetail.value.startDate!)}- ${controller.dateFormat.format(controller.eventDetail.value.endDate!)}',
                          style: TextStyle(
                              letterSpacing: 1.5,
                              fontFamily: 'Nunito',
                              color: controller.eventDetail.value.status == "PENDING"
                                  ? Colors.grey.withOpacity(0.8)
                                  : controller.eventDetail.value.status! == "PROCESSING"
                                      ? ColorsManager.primary
                                      : ColorsManager.green,
                              fontSize: UtilsReponsive.height(17, context),
                              fontWeight: FontWeight.w800),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: UtilsReponsive.height(10, context),
                  ),
                  Text(
                    'Thời gian diễn ra',
                    style: TextStyle(
                        fontFamily: 'Nunito',
                        color: ColorsManager.primary,
                        fontSize: UtilsReponsive.height(20, context),
                        fontWeight: FontWeight.w800),
                  ),
                  SizedBox(
                    height: UtilsReponsive.height(10, context),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        size: 25,
                        color: controller.eventDetail.value.status == "PENDING"
                            ? Colors.grey.withOpacity(0.8)
                            : controller.eventDetail.value.status! == "PROCESSING"
                                ? ColorsManager.primary
                                : ColorsManager.green,
                      ),
                      Container(
                        // padding: EdgeInsets.symmetric(
                        //     horizontal: UtilsReponsive.width(5, context),
                        //     vertical: UtilsReponsive.height(10, context)),
                        // decoration: BoxDecoration(
                        //   color: Colors.white,
                        //   borderRadius:
                        //       BorderRadius.circular(UtilsReponsive.height(5, context)),
                        // ),
                        margin: EdgeInsets.only(left: UtilsReponsive.width(10, context)),
                        child: Text(
                          controller.dateFormat.format(controller.eventDetail.value.processingDate!),
                          style: TextStyle(
                              letterSpacing: 1.5,
                              fontFamily: 'Nunito',
                              color: controller.eventDetail.value.status == "PENDING"
                                  ? Colors.grey.withOpacity(0.8)
                                  : controller.eventDetail.value.status! == "PROCESSING"
                                      ? ColorsManager.primary
                                      : ColorsManager.green,
                              fontSize: UtilsReponsive.height(17, context),
                              fontWeight: FontWeight.w800),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: UtilsReponsive.height(10, context),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 25,
                        color: ColorsManager.orange,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      controller.eventDetail.value.location == null || controller.eventDetail.value.location == ''
                          ? Text(
                              '---',
                              style: TextStyle(
                                  fontFamily: 'Nunito',
                                  wordSpacing: 1.2,
                                  color: ColorsManager.primary,
                                  fontSize: UtilsReponsive.height(20, context),
                                  fontWeight: FontWeight.bold),
                            )
                          : Text(
                              controller.eventDetail.value.location!.length > 30
                                  ? '${controller.eventDetail.value.location!.substring(0, 30)}...'
                                  : controller.eventDetail.value.location!,
                              style: TextStyle(
                                  fontFamily: 'Nunito',
                                  wordSpacing: 1.2,
                                  color: ColorsManager.primary,
                                  fontSize: UtilsReponsive.height(20, context),
                                  fontWeight: FontWeight.bold),
                            ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.monetization_on,
                        size: 25,
                        color: ColorsManager.green,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      controller.eventDetail.value.estBudget == null
                          ? Text(
                              '---',
                              style: TextStyle(
                                  fontFamily: 'Nunito',
                                  wordSpacing: 1.2,
                                  color: ColorsManager.primary,
                                  fontSize: UtilsReponsive.height(20, context),
                                  fontWeight: FontWeight.bold),
                            )
                          : Text(
                              controller.formatCurrency(controller.eventDetail.value.estBudget!),
                              style: TextStyle(
                                  fontFamily: 'Nunito',
                                  wordSpacing: 1.2,
                                  color: ColorsManager.primary,
                                  fontSize: UtilsReponsive.height(20, context),
                                  fontWeight: FontWeight.bold),
                            ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Quil.QuillProvider(
                    configurations: Quil.QuillConfigurations(controller: controller.quillController.value),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          UtilsReponsive.height(10, context),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mô tả',
                            style: TextStyle(
                                fontFamily: 'Nunito',
                                wordSpacing: 1.2,
                                color: ColorsManager.textColor2,
                                fontSize: UtilsReponsive.height(20, context),
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
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
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          );
        });
  }
}
