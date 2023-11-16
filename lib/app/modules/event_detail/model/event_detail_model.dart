// To parse this JSON data, do
//
//     final eventDetailModel = eventDetailModelFromJson(jsonString);

import 'dart:convert';

EventDetailModel eventDetailModelFromJson(String str) =>
    EventDetailModel.fromJson(json.decode(str));

String eventDetailModelToJson(EventDetailModel data) =>
    json.encode(data.toJson());

class EventDetailModel {
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? eventName;
  DateTime? startDate;
  DateTime? endDate;
  String? location;
  String? description;
  String? coverUrl;
  int? estBudget;
  String? status;
  List<ListDivision>? listDivision;

  EventDetailModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.eventName,
    this.startDate,
    this.endDate,
    this.location,
    this.description,
    this.coverUrl,
    this.estBudget,
    this.status,
    this.listDivision,
  });

  factory EventDetailModel.fromJson(Map<String, dynamic> json) =>
      EventDetailModel(
        id: json["id"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        eventName: json["eventName"],
        startDate: json["startDate"] == null
            ? null
            : DateTime.parse(json["startDate"]),
        endDate:
            json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        location: json["location"],
        description: json["description"],
        coverUrl: json["coverUrl"],
        estBudget: json["estBudget"],
        status: json["status"],
        listDivision: json["listDivision"] == null
            ? []
            : List<ListDivision>.from(
                json["listDivision"]!.map((x) => ListDivision.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "eventName": eventName,
        "startDate":
            "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
        "endDate":
            "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
        "location": location,
        "description": description,
        "coverUrl": coverUrl,
        "estBudget": estBudget,
        "status": status,
        "listDivision": listDivision == null
            ? []
            : List<dynamic>.from(listDivision!.map((x) => x.toJson())),
      };
}

class ListDivision {
  String? divisionId;
  String? divisionName;
  String? userId;
  String? fullName;
  String? avatar;

  ListDivision({
    this.divisionId,
    this.divisionName,
    this.userId,
    this.fullName,
    this.avatar,
  });

  factory ListDivision.fromJson(Map<String, dynamic> json) => ListDivision(
        divisionId: json["divisionId"],
        divisionName: json["divisionName"],
        userId: json["userId"],
        fullName: json["fullName"],
        avatar: json["avatar"],
      );

  Map<String, dynamic> toJson() => {
        "divisionId": divisionId,
        "divisionName": divisionName,
        "userId": userId,
        "fullName": fullName,
        "avatar": avatar,
      };
}
