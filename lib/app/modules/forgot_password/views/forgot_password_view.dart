import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_view.dart';
import 'package:hrea_mobile_employee/app/resources/color_manager.dart';
import 'package:hrea_mobile_employee/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_employee/app/resources/style_manager.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';

import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends BaseView<ForgotPasswordController> {
  const ForgotPasswordView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: ColorsManager.primary,
          elevation: 0,
        ),
        body: SafeArea(
          child: Column(
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
                    'Quên mật khẩu?',
                    style: GetTextStyle.getTextStyle(30, 'Nunito', FontWeight.w700, ColorsManager.primary),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: UtilsReponsive.width(20, context),
                  vertical: UtilsReponsive.height(10, context),
                ),
                child: Text(
                  'Hãy nhập email và chúng tôi sẽ gửi mã code cho bạn.',
                  style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w500, ColorsManager.colorIcon),
                ),
              ),
              SizedBox(
                height: UtilsReponsive.height(15, context),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: UtilsReponsive.width(20, context),
                ),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => {controller.setEmail(value)},
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: ColorsManager.textInput,
                    hintText: "Email",
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.grey[600]!,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: UtilsReponsive.height(30, context),
              ),
              Obx(
                () => Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: UtilsReponsive.width(20, context),
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: controller.disableButton.value ? Colors.grey : ColorsManager.primary,
                    ),
                    child: MaterialButton(
                      onPressed: controller.disableButton.value
                          ? null
                          : () async {
                              await controller.sendOtp();
                              controller.errorForgotPassword.value ? _errorMessage(Get.context!) : _successMessage(Get.context!);
                            },
                      child: controller.isLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: ColorsManager.backgroundWhite,
                              ),
                            )
                          : Text(
                              "Lấy lại mật khẩu",
                              style: GetTextStyle.getTextStyle(20, 'Nunito', FontWeight.w400, Colors.white),
                            ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: UtilsReponsive.height(20, context),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Đã nhớ mật khẩu? ',
                    style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w500, Colors.black),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.offAllNamed(Routes.LOGIN);
                    },
                    child: Text(
                      'Đăng nhập',
                      style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w700, ColorsManager.primary),
                    ),
                  )
                ],
              )
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
                  style: GetTextStyle.getTextStyle(18, 'Nunito', FontWeight.w800, Colors.white),
                ),
                Spacer(),
                Text(
                  'Gửi mã thành công',
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
                    controller.errorForgotPasswordText.value,
                    style: GetTextStyle.getTextStyle(12, 'Nunito', FontWeight.w500, Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
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
}
