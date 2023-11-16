import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_view.dart';
import 'package:hrea_mobile_employee/app/resources/color_manager.dart';
import 'package:hrea_mobile_employee/app/resources/dev_utils.dart';
import 'package:hrea_mobile_employee/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_employee/app/resources/style_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/edit_budget_controller.dart';

class EditBudgetView extends BaseView<EditBudgetController> {
  const EditBudgetView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      backgroundColor: ColorsManager.backgroundContainer,
      body: SafeArea(
        child: Column(children: [
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
                    child: Text(
                      "Chỉnh sửa thông tin khoản chi",
                      style: GetTextStyle.getTextStyle(20, 'Roboto', FontWeight.w600, ColorsManager.textColor),
                    ),
                  ),
                  SizedBox(
                    height: UtilsReponsive.heightv2(context, 20),
                  ),
                  Text(
                    'Tên khoản chi',
                    style: GetTextStyle.getTextStyle(16, 'Roboto', FontWeight.w600, ColorsManager.primary),
                  ),
                  SizedBox(
                    height: UtilsReponsive.heightv2(context, 10),
                  ),
                  buildTextField(context, "Tên khoản chi", "Ví dụ: Tiền thuê mic", controller.budgetNameController),
                  Text(
                    'Chi phí ước tính (VNĐ)',
                    style: GetTextStyle.getTextStyle(16, 'Roboto', FontWeight.w600, ColorsManager.primary),
                  ),
                  SizedBox(
                    height: UtilsReponsive.heightv2(context, 10),
                  ),
                  buildWidgetmoney(context, "Chi phí ước tính", "Ví dụ: 100.000", controller.estExpenseController),
                  SizedBox(
                    height: UtilsReponsive.heightv2(context, 10),
                  ),
                  controller.budget.value.status == "ACCEPT"
                      ? Text(
                          'Chi phí thực tế (VNĐ)',
                          style: GetTextStyle.getTextStyle(16, 'Roboto', FontWeight.w600, ColorsManager.primary),
                        )
                      : SizedBox(),
                  controller.budget.value.status == "ACCEPT"
                      ? buildWidgetmoney(context, "Chi phí thực tế", "Ví dụ: 100.000", controller.realExpenseController)
                      : SizedBox(),
                  Text(
                    'Mô tả',
                    style: GetTextStyle.getTextStyle(16, 'Roboto', FontWeight.w600, ColorsManager.primary),
                  ),
                  SizedBox(
                    height: UtilsReponsive.heightv2(context, 10),
                  ),
                  buildTextarea(context, "Mô tả", "Ví dụ: Loại nhỏ", controller.descriptionController),
                  Text(
                    'Nhà cung cấp',
                    style: GetTextStyle.getTextStyle(16, 'Roboto', FontWeight.w600, ColorsManager.primary),
                  ),
                  SizedBox(
                    height: UtilsReponsive.heightv2(context, 10),
                  ),
                  buildTextField(context, "Nhà cung cấp", "Ví dụ: Saigon LED", controller.supplierController),
                  controller.budget.value.status == "ACCEPT"
                      ? Text(
                          'Hình ảnh hóa đơn',
                          style: GetTextStyle.getTextStyle(16, 'Roboto', FontWeight.w600, ColorsManager.primary),
                        )
                      : SizedBox(),
                  SizedBox(
                    height: UtilsReponsive.heightv2(context, 15),
                  ),
                  controller.budget.value.status != "ACCEPT"
                      ? SizedBox()
                      : Stack(
                          children: [
                            Obx(
                              () => Container(
                                  child: controller.selectImagePath.value.isEmpty
                                      ? controller.imageUrl.value == ''
                                          ? GestureDetector(
                                              onTap: () {
                                                showAlertDialogCamera(context);
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(
                                                      UtilsReponsive.height(15, context),
                                                    ),
                                                    border: Border.all(
                                                      color: Colors.grey.withOpacity(0.8), // Màu viền
                                                      width: 1.5, // Độ dày của viền
                                                    ),
                                                  ),
                                                  width: UtilsReponsive.width(150, context),
                                                  height: UtilsReponsive.height(150, context),
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.camera_alt_outlined,
                                                      size: 35,
                                                      color: Colors.grey.withOpacity(0.8),
                                                    ),
                                                  )),
                                            )
                                          : Stack(clipBehavior: Clip.none, children: [
                                              CachedNetworkImage(
                                                // fit: BoxFit.contain,
                                                imageUrl: controller.budget.value.urlImage,
                                                // imageUrl:
                                                //     'https://preview.keenthemes.com/metronic-v4/theme/assets/pages/media/profile/profile_user.jpg',
                                                imageBuilder: (context, imageProvider) => GestureDetector(
                                                  onTap: () async {
                                                    final url = Uri.parse(controller.budget.value.urlImage);
                                                    if (await canLaunchUrl(url)) {
                                                      await launchUrl(url, mode: LaunchMode.externalApplication);
                                                    }
                                                  },
                                                  child: Container(
                                                      width: UtilsReponsive.width(150, context),
                                                      height: UtilsReponsive.height(150, context),
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.circular(
                                                            UtilsReponsive.height(15, context),
                                                          ),
                                                          border: Border.all(
                                                            color: Colors.grey.withOpacity(0.8), // Màu viền
                                                            width: 1.5, // Độ dày của viền
                                                          ),
                                                          image: DecorationImage(fit: BoxFit.cover, image: imageProvider))),
                                                ),
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
                                              Positioned(
                                                top: -10,
                                                right: -12,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: Text('Xác nhận xóa',
                                                              style: TextStyle(
                                                                  fontFamily: 'Roboto',
                                                                  wordSpacing: 1.2,
                                                                  color: ColorsManager.primary,
                                                                  fontSize: UtilsReponsive.height(20, context),
                                                                  fontWeight: FontWeight.bold)),
                                                          content: Text(
                                                            'Bạn có muốn xóa hình ảnh này?',
                                                            style: TextStyle(
                                                                fontFamily: 'Roboto',
                                                                wordSpacing: 1.2,
                                                                color: ColorsManager.textColor2,
                                                                fontSize: UtilsReponsive.height(18, context),
                                                                fontWeight: FontWeight.bold),
                                                          ),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () {
                                                                controller.imageUrl.value = "";

                                                                Navigator.of(context).pop();
                                                              },
                                                              child: Text('Xóa',
                                                                  style: TextStyle(
                                                                      fontFamily: 'Roboto',
                                                                      wordSpacing: 1.2,
                                                                      color: ColorsManager.red,
                                                                      fontSize: UtilsReponsive.height(18, context),
                                                                      fontWeight: FontWeight.bold)),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(context).pop();
                                                              },
                                                              child: Text('Hủy',
                                                                  style: TextStyle(
                                                                      fontFamily: 'Roboto',
                                                                      wordSpacing: 1.2,
                                                                      color: ColorsManager.primary,
                                                                      fontSize: UtilsReponsive.height(18, context),
                                                                      fontWeight: FontWeight.bold)),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: Container(
                                                    padding: UtilsReponsive.paddingAll(context, padding: 5),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: ColorsManager.red,
                                                    ),
                                                    child: const Icon(
                                                      Icons.close,
                                                      color: ColorsManager.backgroundWhite,
                                                      size: 18,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ])
                                      : Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                controller.openFile(controller.selectImagePath.value);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey.withOpacity(0.8),
                                                    width: 1.0,
                                                  ),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                width: UtilsReponsive.width(150, context),
                                                height: UtilsReponsive.height(150, context),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(8),
                                                  child: Image.file(
                                                    File(controller.selectImagePath.value),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: -10,
                                              right: -12,
                                              child: GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text('Xác nhận xóa',
                                                            style: TextStyle(
                                                                fontFamily: 'Roboto',
                                                                wordSpacing: 1.2,
                                                                color: ColorsManager.primary,
                                                                fontSize: UtilsReponsive.height(20, context),
                                                                fontWeight: FontWeight.bold)),
                                                        content: Text(
                                                          'Bạn có muốn xóa hình ảnh này?',
                                                          style: TextStyle(
                                                              fontFamily: 'Roboto',
                                                              wordSpacing: 1.2,
                                                              color: ColorsManager.textColor2,
                                                              fontSize: UtilsReponsive.height(18, context),
                                                              fontWeight: FontWeight.bold),
                                                        ),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () {
                                                              controller.selectImagePath.value = '';
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: Text('Xóa',
                                                                style: TextStyle(
                                                                    fontFamily: 'Roboto',
                                                                    wordSpacing: 1.2,
                                                                    color: ColorsManager.red,
                                                                    fontSize: UtilsReponsive.height(18, context),
                                                                    fontWeight: FontWeight.bold)),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: Text('Hủy',
                                                                style: TextStyle(
                                                                    fontFamily: 'Roboto',
                                                                    wordSpacing: 1.2,
                                                                    color: ColorsManager.primary,
                                                                    fontSize: UtilsReponsive.height(18, context),
                                                                    fontWeight: FontWeight.bold)),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                  padding: UtilsReponsive.paddingAll(context, padding: 5),
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: ColorsManager.red,
                                                  ),
                                                  child: const Icon(
                                                    Icons.close,
                                                    color: ColorsManager.backgroundWhite,
                                                    size: 18,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                            ),
                          ],
                        ),
                  SizedBox(
                    height: UtilsReponsive.heightv2(context, 10),
                  ),
                  SizedBox(
                    height: UtilsReponsive.heightv2(context, 20),
                  ),
                  Obx(
                    () => Container(
                      height: UtilsReponsive.heightv2(context, 60),
                      child: ElevatedButton(
                        onPressed: () async {
                          await controller.updateBudget();
                          controller.errorUpdateBudget.value ? _errorMessage(Get.context!) : _successMessage(Get.context!);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0), // Đặt border radius theo mong muốn
                          ),
                        ),
                        child: controller.isLoading.value
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: ColorsManager.backgroundWhite,
                                ),
                              )
                            : Text(
                                "Lưu",
                                style: GetTextStyle.getTextStyle(
                                  14,
                                  'Roboto',
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
          hintStyle: GetTextStyle.getTextStyle(14, 'Roboto', FontWeight.w400, ColorsManager.textColor2),
        ),
      ),
    );
  }

  Widget buildWidgetmoney(
    BuildContext context,
    String labelText,
    String hintText,
    TextEditingController? nameTextEditingController,
  ) {
    return Padding(
      padding: UtilsReponsive.paddingOnly(context, bottom: 10),
      child: TextField(
        keyboardType: TextInputType.number,
        controller: nameTextEditingController,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          CurrencyInputFormatter(),
        ],
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
          hintStyle: GetTextStyle.getTextStyle(14, 'Roboto', FontWeight.w400, ColorsManager.textColor2),
        ),
      ),
    );
  }

  Widget buildTextarea(
    BuildContext context,
    String labelText,
    String hintText,
    TextEditingController? textEditingController,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: textEditingController,
        maxLines: null,
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
          hintStyle: GetTextStyle.getTextStyle(14, 'Roboto', FontWeight.w400, ColorsManager.textColor2),
        ),
      ),
    );
  }

  void showAlertDialogCamera(BuildContext context) {
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
                  style: GetTextStyle.getTextStyle(18, 'Roboto', FontWeight.w800, Colors.white),
                ),
                Spacer(),
                Text(
                  'Thay đổi thông tin khoản chi thành công',
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
                    style: GetTextStyle.getTextStyle(18, 'Roboto', FontWeight.w800, Colors.white),
                  ),
                  const Spacer(),
                  Obx(
                    () => Text(
                      controller.errorUpdateBudgetText.value,
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
