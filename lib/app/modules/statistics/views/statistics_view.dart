import 'package:flutter/material.dart';

import 'package:hrea_mobile_employee/app/base/base_view.dart';

import '../controllers/statistics_controller.dart';
import 'package:pie_chart/pie_chart.dart';

class StatisticsView extends BaseView<StatisticsController> {
  const StatisticsView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blue[200],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Pie Chart"),
        centerTitle: true,
      ),
      body: Center(
        child: PieChart(
          colorList: controller.colorsList,
          dataMap: controller.dataMap,
          // chartType: ChartType.ring,
          chartLegendSpacing: 10,
          chartRadius: MediaQuery.of(context).size.width / 1.2,
          legendOptions: const LegendOptions(
              // legendPosition: LegendPosition.bottom,
              ),
          chartValuesOptions: const ChartValuesOptions(
            showChartValuesInPercentage: true,
            // showChartValuesOutside: true,
          ),
        ),
      ),
    );
  }
}
