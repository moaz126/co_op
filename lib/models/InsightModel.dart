// To parse required this JSON data, do
//
//     final insightModel = insightModelFromJson(jsonString);

import 'dart:convert';

List<InsightModel> insightModelFromJson(String str) => List<InsightModel>.from(
    json.decode(str).map((x) => InsightModel.fromJson(x)));

class InsightModel {
  InsightModel({
    required this.id,
    required this.requestedById,
    required this.requestedToId,
    required this.long,
    required this.lat,
    required this.meetUpDate,
    required this.meetUpTime,
    required this.status,
    required this.view,
    required this.createdAt,
    required this.updatedAt,
    required this.meetupEndTime,
    required this.userData,
    required this.requestedByUser,
    required this.requestedToUser,
  });

  int id;
  int requestedById;
  int requestedToId;
  double long;
  double lat;
  DateTime meetUpDate;
  String meetUpTime;
  int status;
  int view;
  DateTime createdAt;
  DateTime updatedAt;
  String meetupEndTime;
  List<UserDatum> userData;
  List<RequestedUser> requestedByUser;
  List<RequestedUser> requestedToUser;

  factory InsightModel.fromJson(Map<String, dynamic> json) => InsightModel(
        id: json["id"],
        requestedById: json["requested_by_id"],
        requestedToId: json["requested_to_id"],
        long: json["long"].toDouble(),
        lat: json["lat"].toDouble(),
        meetUpDate: DateTime.parse(json["meet_up_date"]),
        meetUpTime: json["meet_up_time"],
        status: json["status"],
        view: json["view"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        meetupEndTime: json["meetup_end_time"],
        userData: List<UserDatum>.from(
            json["userData"].map((x) => UserDatum.fromJson(x))),
        requestedByUser: List<RequestedUser>.from(
            json["user_info"].map((x) => RequestedUser.fromJson(x))),
        requestedToUser: List<RequestedUser>.from(
            json["requested_to_user"].map((x) => RequestedUser.fromJson(x))),
      );
}

class RequestedUser {
  RequestedUser({
    required this.id,
    required this.subCategoryId,
    required this.userName,
    required this.email,
    required this.gender,
    required this.age,
    required this.weight,
    required this.height,
    required this.goal,
    required this.long,
    required this.lat,
    required this.activityLevel,
    required this.image,
    required this.fullName,
    required this.nickName,
    required this.phone,
    required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.otp,
    required this.fcmTokken,
    required this.rating,
  });

  int id;
  List<String> subCategoryId;
  String userName;
  String email;
  int gender;
  int age;
  String weight;
  String height;
  List<String> goal;
  double long;
  double lat;
  String? activityLevel;
  String? image;
  String? fullName;
  String? nickName;
  String? phone;
  dynamic emailVerifiedAt;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic otp;
  String? fcmTokken;
  double? rating;

  factory RequestedUser.fromJson(Map<String, dynamic> json) => RequestedUser(
        id: json["id"],
        subCategoryId: List<String>.from(json["sub_category_id"].map((x) => x)),
        userName: json["user_name"],
        email: json["email"],
        gender: json["gender"],
        age: json["age"],
        weight: json["weight"],
        height: json["height"],
        goal: List<String>.from(json["goal"]),
        long: json["long"].toDouble(),
        lat: json["lat"].toDouble(),
        activityLevel: json["activity_level"],
        image: json["image"] == null ? null : json["image"],
        fullName: json["full_name"] == null ? null : json["full_name"],
        nickName: json["nick_name"] == null ? null : json["nick_name"],
        phone: json["phone"] == null ? null : json["phone"],
        emailVerifiedAt: json["email_verified_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        otp: json["otp"],
        rating: json["rating"],
        fcmTokken: json["fcm_tokken"] == null ? null : json["fcm_tokken"],
      );
}

class UserDatum {
  UserDatum({
    required this.id,
    required this.filterId,
    required this.title,
    required this.status,
    required this.rememberToken,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int filterId;
  String title;
  int status;
  dynamic rememberToken;
  DateTime createdAt;
  DateTime updatedAt;

  factory UserDatum.fromJson(Map<String, dynamic> json) => UserDatum(
        id: json["id"],
        filterId: json["filter_id"],
        title: json["title"],
        status: json["status"],
        rememberToken: json["remember_token"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "filter_id": filterId,
        "title": title,
        "status": status,
        "remember_token": rememberToken,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
