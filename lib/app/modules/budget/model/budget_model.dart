// To parse this JSON data, do
//
//     final budgetModel = budgetModelFromJson(jsonString);

import 'dart:convert';

List<BudgetModel> budgetModelFromJson(String str) => List<BudgetModel>.from(
    json.decode(str).map((x) => BudgetModel.fromJson(x)));

String budgetModelToJson(List<BudgetModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BudgetModel {
  String? id;
  String? budgetName;
  int? estExpense;
  int? realExpense;
  String? status;
  String? eventId;
  String? eventName;
  String? createBy;
  DateTime? createdAt;
  dynamic approveBy;
  dynamic approveDate;
  dynamic urlImage;
  String? supplier;
  String? description;
  String? userName;

  BudgetModel({
    this.id,
    this.budgetName,
    this.estExpense,
    this.realExpense,
    this.status,
    this.eventId,
    this.eventName,
    this.createBy,
    this.createdAt,
    this.approveBy,
    this.approveDate,
    this.urlImage,
    this.supplier,
    this.description,
    this.userName,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) => BudgetModel(
        id: json["id"],
        budgetName: json["budgetName"],
        estExpense: json["estExpense"],
        realExpense: json["realExpense"],
        status: json["status"],
        eventId: json["eventID"],
        eventName: json["eventName"],
        createBy: json["createBy"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        approveBy: json["approveBy"],
        approveDate: json["approveDate"],
        urlImage: json["urlImage"],
        supplier: json["supplier"],
        description: json["description"],
        userName: json["userName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "budgetName": budgetName,
        "estExpense": estExpense,
        "realExpense": realExpense,
        "status": status,
        "eventID": eventId,
        "eventName": eventName,
        "createBy": createBy,
        "createAt": createdAt?.toIso8601String(),
        "approveBy": approveBy,
        "approveDate": approveDate,
        "urlImage": urlImage,
        "supplier": supplier,
        "description": description,
        "userName": userName,
      };
}
