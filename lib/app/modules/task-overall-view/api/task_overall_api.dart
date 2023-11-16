import 'dart:convert';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/task.dart';
import 'package:hrea_mobile_employee/app/resources/base_link.dart';
import 'package:http/http.dart' as http;

class TaskOverallApi {
  static Future<List<TaskModel>> getFilterTask(String jwtToken, String eventID, String staffID) async {
    var response = await http.get(
      Uri.parse('${BaseLink.localBaseLink}${BaseLink.getTaskBySelf}?assignee=$staffID&eventID=$eventID'),
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

  static Future<List<TaskModel>> getTask(String jwtToken, String eventID) async {
    var response = await http.get(
      Uri.parse('${BaseLink.localBaseLink}${BaseLink.getTask}?fieldName=eventID&conValue=$eventID&sizePage=100&currentPage=1'),
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
