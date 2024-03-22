import 'dart:convert';
import 'package:hrea_mobile_employee/app/modules/budget/model/budget_model.dart';
import 'package:http/http.dart' as http;
import 'package:hrea_mobile_employee/app/resources/base_link.dart';

class BudgetApi {
  static Future<List<BudgetModel>> getAllBudget(String jwtToken, currentPage, String sort, String status) async {
    var response = await http.get(
      Uri.parse(
          '${BaseLink.localBaseLink}${BaseLink.getAllBudget}?sizePage=100&currentPage=$currentPage&sortProperty=createdAt&sort=$sort&status=$status'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        'Authorization': 'Bearer $jwtToken',
      },
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      var jsonData = jsonDecode(response.body)["result"]['data'];
      List<BudgetModel> listBudget = [];
      listBudget.addAll(jsonData.map((listBudget) => BudgetModel.fromJson(listBudget)).cast<BudgetModel>());
      return listBudget;
    } else {
      throw Exception('Exception');
    }
  }
}
