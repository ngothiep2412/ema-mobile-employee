// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  int? statusCode;
  Result? result;

  UserModel({
    this.statusCode,
    this.result,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        statusCode: json["statusCode"],
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "result": result?.toJson(),
      };
}

class Result {
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
  String? divisionName;

  Result({
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
    this.divisionName,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
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
        divisionName: json["divisionName"],
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
        "divisionName": divisionName,
      };
}
