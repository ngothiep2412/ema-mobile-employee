import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_view.dart';
import 'package:hrea_mobile_employee/app/resources/color_manager.dart';
import 'package:hrea_mobile_employee/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_employee/app/resources/style_manager.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/budget_detail_controller.dart';

class BudgetDetailView extends BaseView<BudgetDetailController> {
  const BudgetDetailView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
        appBar: _appBar(context),
        backgroundColor: ColorsManager.backgroundContainer,
        body: SafeArea(
          child: Obx(
            () => Padding(
              padding: EdgeInsets.all(UtilsReponsive.height(20, context)),
              child: controller.isLoading.value == true
                  ? Center(
                      child: SpinKitFadingCircle(
                        color: ColorsManager.primary,
                        // size: 30.0,
                      ),
                    )
                  : Column(children: [
                      Center(
                        child: Text(
                          'Thông tin khoản chi chi tiết',
                          style: GetTextStyle.getTextStyle(20, 'Nunito', FontWeight.w600, ColorsManager.primary),
                        ),
                      ),
                      SizedBox(
                        height: UtilsReponsive.heightv2(context, 5),
                      ),
                      Expanded(
                        child: Padding(
                          padding: UtilsReponsive.paddingHorizontal(context, padding: 5),
                          child: RefreshIndicator(
                            onRefresh: controller.refreshPage,
                            child: ListView(
                              children: [
                                SizedBox(
                                  height: UtilsReponsive.heightv2(context, 15),
                                ),
                                Text(
                                  'Trạng thái',
                                  style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, ColorsManager.textColor),
                                ),
                                SizedBox(
                                  height: UtilsReponsive.heightv2(context, 10),
                                ),
                                Container(
                                  padding: UtilsReponsive.paddingAll(context, padding: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      UtilsReponsive.height(10, context),
                                    ),
                                  ),
                                  child: Text(
                                    controller.budgetView.value.status! == "REJECT"
                                        ? "Từ chối"
                                        : controller.budgetView.value.status! == "ACCEPT"
                                            ? "Chấp nhận"
                                            : controller.budgetView.value.status! == "USED"
                                                ? "Đã sử dụng"
                                                : "Đang xử lí",
                                    style: GetTextStyle.getTextStyle(
                                        14,
                                        'Nunito',
                                        FontWeight.w700,
                                        controller.budgetView.value.status! == "REJECT"
                                            ? ColorsManager.red
                                            : controller.budgetView.value.status! == "ACCEPT"
                                                ? ColorsManager.green
                                                : controller.budgetView.value.status! == "PROCESSING"
                                                    ? ColorsManager.orange
                                                    : ColorsManager.primary),
                                  ),
                                ),
                                SizedBox(
                                  height: UtilsReponsive.heightv2(context, 15),
                                ),
                                Text(
                                  'Tên khoản chi',
                                  style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, ColorsManager.textColor),
                                ),
                                SizedBox(
                                  height: UtilsReponsive.heightv2(context, 10),
                                ),
                                Container(
                                  padding: UtilsReponsive.paddingAll(context, padding: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      UtilsReponsive.height(10, context),
                                    ),
                                  ),
                                  child: Text(
                                    controller.budgetView.value.budgetName!,
                                    style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w700, ColorsManager.textColor2),
                                  ),
                                ),
                                SizedBox(
                                  height: UtilsReponsive.heightv2(context, 20),
                                ),
                                Text(
                                  'Chi phí ước tính (VNĐ)',
                                  style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, ColorsManager.textColor),
                                ),
                                SizedBox(
                                  height: UtilsReponsive.heightv2(context, 10),
                                ),
                                Container(
                                  padding: UtilsReponsive.paddingAll(context, padding: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      UtilsReponsive.height(10, context),
                                    ),
                                  ),
                                  child: Text(
                                    controller.formatCurrency(controller.budgetView.value.estExpense!),
                                    style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w700, ColorsManager.textColor2),
                                  ),
                                ),
                                SizedBox(
                                  height: UtilsReponsive.heightv2(context, 20),
                                ),
                                Text(
                                  'Chi phí thực tế (VNĐ)',
                                  style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, ColorsManager.textColor),
                                ),
                                SizedBox(
                                  height: UtilsReponsive.heightv2(context, 10),
                                ),
                                Container(
                                  padding: UtilsReponsive.paddingAll(context, padding: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      UtilsReponsive.height(10, context),
                                    ),
                                  ),
                                  child: controller.budgetView.value.realExpense == null
                                      ? Text(
                                          '--',
                                          style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w700, ColorsManager.textColor2),
                                        )
                                      : Text(
                                          controller.formatCurrency(controller.budgetView.value.realExpense!),
                                          style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w700, ColorsManager.textColor2),
                                        ),
                                ),
                                SizedBox(
                                  height: UtilsReponsive.heightv2(context, 20),
                                ),
                                Text(
                                  'Mô tả',
                                  style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, ColorsManager.textColor),
                                ),
                                SizedBox(
                                  height: UtilsReponsive.heightv2(context, 10),
                                ),
                                Container(
                                  constraints: BoxConstraints(minHeight: UtilsReponsive.width(150, context)),
                                  padding: UtilsReponsive.paddingAll(context, padding: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      UtilsReponsive.height(10, context),
                                    ),
                                  ),
                                  child: Text(
                                    controller.budgetView.value.description!,
                                    style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w700, ColorsManager.textColor2),
                                  ),
                                ),
                                SizedBox(
                                  height: UtilsReponsive.heightv2(context, 20),
                                ),
                                Text(
                                  'Nhà cung cấp',
                                  style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, ColorsManager.textColor),
                                ),
                                SizedBox(
                                  height: UtilsReponsive.heightv2(context, 10),
                                ),
                                Container(
                                  padding: UtilsReponsive.paddingAll(context, padding: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      UtilsReponsive.height(10, context),
                                    ),
                                  ),
                                  child: Text(
                                    controller.budgetView.value.supplier!,
                                    style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w700, ColorsManager.textColor2),
                                  ),
                                ),
                                SizedBox(
                                  height: UtilsReponsive.heightv2(context, 20),
                                ),
                                Text(
                                  'Hình ảnh hóa đơn',
                                  style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w600, ColorsManager.textColor),
                                ),
                                SizedBox(
                                  height: UtilsReponsive.heightv2(context, 10),
                                ),
                                Stack(children: [
                                  Obx(
                                    () => controller.budgetView.value.urlImage == '' || controller.budgetView.value.urlImage == null
                                        ? Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.grey.withOpacity(0.8),
                                                  width: 1.0,
                                                ),
                                                borderRadius: BorderRadius.circular(8)),
                                            width: UtilsReponsive.width(150, context),
                                            height: UtilsReponsive.height(150, context),
                                            child: Center(
                                              child: Icon(
                                                Icons.camera_alt_outlined,
                                                size: 35,
                                                color: Colors.grey.withOpacity(0.8),
                                              ),
                                            ))
                                        : Container(
                                            height: UtilsReponsive.height(150, context),
                                            width: UtilsReponsive.height(200, context),
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
                                            child: CachedNetworkImage(
                                              // fit: BoxFit.contain,
                                              imageUrl: controller.budgetView.value.urlImage!,
                                              imageBuilder: (context, imageProvider) => GestureDetector(
                                                onTap: () async {
                                                  final url = Uri.parse(controller.budget.urlImage);
                                                  if (await canLaunchUrl(url)) {
                                                    await launchUrl(url, mode: LaunchMode.externalApplication);
                                                  }
                                                },
                                                child: Container(
                                                    height: UtilsReponsive.height(30, context),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(
                                                          UtilsReponsive.height(15, context),
                                                        ),
                                                        border: Border.all(width: 1.5, color: Theme.of(context).scaffoldBackgroundColor),
                                                        image: DecorationImage(fit: BoxFit.cover, image: imageProvider))),
                                              ),
                                              progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                                                padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
                                                height: UtilsReponsive.height(20, context),
                                                width: UtilsReponsive.height(20, context),
                                                child: CircularProgressIndicator(
                                                  color: ColorsManager.primary,
                                                ),
                                              ),
                                              errorWidget: (context, url, error) => const Icon(Icons.error),
                                            ),
                                          ),
                                  ),
                                ]),
                                SizedBox(
                                  height: UtilsReponsive.heightv2(context, 30),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]),
            ),
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
      actions: [
        Obx(
          () => controller.budgetView.value.status == "USED" || controller.budgetView.value.status == "REJECT"
              ? PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: ColorsManager.primary,
                  ),
                  onSelected: (choice) {
                    if (choice == 'delete') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Xác nhận xóa',
                                style: TextStyle(
                                    fontFamily: 'Nunito',
                                    wordSpacing: 1.2,
                                    color: ColorsManager.primary,
                                    fontSize: UtilsReponsive.height(20, context),
                                    fontWeight: FontWeight.bold)),
                            content: Text(
                              'Bạn có muốn xóa đơn thu chi này?',
                              style: TextStyle(
                                  fontFamily: 'Nunito',
                                  wordSpacing: 1.2,
                                  color: ColorsManager.textColor2,
                                  fontSize: UtilsReponsive.height(18, context),
                                  fontWeight: FontWeight.bold),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  await controller.deleteBudget();
                                  Navigator.of(Get.context!).pop();
                                  controller.errorUpdateBudget.value ? _errorMessage(Get.context!) : _successMessage(Get.context!);
                                },
                                child: Text('Xóa',
                                    style: TextStyle(
                                        fontFamily: 'Nunito',
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
                                        fontFamily: 'Nunito',
                                        wordSpacing: 1.2,
                                        color: ColorsManager.primary,
                                        fontSize: UtilsReponsive.height(18, context),
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Text(
                          'Xóa đơn thu chi này',
                          style: TextStyle(
                              fontFamily: 'Nunito',
                              wordSpacing: 1.2,
                              color: ColorsManager.textColor2,
                              fontSize: UtilsReponsive.height(18, context),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ];
                  },
                )
              : PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: ColorsManager.primary,
                  ),
                  onSelected: (choice) {
                    if (choice == 'delete') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Xác nhận xóa',
                                style: TextStyle(
                                    fontFamily: 'Nunito',
                                    wordSpacing: 1.2,
                                    color: ColorsManager.primary,
                                    fontSize: UtilsReponsive.height(20, context),
                                    fontWeight: FontWeight.bold)),
                            content: Text(
                              'Bạn có muốn xóa đơn thu chi này?',
                              style: TextStyle(
                                  fontFamily: 'Nunito',
                                  wordSpacing: 1.2,
                                  color: ColorsManager.textColor2,
                                  fontSize: UtilsReponsive.height(18, context),
                                  fontWeight: FontWeight.bold),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  await controller.deleteBudget();
                                  Navigator.of(Get.context!).pop();
                                  controller.errorUpdateBudget.value ? _errorMessage(Get.context!) : _successMessage(Get.context!);
                                },
                                child: Text('Xóa',
                                    style: TextStyle(
                                        fontFamily: 'Nunito',
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
                                        fontFamily: 'Nunito',
                                        wordSpacing: 1.2,
                                        color: ColorsManager.primary,
                                        fontSize: UtilsReponsive.height(18, context),
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          );
                        },
                      );
                    }
                    if (choice == 'edit') {
                      Get.toNamed(Routes.EDIT_BUDGET, arguments: {"eventID": controller.eventID, "budget": controller.budgetView});
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Text(
                          'Xóa đơn thu chi này',
                          style: TextStyle(
                              fontFamily: 'Nunito',
                              wordSpacing: 1.2,
                              color: ColorsManager.textColor2,
                              fontSize: UtilsReponsive.height(18, context),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'edit',
                        child: Text(
                          'Chỉnh sửa thông tin thu chi',
                          style: TextStyle(
                              fontFamily: 'Nunito',
                              wordSpacing: 1.2,
                              color: ColorsManager.textColor2,
                              fontSize: UtilsReponsive.height(18, context),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ];
                  },
                ),
        )
      ],
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
                  style: GetTextStyle.getTextStyle(18, 'Nunito', FontWeight.w800, Colors.white),
                ),
                Spacer(),
                Text(
                  'Thay đổi thông tin thu chi thành công',
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
                      controller.errorUpdateBudgetText.value,
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
