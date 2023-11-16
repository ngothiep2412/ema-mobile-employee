import 'dart:convert';
import 'package:hrea_mobile_employee/app/modules/check_in_detail/model/timesheet_model.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/request.dart';
import 'package:http/http.dart' as http;
import 'package:hrea_mobile_employee/app/resources/base_link.dart';

class TabTimeSheetApi {
  static Future<List<RequestModel>> getAllLeaveRequest(String jwtToken, String requestor, int page) async {
    var response = await http.get(
      Uri.parse('${BaseLink.localBaseLink}${BaseLink.getAllLeaveRequest}$page/10?requestor=$requestor'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $jwtToken',
      },
    );
    print('abc task' + response.statusCode.toString());
    if (response.statusCode == 201 || response.statusCode == 200) {
      var jsonData = jsonDecode(response.body)["result"]["data"];
      List<RequestModel> listLeaveRequest = [];
      listLeaveRequest.addAll(jsonData.map((listLeaveRequest) => RequestModel.fromJson(listLeaveRequest)).cast<RequestModel>());
      return listLeaveRequest;
    } else {
      throw Exception('Exception');
    }
  }

  static Future<List<TimesheetModel>> getTimeSheet(String jwtToken, String eventId, String startDate) async {
    var response = await http.get(
      Uri.parse('${BaseLink.localBaseLink}${BaseLink.getDetailTimesheet}?eventId=$eventId&startDate=$startDate&me=true'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $jwtToken',
      },
    );
    print('abc task' + response.statusCode.toString());
    if (response.statusCode == 201 || response.statusCode == 200) {
      var jsonData = jsonDecode(response.body)["result"]["data"];
      List<TimesheetModel> listTimeSheet = [];
      listTimeSheet.addAll(jsonData.map((listTimeSheet) => TimesheetModel.fromJson(listTimeSheet)).cast<TimesheetModel>());
      return listTimeSheet;
    } else {
      throw Exception('Exception');
    }
  }
}
