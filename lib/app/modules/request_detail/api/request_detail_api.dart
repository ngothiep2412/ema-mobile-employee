import 'dart:convert';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/request.dart';
import 'package:hrea_mobile_employee/app/resources/response_api_model.dart';
import 'package:http/http.dart' as http;
import 'package:hrea_mobile_employee/app/resources/base_link.dart';

class LeaveRequestDetailApi {
  static Future<ResponseApi> deleteRequest(String requestID, String jwtToken) async {
    var response = await http.delete(Uri.parse('${BaseLink.localBaseLink}${BaseLink.deleteLeaveRequest}$requestID'), headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      'Authorization': 'Bearer $jwtToken',
    });

    print('abc' + response.statusCode.toString());
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }

  static Future<RequestModel> getLeaveRequestDetail(String requestID, String jwtToken) async {
    var response = await http.get(Uri.parse('${BaseLink.localBaseLink}${BaseLink.getLeaveRequestDetail}$requestID'), headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      'Authorization': 'Bearer $jwtToken',
    });

    if (response.statusCode == 201 || response.statusCode == 200) {
      var jsonData = jsonDecode(response.body)["result"][0];
      return Future<RequestModel>.value(RequestModel.fromJson(jsonData));
    } else {
      throw Exception('Exception');
    }
  }
}
