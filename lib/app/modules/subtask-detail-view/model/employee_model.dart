// To parse this JSON data, do
//
//     final employeeModel = employeeModelFromJson(jsonString);

import 'dart:convert';

List<EmployeeModel> employeeModelFromJson(String str) =>
    List<EmployeeModel>.from(
        json.decode(str).map((x) => EmployeeModel.fromJson(x)));

String employeeModelToJson(List<EmployeeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EmployeeModel {
  String? role;
  String? id;
  String? fullName;
  String? email;
  String? phoneNumber;
  DateTime? dob;
  String? nationalId;
  String? gender;
  String? address;
  String? avatar;
  String? divisionId;
  String? divisionName;
  String? status;
  bool? check;

  EmployeeModel({
    this.role,
    this.id,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.dob,
    this.nationalId,
    this.gender,
    this.address,
    this.avatar,
    this.divisionId,
    this.divisionName,
    this.status,
    this.check,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
        role: json["role"],
        id: json["id"],
        fullName: json["fullName"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        nationalId: json["nationalId"],
        gender: json["gender"],
        address: json["address"],
        avatar: json["avatar"],
        divisionId: json["divisionId"],
        divisionName: json["divisionName"],
        status: json["status"],
        check: false,
      );

  Map<String, dynamic> toJson() => {
        "role": role,
        "id": id,
        "fullName": fullName,
        "email": email,
        "phoneNumber": phoneNumber,
        "dob": dob?.toIso8601String(),
        "nationalId": nationalId,
        "gender": gender,
        "address": address,
        "avatar": avatar,
        "divisionId": divisionId,
        "divisionName": divisionName,
        "status": status,
      };
}
