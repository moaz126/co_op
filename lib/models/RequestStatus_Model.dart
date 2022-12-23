// To parse required this JSON data, do
//
//     final getRequestStatusModel = getRequestStatusModelFromJson(jsonString);

import 'dart:convert';

import 'package:co_op/models/GetUsers_Model.dart';

GetRequestStatusModel getRequestStatusModelFromJson(String str) =>
    GetRequestStatusModel.fromJson(json.decode(str));

class GetRequestStatusModel {
  GetRequestStatusModel({
    required this.success,
    required this.userData,
    required this.request,
    required this.status,
    required this.requestId,
    required this.message,
  });

  bool success;
  GetUsersModel? userData;
  List<Request> request;
  int status;
  int? requestId;
  String? message;

  factory GetRequestStatusModel.fromJson(Map<String, dynamic> json) =>
      GetRequestStatusModel(
        success: json["success"],
        userData: GetUsersModel.fromJson(json["request_send_to"]),
        request: json.containsKey("request")
            ? List<Request>.from(
                json["request"].map((x) => Request.fromJson(x)))
            : [],
        status: json["status"],
        requestId: json.containsKey("request_id") ? json["request_id"] : null,
        message: json["message"],
      );
}

class Request {
  Request({
    required this.id,
    required this.requestedById,
    required this.requestedToId,
    required this.long,
    required this.lat,
    required this.meetUpDate,
    required this.meetUpTime,
    required this.endTime,
    required this.status,
    required this.completed,
    required this.inProgress,
    required this.view,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int requestedById;
  int requestedToId;
  double long;
  double lat;
  DateTime meetUpDate;
  String meetUpTime;
  String endTime;
  int status;
  int completed;
  int inProgress;
  int view;
  DateTime createdAt;
  DateTime updatedAt;

  factory Request.fromJson(Map<String, dynamic> json) => Request(
        id: json["id"],
        requestedById: json["requested_by_id"],
        requestedToId: json["requested_to_id"],
        long: json["long"].toDouble(),
        lat: json["lat"].toDouble(),
        meetUpDate: DateTime.parse(json["meet_up_date"]),
        meetUpTime: json["meet_up_time"],
        endTime: json["meetup_end_time"],
        status: json["status"],
        completed: json["is_completed"],
        inProgress: json["in_progress"],
        view: json["view"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "requested_by_id": requestedById,
        "requested_to_id": requestedToId,
        "long": long,
        "lat": lat,
        "meet_up_date":
            "${meetUpDate.year.toString().padLeft(4, '0')}-${meetUpDate.month.toString().padLeft(2, '0')}-${meetUpDate.day.toString().padLeft(2, '0')}",
        "meet_up_time": meetUpTime,
        "status": status,
        "view": view,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
