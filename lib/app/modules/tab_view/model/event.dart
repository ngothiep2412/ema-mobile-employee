// To parse this JSON data, do
//
//     final eventModel = eventModelFromJson(jsonString);

import 'dart:convert';

List<EventModel> eventModelFromJson(String str) => List<EventModel>.from(json.decode(str).map((x) => EventModel.fromJson(x)));

String eventModelToJson(List<EventModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EventModel {
  String? id;
  String? eventName;
  String? description;
  String? coverUrl;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? processingDate;
  String? location;
  int? estBudget;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? status;

  EventModel({
    this.id,
    this.eventName,
    this.description,
    this.coverUrl,
    this.startDate,
    this.endDate,
    this.processingDate,
    this.location,
    this.estBudget,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        id: json["id"],
        eventName: json["eventName"],
        description: json["description"],
        coverUrl: json["coverUrl"],
        startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
        endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        processingDate: json["processingDate"] == null ? null : DateTime.parse(json["processingDate"]),
        location: json["location"],
        estBudget: json["estBudget"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "eventName": eventName,
        "description": description,
        "coverUrl": coverUrl,
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
        "processingDate": processingDate?.toIso8601String(),
        "location": location,
        "estBudget": estBudget,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "status": status,
      };
}
