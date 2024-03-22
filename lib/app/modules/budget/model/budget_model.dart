// To parse this JSON data, do
//
//     final budgetModel = budgetModelFromJson(jsonString);

import 'dart:convert';

BudgetModel budgetModelFromJson(String str) => BudgetModel.fromJson(json.decode(str));

String budgetModelToJson(BudgetModel data) => json.encode(data.toJson());

class BudgetModel {
  String? taskId;
  dynamic taskCode;
  String? taskTitle;
  String? parentTask;
  List<Transaction>? transactions;

  BudgetModel({
    this.taskId,
    this.taskCode,
    this.taskTitle,
    this.parentTask,
    this.transactions,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) => BudgetModel(
        taskId: json["taskId"],
        taskCode: json["taskCode"],
        taskTitle: json["taskTitle"],
        parentTask: json["parentTask"],
        transactions: json["transactions"] == null ? [] : List<Transaction>.from(json["transactions"]!.map((x) => Transaction.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "taskId": taskId,
        "taskCode": taskCode,
        "taskTitle": taskTitle,
        "parentTask": parentTask,
        "transactions": transactions == null ? [] : List<dynamic>.from(transactions!.map((x) => x.toJson())),
      };
}

class Transaction {
  String? id;
  String? transactionName;
  String? transactionCode;
  String? description;
  int? amount;
  dynamic rejectNote;
  String? status;
  dynamic processedBy;
  DateTime? createdAt;
  String? createdBy;
  DateTime? updatedAt;
  dynamic updatedBy;
  List<Evidence>? evidences;

  Transaction({
    this.id,
    this.transactionName,
    this.transactionCode,
    this.description,
    this.amount,
    this.rejectNote,
    this.status,
    this.processedBy,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
    this.evidences,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json["id"],
        transactionName: json["transactionName"],
        transactionCode: json["transactionCode"],
        description: json["description"],
        amount: json["amount"],
        rejectNote: json["rejectNote"],
        status: json["status"],
        processedBy: json["processedBy"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        createdBy: json["createdBy"],
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        updatedBy: json["updatedBy"],
        evidences: json["evidences"] == null ? [] : List<Evidence>.from(json["evidences"]!.map((x) => Evidence.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "transactionName": transactionName,
        "transactionCode": transactionCode,
        "description": description,
        "amount": amount,
        "rejectNote": rejectNote,
        "status": status,
        "processedBy": processedBy,
        "createdAt": createdAt?.toIso8601String(),
        "createdBy": createdBy,
        "updatedAt": updatedAt?.toIso8601String(),
        "updatedBy": updatedBy,
        "evidences": evidences == null ? [] : List<dynamic>.from(evidences!.map((x) => x.toJson())),
      };
}

class Evidence {
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? evidenceFileName;
  int? evidenceFileSize;
  String? evidenceFileType;
  String? evidenceUrl;
  String? createdBy;

  Evidence({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.evidenceFileName,
    this.evidenceFileSize,
    this.evidenceFileType,
    this.evidenceUrl,
    this.createdBy,
  });

  factory Evidence.fromJson(Map<String, dynamic> json) => Evidence(
        id: json["id"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        evidenceFileName: json["evidenceFileName"],
        evidenceFileSize: json["evidenceFileSize"],
        evidenceFileType: json["evidenceFileType"],
        evidenceUrl: json["evidenceUrl"],
        createdBy: json["createdBy"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "evidenceFileName": evidenceFileName,
        "evidenceFileSize": evidenceFileSize,
        "evidenceFileType": evidenceFileType,
        "evidenceUrl": evidenceUrl,
        "createdBy": createdBy,
      };
}
