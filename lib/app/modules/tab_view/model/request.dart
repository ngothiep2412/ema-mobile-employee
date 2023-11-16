// To parse this JSON data, do
//
//     final requestModel = requestModelFromJson(jsonString);

import 'dart:convert';

List<RequestModel> requestModelFromJson(String str) => List<RequestModel>.from(
    json.decode(str).map((x) => RequestModel.fromJson(x)));

String requestModelToJson(List<RequestModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RequestModel {
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? title;
  String? content;
  DateTime? startDate;
  DateTime? endDate;
  bool? isFull;
  bool? isPm;
  dynamic approver;
  String? status;
  dynamic replyMessage;
  String? requestor;
  String? type;
  User? user;

  RequestModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.title,
    this.content,
    this.startDate,
    this.endDate,
    this.isFull,
    this.isPm,
    this.approver,
    this.status,
    this.replyMessage,
    this.requestor,
    this.type,
    this.user,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) => RequestModel(
        id: json["id"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        title: json["title"],
        content: json["content"],
        startDate: json["startDate"] == null
            ? null
            : DateTime.parse(json["startDate"]),
        endDate:
            json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        isFull: json["isFull"],
        isPm: json["isPM"],
        approver: json["approver"],
        status: json["status"],
        replyMessage: json["replyMessage"],
        requestor: json["requestor"],
        type: json["type"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "title": title,
        "content": content,
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
        "isFull": isFull,
        "isPM": isPm,
        "approver": approver,
        "status": status,
        "replyMessage": replyMessage,
        "requestor": requestor,
        "type": type,
        "user": user?.toJson(),
      };
}

class User {
  String? id;
  Profile? profile;

  User({
    this.id,
    this.profile,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        profile:
            json["profile"] == null ? null : Profile.fromJson(json["profile"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "profile": profile?.toJson(),
      };
}

class Profile {
  String? profileId;
  String? role;
  String? fullName;
  String? phoneNumber;
  String? avatar;

  Profile({
    this.profileId,
    this.role,
    this.fullName,
    this.phoneNumber,
    this.avatar,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        profileId: json["profileId"],
        role: json["role"],
        fullName: json["fullName"],
        phoneNumber: json["phoneNumber"],
        avatar: json["avatar"],
      );

  Map<String, dynamic> toJson() => {
        "profileId": profileId,
        "role": role,
        "fullName": fullName,
        "phoneNumber": phoneNumber,
        "avatar": avatar,
      };
}
