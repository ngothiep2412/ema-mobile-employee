import 'dart:convert';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/request.dart';
import 'package:http/http.dart' as http;
import 'package:hrea_mobile_employee/app/resources/base_link.dart';

class TabRequestApi {
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

  static Future<List<RequestModel>> getLeaveRequestByStatusAndType(String jwtToken, String requestor, int page, String status, String type) async {
    var response = await http.get(
      Uri.parse('${BaseLink.localBaseLink}${BaseLink.getAllLeaveRequest}$page/10?requestor=$requestor&status=$status&type=$type'),
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

  static Future<List<RequestModel>> getLeaveRequestByStatus(String jwtToken, String requestor, int page, String status) async {
    var response = await http.get(
      Uri.parse('${BaseLink.localBaseLink}${BaseLink.getAllLeaveRequest}$page/10?requestor=$requestor&status=$status'),
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

  static Future<List<RequestModel>> getLeaveRequestByType(String jwtToken, String requestor, int page, String type) async {
    var response = await http.get(
      Uri.parse('${BaseLink.localBaseLink}${BaseLink.getAllLeaveRequest}$page/10?requestor=$requestor&type=$type'),
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
}
