// To parse required this JSON data, do
//
//     final notificationListModel = notificationListModelFromJson(jsonString);

import 'dart:convert';

import 'package:co_op/models/Profile_Model.dart';

List<NotificationListModel> notificationListModelFromJson(String str) =>
    List<NotificationListModel>.from(
        json.decode(str).map((x) => NotificationListModel.fromJson(x)));

class NotificationListModel {
  NotificationListModel({
    required this.id,
    required this.requestedById,
    required this.requestedToId,
    required this.link,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.requestedByUser,
    required this.requestedToUser,
  });

  int id;
  int requestedById;
  int requestedToId;
  dynamic link;
  String title;
  String description;
  DateTime createdAt;
  DateTime updatedAt;
  int status;
  List<GetProfileModel> requestedByUser;
  List<GetProfileModel> requestedToUser;

  factory NotificationListModel.fromJson(Map<String, dynamic> json) =>
      NotificationListModel(
        id: json["id"],
        requestedById: json["requested_by_id"],
        requestedToId: json["requested_to_id"],
        link: json["link"],
        title: json["title"],
        description: json["description"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        status: json["status"],
        requestedByUser: json['requested_by_user'] == null
            ? []
            : List<GetProfileModel>.from(json["requested_by_user"]
                .map((x) => GetProfileModel.fromJson(x))),
        requestedToUser: json['requested_to_user'] == null
            ? []
            : List<GetProfileModel>.from(json["requested_to_user"]
                .map((x) => GetProfileModel.fromJson(x))),
      );
}
