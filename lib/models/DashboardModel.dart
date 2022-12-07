// To parse required this JSON data, do
//
//     final dashboardModel = dashboardModelFromJson(jsonString);

import 'dart:convert';

List<DashboardModel> dashboardModelFromJson(String str) =>
    List<DashboardModel>.from(
        json.decode(str).map((x) => DashboardModel.fromJson(x)));

class DashboardModel {
  DashboardModel({
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
    required this.avg,
    required this.getReviews,
    required this.bookmark,
    required this.bookmarkId,
  });

  int id;
  List<dynamic> subCategoryId;
  String userName;
  String email;
  int gender;
  int age;
  String weight;
  String height;
  List<String> goal;
  double long;
  double lat;
  String activityLevel;
  String? image;
  String? fullName;
  String? nickName;
  String? phone;
  dynamic emailVerifiedAt;
  DateTime createdAt;
  DateTime updatedAt;
  String? otp;
  String? fcmTokken;
  dynamic avg;
  int? bookmark;
  int? bookmarkId;
  List<dynamic> getReviews;

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
        id: json["id"],
        subCategoryId:
            List<dynamic>.from(json["sub_category_id"].map((x) => x)),
        userName: json["user_name"],
        email: json["email"],
        gender: json["gender"],
        age: json["age"],
        weight: json["weight"],
        height: json["height"],
        goal: List<String>.from(json["goal"].map((x) => x)),
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
        otp: json["otp"] == null ? null : json["otp"],
        fcmTokken: json["fcm_tokken"] == null ? null : json["fcm_tokken"],
        avg: json["avg"],
        bookmark: json["is_bookmark"],
        bookmarkId: json["bookmark_id"] == null ? null : json["bookmark_id"],
        getReviews: json["get_reviews"] == null
            ? []
            : List<dynamic>.from(json["get_reviews"].map((x) => x)),
      );
}
