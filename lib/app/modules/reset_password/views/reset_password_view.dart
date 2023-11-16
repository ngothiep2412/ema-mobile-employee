import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_view.dart';
import 'package:hrea_mobile_employee/app/resources/color_manager.dart';
import 'package:hrea_mobile_employee/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_employee/app/resources/style_manager.dart';
import '../controllers/reset_password_controller.dart';

class ResetPasswordView extends BaseView<ResetPasswordController> {
  const ResetPasswordView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsManager.primary,
          elevation: 0,
        ),
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
                    'Tạo mật khẩu mới',
                    style: GetTextStyle.getTextStyle(30, 'Roboto', FontWeight.w700, ColorsManager.primary),
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
              //         16, 'Roboto', FontWeight.w500, ColorsManager.colorIcon),
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
                          obscureText: controller.passwordObscured.value,
                          onChanged: (value) => {controller.setPassword(value)},
                          decoration: InputDecoration(
                              errorBorder: InputBorder.none,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: ColorsManager.textInput,
                              hintText: "Mật khẩu",
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.grey[600]!,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  controller.passwordObscured.value = !controller.passwordObscured.value;
                                },
                                icon: Icon(
                                  controller.passwordObscured.value ? Icons.visibility_off : Icons.visibility,
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
                              controller.errorResetPassword.value ? _errorMessage(context) : _successMessage(context);
                            },
                            child: controller.isLoading.value
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: ColorsManager.primary,
                                    ),
                                  )
                                : Text(
                                    "Đặt lại mật khẩu",
                                    style: GetTextStyle.getTextStyle(20, 'Roboto', FontWeight.w400, Colors.white),
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
                  style: GetTextStyle.getTextStyle(18, 'Roboto', FontWeight.w800, Colors.white),
                ),
                Spacer(),
                Text(
                  'Tạo mới mật khẩu thành công',
                  style: GetTextStyle.getTextStyle(12, 'Roboto', FontWeight.w500, Colors.white),
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
                    style: GetTextStyle.getTextStyle(18, 'Roboto', FontWeight.w800, Colors.white),
                  ),
                  const Spacer(),
                  Obx(
                    () => Text(
                      controller.errorResetPasswordText.value,
                      style: GetTextStyle.getTextStyle(12, 'Roboto', FontWeight.w500, Colors.white),
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
