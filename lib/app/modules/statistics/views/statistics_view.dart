import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

import 'package:hrea_mobile_employee/app/base/base_view.dart';
import 'package:hrea_mobile_employee/app/resources/assets_manager.dart';
import 'package:hrea_mobile_employee/app/resources/color_manager.dart';
import 'package:hrea_mobile_employee/app/resources/reponsive_utils.dart';
import 'package:hrea_mobile_employee/app/resources/style_manager.dart';

import '../controllers/statistics_controller.dart';
import 'package:pie_chart/pie_chart.dart';

class StatisticsView extends BaseView<StatisticsController> {
  const StatisticsView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.blue[200],
        appBar: _appBar(context),
        body: Obx(
          () => controller.isLoading.value
              ? Center(
                  child: SpinKitFadingCircle(
                    color: ColorsManager.primary,
                  ),
                )
              : controller.checkView.value == false
                  ? SafeArea(
                      child: Center(
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
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: controller.refreshPage,
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height, maxWidth: MediaQuery.of(context).size.width),
                          color: ColorsManager.backgroundContainer,
                          // height: double.infinity,
                          child: Obx(
                            () => Column(
                              children: [
                                SizedBox(
                                  height: UtilsReponsive.height(20, context),
                                ),
                                Text.rich(
                                  TextSpan(
                                    text: 'Tổng số công việc: ',
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      color: ColorsManager.textColor2,
                                      fontSize: UtilsReponsive.height(18, context),
                                      fontWeight: FontWeight.w700,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '${controller.listTask.length}',
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          color: ColorsManager.primary,
                                          fontSize: UtilsReponsive.height(18, context),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' công việc trong tuần này',
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          color: ColorsManager.textColor2,
                                          fontSize: UtilsReponsive.height(18, context),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: UtilsReponsive.height(20, context),
                                ),
                                Text.rich(
                                  TextSpan(
                                    text: 'Từ ',
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      color: ColorsManager.textColor2,
                                      fontSize: UtilsReponsive.height(16, context),
                                      fontWeight: FontWeight.w700,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '${controller.startDate}',
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          color: ColorsManager.primary,
                                          fontSize: UtilsReponsive.height(16, context),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' đến',
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          color: ColorsManager.textColor2,
                                          fontSize: UtilsReponsive.height(16, context),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' ${controller.endDate}',
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          color: ColorsManager.primary,
                                          fontSize: UtilsReponsive.height(16, context),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: UtilsReponsive.height(20, context),
                                ),
                                Container(
                                  height: MediaQuery.of(context).size.height / 4,
                                  child: GridView(
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 1.7,
                                    ),
                                    physics: BouncingScrollPhysics(),
                                    children: [
                                      myBoxTask(controller.dataStatusTask['PENDING']!, 'PENDING'),
                                      myBoxTask(controller.dataStatusTask['PROCESSING']!, 'PROCESSING'),
                                      myBoxTask(controller.dataStatusTask['DONE']!, 'DONE'),
                                      myBoxTask(controller.dataStatusTask['CONFIRM']!, 'CONFIRM'),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: MediaQuery.of(context).size.height / 3,
                                  child: Center(
                                    child: Obx(
                                      () => PieChart(
                                        colorList: controller.colorsList,
                                        dataMap: controller.dataMapView.value,
                                        // chartType: ChartType.ring,
                                        chartLegendSpacing: 10,
                                        chartRadius: MediaQuery.of(context).size.width / 1.2,
                                        legendOptions: const LegendOptions(
                                            // legendPosition: LegendPosition.bottom,

                                            ),

                                        centerWidget: const Text("Độ ưu tiên",
                                            style: TextStyle(
                                              fontFamily: 'Nunito',
                                              color: ColorsManager.backgroundWhite,
                                              fontWeight: FontWeight.w700,
                                            )),

                                        chartValuesOptions: const ChartValuesOptions(
                                          showChartValuesInPercentage: true,
                                          // showC
                                          // showChartValuesOutside: true,
                                          showChartValueBackground: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
      title: Text(
        'Thống kê công việc',
        style: TextStyle(
          fontFamily: 'Nunito',
          color: ColorsManager.primary,
          fontSize: UtilsReponsive.height(22, context),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget myBoxTask(int i, String status) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: status == 'PENDING'
            ? ColorsManager.grey
            : status == 'PROCESSING'
                ? ColorsManager.blue
                : status == 'DONE'
                    ? ColorsManager.green
                    : status == 'CONFIRM'
                        ? ColorsManager.purple
                        : ColorsManager.red,
        borderRadius: BorderRadius.circular(10), // Đặt bán kính cho góc là 10
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$i',
            style: const TextStyle(letterSpacing: 1, color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            status == 'PENDING'
                ? "Đang chuẩn bị"
                : status == 'PROCESSING'
                    ? "Đang thực hiện"
                    : status == 'DONE'
                        ? "Hoàn thành"
                        : status == 'CONFIRM'
                            ? "Đã xác thực"
                            : "Quá hạn",
            style: const TextStyle(letterSpacing: 1, color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800),
          )
        ],
      ),
    );
  }
}
