import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/modules/chat_detail/models/chat_message.dart';
import 'package:hrea_mobile_employee/app/resources/assets_manager.dart';
import 'package:hrea_mobile_employee/app/resources/color_manager.dart';
import 'package:hrea_mobile_employee/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_employee/app/resources/style_manager.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';
import 'package:hrea_mobile_employee/app/utils/calculate_time_difference.dart';

import '../controllers/chat_detail_controller.dart';

class ChatDetailView extends GetView<ChatDetailController> {
  const ChatDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.only(right: UtilsReponsive.height(16, context)),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Obx(
                    () => Stack(children: [
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.PROFILE_CHAT, arguments: {"idUserChat": controller.userIDChat});
                        },
                        child: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(controller.avatar),
                          maxRadius: 20,
                        ),
                      ),
                      controller.checkOnline.value
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
                    ]),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.PROFILE_CHAT, arguments: {"idUserChat": controller.userIDChat});
                            },
                            child: Text(
                              controller.name,
                              style: TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Nunito', color: Colors.black),
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            controller.checkOnline.value ? "Trực tuyến" : "Ngoại tuyến",
                            style: TextStyle(
                                color: controller.checkOnline.value ? Colors.green : Colors.grey.shade300, fontSize: 12, fontFamily: 'Nunito'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: Icon(
                  //     CupertinoIcons.phone_solid,
                  //     color: ColorsManager.primary,
                  //   ),
                  // ),
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: Icon(
                  //     CupertinoIcons.video_camera_solid,
                  //     color: ColorsManager.primary,
                  //     size: 30,
                  //   ),
                  // ),
                ],
              ),
            ),
          )),
      body: Obx(
        () => Column(
          children: [
            Obx(
              () => Expanded(
                child: Stack(children: [
                  controller.isLoading.value == true
                      ? Center(
                          child: SpinKitFadingCircle(
                            color: ColorsManager.primary,
                            // size: 30.0,
                          ),
                        )
                      : controller.checkInView.value == false
                          ? Container(
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
                            )
                          : ListView.builder(
                              controller: controller.scrollController,
                              reverse: true,
                              itemCount: controller.chatMessages.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              // physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                if (index == controller.chatMessages.length - 1 && controller.isMoreDataAvailable.value == true) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return chatBubble(
                                  chatMessage: controller.chatMessages[index],
                                  index: index,
                                );
                              },
                            ),
                  controller.isScrollDown.value
                      ? Positioned(
                          bottom: 20,
                          right: MediaQuery.of(context).size.width / 2.15,
                          child: GestureDetector(
                            onTap: () {
                              controller.scrollDown();
                            },
                            child: Container(
                              width: UtilsReponsive.height(40, context),
                              height: UtilsReponsive.height(40, context),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white, // Màu nền là màu trắng
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5), // Màu của shadow
                                    spreadRadius: 1, // Bán kính mở rộng của shadow
                                    blurRadius: 1, // Bán kính mờ của shadow
                                    offset: Offset(0, 1), // Vị trí của shadow (ngang, dọc)
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.arrow_downward_rounded, // chọn icon mũi tên xuống
                                size: 20, // kích thước của icon
                                color: Colors.black, // màu của icon
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),
                ]),
              ),
            ),
            controller.checkInView.value == false
                ? const SizedBox()
                : Container(
                    height: UtilsReponsive.height(60, context),
                    padding: EdgeInsets.only(bottom: 10),
                    width: double.infinity,
                    color: Colors.white,
                    child: Row(
                      children: [
                        Obx(
                          () => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: TextFormField(
                                controller: controller.textEditingController.value,
                                onChanged: (val) {
                                  if (controller.textEditingController.value.text.isNotEmpty) {
                                    controller.checkTyping.value = true;
                                  } else {
                                    controller.checkTyping.value = false;
                                  }
                                },
                                style: const TextStyle(fontSize: 14),
                                decoration: const InputDecoration(
                                  hintText: 'Nhập gì đó...',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Obx(
                          () => controller.checkTyping.value
                              ? Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: ColorsManager.primary,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: ColorsManager.primary.withOpacity(0.3),
                                        spreadRadius: 8,
                                        blurRadius: 24,
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: Material(
                                      color: ColorsManager.primary,
                                      child: InkWell(
                                        splashColor: Colors.green,
                                        onTap: () async {
                                          await controller.createAMessage(controller.textEditingController.value.text);
                                          // controller.scrollController.animateTo(controller.scrollController.position.minScrollExtent,
                                          //     duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
                                        },
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: Icon(
                                            Icons.send_rounded,
                                            size: 26,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                        ),
                        SizedBox(
                          width: 10,
                        )
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget chatBubble({required ChatMessage chatMessage, required int index}) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          controller.showTime.value = !controller.showTime.value;
          controller.indexChat.value = index;
        },
        child: Container(
          padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
          child: Column(children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 100),
              height: (controller.showTime.value && controller.indexChat.value == index) ? 20 : 0,
              child: Opacity(
                opacity: (controller.showTime.value && controller.indexChat.value == index) ? 1 : 0,
                child: Text(
                  '${calculateTimeDifferenceMessenger(chatMessage.time!)}',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
            // SizedBox(height: 5),
            Align(
              alignment: (chatMessage.type == MessageType.Receiver ? Alignment.topLeft : Alignment.topRight),
              child: Container(
                decoration: chatMessage.type == MessageType.Receiver
                    ? BoxDecoration(
                        borderRadius:
                            BorderRadius.only(bottomRight: Radius.circular(15), topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                        color: Colors.grey.shade400)
                    : BoxDecoration(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                        color: Colors.blueAccent,
                      ),
                padding: EdgeInsets.all(14),
                child: Text(
                  chatMessage.message,
                  style: TextStyle(
                      fontSize: 14,
                      color: chatMessage.type == MessageType.Receiver ? ColorsManager.textColor : Colors.white,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Nunito'),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
