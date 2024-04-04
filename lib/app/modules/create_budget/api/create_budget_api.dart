import 'dart:convert';
import 'package:hrea_mobile_employee/app/resources/response_api_model.dart';
import 'package:http/http.dart' as http;
import 'package:hrea_mobile_employee/app/resources/base_link.dart';

class CreateBudgetApi {
  static Future<ResponseApi> createBudget(String taskID, String transactionName, double amount, String description, String jwtToken) async {
    Map<String, dynamic> body = {
      "transactionName": transactionName,
      "description": description,
      "amount": amount,
    };
    var response = await http.post(Uri.parse('${BaseLink.localBaseLink}${BaseLink.createBudget}/$taskID/transaction-request'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          'Authorization': 'Bearer $jwtToken',
        },
        body: jsonEncode(body));
    print('budget create' + response.statusCode.toString());
    if (response.statusCode == 201 || response.statusCode == 200) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 400 || response.statusCode == 500) {
      return Future<ResponseApi>.value(ResponseApi.fromJson(jsonDecode(response.body)));
    } else {
      throw Exception('Exception');
    }
  }
}
