import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:get/get.dart';

import 'package:hrea_mobile_employee/app/base/base_view.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/controllers/tab_chat_controller/tab_chat_controller.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/chat_user.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/user_division_model.dart';
import 'package:hrea_mobile_employee/app/resources/assets_manager.dart';

import 'package:hrea_mobile_employee/app/resources/color_manager.dart';
import 'package:hrea_mobile_employee/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_employee/app/resources/style_manager.dart';
import 'package:hrea_mobile_employee/app/utils/calculate_time_difference.dart';
import 'package:hrea_mobile_employee/app/utils/check_vietnamese.dart';

class TabChatView extends BaseView<TabChatController> {
  const TabChatView({Key? key}) : super(key: key);
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
                  // size: 30.0,
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
                : Column(children: [
                    Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Đoạn chat',
                              style: GetTextStyle.getTextStyle(22, 'Nunito', FontWeight.w800, ColorsManager.primary),
                            ),
                          ),
                        ),
                        // Icon(
                        //   Icons.filter_alt_outlined,
                        //   color: ColorsManager.primary,
                        // ),
                        // SizedBox(
                        //   width: UtilsReponsive.width(10, context),
                        // ),
                      ],
                    ),
                    SizedBox(
                      height: UtilsReponsive.height(20, context),
                    ),
                    Expanded(
                      flex: 1,
                      child: RefreshIndicator(
                          onRefresh: controller.refreshpage,
                          child: ListView(
                            // controller: controller.scrollController,
                            children: [
                              GestureDetector(
                                onTap: () => showSearch(
                                  context: context,
                                  delegate: CustomSearch(listUserDivision: controller.listAllUser, listUserOnline: controller.listUserOnline),
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
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
                                      const Icon(
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
                                height: UtilsReponsive.height(20, context),
                              ),
                              SizedBox(
                                height: UtilsReponsive.height(100, context), // Adjust the height as needed
                                child: Obx(
                                  () => ListView.separated(
                                    separatorBuilder: (context, index) => SizedBox(
                                      width: UtilsReponsive.height(20, context),
                                    ),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: controller.listAllUser.length, // Provide the item count
                                    itemBuilder: (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Get.toNamed('/chat-detail', arguments: {
                                            "email": controller.listAllUser[index].email,
                                            "userIDChat": controller.listAllUser[index].id,
                                            "name": controller.listAllUser[index].fullName,
                                            "avatar": controller.listAllUser[index].avatar,
                                            "listUserOnline": controller.listUserOnline
                                          });
                                        },
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Stack(
                                              children: [
                                                // User avatar
                                                CircleAvatar(
                                                  radius: 26,
                                                  backgroundImage: CachedNetworkImageProvider('${controller.listAllUser[index].avatar}'),
                                                  backgroundColor: Theme.of(context).cardColor,
                                                ),
                                                // Status indicator positioned relative to the avatar
                                                controller.listAllUser[index].online!
                                                    ? Positioned(
                                                        bottom: 0,
                                                        right: 0,
                                                        child: Container(
                                                          width: 14,
                                                          height: 14,
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: Colors.green, // Màu nền là màu xanh
                                                            border: Border.all(color: Colors.white, width: 2), // Viền trắng xung quanh
                                                          ),
                                                        ))
                                                    : SizedBox(),
                                              ],
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 5.0),
                                                child: Text(
                                                  controller.listAllUser[index].fullName!.length > 10
                                                      ? '${controller.listAllUser[index].fullName!.substring(0, 10)}...'
                                                      : controller.listAllUser[index].fullName!,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontFamily: 'Nunito',
                                                    fontSize: 11,
                                                    letterSpacing: 0.3,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                    SizedBox(
                      height: UtilsReponsive.height(20, context),
                    ),
                    Expanded(
                      flex: 3,
                      child: Obx(
                        () => controller.listChatUser.isNotEmpty
                            ? ListView.builder(
                                controller: controller.scrollController,
                                itemCount: controller.listChatUser.length,
                                shrinkWrap: true,

                                // physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  if (index == controller.listChatUser.length - 1 && controller.isMoreDataAvailable.value == true) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  return chatUsersList(chatUserModel: controller.listChatUser[index], controller: controller);
                                })
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: UtilsReponsive.height(200, context),
                                    child: Image.asset(ImageAssets.noChat, fit: BoxFit.fill),
                                  ),
                                  SizedBox(
                                    height: UtilsReponsive.height(10, context),
                                  ),
                                  Center(
                                    child: Text(
                                      'Bạn chưa có cuộc hội thoại',
                                      style: GetTextStyle.getTextStyle(18, 'Nunito', FontWeight.w800, ColorsManager.textColor2),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    )
                  ]),
      ),
    ));
  }
}

Widget chatUsersList({required ChatUserModel chatUserModel, required TabChatController controller}) {
  return GestureDetector(
    onTap: () {
      if (chatUserModel.creator!.id! == controller.idUser) {
        Get.toNamed('/chat-detail', arguments: {
          "email": chatUserModel.recipient!.email,
          "userIDChat": chatUserModel.recipient!.id,
          "name": chatUserModel.recipient!.profile!.fullName,
          "avatar": chatUserModel.recipient!.profile!.avatar,
          "listUserOnline": controller.listUserOnline
        });
      } else {
        Get.toNamed('/chat-detail', arguments: {
          "email": chatUserModel.creator!.email,
          "userIDChat": chatUserModel.creator!.id,
          "name": chatUserModel.creator!.profile!.fullName,
          "avatar": chatUserModel.creator!.profile!.avatar,
          "listUserOnline": controller.listUserOnline
        });
      }
    },
    child: Container(
      padding: const EdgeInsets.only(left: 5, right: 10, top: 0, bottom: 15),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Stack(children: [
                      CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(chatUserModel.creator!.id == controller.idUser
                            ? chatUserModel.recipient!.profile!.avatar!
                            : chatUserModel.creator!.profile!.avatar!),
                        maxRadius: 25,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: chatUserModel.online != null
                            ? Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green, // Màu nền là màu xanh
                                  border: Border.all(color: Colors.white, width: 2), // Viền trắng xung quanh
                                ))
                            : SizedBox(),
                      ),
                    ]),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                controller.idUser == chatUserModel.recipient!.id
                                    ? '${chatUserModel.creator!.profile!.fullName}'
                                    : '${chatUserModel.recipient!.profile!.fullName}',
                                style: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w700, fontFamily: 'Nunito')),
                            const SizedBox(
                              height: 6,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                chatUserModel.lastMessageSent!.author!.id == controller.idUser
                                    ? Text(
                                        chatUserModel.lastMessageSent!.content!.length > 10
                                            ? 'Bạn: ${chatUserModel.lastMessageSent!.content!.substring(0, 10)}...'
                                            : 'Bạn: ${chatUserModel.lastMessageSent!.content}',
                                        style: const TextStyle(
                                            fontFamily: 'Nunito', fontSize: 14, color: ColorsManager.textColor2, fontWeight: FontWeight.w600),
                                      )
                                    : Text(
                                        chatUserModel.lastMessageSent!.content!.length > 10
                                            ? '${chatUserModel.lastMessageSent!.content!.substring(0, 10)}...'
                                            : '${chatUserModel.lastMessageSent!.content}',
                                        style: const TextStyle(
                                            fontFamily: 'Nunito', fontSize: 14, color: ColorsManager.textColor2, fontWeight: FontWeight.w600),
                                      ),
                                Text(
                                  calculateTimeDifferenceMessenger(chatUserModel.lastMessageSentAt!),
                                  style: const TextStyle(
                                      fontFamily: 'Nunito', fontSize: 14, color: ColorsManager.textColor2, fontWeight: FontWeight.w600),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class CustomSearch extends SearchDelegate {
  RxList<UserDivisionModel> listUserDivision = <UserDivisionModel>[].obs;
  List<UserDivisionModel> listUserOnline = [];
  CustomSearch({required this.listUserDivision, required this.listUserOnline});

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
    RxList<UserDivisionModel> matchQuery = <UserDivisionModel>[].obs;
    for (var item in listUserDivision) {
      final normalizedEventName = removeVietnameseAccent(item.fullName!.toLowerCase());
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
                  Get.toNamed('/chat-detail', arguments: {
                    "email": result.email,
                    "userIDChat": result.id,
                    "name": result.fullName,
                    "avatar": result.avatar,
                    "listUserOnline": listUserOnline
                  });
                },
                child: ListTile(
                    title: Row(
                  children: [
                    result.avatar!.isEmpty
                        ? ClipOval(
                            child: Image.asset(
                              ImageAssets.errorImage,
                              fit: BoxFit.cover,
                              width: UtilsReponsive.widthv2(context, 45),
                              height: UtilsReponsive.heightv2(context, 50),
                            ),
                          )
                        : Container(
                            width: UtilsReponsive.widthv2(context, 45),
                            height: UtilsReponsive.heightv2(context, 50),
                            child: Stack(
                              children: [
                                ClipOval(
                                  child: Image.network(
                                    result.avatar!,
                                    fit: BoxFit.cover,
                                    width: UtilsReponsive.widthv2(context, 45),
                                    height: UtilsReponsive.heightv2(context, 50),
                                  ),
                                ),
                                result.online!
                                    ? Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          width: 14,
                                          height: 14,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.green, // Màu nền là màu xanh
                                            border: Border.all(color: Colors.white, width: 2), // Viền trắng xung quanh
                                          ),
                                        ))
                                    : SizedBox(),
                              ],
                            ),
                          ),
                    SizedBox(
                      width: UtilsReponsive.width(15, context),
                    ),
                    Text(
                      result.fullName!.length > 20 ? '${result.fullName!.substring(0, 20)}...' : result.fullName!,
                      style: GetTextStyle.getTextStyle(15, 'Nunito', FontWeight.w800, ColorsManager.textColor),
                    ),
                  ],
                )),
              )
            : SizedBox();
      },
    );
  }
}
