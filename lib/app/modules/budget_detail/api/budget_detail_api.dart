import 'dart:convert';
import 'package:hrea_mobile_employee/app/modules/budget/model/budget_model.dart';
import 'package:hrea_mobile_employee/app/resources/response_api_model.dart';
import 'package:http/http.dart' as http;
import 'package:hrea_mobile_employee/app/resources/base_link.dart';

class BudgetDetailApi {
  static Future<ResponseApi> deleteBudget(String budgetID, String jwtToken) async {
    var response = await http.delete(Uri.parse('${BaseLink.localBaseLink}${BaseLink.deleteBudget}$budgetID'), headers: {
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

  static Future<BudgetModel> getBudgetDetail(String budgetID, String jwtToken) async {
    var response = await http.get(Uri.parse('${BaseLink.localBaseLink}${BaseLink.getBudgetDetail}$budgetID'), headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      'Authorization': 'Bearer $jwtToken',
    });

    print('abc' + response.statusCode.toString());
    if (response.statusCode == 201 || response.statusCode == 200) {
      var jsonData = jsonDecode(response.body)["result"];
      return Future<BudgetModel>.value(BudgetModel.fromJson(jsonData));
    } else {
      throw Exception('Exception');
    }
  }
}
