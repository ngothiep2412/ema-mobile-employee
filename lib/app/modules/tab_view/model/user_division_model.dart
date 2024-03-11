// To parse this JSON data, do
//
//     final userDivisionModel = userDivisionModelFromJson(jsonString);

import 'dart:convert';

List<UserDivisionModel> userDivisionModelFromJson(String str) =>
    List<UserDivisionModel>.from(json.decode(str).map((x) => UserDivisionModel.fromJson(x)));

String userDivisionModelToJson(List<UserDivisionModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserDivisionModel {
  String? role;
  String? id;
  String? fullName;
  String? email;
  String? typeEmployee;
  String? phoneNumber;
  DateTime? dob;
  String? nationalId;
  dynamic nationalImages;
  String? gender;
  String? address;
  String? avatar;
  String? divisionId;
  String? divisionName;
  String? status;
  bool? online;

  UserDivisionModel({
    this.role,
    this.id,
    this.fullName,
    this.email,
    this.typeEmployee,
    this.phoneNumber,
    this.dob,
    this.nationalId,
    this.nationalImages,
    this.gender,
    this.address,
    this.avatar,
    this.divisionId,
    this.divisionName,
    this.status,
    this.online,
  });

  factory UserDivisionModel.fromJson(Map<String, dynamic> json) => UserDivisionModel(
        role: json["role"],
        id: json["id"],
        fullName: json["fullName"],
        email: json["email"],
        typeEmployee: json["typeEmployee"],
        phoneNumber: json["phoneNumber"],
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        nationalId: json["nationalId"],
        nationalImages: json["nationalImages"],
        gender: json["gender"],
        address: json["address"],
        avatar: json["avatar"],
        divisionId: json["divisionId"],
        divisionName: json["divisionName"],
        status: json["status"],
        online: json['online'],
      );

  Map<String, dynamic> toJson() => {
        "role": role,
        "id": id,
        "fullName": fullName,
        "email": email,
        "typeEmployee": typeEmployee,
        "phoneNumber": phoneNumber,
        "dob": dob?.toIso8601String(),
        "nationalId": nationalId,
        "nationalImages": nationalImages,
        "gender": gender,
        "address": address,
        "avatar": avatar,
        "divisionId": divisionId,
        "divisionName": divisionName,
        "status": status,
        "online": online,
      };
}
