// To parse required this JSON data, do
//
//     final getRequestModel = getRequestModelFromJson(jsonString);

import 'dart:convert';

import 'package:co_op/models/DashboardModel.dart';

GetRequestModel getRequestModelFromJson(String str) =>
    GetRequestModel.fromJson(json.decode(str));

class GetRequestModel {
  GetRequestModel({
    this.id,
    this.requestedById,
    this.requestedToId,
    this.long,
    this.lat,
    this.meetUpDate,
    required this.meetUpTime,
    this.status,
    this.view,
    this.createdAt,
    this.updatedAt,
    required this.meetupEndTime,
     
  });

  int? id;
  int? requestedById;
  int? requestedToId;
  double? long;
  double? lat;
  String? meetUpDate;
  String meetUpTime;
  int? status;
  int? view;
  DateTime? createdAt;
  DateTime? updatedAt;
  String meetupEndTime;
  

  factory GetRequestModel.fromJson(Map<String, dynamic> json) =>
      GetRequestModel(
        id: json["id"],
        requestedById: json["requested_by_id"],
        requestedToId: json["requested_to_id"],
        long: json["long"].toDouble(),
        lat: json["lat"].toDouble(),
        // meetUpDate: DateTime.parse(json["meet_up_date"]),
        meetUpDate: json["meet_up_date"],
        meetUpTime: json["meet_up_time"],
        status: json["status"],
        view: json["view"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        meetupEndTime: json["meetup_end_time"],
       
      );
}
