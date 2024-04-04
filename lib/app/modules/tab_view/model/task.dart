// To parse this JSON data, do
//
//     final taskModel = taskModelFromJson(jsonString);

import 'dart:convert';

List<TaskModel> taskModelFromJson(String str) => List<TaskModel>.from(json.decode(str).map((x) => TaskModel.fromJson(x)));

String taskModelToJson(List<TaskModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TaskModel {
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? title;
  DateTime? startDate;
  DateTime? endDate;
  String? description;
  Priority? priority;
  Status? status;
  // dynamic estimationTime;
  // dynamic effort;
  String? createdBy;
  String? nameAssigner;
  String? avatarAssigner;
  String? modifiedBy;
  dynamic approvedBy;
  // String? eventId;
  dynamic progress;
  List<TaskFile>? taskFiles;
  List<AssignTask>? assignTasks;
  List<TaskModel>? subTask;
  TaskModel? parent;
  EventDivision? eventDivision;

  TaskModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.title,
    this.startDate,
    this.endDate,
    this.description,
    this.priority,
    this.status,
    // this.estimationTime,
    this.progress,
    // this.effort,
    this.createdBy,
    this.nameAssigner,
    this.avatarAssigner,
    this.modifiedBy,
    this.approvedBy,
    // this.eventId,
    this.taskFiles,
    this.assignTasks,
    this.subTask,
    this.parent,
    this.eventDivision,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json["id"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        title: json["title"],
        startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
        endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        description: json["description"],
        priority: json["priority"] == null ? null : priorityValues.map[json["priority"]]!,
        status: json["status"] == null ? null : statusValues.map[json["status"]]!,
        // estimationTime: json["estimationTime"],
        progress: json["progress"],
        // effort: json["effort"],
        createdBy: json["createdBy"],
        modifiedBy: json["modifiedBy"],
        approvedBy: json["approvedBy"],
        // eventId: json["eventID"],
        taskFiles: json["taskFiles"] == null ? [] : List<TaskFile>.from(json["taskFiles"]!.map((x) => TaskFile.fromJson(x))),
        eventDivision: json["eventDivision"] == null ? null : EventDivision.fromJson(json["eventDivision"]),
        assignTasks: json["assignTasks"] == null ? [] : List<AssignTask>.from(json["assignTasks"]!.map((x) => AssignTask.fromJson(x))),
        subTask: json["subTask"] == null ? [] : List<TaskModel>.from(json["subTask"]!.map((x) => TaskModel.fromJson(x))),
        parent: json["parent"] == null ? null : TaskModel.fromJson(json["parent"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "title": title,
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
        "description": description,
        "priority": priorityValues.reverse[priority],
        "status": statusValues.reverse[status],
        // "estimationTime": estimationTime,
        "progress": progress,
        // "effort": effort,
        "createdBy": createdBy,
        "modifiedBy": modifiedBy,
        "approvedBy": approvedBy,
        // "eventID": eventId,
        "eventDivision": eventDivision?.toJson(),
        "taskFiles": taskFiles == null ? [] : List<dynamic>.from(taskFiles!.map((x) => x.toJson())),
        "assignTasks": assignTasks == null ? [] : List<dynamic>.from(assignTasks!.map((x) => x.toJson())),
        "subTask": subTask == null ? [] : List<dynamic>.from(subTask!.map((x) => x.toJson())),
        "parent": parent?.toJson(),
      };
}

class AssignTask {
  String? id;
  User? user;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? assignee;
  String? taskMaster;
  bool? isLeader;
  String? taskId;
  String? status;

  AssignTask({
    this.id,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.assignee,
    this.taskMaster,
    this.isLeader,
    this.taskId,
    this.status,
  });

  factory AssignTask.fromJson(Map<String, dynamic> json) => AssignTask(
        id: json["id"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        assignee: json["assignee"],
        taskMaster: json["taskMaster"],
        isLeader: json["isLeader"],
        taskId: json["taskID"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user?.toJson(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "assignee": assignee,
        "taskMaster": taskMaster,
        "isLeader": isLeader,
        "taskID": taskId,
        "status": status,
      };
}

class EventDivision {
  String? id;
  Event? event;

  EventDivision({
    this.id,
    this.event,
  });

  factory EventDivision.fromJson(Map<String, dynamic> json) => EventDivision(
        id: json["id"],
        event: json["event"] == null ? null : Event.fromJson(json["event"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "event": event?.toJson(),
      };
}

class Event {
  String? id;
  String? eventName;

  Event({
    this.id,
    this.eventName,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json["id"],
        eventName: json["eventName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "eventName": eventName,
      };
}

class User {
  String? id;
  Profile? profile;
  String? email;

  User({this.id, this.profile, this.email});

  factory User.fromJson(Map<String, dynamic> json) =>
      User(id: json["id"], profile: json["profile"] == null ? null : Profile.fromJson(json["profile"]), email: json["email"]);

  Map<String, dynamic> toJson() => {"id": id, "profile": profile?.toJson(), "email": email};
}

class Profile {
  String? profileId;
  String? fullName;
  String? avatar;

  Profile({
    this.profileId,
    this.fullName,
    this.avatar,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        profileId: json["profileId"],
        fullName: json["fullName"],
        avatar: json["avatar"],
      );

  Map<String, dynamic> toJson() => {
        "profileId": profileId,
        "fullName": fullName,
        "avatar": avatar,
      };
}

enum Priority { HIGH, LOW, MEDIUM }

final priorityValues = EnumValues({"HIGH": Priority.HIGH, "LOW": Priority.LOW, "MEDIUM": Priority.MEDIUM});

enum Status { PENDING, PROCESSING, DONE, CANCEL, OVERDUE, CONFIRM }

final statusValues = EnumValues(
  {
    "PENDING": Status.PENDING,
    "PROCESSING": Status.PROCESSING,
    "DONE": Status.DONE,
    "CANCEL": Status.CANCEL,
    "OVERDUE": Status.OVERDUE,
    "CONFIRM": Status.CONFIRM
  },
);

class TaskFile {
  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? fileUrl;
  String? taskId;
  String? fileName;

  TaskFile({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.fileUrl,
    this.taskId,
    this.fileName,
  });

  factory TaskFile.fromJson(Map<String, dynamic> json) => TaskFile(
      id: json["id"],
      createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
      updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      fileUrl: json["fileUrl"],
      taskId: json["taskID"],
      fileName: json["fileName"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "fileUrl": fileUrl,
        "taskID": taskId,
        "fileName": fileName,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
