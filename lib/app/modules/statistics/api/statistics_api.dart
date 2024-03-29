import 'dart:convert';

import 'package:hrea_mobile_employee/app/modules/tab_view/model/task.dart';
import 'package:hrea_mobile_employee/app/resources/base_link.dart';
import 'package:http/http.dart' as http;

class StatisticsApi {
  static Future<List<TaskModel>> getTaskByDate(String jwtToken, String startDate, String endDate, String userID) async {
    var response = await http.get(
      Uri.parse('${BaseLink.localBaseLink}${BaseLink.getTaskByDate}?userId=$userID&date=$startDate&dateEnd=$endDate'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $jwtToken',
      },
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      var jsonData = jsonDecode(response.body)["result"];
      List<TaskModel> listTask = [];
      listTask.addAll(jsonData.map((listTask) => TaskModel.fromJson(listTask)).cast<TaskModel>());
      return listTask;
    } else {
      throw Exception('Exception');
    }
  }
}
