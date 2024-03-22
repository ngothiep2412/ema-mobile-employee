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
    return Scaffold(
      backgroundColor: ColorsManager.backgroundWhite,
      body: Obx(
        () => controller.isLoading.value == true
            ? Center(
                child: SpinKitFadingCircle(
                  color: ColorsManager.primary,
                  // size: 50.0,
                ),
              )
            : controller.checkInView.value == false
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: controller.refreshpage,
                          child: ListView(children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center, // Đặt crossAxisAlignment thành center
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height / 4,
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
                                  'Đang có lỗi xảy ra',
                                  style: GetTextStyle.getTextStyle(20, 'Nunito', FontWeight.w800, ColorsManager.primary),
                                ),
                              ],
                            ),
                          ]),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(UtilsReponsive.height(30, context)),
                            bottomRight: Radius.circular(UtilsReponsive.height(30, context)),
                          ),
                          color: Colors.blue.withOpacity(0.9),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: UtilsReponsive.height(10, context)),
                          child: Column(
                            children: [
                              SizedBox(
                                height: UtilsReponsive.height(40, context),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Trang chủ',
                                    style: GetTextStyle.getTextStyle(22, 'Nunito', FontWeight.w800, ColorsManager.backgroundWhite),
                                  ),
                                  Container(
                                    width: UtilsReponsive.width(50, context),
                                    height: UtilsReponsive.width(50, context),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: ColorsManager.backgroundWhite,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.5), // Màu của shadow
                                          spreadRadius: 2, // Bán kính lan rộng của shadow
                                          blurRadius: 5, // Độ mờ của shadow
                                          offset: Offset(0, 3), // Độ lệch của shadow theo trục x và y
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        // showSearch(
                                        //   context: context,
                                        //   delegate: CustomSearch(
                                        //     listEvent: controller.listEvent,
                                        //   ),
                                        // );
                                        Get.toNamed(
                                          '/task-schedule',
                                        );
                                      },
                                      icon: const Icon(Icons.calendar_month_rounded),
                                      color: ColorsManager.primary,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: UtilsReponsive.height(40, context),
                              ),
                              GestureDetector(
                                onTap: () => showSearch(
                                  context: context,
                                  delegate: CustomSearch(
                                    listEvent: controller.listEvent,
                                  ),
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: Colors.grey.withOpacity(0.5),
                                    //     blurRadius: 5,
                                    //     spreadRadius: 2,
                                    //     offset: Offset(0, 3),
                                    //   )
                                    // ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.search,
                                        color: Color(0xFF113953),
                                      ),
                                      Container(
                                        width: UtilsReponsive.width(200, context),
                                        height: UtilsReponsive.height(50, context),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 10),

                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Tìm kiếm',
                                                style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, Color(0xffA7A7A7)),
                                              ),
                                            ],
                                          ),

                                          // TextFormField(
                                          //   decoration: const InputDecoration(
                                          //     hintText: "Tìm kiếm",
                                          //     border: InputBorder.none,
                                          //   ),
                                          //   onTap: () => showSearch(
                                          //     context: context,
                                          //     delegate: CustomSearch(
                                          //       listEvent: controller.listEvent,
                                          //     ),
                                          //   ),
                                          // ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: UtilsReponsive.height(30, context),
                              ),
                            ],
                          ),
                        ),
                      )),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.only(left: UtilsReponsive.height(20, context), right: UtilsReponsive.height(20, context)),
                          child: RefreshIndicator(
                            onRefresh: controller.refreshpage,
                            child: ListView(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        'Thống kê',
                                        style: GetTextStyle.getTextStyle(19, 'Nunito', FontWeight.w800, Colors.blueAccent),
                                      ),
                                    ),
                                    SizedBox(
                                      width: UtilsReponsive.width(5, context),
                                    ),
                                    const Icon(
                                      Icons.analytics,
                                      color: Colors.blueGrey,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: UtilsReponsive.height(10, context),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Các sự kiện ngày hôm nay',
                                    style: GetTextStyle.getTextStyle(19, 'Nunito', FontWeight.w700, Color(0xffA7A7A7)),
                                  ),
                                ),
                                SizedBox(
                                  height: UtilsReponsive.height(10, context),
                                ),
                                Obx(
                                  () => controller.listEventToday.isNotEmpty
                                      ? Container(
                                          height: MediaQuery.of(context).size.height / 2.5,
                                          padding: EdgeInsets.all(UtilsReponsive.width(8, context)),
                                          child: GridView.builder(
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemCount: controller.listEventToday.length,
                                            itemBuilder: (context, index) {
                                              return _itemEvent(context: context, eventModel: controller.listEventToday[index]);
                                            },
                                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 1,
                                              mainAxisSpacing: 20,
                                              crossAxisSpacing: 10,
                                              childAspectRatio: 1,
                                            ),
                                          ),
                                        )
                                      : Container(
                                          height: MediaQuery.of(context).size.height / 3,
                                          child: Column(
                                            children: [
                                              Container(
                                                width: UtilsReponsive.width(150, context),
                                                height: UtilsReponsive.height(200, context),
                                                child: Image.asset(ImageAssets.noEvent, fit: BoxFit.fill),
                                              ),
                                              Center(
                                                child: Text(
                                                  'Không có sự kiện cho hôm nay',
                                                  style: GetTextStyle.getTextStyle(18, 'Nunito', FontWeight.w800, ColorsManager.textColor2),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                                SizedBox(
                                  height: UtilsReponsive.height(10, context),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Các sự kiện sắp tới',
                                    style: GetTextStyle.getTextStyle(19, 'Nunito', FontWeight.w700, Color(0xffA7A7A7)),
                                  ),
                                ),
                                SizedBox(
                                  height: UtilsReponsive.height(10, context),
                                ),
                                Obx(
                                  () => controller.listEventUpComing.isNotEmpty
                                      ? Container(
                                          height: MediaQuery.of(context).size.height / 2.5,
                                          // height: MediaQuery.of(context).size.height / 1.38,
                                          padding: EdgeInsets.all(UtilsReponsive.width(8, context)),
                                          child: GridView.builder(
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemCount: controller.listEventUpComing.length,
                                            itemBuilder: (context, index) {
                                              return _itemEvent(context: context, eventModel: controller.listEventUpComing[index]);
                                            },
                                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 1,
                                              mainAxisSpacing: 20,
                                              crossAxisSpacing: 10,
                                              childAspectRatio: 1,
                                            ),
                                          ),
                                        )
                                      : Container(
                                          height: MediaQuery.of(context).size.height / 3,
                                          child: Column(
                                            children: [
                                              Container(
                                                width: UtilsReponsive.width(150, context),
                                                height: UtilsReponsive.height(200, context),
                                                child: Image.asset(ImageAssets.noEvent, fit: BoxFit.fill),
                                              ),
                                              Center(
                                                child: Text(
                                                  'Không có sự kiện sắp tới',
                                                  style: GetTextStyle.getTextStyle(18, 'Nunito', FontWeight.w800, ColorsManager.textColor2),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _itemEvent({required BuildContext context, required EventModel eventModel}) {
    return GestureDetector(
      onTap: () {
        controller.onTapEvent(eventID: eventModel.id!, eventName: eventModel.eventName!);
      },
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            UtilsReponsive.height(15, context),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Màu của shadow và độ mờ
              spreadRadius: 2, // Độ lan rộng của shadow
              blurRadius: 5, // Độ mờ của shadow
              offset: const Offset(0, 1), // Độ dịch chuyển của shadow
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
          child: Column(
            children: [
              Container(
                height: UtilsReponsive.height(140, context),
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
                  fit: BoxFit.fill,
                  imageUrl: eventModel.coverUrl!,
                  imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            UtilsReponsive.height(15, context),
                          ),
                          border: Border.all(width: 1.5, color: Theme.of(context).scaffoldBackgroundColor),
                          image: DecorationImage(fit: BoxFit.fill, image: imageProvider))),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        eventModel.eventName!,
                        overflow: TextOverflow.ellipsis,
                        style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w800, ColorsManager.textColor),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      'Ngày bắt đầu: ',
                      style: GetTextStyle.getTextStyle(15, 'Nunito', FontWeight.w600, ColorsManager.textColor2),
                    ),
                    Text(
                      DateFormat('dd-MM-yyyy').format(eventModel.startDate!),
                      style: GetTextStyle.getTextStyle(15, 'Nunito', FontWeight.w800, ColorsManager.textColor),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      'Ngày diễn ra: ',
                      style: GetTextStyle.getTextStyle(15, 'Nunito', FontWeight.w600, ColorsManager.textColor2),
                    ),
                    Text(
                      DateFormat('dd-MM-yyyy').format(eventModel.endDate!),
                      style: GetTextStyle.getTextStyle(15, 'Nunito', FontWeight.w800, Colors.blueAccent),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Text(
                      'Ngày Kết thúc: ',
                      style: GetTextStyle.getTextStyle(15, 'Nunito', FontWeight.w600, ColorsManager.textColor2),
                    ),
                    Text(
                      DateFormat('dd-MM-yyyy').format(eventModel.endDate!),
                      style: GetTextStyle.getTextStyle(15, 'Nunito', FontWeight.w800, ColorsManager.textColor),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3.0), // Thêm padding cho khoảng cách giữa văn bản và viền của Container
                      decoration: BoxDecoration(
                        color: eventModel.status == "PENDING"
                            ? Colors.blueGrey
                            : eventModel.status == "PREPARING"
                                ? Colors.orangeAccent
                                : eventModel.status == "PROCESSING"
                                    ? Colors.blueAccent
                                    : Colors.greenAccent, // Đặt màu nền của Container là màu trắng
                        borderRadius: BorderRadius.circular(10.0), // Đặt bo tròn cho viền của Container
                      ),
                      child: Text(
                        eventModel.status == "PENDING"
                            ? "Chưa bắt đầu"
                            : eventModel.status == "PREPARING"
                                ? "Đang chuẩn bị"
                                : eventModel.status == "PROCESSING"
                                    ? "Đang diễn ra"
                                    : "Đã kết thúc",
                        style: TextStyle(
                            fontFamily: 'Nunito', fontWeight: FontWeight.w800, fontSize: UtilsReponsive.height(15, context), color: Colors.white),
                      ),
                    )
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
    return query.isNotEmpty
        ? [
            IconButton(
                onPressed: () {
                  query = '';
                },
                icon: const Icon(Icons.clear))
          ]
        : [];
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
    try {
      throw UnimplementedError();
    } catch (e) {
      // Bắt lỗi ở đây
      // Có thể log lỗi hoặc thực hiện các hành động khác nếu cần
      // Ví dụ: print("Có lỗi xảy ra: $e");
      return SizedBox(); // Trả về một widget trống để ẩn thông báo lỗi
    }
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
        return query.isNotEmpty
            ? GestureDetector(
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
                      result.eventName!.length > 20 ? '${result.eventName!.substring(0, 20)}...' : result.eventName!,
                      style: GetTextStyle.getTextStyle(18, 'Nunito', FontWeight.w800, ColorsManager.textColor),
                    ),
                  ],
                )),
              )
            : SizedBox();
      },
    );
  }
}
