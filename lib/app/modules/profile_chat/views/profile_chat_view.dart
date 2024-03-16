import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import 'package:hrea_mobile_employee/app/base/base_view.dart';
import 'package:hrea_mobile_employee/app/resources/assets_manager.dart';
import 'package:hrea_mobile_employee/app/resources/color_manager.dart';
import 'package:hrea_mobile_employee/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_employee/app/resources/style_manager.dart';

import '../controllers/profile_chat_controller.dart';

class ProfileChatView extends BaseView<ProfileChatController> {
  const ProfileChatView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.withOpacity(0.9),
      body: SafeArea(
        child: Column(
          children: [
            Row(
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
                    'Thông tin chi tiết',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily: 'Nunito',
                        letterSpacing: 0.5,
                        color: ColorsManager.backgroundWhite,
                        fontSize: UtilsReponsive.height(26, context),
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            Obx(
              () => Expanded(
                flex: 4,
                child: controller.isLoading.value
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
                        : SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0, bottom: 20, left: 20, right: 20),
                              child: Column(
                                children: [
                                  const SizedBox(height: 20),
                                  CachedNetworkImage(
                                    // fit: BoxFit.contain,
                                    imageUrl: controller.userChatView.value.result!.avatar!,
                                    // imageUrl:
                                    //     'https://preview.keenthemes.com/metronic-v4/theme/assets/pages/media/profile/profile_user.jpg',
                                    imageBuilder: (context, imageProvider) => Container(
                                        width: UtilsReponsive.width(150, context),
                                        height: UtilsReponsive.height(150, context),
                                        decoration: BoxDecoration(
                                            border: Border.all(width: 2, color: ColorsManager.backgroundWhite),
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
                                  const SizedBox(height: 20),
                                  itemProfile('Họ và tên', '${controller.userChatView.value.result!.fullName}', CupertinoIcons.person, context),
                                  const SizedBox(height: 10),
                                  itemProfile('Chức vụ', '${controller.userChatView.value.result!.role}', Icons.build_outlined, context),
                                  const SizedBox(height: 10),
                                  itemProfile(
                                      'Nhóm', controller.userChatView.value.result!.divisionName ?? "Không có", Icons.ballot_outlined, context),
                                  const SizedBox(height: 10),
                                  itemProfile(
                                      'Số điện thoại', '${controller.userChatView.value.result!.phoneNumber}', CupertinoIcons.phone, context),
                                  const SizedBox(height: 10),
                                  itemProfile('Địa chỉ', '${controller.userChatView.value.result!.address}', CupertinoIcons.location, context),
                                  const SizedBox(height: 10),
                                  itemProfile('Email', '${controller.userChatView.value.result!.email}', CupertinoIcons.mail, context),
                                ],
                              ),
                            ),
                          ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget itemProfile(String title, String subtitle, IconData iconData, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: UtilsReponsive.height(10, context)),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(offset: const Offset(0, 5), color: Colors.blueGrey.withOpacity(.2), spreadRadius: 2, blurRadius: 10)]),
      child: InkWell(
        onTap: () {
          // Xử lý sự kiện khi bấm vào container
        },
        borderRadius: BorderRadius.circular(15), // Áp dụng borderRadius cho InkWell
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(
                iconData,
                color: Colors.blueAccent,
              ),
              const SizedBox(width: 15),
              Expanded(
                // Sử dụng Expanded để mở rộng văn bản
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        letterSpacing: 0.5,
                        color: ColorsManager.textColor2,
                        fontSize: UtilsReponsive.height(15, context),
                        fontWeight: FontWeight.w800,
                      ),
                      overflow: TextOverflow.ellipsis, // Áp dụng overflow cho văn bản
                    ),
                    const SizedBox(height: 10),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        letterSpacing: 0.5,
                        color: ColorsManager.textColor,
                        fontSize: UtilsReponsive.height(15, context),
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
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
