import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_view.dart';
import 'package:hrea_mobile_employee/app/resources/color_manager.dart';
import 'package:hrea_mobile_employee/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_employee/app/resources/style_manager.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends BaseView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.backgroundContainer,
      body: SafeArea(
        child: Column(children: [
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () => {
                          Get.back(),
                          controller.onDelete(),
                        },
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: ColorsManager.primary,
                    )),
                SizedBox(
                  width: UtilsReponsive.width(5, context),
                ),
                Expanded(
                  child: Text(
                    "Thay đổi thông tin",
                    style: GetTextStyle.getTextStyle(20, 'Nunito', FontWeight.w600, ColorsManager.primary),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 10,
            child: Padding(
              padding: UtilsReponsive.paddingHorizontal(context, padding: 20),
              child: ListView(
                children: [
                  SizedBox(
                    height: UtilsReponsive.heightv2(context, 15),
                  ),
                  Center(
                    child: Stack(
                      children: [
                        Obx(
                          () => CircleAvatar(
                            backgroundColor: ColorsManager.backgroundBlackGrey, // Màu nền mà bạn muốn
                            radius: 60, // Điều chỉnh kích thước hình tròn theo ý muốn
                            child: controller.selectImagePath.value.isEmpty
                                ? Container(
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
                                      imageUrl: controller.userModelView.value.result!.avatar!,
                                      // imageUrl:
                                      //     'https://preview.keenthemes.com/metronic-v4/theme/assets/pages/media/profile/profile_user.jpg',
                                      imageBuilder: (context, imageProvider) => Container(
                                          width: UtilsReponsive.width(150, context),
                                          height: UtilsReponsive.height(150, context),
                                          decoration: BoxDecoration(
                                              border: Border.all(width: 4, color: ColorsManager.backgroundBlackGrey),
                                              boxShadow: [
                                                BoxShadow(
                                                    spreadRadius: 2,
                                                    blurRadius: 10,
                                                    color: Colors.black.withOpacity(0.1),
                                                    offset: const Offset(0, 10))
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
                                  )
                                : ClipOval(
                                    child: Image.file(
                                      File(controller.selectImagePath.value),
                                      fit: BoxFit.cover,
                                      width: UtilsReponsive.widthv2(context, 120), // Kích thước của hình ảnh
                                      height: UtilsReponsive.heightv2(context, 145),
                                    ),
                                  ),
                          ),
                        ),
                        Positioned(
                            bottom: 0,
                            right: -5,
                            child: Container(
                              height: UtilsReponsive.heightv2(context, 50),
                              width: UtilsReponsive.widthv2(context, 50),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 4,
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                ),
                                color: ColorsManager.primary,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  showAlertDialog(context);
                                },
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: UtilsReponsive.heightv2(context, 25),
                  ),
                  Text(
                    'Họ và tên',
                    style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, ColorsManager.primary),
                  ),
                  SizedBox(
                    height: UtilsReponsive.heightv2(context, 10),
                  ),
                  buildTextField(context, "Họ và tên", "Ví dụ: Thiệp", controller.fullNameController),
                  // buildTextField(context, "E-mail", "Ví dụ: hrea@gmail.com",
                  //     controller.emailController),
                  Text(
                    'Địa chỉ',
                    style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, ColorsManager.primary),
                  ),
                  SizedBox(
                    height: UtilsReponsive.heightv2(context, 10),
                  ),
                  buildTextField(context, "Địa chỉ", "Ví dụ: thành Phố Hồ Chí Minh", controller.addressController),
                  Text(
                    'Ngày sinh',
                    style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, ColorsManager.primary),
                  ),
                  SizedBox(
                    height: UtilsReponsive.heightv2(context, 10),
                  ),
                  buildTextFieldDate(
                    context,
                    "Ngày sinh",
                    "Ví dụ: 2001/24/12",
                  ),
                  Text(
                    'Số điện thoại',
                    style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, ColorsManager.primary),
                  ),
                  SizedBox(
                    height: UtilsReponsive.heightv2(context, 10),
                  ),
                  buildTextField(context, "Số điện thoại", "Ví dụ: 0905952718", controller.phoneController),
                  Text(
                    'Giới tính',
                    style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, ColorsManager.primary),
                  ),
                  SizedBox(
                    height: UtilsReponsive.heightv2(context, 10),
                  ),
                  DropdownButtonFormField(
                    items: controller.genderList
                        .map((e) => DropdownMenuItem(
                              child: Text(e),
                              value: e,
                            ))
                        .toList(),
                    onChanged: (value) {
                      controller.setGender(value as String);
                    },
                    value: controller.selectedGenderVal.value == "MALE" ? "Nam" : "Nữ",
                    icon: Icon(
                      Icons.arrow_drop_down_circle,
                      color: ColorsManager.primary,
                    ),
                    decoration: const InputDecoration(
                        // labelText: 'Giới tính',
                        errorBorder: InputBorder.none,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        fillColor: ColorsManager.textInput,
                        filled: true),
                  ),
                  SizedBox(
                    height: UtilsReponsive.heightv2(context, 20),
                  ),
                  Obx(
                    () => Container(
                      height: UtilsReponsive.heightv2(context, 60),
                      child: ElevatedButton(
                        onPressed: () async {
                          await controller.updateProfile();

                          controller.errorUpdateProfile.value ? _errorMessage(context) : _successMessage(context);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0), // Đặt border radius theo mong muốn
                          ),
                        ),
                        child: controller.isLoading.value
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: ColorsManager.primary,
                                ),
                              )
                            : Text(
                                "Cập nhật",
                                style: GetTextStyle.getTextStyle(
                                  14,
                                  'Nunito',
                                  FontWeight.w800,
                                  ColorsManager.backgroundWhite,
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget buildTextField(
    BuildContext context,
    String labelText,
    String hintText,
    TextEditingController? nameTextEditingController,
  ) {
    return Padding(
      padding: UtilsReponsive.paddingOnly(context, bottom: 10),
      child: TextField(
        controller: nameTextEditingController,
        decoration: InputDecoration(
          errorBorder: InputBorder.none,
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: ColorsManager.textInput,
          // labelText: labelText,
          // labelStyle: TextStyle(color: ColorsManager.primary, fontSize: 20),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: hintText,
          hintStyle: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w400, ColorsManager.textColor2),
        ),
      ),
    );
  }

  Widget buildTextFieldDate(
    BuildContext context,
    String labelText,
    String hintText,
  ) {
    return Padding(
      padding: UtilsReponsive.paddingOnly(context, bottom: 10),
      child: TextField(
        controller: controller.dateController,
        decoration: InputDecoration(
          errorBorder: InputBorder.none,
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              controller.chooseDate();
            },
            icon: Icon(
              Icons.calendar_today_rounded,
              color: Colors.grey[600]!,
            ),
          ),
          filled: true,
          fillColor: ColorsManager.textInput,
          // labelText: labelText,
          // labelStyle: TextStyle(color: ColorsManager.primary, fontSize: 20),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: hintText,
          hintStyle: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w400, ColorsManager.textColor2),
        ),
      ),
    );
  }

  void showAlertDialog(BuildContext context) {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          Get.back();
          controller.selectImage(ImageSource.gallery);
        },
        child: const Text('Gallery'));
    Widget cameraButton = ElevatedButton(
        onPressed: () {
          Get.back();
          controller.selectImage(ImageSource.camera);
        },
        child: const Text('Camera'));

    AlertDialog alertDialog = AlertDialog(
      title: Text('Select option'),
      actions: [
        galleryButton,
        cameraButton,
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
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
                Spacer(),
                Text(
                  'Thay đổi thông tin cá nhân thành công',
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
                      controller.errorUpdateProfileText.value,
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
