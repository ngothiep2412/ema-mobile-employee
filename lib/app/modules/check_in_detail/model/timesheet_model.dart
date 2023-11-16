// To parse this JSON data, do
//
//     final timesheetModel = timesheetModelFromJson(jsonString);

import 'dart:convert';

TimesheetModel timesheetModelFromJson(String str) =>
    TimesheetModel.fromJson(json.decode(str));

String timesheetModelToJson(TimesheetModel data) => json.encode(data.toJson());

class TimesheetModel {
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? date;
  String? checkinTime;
  dynamic checkinLocation;
  Event? event;

  TimesheetModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.date,
    this.checkinTime,
    this.checkinLocation,
    this.event,
  });

  factory TimesheetModel.fromJson(Map<String, dynamic> json) => TimesheetModel(
        id: json["id"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        checkinTime: json["checkinTime"],
        checkinLocation: json["checkinLocation"],
        event: json["event"] == null ? null : Event.fromJson(json["event"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "checkinTime": checkinTime,
        "checkinLocation": checkinLocation,
        "event": event?.toJson(),
      };
}

class Event {
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? eventName;
  DateTime? startDate;
  DateTime? processingDate;
  DateTime? endDate;
  String? location;
  String? description;
  String? coverUrl;
  int? estBudget;
  dynamic checkInQrCode;
  dynamic checkOutQrCode;
  bool? isTemplate;
  String? status;

  Event({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.eventName,
    this.startDate,
    this.processingDate,
    this.endDate,
    this.location,
    this.description,
    this.coverUrl,
    this.estBudget,
    this.checkInQrCode,
    this.checkOutQrCode,
    this.isTemplate,
    this.status,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
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
        processingDate: json["processingDate"] == null
            ? null
            : DateTime.parse(json["processingDate"]),
        endDate:
            json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        location: json["location"],
        description: json["description"],
        coverUrl: json["coverUrl"],
        estBudget: json["estBudget"],
        checkInQrCode: json["checkInQRCode"],
        checkOutQrCode: json["checkOutQRCode"],
        isTemplate: json["isTemplate"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "eventName": eventName,
        "startDate":
            "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
        "processingDate":
            "${processingDate!.year.toString().padLeft(4, '0')}-${processingDate!.month.toString().padLeft(2, '0')}-${processingDate!.day.toString().padLeft(2, '0')}",
        "endDate":
            "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
        "location": location,
        "description": description,
        "coverUrl": coverUrl,
        "estBudget": estBudget,
        "checkInQRCode": checkInQrCode,
        "checkOutQRCode": checkOutQrCode,
        "isTemplate": isTemplate,
        "status": status,
      };
}
