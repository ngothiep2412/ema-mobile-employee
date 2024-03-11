import 'package:flutter/material.dart';
// import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_view.dart';
import 'package:hrea_mobile_employee/app/resources/color_manager.dart';
import 'package:hrea_mobile_employee/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_employee/app/resources/style_manager.dart';
import '../controllers/edit_description_controller.dart';
import 'package:flutter_quill/flutter_quill.dart' as Quil;

class EditDescriptionView extends BaseView<EditDescriptionController> {
  EditDescriptionView({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: _appBar(context),
      backgroundColor: ColorsManager.backgroundContainer,
      body: Quil.QuillProvider(
        configurations: Quil.QuillConfigurations(controller: controller.quillController.value),
        child: SafeArea(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
                  flex: 10,
                  child: Column(
                    children: [
                      const Quil.QuillToolbar(
                        configurations: Quil.QuillToolbarConfigurations(
                          showDividers: false,
                          showFontFamily: false,
                          showFontSize: true,
                          showBoldButton: true,
                          showItalicButton: true,
                          showSmallButton: false,
                          showUnderLineButton: true,
                          showStrikeThrough: false,
                          showInlineCode: false,
                          showColorButton: true,
                          showBackgroundColorButton: false,
                          showClearFormat: false,
                          showAlignmentButtons: true,
                          showLeftAlignment: true,
                          showCenterAlignment: true,
                          showRightAlignment: true,
                          showJustifyAlignment: true,
                          showHeaderStyle: false,
                          showListNumbers: false,
                          showListBullets: false,
                          showListCheck: false,
                          showCodeBlock: false,
                          showQuote: false,
                          showIndent: false,
                          showLink: false,
                          showUndo: true,
                          showRedo: true,
                          showDirection: false,
                          showSearchButton: false,
                          showSubscript: false,
                          showSuperscript: false,
                        ),
                        // embedButtons: FlutterQuillEmbeds.buttons(),

                        // multiRowsDisplay: true,
                      ),
                      const Divider(
                        color: ColorsManager.textColor2,
                        thickness: 1,
                      ),
                      Stack(
                        children: [
                          Quil.QuillEditor.basic(
                            configurations: Quil.QuillEditorConfigurations(autoFocus: false, expands: false, editorKey: GlobalKey(), readOnly: false),
                            focusNode: controller.focusNodeDetail,

                            // embedBuilders: FlutterQuillEmbeds.builders(),

                            // controller: controller.quillController.value,
                            // true for view only mode
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
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
      actions: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                controller.saveDescription();
                controller.errorUpdateTask.value == true ? _errorMessage(context) : _successMessage(context);
                controller.onDelete();
              },
              child: Text(
                "Lưu",
                style: GetTextStyle.getTextStyle(18, 'Nunito', FontWeight.w600, ColorsManager.primary),
              ),
            ),
            SizedBox(
              width: UtilsReponsive.width(15, context),
            ),
          ],
        ),
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
                  'Thay đổi mô tả công việc thành công',
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
                      controller.errorUpdateTaskText.value,
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
