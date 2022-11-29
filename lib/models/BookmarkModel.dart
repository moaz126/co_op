// To parse required this JSON data, do
//
//     final bookmarkModel = bookmarkModelFromJson(jsonString);

import 'dart:convert';

List<BookmarkModel> bookmarkModelFromJson(String str) =>
    List<BookmarkModel>.from(
        json.decode(str).map((x) => BookmarkModel.fromJson(x)));

String bookmarkModelToJson(List<BookmarkModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BookmarkModel {
  BookmarkModel({
    required this.id,
    required this.userId,
    required this.bookmarkId,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  int id;
  int userId;
  int bookmarkId;
  DateTime createdAt;
  DateTime updatedAt;
  User user;

  factory BookmarkModel.fromJson(Map<String, dynamic> json) => BookmarkModel(
        id: json["id"],
        userId: json["user_id"],
        bookmarkId: json["bookmark_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "bookmark_id": bookmarkId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "user": user.toJson(),
      };
}

class User {
  User({
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
  dynamic fullName;
  String? nickName;
  dynamic phone;
  dynamic emailVerifiedAt;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic otp;
  dynamic fcmTokken;

  factory User.fromJson(Map<String, dynamic> json) => User(
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
        image: json["image"],
        fullName: json["full_name"],
        nickName: json["nick_name"],
        phone: json["phone"],
        emailVerifiedAt: json["email_verified_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        otp: json["otp"],
        fcmTokken: json["fcm_tokken"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sub_category_id": List<dynamic>.from(subCategoryId.map((x) => x)),
        "user_name": userName,
        "email": email,
        "gender": gender,
        "age": age,
        "weight": weight,
        "height": height,
        "goal": List<dynamic>.from(goal.map((x) => x)),
        "long": long,
        "lat": lat,
        "activity_level": activityLevel,
        "image": image,
        "full_name": fullName,
        "nick_name": nickName,
        "phone": phone,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "otp": otp,
        "fcm_tokken": fcmTokken,
      };
}
