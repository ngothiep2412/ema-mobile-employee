import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:hrea_mobile_employee/app/base/base_view.dart';
import 'package:hrea_mobile_employee/app/resources/assets_manager.dart';
import 'package:hrea_mobile_employee/app/resources/color_manager.dart';
import 'package:hrea_mobile_employee/app/resources/reponsive_utils.dart';

import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends BaseView<SplashScreenController> {
  const SplashScreenView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.primary,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [ColorsManager.primary, ColorsManager.blue, ColorsManager.backgroundWhite], // Thay đổi màu sắc theo ý muốn
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                ImageAssets.logo,
                height: 170,
              ),
              // Text(
              //   'EMA',
              //   style: TextStyle(
              //       letterSpacing: 3, color: Colors.white, fontSize: UtilsReponsive.formatFontSize(42, context), fontWeight: FontWeight.w900),
              // ),
              SizedBox(
                height: UtilsReponsive.height(100, context),
                width: UtilsReponsive.width(100, context),
                child: SpinKitFadingCircle(
                  color: Colors.white, // Màu của nét đứt
                  size: 50.0, // Kích thước của CircularProgressIndicator
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
