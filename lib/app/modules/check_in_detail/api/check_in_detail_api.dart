import 'dart:convert';
import 'package:hrea_mobile_employee/app/modules/check_in_detail/model/timesheet_model.dart';
import 'package:http/http.dart' as http;
import 'package:hrea_mobile_employee/app/resources/base_link.dart';

class CheckInDetailApi {
  static Future<List<TimesheetModel>> getListTimeSheet(String jwtToken, String eventID) async {
    var response = await http.get(
      Uri.parse('${BaseLink.localBaseLink}${BaseLink.getDetailTimesheet}?eventId=$eventID&me=true'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $jwtToken',
      },
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      var jsonData = jsonDecode(response.body)["result"];
      List<TimesheetModel> listComment = [];
      listComment.addAll(jsonData.map((events) => TimesheetModel.fromJson(events)).cast<TimesheetModel>());
      return listComment;
    } else {
      throw Exception('Exception');
    }
  }
}
