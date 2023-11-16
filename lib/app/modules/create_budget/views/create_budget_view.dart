import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_view.dart';
import 'package:hrea_mobile_employee/app/resources/color_manager.dart';
import 'package:hrea_mobile_employee/app/resources/dev_utils.dart';
import 'package:hrea_mobile_employee/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_employee/app/resources/style_manager.dart';
import '../controllers/create_budget_controller.dart';

class CreateBudgetView extends BaseView<CreateBudgetController> {
  const CreateBudgetView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      backgroundColor: ColorsManager.backgroundContainer,
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: Padding(
              padding: UtilsReponsive.paddingHorizontal(context, padding: 20),
              child: ListView(
                children: [
                  SizedBox(
                    height: UtilsReponsive.heightv2(context, 15),
                  ),
                  Center(
                    child: Text(
                      'Tạo khoản chi',
                      style: GetTextStyle.getTextStyle(18, 'Roboto', FontWeight.w600, ColorsManager.textColor),
                    ),
                  ),
                  SizedBox(
                    height: UtilsReponsive.heightv2(context, 30),
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
                  // DropdownButtonFormField(
                  //   items: controller.genderList
                  //       .map((e) => DropdownMenuItem(
                  //             child: Text(e),
                  //             value: e,
                  //           ))
                  //       .toList(),
                  //   onChanged: (value) {
                  //     controller.setGender(value as String);
                  //   },
                  //   value:
                  //       controller.selectedGenderVal == "MALE" ? "Nam" : "Nữ",
                  //   icon: Icon(
                  //     Icons.arrow_drop_down_circle,
                  //     color: ColorsManager.primary,
                  //   ),
                  //   decoration: const InputDecoration(
                  //       // labelText: 'Giới tính',
                  //       errorBorder: InputBorder.none,
                  //       border: OutlineInputBorder(
                  //         borderSide: BorderSide.none,
                  //       ),
                  //       fillColor: ColorsManager.textInput,
                  //       filled: true),
                  // ),
                  SizedBox(
                    height: UtilsReponsive.heightv2(context, 20),
                  ),
                  Obx(
                    () => Container(
                      height: UtilsReponsive.heightv2(context, 60),
                      child: ElevatedButton(
                        onPressed: () async {
                          await controller.createBudget();
                          controller.errorCreateBudget.value ? _errorMessage(Get.context!) : _successMessage(Get.context!);
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
                                "Tạo đơn",
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
                  'Tạo đơn thành công',
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
                      controller.errorCreateBudgetText.value,
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
}
