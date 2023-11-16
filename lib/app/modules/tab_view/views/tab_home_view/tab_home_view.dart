import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_view.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/controllers/tab_home_controller/tab_home_controller.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/event.dart';
import 'package:hrea_mobile_employee/app/resources/assets_manager.dart';
import 'package:hrea_mobile_employee/app/resources/color_manager.dart';
import 'package:hrea_mobile_employee/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_employee/app/resources/style_manager.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';
import 'package:hrea_mobile_employee/app/utils/check_vietnamese.dart';
import 'package:intl/intl.dart';

class TabHomeView extends BaseView<TabHomeController> {
  const TabHomeView({Key? key}) : super(key: key);
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
                  // size: 50.0,
                ),
              )
            : Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: UtilsReponsive.width(40, context),
                        height: UtilsReponsive.width(40, context),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorsManager.primary,
                        ),
                        child: IconButton(
                          onPressed: () {
                            showSearch(
                              context: context,
                              delegate: CustomSearch(
                                listEvent: controller.listEvent,
                              ),
                            );
                          },
                          icon: const Icon(Icons.search),
                          color: ColorsManager.backgroundWhite,
                        ),
                      ),
                      SizedBox(
                        width: UtilsReponsive.width(20, context),
                      ),
                      Text(
                        'Sự kiện',
                        style: GetTextStyle.getTextStyle(22, 'Roboto', FontWeight.w600, ColorsManager.primary),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: UtilsReponsive.height(10, context),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     const SizedBox(),
                  //     Text(
                  //       'Xem báo cáo',
                  //       style: GetTextStyle.getTextStyle(
                  //           15, 'Roboto', FontWeight.w500, Colors.blue),
                  //     )
                  //   ],
                  // ),
                  SizedBox(
                    height: UtilsReponsive.height(10, context),
                  ),
                  Obx(
                    () => Expanded(
                      child: RefreshIndicator(
                        onRefresh: controller.refreshpage,
                        child: Container(
                          // height: MediaQuery.of(context).size.height / 1.38,
                          padding: EdgeInsets.all(UtilsReponsive.width(8, context)),
                          child: GridView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: controller.listEvent.length,
                            itemBuilder: (context, index) {
                              return _itemEvent(context: context, eventModel: controller.listEvent[index]);
                            },
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 10,
                              childAspectRatio: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    ));
  }

  Widget _itemEvent({required BuildContext context, required EventModel eventModel}) {
    return GestureDetector(
      onTap: () {
        controller.onTapEvent(eventID: eventModel.id!, eventName: eventModel.eventName!);
      },
      child: Container(
        height: UtilsReponsive.height(50, context),
        width: UtilsReponsive.width(150, context),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(UtilsReponsive.height(15, context))),
        child: Padding(
          padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
          child: Column(
            children: [
              Container(
                height: UtilsReponsive.height(80, context),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    UtilsReponsive.height(15, context),
                  ),
                  border: Border.all(
                    color: ColorsManager.primary, // Màu viền
                    width: 1.5, // Độ dày của viền
                  ),
                ),
                child: CachedNetworkImage(
                  // fit: BoxFit.contain,
                  imageUrl: eventModel.coverUrl!,
                  imageBuilder: (context, imageProvider) => Container(
                      height: UtilsReponsive.height(50, context),
                      width: UtilsReponsive.width(150, context),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            UtilsReponsive.height(15, context),
                          ),
                          border: Border.all(width: 1.5, color: Theme.of(context).scaffoldBackgroundColor),
                          image: DecorationImage(fit: BoxFit.contain, image: imageProvider))),
                  progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                    padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
                    height: UtilsReponsive.height(20, context),
                    width: UtilsReponsive.height(20, context),
                    child: CircularProgressIndicator(
                      color: ColorsManager.primary,
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              SizedBox(
                height: UtilsReponsive.height(10, context),
              ),
              Expanded(
                child: Text(
                  eventModel.eventName!,
                  style: GetTextStyle.getTextStyle(12, 'Roboto', FontWeight.w600, ColorsManager.textColor),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      'Ngày bắt đầu: ',
                      style: GetTextStyle.getTextStyle(11, 'Roboto', FontWeight.w400, ColorsManager.textColor2),
                    ),
                    Text(
                      DateFormat('dd-MM-yyyy').format(eventModel.startDate!),
                      style: GetTextStyle.getTextStyle(11, 'Roboto', FontWeight.w500, ColorsManager.textColor),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      'Ngày Kết thúc: ',
                      style: GetTextStyle.getTextStyle(11, 'Roboto', FontWeight.w400, ColorsManager.textColor2),
                    ),
                    Text(
                      DateFormat('dd-MM-yyyy').format(eventModel.endDate!),
                      style: GetTextStyle.getTextStyle(11, 'Roboto', FontWeight.w500, ColorsManager.textColor),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      eventModel.status == "PENDING"
                          ? "Đang chuẩn bị"
                          : eventModel.status == "PROCESSING"
                              ? "Đang diễn ra"
                              : "Đã kết thúc",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        fontSize: UtilsReponsive.height(16, context),
                        color: eventModel.status == "PENDING"
                            ? ColorsManager.primary
                            : eventModel.status == "PROCESSING"
                                ? Colors.orangeAccent
                                : Colors.greenAccent,
                      ),
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
}

class CustomSearch extends SearchDelegate {
  RxList<EventModel> listEvent = <EventModel>[].obs;
  CustomSearch({required this.listEvent});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    RxList<EventModel> matchQuery = <EventModel>[].obs;
    for (var item in listEvent) {
      final normalizedEventName = removeVietnameseAccent(item.eventName!.toLowerCase());
      final normalizedQuery = removeVietnameseAccent(query.toLowerCase());
      if (normalizedEventName.contains(normalizedQuery)) {
        matchQuery.add(item);
      }
    }

    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(
        height: UtilsReponsive.height(20, context),
      ),
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return GestureDetector(
          onTap: () {
            Get.toNamed(Routes.TASK_OVERALL_VIEW, arguments: {"eventID": result.id, "eventName": result.eventName});
          },
          child: ListTile(
              title: Row(
            children: [
              result.coverUrl!.isEmpty
                  ? Image.asset(
                      ImageAssets.errorImage,
                      fit: BoxFit.cover,
                      width: UtilsReponsive.widthv2(context, 45), // Kích thước của hình ảnh
                      height: UtilsReponsive.heightv2(context, 50),
                    )
                  : Image.network(
                      result.coverUrl!,
                      fit: BoxFit.cover,
                      width: UtilsReponsive.widthv2(context, 45), // Kích thước của hình ảnh
                      height: UtilsReponsive.heightv2(context, 50),
                    ),
              SizedBox(
                width: UtilsReponsive.width(15, context),
              ),
              Text(
                result.eventName!,
                style: GetTextStyle.getTextStyle(18, 'Roboto', FontWeight.w600, ColorsManager.textColor),
              ),
            ],
          )),
        );
      },
    );
  }
}
