import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_view.dart';
import 'package:hrea_mobile_employee/app/resources/assets_manager.dart';
import 'package:hrea_mobile_employee/app/resources/color_manager.dart';
import 'package:hrea_mobile_employee/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_employee/app/resources/style_manager.dart';
import '../controllers/login_controller.dart';

class LoginView extends BaseView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height, maxWidth: MediaQuery.of(context).size.width),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue[800]!,
                Colors.blue[600]!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: UtilsReponsive.height(36, context), horizontal: UtilsReponsive.width(24, context)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.asset(
                          ImageAssets.logo,
                          height: 170,
                        ),
                      ),
                      // SizedBox(
                      //   height: UtilsReponsive.height(10, context),
                      // ),
                      // Text(
                      //   'Đăng nhập dành cho nhân viên',
                      //   style: GetTextStyle.getTextStyle(20, 'Nunito', FontWeight.w400, Colors.white),
                      // ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(40))),
                  child: Padding(
                    padding: UtilsReponsive.paddingAll(context, padding: 24),
                    child: Obx(
                      () => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Đăng nhập',
                            style: GetTextStyle.getTextStyle(20, 'Nunito', FontWeight.w800, ColorsManager.primary),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
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
                            onChanged: (value) => {controller.setEmail(value)},
                          ),
                          SizedBox(
                            height: UtilsReponsive.height(25, context),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: controller.passwordObscured.value,
                            decoration: InputDecoration(
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
                              ),
                            ),
                            onChanged: (value) => {controller.setPassword(value)},
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  controller.forgotPassword();
                                },
                                child: Text(
                                  "Quên mật khẩu?",
                                  style: GetTextStyle.getTextStyle(15, 'Nunito', FontWeight.w400, ColorsManager.primary),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: UtilsReponsive.height(20, context),
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: ColorsManager.primary,
                            ),
                            child: MaterialButton(
                              onPressed: () async {
                                await controller.login();
                                controller.errorLogin.value ? _errorMessage(context) : null;
                                // : _successMessage(context);
                              },
                              child: controller.isLoading.value
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: ColorsManager.backgroundWhite,
                                      ),
                                    )
                                  : Text(
                                      "Đăng nhập",
                                      style: GetTextStyle.getTextStyle(20, 'Nunito', FontWeight.w400, Colors.white),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // _successMessage(BuildContext context) {
  //   return ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       backgroundColor: Colors.transparent,
  //       content: Container(
  //         padding: UtilsReponsive.paddingAll(context, padding: 8),
  //         height: UtilsReponsive.height(80, context),
  //         decoration: const BoxDecoration(
  //             color: Color.fromARGB(255, 81, 146, 83),
  //             borderRadius: BorderRadius.all(Radius.circular(10))),
  //         child: Row(children: [
  //           const Icon(
  //             Icons.check_circle,
  //             color: ColorsManager.backgroundWhite,
  //             size: 40,
  //           ),
  //           const SizedBox(
  //             width: 20,
  //           ),
  //           Expanded(
  //               child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 'Thành công',
  //                 style: GetTextStyle.getTextStyle(
  //                     18, 'Nunito', FontWeight.w800, Colors.white),
  //               ),
  //               Spacer(),
  //               Text(
  //                 'Đăng nhập thành công',
  //                 style: GetTextStyle.getTextStyle(
  //                     12, 'Nunito', FontWeight.w500, Colors.white),
  //                 maxLines: 2,
  //                 overflow: TextOverflow.ellipsis,
  //               )
  //             ],
  //           ))
  //         ]),
  //       ),
  //       behavior: SnackBarBehavior.floating,
  //       elevation: 0,
  //     ),
  //   );
  // }

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
                      controller.errorLoginText.value,
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
