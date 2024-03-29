import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_view.dart';
import 'package:hrea_mobile_employee/app/modules/budget/model/budget_model.dart';
import 'package:hrea_mobile_employee/app/resources/assets_manager.dart';
import 'package:hrea_mobile_employee/app/resources/color_manager.dart';
import 'package:hrea_mobile_employee/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_employee/app/resources/style_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/budget_detail_controller.dart';

class BudgetDetailView extends BaseView<BudgetDetailController> {
  const BudgetDetailView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Obx(
      () => Scaffold(
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
                    : controller.checkView.value == false
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  ImageAssets.noInternet,
                                  fit: BoxFit.cover,
                                  width: UtilsReponsive.widthv2(context, 200),
                                  height: UtilsReponsive.heightv2(context, 200),
                                ),
                                SizedBox(
                                  height: UtilsReponsive.height(20, context),
                                ),
                                Text(
                                  'Đang có lỗi xảy ra',
                                  style: GetTextStyle.getTextStyle(20, 'Nunito', FontWeight.w800, ColorsManager.primary),
                                ),
                              ],
                            ),
                          )
                        : Column(children: [
                            Center(
                              child: Text(
                                'Thông tin giao dịch chi tiết',
                                style: GetTextStyle.getTextStyle(22, 'Nunito', FontWeight.w800, ColorsManager.primary),
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
                                        style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w700, ColorsManager.textColor),
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
                                          controller.transactionView.value.status! == "REJECTED"
                                              ? "Từ chối"
                                              : controller.transactionView.value.status! == "ACCEPTED"
                                                  ? "Chấp nhận"
                                                  : controller.transactionView.value.status! == "SUCCESS"
                                                      ? "Thành công"
                                                      : "Chờ duyệt",
                                          style: GetTextStyle.getTextStyle(
                                              14,
                                              'Nunito',
                                              FontWeight.w700,
                                              controller.transactionView.value.status! == "REJECTED"
                                                  ? ColorsManager.red
                                                  : controller.transactionView.value.status! == "ACCEPTED"
                                                      ? ColorsManager.green
                                                      : controller.transactionView.value.status! == "PENDING"
                                                          ? ColorsManager.grey
                                                          : ColorsManager.purple),
                                        ),
                                      ),
                                      SizedBox(
                                        height: UtilsReponsive.heightv2(context, 15),
                                      ),
                                      Text(
                                        'Mã giao dịch',
                                        style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w700, ColorsManager.textColor),
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
                                          controller.transactionView.value.transactionCode!,
                                          style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w700, ColorsManager.textColor2),
                                        ),
                                      ),
                                      SizedBox(
                                        height: UtilsReponsive.heightv2(context, 20),
                                      ),
                                      Text(
                                        'Tên giao dịch',
                                        style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w700, ColorsManager.textColor),
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
                                          controller.transactionView.value.transactionName!,
                                          style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w700, ColorsManager.textColor2),
                                        ),
                                      ),
                                      SizedBox(
                                        height: UtilsReponsive.heightv2(context, 20),
                                      ),
                                      Text(
                                        'Chi phí (VNĐ)',
                                        style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w700, ColorsManager.textColor),
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
                                          controller.formatCurrency(controller.transactionView.value.amount!),
                                          style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w700, ColorsManager.textColor2),
                                        ),
                                      ),
                                      SizedBox(
                                        height: UtilsReponsive.heightv2(context, 20),
                                      ),
                                      Text(
                                        'Mô tả',
                                        style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w700, ColorsManager.textColor),
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
                                          controller.transactionView.value.description!,
                                          style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w700, ColorsManager.textColor2),
                                        ),
                                      ),
                                      controller.transactionView.value.status! == "REJECTED"
                                          ? SizedBox(
                                              height: UtilsReponsive.heightv2(context, 20),
                                            )
                                          : SizedBox(),
                                      controller.transactionView.value.status! == "REJECTED"
                                          ? Text(
                                              'Lí do từ chối',
                                              style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w700, ColorsManager.red),
                                            )
                                          : SizedBox(),
                                      controller.transactionView.value.status! == "REJECTED"
                                          ? SizedBox(
                                              height: UtilsReponsive.heightv2(context, 10),
                                            )
                                          : SizedBox(),
                                      controller.transactionView.value.status! == "REJECTED"
                                          ? Container(
                                              constraints: BoxConstraints(minHeight: UtilsReponsive.width(150, context)),
                                              padding: UtilsReponsive.paddingAll(context, padding: 10),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(
                                                  UtilsReponsive.height(10, context),
                                                ),
                                              ),
                                              child: Text(
                                                controller.transactionView.value.rejectNote!,
                                                style: GetTextStyle.getTextStyle(14, 'Nunito', FontWeight.w700, ColorsManager.textColor2),
                                              ),
                                            )
                                          : SizedBox(),
                                      SizedBox(
                                        height: UtilsReponsive.heightv2(context, 20),
                                      ),
                                      controller.transactionView.value.status == 'ACCEPTED' || controller.transactionView.value.status == 'SUCCESS'
                                          ? Text(
                                              'Tài liệu hóa đơn chứng từ',
                                              style: GetTextStyle.getTextStyle(16, 'Nunito', FontWeight.w700, ColorsManager.textColor),
                                            )
                                          : const SizedBox(),
                                      SizedBox(
                                        height: UtilsReponsive.heightv2(context, 10),
                                      ),
                                      controller.transactionView.value.status == 'ACCEPTED' || controller.transactionView.value.status == 'SUCCESS'
                                          ? _documentV2(context)
                                          : const SizedBox(),
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
          )),
    );
  }

  StatefulBuilder _documentV2(BuildContext context) {
    List<PlatformFile> filePickerEditCommentFile = [];
    bool isEditComment = false;
    return StatefulBuilder(builder: (context, setStateX) {
      return Obx(
        () => Container(
            // height: controller.listAttachment.isEmpty
            //     ? 50
            //     : UtilsReponsive.height(200, context),
            // padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(UtilsReponsive.height(10, context))),
            child: Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: UtilsReponsive.height(10, context),
                    ),
                    Obx(
                      () => Row(
                        children: [
                          Text(
                            controller.listAttachmentEvidence.isEmpty ? 'Chưa có tài liệu' : 'Đang có',
                            style: TextStyle(color: ColorsManager.primary, fontSize: UtilsReponsive.height(15, context), fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            width: UtilsReponsive.width(10, context),
                          ),
                          controller.listAttachmentEvidence.isNotEmpty
                              ? CircleAvatar(
                                  radius: controller.listAttachmentEvidence.length >= 100
                                      ? 15
                                      : controller.listAttachmentEvidence.length >= 10
                                          ? 15
                                          : 10,
                                  child: Text(
                                    controller.listAttachmentEvidence.length.toString(),
                                    style: TextStyle(
                                        letterSpacing: 1,
                                        color: ColorsManager.backgroundWhite,
                                        fontSize: UtilsReponsive.height(15, context),
                                        fontWeight: FontWeight.w800),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: UtilsReponsive.height(20, context),
                    ),
                  ],
                ),
                children: [
                  controller.listAttachmentEvidence.isEmpty
                      ? Container(
                          padding: EdgeInsets.only(
                              left: UtilsReponsive.height(20, context),
                              right: UtilsReponsive.height(15, context),
                              bottom: UtilsReponsive.height(10, context)),
                          // height: UtilsReponsive.height(120, context),
                          child: Column(
                            children: [
                              SizedBox(
                                height: UtilsReponsive.height(10, context),
                              ),
                              controller.transactionView.value.status != "SUCCESS" && controller.statusTask != true
                                  ? Row(
                                      children: [
                                        InkWell(
                                            onTap: () async {
                                              controller.selectFile();
                                            },
                                            child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  '+  Thêm tệp',
                                                  style: GetTextStyle.getTextStyle(15, 'Nunito', FontWeight.w700, ColorsManager.primary),
                                                ))),
                                        SizedBox(
                                          height: UtilsReponsive.height(10, context),
                                        ),
                                      ],
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: UtilsReponsive.height(20, context),
                              ),
                              controller.filePicker.isNotEmpty
                                  ? Container(
                                      decoration: const BoxDecoration(
                                        boxShadow: [
                                          // BoxShadow(
                                          //   color: ColorsManager.textColor,
                                          //   blurRadius: 1.0,
                                          // ),
                                        ],
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: UtilsReponsive.height(170, context),
                                            padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
                                            child: ListView.separated(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: controller.filePicker.length,
                                              separatorBuilder: (context, index) => SizedBox(width: UtilsReponsive.width(15, context)),
                                              itemBuilder: (context, index) {
                                                return attchfileComment(controller.filePicker[index], context, index);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: UtilsReponsive.height(10, context),
                              ),
                              controller.filePicker.isEmpty
                                  ? const SizedBox()
                                  : GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                "Bạn có muốn cập nhật hóa đơn không?",
                                                style: TextStyle(
                                                    fontFamily: 'Nunito', fontSize: 20, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () async {
                                                    Navigator.of(Get.context!).pop();
                                                    await controller.uploadFileEvidence();
                                                  },
                                                  child: Text(
                                                    "Có",
                                                    style: TextStyle(
                                                        fontFamily: 'Nunito',
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w700,
                                                        color: ColorsManager.primary),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop(); // Đóng hộp thoại
                                                  },
                                                  child: Text(
                                                    "Hủy",
                                                    style: TextStyle(
                                                        fontFamily: 'Nunito',
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w700,
                                                        color: ColorsManager.textColor2),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.blue,
                                        ),
                                        child: const Text(
                                          'Cập nhật tài liệu hóa đơn',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white, // Màu văn bản trắng
                                          ),
                                        ),
                                      ),
                                    )
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            isEditComment == false && controller.transactionView.value.status != "SUCCESS"
                                ? Row(
                                    children: [
                                      SizedBox(
                                        width: UtilsReponsive.width(10, context),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setStateX(() {
                                            isEditComment = true;
                                          });
                                        },
                                        child: Text(
                                          'Chỉnh sửa',
                                          style: GetTextStyle.getTextStyle(15, 'Nunito', FontWeight.w700, ColorsManager.textColor2),
                                        ),
                                      )
                                    ],
                                  )
                                : controller.transactionView.value.status != "SUCCESS" && controller.statusTask != true
                                    ? Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          InkWell(
                                              onTap: () async {
                                                final result = await FilePicker.platform.pickFiles(
                                                  type: FileType.custom,
                                                  allowedExtensions: ['jpg', 'pdf', 'doc', 'xlsx', 'docx', 'png', 'jpeg'],
                                                );
                                                if (result == null) {
                                                  return;
                                                }

                                                final file = result.files.first;
                                                double fileLength = File(result.files[0].path!).lengthSync() / 1024 / 1024;
                                                if (fileLength > 10) {
                                                  Get.snackbar('Lỗi', 'Không thể lấy tài liệu lớn hơn 10mb',
                                                      snackPosition: SnackPosition.BOTTOM,
                                                      backgroundColor: Colors.redAccent,
                                                      colorText: Colors.white);

                                                  return;
                                                }
                                                setStateX(() {
                                                  filePickerEditCommentFile.add(file);
                                                });
                                              },
                                              child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    '+  Thêm tệp',
                                                    style: GetTextStyle.getTextStyle(15, 'Nunito', FontWeight.w700, ColorsManager.primary),
                                                  ))),
                                          GestureDetector(
                                            onTap: () {
                                              setStateX(() {
                                                isEditComment = false;
                                              });
                                            },
                                            child: Text(
                                              'Hủy',
                                              style: GetTextStyle.getTextStyle(15, 'Nunito', FontWeight.w700, ColorsManager.red),
                                            ),
                                          ),
                                        ],
                                      )
                                    : SizedBox(),
                            SizedBox(
                              height: UtilsReponsive.height(20, context),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: UtilsReponsive.height(15, context),
                                  right: UtilsReponsive.height(15, context),
                                  bottom: UtilsReponsive.height(10, context)),
                              height: UtilsReponsive.height(80, context),
                              width: UtilsReponsive.width(300, context),
                              child: ListView.separated(
                                primary: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.listAttachmentEvidence.length,
                                separatorBuilder: (context, index) => SizedBox(width: UtilsReponsive.width(10, context)),
                                itemBuilder: (context, index) {
                                  return _files(controller.listAttachmentEvidence[index], index, context);
                                },
                              ),
                            ),
                            filePickerEditCommentFile.isNotEmpty
                                ? Padding(
                                    padding: UtilsReponsive.padding(context, horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Tệp thay thế',
                                          style: TextStyle(
                                              fontFamily: 'Nunito',
                                              color: ColorsManager.textColor2,
                                              fontSize: UtilsReponsive.height(15, context),
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: UtilsReponsive.height(8, context)),
                                          height: UtilsReponsive.height(200, context),
                                          child: ListView.separated(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: filePickerEditCommentFile.length,
                                            separatorBuilder: (context, index) => SizedBox(width: UtilsReponsive.width(15, context)),
                                            itemBuilder: (context, index) {
                                              return editFileComment(
                                                  filePickerEditCommentFile[index], context, index, setStateX, filePickerEditCommentFile);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                            controller.transactionView.value.status != "SUCCESS" && filePickerEditCommentFile.isNotEmpty
                                ? GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                              "Bạn có muốn cập nhật hóa đơn không?",
                                              style: TextStyle(
                                                  fontFamily: 'Nunito', fontSize: 20, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () async {
                                                  Navigator.of(Get.context!).pop();
                                                  await controller.editBudget(filePickerEditCommentFile);
                                                  // setStateX(() {
                                                  //   isEditComment = false;
                                                  //   filePickerEditCommentFile = [];
                                                  // });
                                                },
                                                child: Text(
                                                  "Có",
                                                  style: TextStyle(
                                                      fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w700, color: ColorsManager.primary),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(); // Đóng hộp thoại
                                                },
                                                child: Text(
                                                  "Hủy",
                                                  style: TextStyle(
                                                      fontFamily: 'Nunito',
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w700,
                                                      color: ColorsManager.textColor2),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.blue,
                                      ),
                                      child: const Text(
                                        'Cập nhật tài liệu hóa đơn',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Nunito',
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white, // Màu văn bản trắng
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                            SizedBox(
                              height: UtilsReponsive.height(10, context),
                            ),
                          ],
                        ),
                ],
              ),
            )),
      );
    });
  }

  InkWell editFileComment(PlatformFile attachCommentFile, BuildContext context, int index, setStateX, List<PlatformFile> filePickerEditCommentFile) {
    final fileName = attachCommentFile.path!.split('/').last;
    final kb = attachCommentFile.size / 1024;
    final mb = kb / 1024;
    final fileSize = mb >= 1 ? '${mb.toStringAsFixed(2)} MB' : '${kb.toStringAsFixed(2)} KB';
    final extension = attachCommentFile.extension;
    return InkWell(
      onTap: () {
        controller.openFile(attachCommentFile);
      },
      onLongPress: () {
        _showOptionsAttachmentCommentPopupV2(context, index, setStateX, filePickerEditCommentFile);
      },
      child: extension == 'jpg' || extension == 'png' || extension == 'jpeg'
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorsManager.backgroundGrey,
              ),
              width: UtilsReponsive.width(120, context),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File(attachCommentFile.path!),
                  fit: BoxFit.fill,
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorsManager.backgroundGrey,
              ),
              width: UtilsReponsive.width(125, context),
              padding: UtilsReponsive.paddingOnly(context, top: 10, left: 10, bottom: 5, right: 10),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                  flex: 4,
                  // child: Text('hiii'),
                  child: fileName.length > 35
                      ? Text(
                          fileName.length > 35 ? '${fileName.substring(0, 35)}...' : fileName,
                          style: const TextStyle(fontFamily: 'Nunito', fontSize: 12, fontWeight: FontWeight.w700, color: ColorsManager.textColor),
                        )
                      : Text(
                          fileName,
                          style: const TextStyle(fontFamily: 'Nunito', fontSize: 12, fontWeight: FontWeight.w700, color: ColorsManager.textColor),
                        ),
                ),
                Expanded(
                    child: Text(
                  fileSize,
                  style: const TextStyle(fontFamily: 'Nunito', fontSize: 12, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
                )),
              ]),
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
        actions: controller.transactionView.value.status == "PENDING"
            ? [
                PopupMenuButton<String>(
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
                                  Navigator.of(Get.context!).pop();
                                  await controller.deleteBudget();
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
                              color: ColorsManager.textColor2,
                              fontSize: UtilsReponsive.height(16, context),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ];
                  },
                )
              ]
            : []);
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

  InkWell _files(Evidence evidenceFile, int index, BuildContext context) {
    return InkWell(
      onTap: () async {
        final url = Uri.parse(evidenceFile.evidenceUrl!);
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      },
      onLongPress: () {
        _showOptionsAttachmentCommentPopup(context, index);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ColorsManager.backgroundGrey,
        ),
        // width: UtilsReponsive.width(110, context),
        padding: UtilsReponsive.paddingOnly(
          context,
          top: 10,
          left: 10,
          bottom: 5,
          right: 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(evidenceFile.evidenceFileName!, style: GetTextStyle.getTextStyle(12, 'Nunito', FontWeight.w700, ColorsManager.primary)),
          ],
        ),
      ),
    );
    //   CachedNetworkImage(
    //     imageUrl: evidenceFile.evidenceUrl!,
    //     imageBuilder: (context, imageProvider) => Container(
    //         width: UtilsReponsive.width(120, context),
    //         // height: UtilsReponsive.height(120, context),
    //         padding: UtilsReponsive.paddingAll(context, padding: 5),
    //         decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(fit: BoxFit.cover, image: imageProvider))),
    //     progressIndicatorBuilder: (context, url, downloadProgress) => Container(
    //       padding: EdgeInsets.all(UtilsReponsive.height(10, context)),
    //       height: UtilsReponsive.height(5, context),
    //       width: UtilsReponsive.height(5, context),
    //       child: CircularProgressIndicator(
    //         color: ColorsManager.primary,
    //       ),
    //     ),
    //     errorWidget: (context, url, error) => Container(
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(10),
    //         color: ColorsManager.backgroundGrey,
    //       ),
    //       width: UtilsReponsive.width(110, context),
    //       padding: UtilsReponsive.paddingOnly(context, top: 10, left: 10, bottom: 5, right: 10),
    //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    //         Expanded(
    //           flex: 2,
    //           // child: Text('hiii'),
    //           child: evidenceFile.evidenceFileName!.length > 35
    //               ? Text(
    //                   evidenceFile.evidenceFileName!.length > 35
    //                       ? '${evidenceFile.evidenceFileName!.substring(0, 35)}...'
    //                       : evidenceFile.evidenceFileName!,
    //                   style: const TextStyle(fontFamily: 'Nunito', fontSize: 11, fontWeight: FontWeight.w700, color: ColorsManager.textColor),
    //                 )
    //               : Text(
    //                   evidenceFile.evidenceFileName!,
    //                   style: const TextStyle(fontFamily: 'Nunito', fontSize: 11, fontWeight: FontWeight.w700, color: ColorsManager.textColor),
    //                 ),
    //         ),
    //         // const Expanded(
    //         //   child: Column(
    //         //     mainAxisAlignment: MainAxisAlignment.end,
    //         //     children: [
    //         //       Text(
    //         //         'Kích thước',
    //         //         style: TextStyle(fontFamily: 'Nunito', fontSize: 14, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
    //         //       ),
    //         //     ],
    //         //   ),
    //         // ),
    //       ]),
    //     ),
    //   ),
    // );
  }

  void _showOptionsAttachmentCommentPopup(BuildContext context, int index) {
    BuildContext _popupContext = context;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Tùy chọn",
            style: TextStyle(fontFamily: 'Nunito', fontSize: 18, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  'Xóa tài liệu này',
                  style: TextStyle(fontFamily: 'Nunito', fontSize: 17, fontWeight: FontWeight.w700, color: ColorsManager.red),
                ),
                onTap: () {
                  _showDeleteAttachmentCommentConfirmation(context, index, _popupContext);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteAttachmentCommentConfirmation(BuildContext context, int index, BuildContext popupContext) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Xóa tệp này?",
            style: TextStyle(fontFamily: 'Nunito', fontSize: 20, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
          ),
          content: const Text(
            "Một khi nó đã mất, thì nó đã mất.",
            style: TextStyle(fontFamily: 'Nunito', fontSize: 15, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text(
                "Hủy",
                style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w700, color: ColorsManager.primary),
              ),
            ),
            TextButton(
              onPressed: () {
                controller.deleteAttachmentCommentFile(index);
                Navigator.of(context).pop();
                Navigator.of(popupContext).pop();
              },
              child: Text(
                "Xóa",
                style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w700, color: ColorsManager.red),
              ),
            ),
          ],
        );
      },
    );
  }

  InkWell attchfileComment(PlatformFile attachCommentFile, BuildContext context, int index) {
    final fileName = attachCommentFile.path!.split('/').last;
    final kb = attachCommentFile.size / 1024;
    final mb = kb / 1024;
    final fileSize = mb >= 1 ? '${mb.toStringAsFixed(2)} MB' : '${kb.toStringAsFixed(2)} KB';
    final extension = attachCommentFile.extension;
    return InkWell(
      onTap: () {
        controller.openFile(attachCommentFile);
      },
      onLongPress: () {
        _showOptionsAttachmentCommentPopup(context, index);
      },
      child: extension == 'jpg' || extension == 'png' || extension == 'jpeg'
          ? Container(
              color: ColorsManager.backgroundGrey,
              width: UtilsReponsive.width(120, context),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File(attachCommentFile.path!),
                  fit: BoxFit.cover,
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorsManager.backgroundGrey,
              ),
              width: UtilsReponsive.width(120, context),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(
                    flex: 4,
                    // child: Text('hiii'),
                    child: fileName.length > 35
                        ? Text(
                            fileName.length > 35 ? '${fileName.substring(0, 35)}...' : fileName,
                            style: const TextStyle(fontFamily: 'Nunito', fontSize: 12, fontWeight: FontWeight.w700, color: ColorsManager.textColor),
                          )
                        : Text(
                            fileName,
                            style: const TextStyle(fontFamily: 'Nunito', fontSize: 12, fontWeight: FontWeight.w700, color: ColorsManager.textColor),
                          ),
                  ),
                  Expanded(
                      child: Text(
                    fileSize,
                    style: const TextStyle(fontFamily: 'Nunito', fontSize: 12, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
                  )),
                ]),
              ),
            ),
    );
  }

  void _showOptionsAttachmentCommentPopupV2(BuildContext context, int index, setStateX, List<PlatformFile> filePickerEditCommentFile) {
    BuildContext popupContext = context;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Tùy chọn",
            style: TextStyle(fontFamily: 'Nunito', fontSize: 18, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  'Xóa',
                  style: TextStyle(fontFamily: 'Nunito', fontSize: 17, fontWeight: FontWeight.w700, color: ColorsManager.red),
                ),
                onTap: () {
                  _showDeleteAttachmentCommentConfirmationV2(context, index, popupContext, setStateX, filePickerEditCommentFile);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteAttachmentCommentConfirmationV2(
      BuildContext context, int index, BuildContext popupContext, setStateX, List<PlatformFile> filePickerEditCommentFile) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Xóa tệp này?",
            style: TextStyle(fontFamily: 'Nunito', fontSize: 20, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
          ),
          content: const Text(
            "Một khi nó đã mất, thì nó đã mất.",
            style: TextStyle(fontFamily: 'Nunito', fontSize: 15, fontWeight: FontWeight.w700, color: ColorsManager.textColor2),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text(
                "Hủy",
                style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w700, color: ColorsManager.primary),
              ),
            ),
            TextButton(
              onPressed: () {
                setStateX(() => {filePickerEditCommentFile.removeAt(index)});
                Navigator.of(context).pop();
                Navigator.of(popupContext).pop();
              },
              child: Text(
                "Xóa tài liệu này",
                style: TextStyle(fontFamily: 'Nunito', fontSize: 16, fontWeight: FontWeight.w700, color: ColorsManager.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
