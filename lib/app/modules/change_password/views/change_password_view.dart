import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_view.dart';
import 'package:hrea_mobile_employee/app/resources/color_manager.dart';
import 'package:hrea_mobile_employee/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_employee/app/resources/style_manager.dart';

import '../controllers/change_password_controller.dart';

class ChangePasswordView extends BaseView<ChangePasswordController> {
  const ChangePasswordView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
        appBar: _appBar(context),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: UtilsReponsive.height(20, context),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: UtilsReponsive.width(20, context),
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    'Thay đổi mật khẩu',
                    style: GetTextStyle.getTextStyle(22, 'Nunito', FontWeight.w700, ColorsManager.primary),
                  ),
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.symmetric(
              //     horizontal: UtilsReponsive.width(20,context),
              //     vertical: UtilsReponsive.height(10,context),
              //   ),
              //   child: Text(
              //     'H',
              //     style: GetTextStyle.getTextStyle(
              //         16, 'Nunito', FontWeight.w500, ColorsManager.colorIcon),
              //   ),
              // ),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(40))),
                child: Padding(
                  padding: UtilsReponsive.paddingAll(context, padding: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Obx(
                        () => TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: controller.oldPasswordObscured.value,
                          onChanged: (value) => {controller.setOldPassword(value)},
                          decoration: InputDecoration(
                              errorBorder: InputBorder.none,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: ColorsManager.textInput,
                              hintText: "Mật khẩu cũ",
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.grey[600]!,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  controller.oldPasswordObscured.value = !controller.oldPasswordObscured.value;
                                },
                                icon: Icon(
                                  controller.oldPasswordObscured.value ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.grey[600]!,
                                ),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: UtilsReponsive.height(30, context),
                      ),
                      Obx(
                        () => TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: controller.newPasswordObscured.value,
                          onChanged: (value) => {controller.setNewPassword(value)},
                          decoration: InputDecoration(
                              errorBorder: InputBorder.none,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: ColorsManager.textInput,
                              hintText: "Mật khẩu mới",
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.grey[600]!,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  controller.newPasswordObscured.value = !controller.newPasswordObscured.value;
                                },
                                icon: Icon(
                                  controller.newPasswordObscured.value ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.grey[600]!,
                                ),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: UtilsReponsive.height(30, context),
                      ),
                      Obx(
                        () => TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: controller.confirmPasswordObscured.value,
                          onChanged: (value) => {controller.setConfirmPassword(value)},
                          decoration: InputDecoration(
                              errorBorder: InputBorder.none,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: ColorsManager.textInput,
                              hintText: "Xác nhận mật khẩu",
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.grey[600]!,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  controller.confirmPasswordObscured.value = !controller.confirmPasswordObscured.value;
                                },
                                icon: Icon(
                                  controller.confirmPasswordObscured.value ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.grey[600]!,
                                ),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: UtilsReponsive.height(40, context),
                      ),
                      Obx(
                        () => Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: ColorsManager.primary,
                          ),
                          child: MaterialButton(
                            onPressed: () async {
                              await controller.resetPassword();
                              controller.errorChangePassword.value ? _errorMessage(Get.context!) : _successMessage(Get.context!);
                            },
                            child: controller.isLoading.value
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: ColorsManager.primary,
                                    ),
                                  )
                                : Text(
                                    "Lưu",
                                    style: GetTextStyle.getTextStyle(20, 'Nunito', FontWeight.w400, Colors.white),
                                  ),
                          ),
                        ),
                      ),
                    ],
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
    );
  }

  _successMessage(BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        content: Container(
          padding: UtilsReponsive.paddingAll(context, padding: 8),
          height: UtilsReponsive.height(80, context),
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
                  'Thay đổi mật khẩu thành công',
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
          height: UtilsReponsive.height(80, context),
          decoration: const BoxDecoration(color: Color.fromARGB(255, 219, 90, 90), borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Row(children: [
            const Icon(
              Icons.error_outline,
              color: ColorsManager.backgroundWhite,
              size: 40,
            ),
            SizedBox(
              width: UtilsReponsive.width(12, context),
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
                      controller.errorChangePasswordText.value,
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
