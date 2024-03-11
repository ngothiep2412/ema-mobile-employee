import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_employee/app/base/base_view.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/controllers/tab_setting_controller/tab_setting_controller.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/user_model.dart';
import 'package:hrea_mobile_employee/app/resources/color_manager.dart';
import 'package:hrea_mobile_employee/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_employee/app/resources/style_manager.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';

class TabSettingView extends BaseView<TabSettingController> {
  const TabSettingView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return controller.isLoading.value == true
        ? Center(
            child: SpinKitWave(
              color: ColorsManager.primary,
              size: 30.0,
            ),
          )
        : Container(
            padding: UtilsReponsive.paddingOnly(context, left: 16, top: 25, right: 16),
            child: ListView(
              children: [
                Center(
                  child: Text(
                    'Khác',
                    style: GetTextStyle.getTextStyle(22, 'Nunito', FontWeight.w800, ColorsManager.primary),
                  ),
                ),
                SizedBox(
                  height: UtilsReponsive.height(30, context),
                ),
                Center(
                  child: Stack(
                    children: [
                      Obx(
                        () => Container(
                          width: UtilsReponsive.width(150, context),
                          height: UtilsReponsive.height(150, context),
                          decoration: BoxDecoration(
                            border: Border.all(width: 4, color: ColorsManager.primary),
                            boxShadow: const [
                              // BoxShadow(
                              //   spreadRadius: 2,
                              //   blurRadius: 10,
                              //   color: Colors.white12,
                              //   offset: Offset(0, 10),
                              // )
                            ],
                            shape: BoxShape.circle,
                          ),
                          child: CachedNetworkImage(
                            // fit: BoxFit.contain,
                            imageUrl: controller.userModel.value.result!.avatar!,
                            // imageUrl:
                            //     'https://preview.keenthemes.com/metronic-v4/theme/assets/pages/media/profile/profile_user.jpg',
                            imageBuilder: (context, imageProvider) => Container(
                                width: UtilsReponsive.width(150, context),
                                height: UtilsReponsive.height(150, context),
                                decoration: BoxDecoration(
                                    border: Border.all(width: 4, color: Theme.of(context).scaffoldBackgroundColor),
                                    boxShadow: [
                                      BoxShadow(spreadRadius: 2, blurRadius: 10, color: Colors.black.withOpacity(0.1), offset: const Offset(0, 10))
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
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: UtilsReponsive.height(10, context),
                ),
                Obx(
                  () => Center(
                    child: Text(
                      controller.userModel.value.result!.fullName!,
                      style: GetTextStyle.getTextStyle(17, 'Nunito', FontWeight.w600, ColorsManager.primary),
                    ),
                  ),
                ),
                SizedBox(
                  height: UtilsReponsive.heightv2(context, 10),
                ),
                Obx(
                  () => Center(
                    child: Text(
                      controller.userModel.value.result!.email!,
                      style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w500, ColorsManager.textColor2),
                    ),
                  ),
                ),
                SizedBox(
                  height: UtilsReponsive.heightv2(context, 10),
                ),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Đơn vị công tác:',
                        style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w500, ColorsManager.textColor2),
                      ),
                      SizedBox(
                        width: UtilsReponsive.heightv2(context, 10),
                      ),
                      Text(
                        controller.userModel.value.result!.divisionName!,
                        style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w700, ColorsManager.textColor2),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: UtilsReponsive.heightv2(context, 30),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: ColorsManager.primary,
                    ),
                    SizedBox(
                      width: UtilsReponsive.widthv2(context, 8),
                    ),
                    Text(
                      "Tài khoản",
                      style: GetTextStyle.getTextStyle(20, 'Nunito', FontWeight.w700, ColorsManager.primary),
                    ),
                  ],
                ),
                Divider(
                  height: UtilsReponsive.heightv2(context, 20),
                  thickness: 2,
                ),
                Obx(
                  () => buildAccountOptionRow(context, "Thay đổi thông tin", Routes.PROFILE, controller.userModel.value),
                ),
                buildAccountOptionRow(context, "Thay đổi mật khẩu", Routes.CHANGE_PASSWORD, null),
                buildAccountOptionRow(context, "Quyền riêng tư và bảo mật", Routes.POLICY, null),
                SizedBox(
                  height: UtilsReponsive.heightv2(context, 40),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        padding: UtilsReponsive.paddingHorizontal(context, padding: 40),
                        child: OutlinedButton(
                          style: ButtonStyle(
                            side: MaterialStateProperty.resolveWith<BorderSide>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return const BorderSide(
                                    color: Colors.white,
                                  );
                                }
                                return BorderSide(
                                  color: ColorsManager.primary,
                                );
                              },
                            ),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0), // Điều chỉnh độ cong của viền
                              ),
                            ),
                            // Bất kỳ thuộc tính khác mà bạn muốn tùy chỉnh, ví dụ: màu nền
                            backgroundColor: MaterialStateProperty.all(ColorsManager.backgroundWhite),
                          ),
                          onPressed: () async {
                            // Xử lý sự kiện khi nút được nhấn
                            GetStorage().remove('JWT');
                            GetStorage().remove('Email');
                            Get.offAndToNamed(Routes.LOGIN);
                          },
                          child: Text(
                            "Đăng xuất",
                            style: GetTextStyle.getTextStyle(
                              20,
                              'Nunito',
                              FontWeight.w700,
                              ColorsManager.primary,
                            ),
                          ),
                        )),
                  ],
                )
              ],
            ),
          );
  }

  GestureDetector buildAccountOptionRow(BuildContext context, String title, String routeName, UserModel? usermodel) {
    return GestureDetector(
      onTap: () {
        if (usermodel != null) {
          Get.toNamed(routeName, arguments: {'userModel': usermodel});
        } else {
          Get.toNamed(routeName);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GetTextStyle.getTextStyle(18, 'Nunito', FontWeight.w600, ColorsManager.primary),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
