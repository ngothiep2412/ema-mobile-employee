import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_view.dart';
import 'package:hrea_mobile_employee/app/resources/color_manager.dart';
import 'package:hrea_mobile_employee/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_employee/app/resources/style_manager.dart';
import 'package:pinput/pinput.dart';

import '../controllers/otp_controller.dart';

class OtpView extends BaseView<OtpController> {
  const OtpView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    TextEditingController _otp = TextEditingController();
    PinTheme defaultTheme = PinTheme(
      height: UtilsReponsive.height(70, context),
      width: UtilsReponsive.height(70, context),
      textStyle: const TextStyle(fontSize: 25),
      decoration: BoxDecoration(
          color: const Color(0xFFF7F8F9),
          border: Border.all(
            color: const Color(0xFFE8ECF4),
          ),
          borderRadius: BorderRadius.circular(8)),
    );
    PinTheme focusedTheme = PinTheme(
      height: UtilsReponsive.height(70, context),
      width: UtilsReponsive.height(70, context),
      textStyle: const TextStyle(fontSize: 25),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: ColorsManager.primary,
          ),
          borderRadius: BorderRadius.circular(8)),
    );
    return Scaffold(
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
                    'Xác thực CODE',
                    style: GetTextStyle.getTextStyle(30, 'Roboto', FontWeight.w700, ColorsManager.primary),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: UtilsReponsive.width(20, context),
                  vertical: UtilsReponsive.height(10, context),
                ),
                child: Text(
                  'Hãy nhập code xác thực mà chúng tôi vừa gửi cho bạn qua email.',
                  style: GetTextStyle.getTextStyle(16, 'Roboto', FontWeight.w500, ColorsManager.colorIcon),
                ),
              ),
              SizedBox(height: UtilsReponsive.height(20, context)),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Pinput(
                  length: 4,
                  defaultPinTheme: defaultTheme,
                  focusedPinTheme: focusedTheme,
                  submittedPinTheme: focusedTheme,
                  onChanged: (value) {
                    controller.setOtp(value);
                  },
                ),
              ),
              SizedBox(height: UtilsReponsive.height(40, context)),
              Padding(
                padding: UtilsReponsive.paddingAll(context, padding: 20),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: ColorsManager.primary,
                  ),
                  child: Obx(
                    () => MaterialButton(
                      onPressed: () async {
                        await controller.verifyCode();
                        controller.errorVerifyCode.value ? _errorMessage(context) : _successMessage(context);
                      },
                      child: controller.isLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: ColorsManager.backgroundWhite,
                              ),
                            )
                          : Text(
                              "Xác thực",
                              style: GetTextStyle.getTextStyle(20, 'Roboto', FontWeight.w400, Colors.white),
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
                    "Không nhận được mã code? ",
                    style: GetTextStyle.getTextStyle(16, 'Roboto', FontWeight.w500, Colors.black),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await controller.sendOtp();
                      controller.errorVerifyCode.value ? _errorMessage(context) : _successMessageBySentOtp(context);
                    },
                    child: Text(
                      "Gửi lại",
                      style: GetTextStyle.getTextStyle(16, 'Roboto', FontWeight.w700, ColorsManager.primary),
                    ),
                  ),
                ],
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
                  'Xác thực mã code thành công',
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

  _successMessageBySentOtp(BuildContext context) {
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
                  'Đã gửi mã thành công',
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
                      controller.errorVerifyCodeText.value,
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
