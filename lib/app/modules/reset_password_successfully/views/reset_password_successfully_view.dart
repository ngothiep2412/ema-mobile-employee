import 'package:flutter/material.dart';
import 'package:hrea_mobile_employee/app/base/base_view.dart';
import 'package:hrea_mobile_employee/app/resources/color_manager.dart';
import 'package:hrea_mobile_employee/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_employee/app/resources/style_manager.dart';
import 'package:lottie/lottie.dart';

import '../controllers/reset_password_successfully_controller.dart';

class ResetPasswordSuccessfullyView extends BaseView<ResetPasswordSuccessfullyController> {
  const ResetPasswordSuccessfullyView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsManager.primary,
        elevation: 0,
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Lottie.asset('animations/successfully.json', height: UtilsReponsive.height(300, context), reverse: true, repeat: true, fit: BoxFit.cover),
        SizedBox(
          height: UtilsReponsive.height(30, context),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: UtilsReponsive.width(30, context),
          ),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: ColorsManager.primary,
            ),
            child: MaterialButton(
              onPressed: () async {
                await controller.goToLogin();
              },
              child: Text(
                "Trở về đăng nhập",
                style: GetTextStyle.getTextStyle(18, 'Roboto', FontWeight.w500, Colors.white),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
