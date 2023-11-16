import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_view.dart';
import 'package:hrea_mobile_employee/app/resources/color_manager.dart';
import 'package:hrea_mobile_employee/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_employee/app/resources/style_manager.dart';
import 'package:hrea_mobile_employee/app/routes/app_pages.dart';
import '../controllers/budget_controller.dart';

class BudgetView extends BaseView<BudgetController> {
  const BudgetView({Key? key}) : super(key: key);
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
                : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Center(
                      child: Text(
                        'Danh sách đơn khoản chi',
                        style: GetTextStyle.getTextStyle(18, 'Roboto', FontWeight.w700, ColorsManager.primary),
                      ),
                    ),
                    SizedBox(
                      height: UtilsReponsive.height(10, context),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: controller.refreshPage,
                        child: controller.listBudget.isEmpty
                            ? Center(
                                child: Text(
                                  'Hiện không có danh sách yêu cầu khoản chi',
                                  style: GetTextStyle.getTextStyle(14, 'Roboto', FontWeight.w700, ColorsManager.textColor),
                                ),
                              )
                            : ListView.separated(
                                controller: controller.scrollController,
                                separatorBuilder: (context, index) => SizedBox(
                                      height: UtilsReponsive.height(20, context),
                                    ),
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(8),
                                itemCount: controller.listBudget.length,
                                itemBuilder: (context, index) {
                                  if (index == controller.listBudget.length - 1 && controller.isMoreDataAvailable.value == true) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  return GestureDetector(
                                    onTap: () {
                                      Get.toNamed(Routes.BUDGET_DETAIL,
                                          arguments: {"eventID": controller.eventID, "budget": controller.listBudget[index]});
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: UtilsReponsive.paddingAll(context, padding: 10),
                                      child: Row(children: [
                                        Expanded(
                                            child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              controller.listBudget[index].budgetName!,
                                              style: GetTextStyle.getTextStyle(14, 'Roboto', FontWeight.w700, ColorsManager.textColor),
                                            ),
                                            SizedBox(
                                              height: UtilsReponsive.height(10, context),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Ngày nộp đơn: ',
                                                  style: GetTextStyle.getTextStyle(12, 'Roboto', FontWeight.w600, ColorsManager.textColor2),
                                                ),
                                                Text(controller.dateFormat.format(controller.listBudget[index].createdAt!).toString(),
                                                    style: GetTextStyle.getTextStyle(12, 'Roboto', FontWeight.bold, ColorsManager.textColor)),
                                              ],
                                            ),
                                            SizedBox(
                                              height: UtilsReponsive.height(10, context),
                                            ),
                                            Row(
                                              children: [
                                                Text('Trạng thái: ',
                                                    style: GetTextStyle.getTextStyle(12, 'Roboto', FontWeight.w600, ColorsManager.textColor2)),
                                                Text(
                                                    controller.listBudget[index].status! == "REJECT"
                                                        ? "Từ chối"
                                                        : controller.listBudget[index].status! == "ACCEPT"
                                                            ? "Chấp nhận"
                                                            : "Đang xử lí",
                                                    style: GetTextStyle.getTextStyle(
                                                        12,
                                                        'Roboto',
                                                        FontWeight.bold,
                                                        controller.listBudget[index].status == 'REJECT'
                                                            ? ColorsManager.red
                                                            : controller.listBudget[index].status == 'PROCESSING'
                                                                ? ColorsManager.orange
                                                                : controller.listBudget[index].status == 'ACCEPT'
                                                                    ? ColorsManager.green
                                                                    : ColorsManager.primary)),
                                              ],
                                            ),
                                          ],
                                        ))
                                      ]),
                                    ),
                                  );
                                }),
                      ),
                    ),
                  ]),
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
        IconButton(
            onPressed: () {
              controller.refreshPage();
            },
            icon: const Icon(
              Icons.refresh,
              color: ColorsManager.textColor2,
            )),
        IconButton(
            onPressed: () {
              controller.createBudget();
            },
            icon: Icon(
              Icons.add,
              color: ColorsManager.primary,
            )),
      ],
    );
  }
}
