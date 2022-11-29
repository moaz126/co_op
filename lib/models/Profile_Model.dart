// To parse   this JSON data, do
//
//     final getProfileModel = getProfileModelFromJson(jsonString);

import 'dart:convert';

GetProfileModel getProfileModelFromJson(String str) =>
    GetProfileModel.fromJson(json.decode(str));

class GetProfileModel {
  GetProfileModel({
    this.id,
    this.userName,
    this.email,
    required this.subCategoryId,
    this.gender,
    this.age,
    this.weight,
    this.height,
    this.goal,
    this.activityLevel,
    this.image,
    this.fullName,
    this.nickName,
    this.phone,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.lat,
    this.lng,
  });

  int? id;
  String? userName;
  String? email;
  List<String> subCategoryId;

  int? gender;
  int? age;
  String? weight;
  String? height;
  List<String>? goal;
  String? activityLevel;
  String? image;
  String? fullName;
  String? nickName;
  String? phone;
  dynamic? emailVerifiedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  double? lat;
  double? lng;

  factory GetProfileModel.fromJson(Map<String, dynamic> json) =>
      GetProfileModel(
        id: json["id"],
        userName: json["user_name"],
        subCategoryId: List<String>.from(json["sub_category_id"].map((x) => x)),
        email: json["email"],
        gender: json["gender"],
        age: json["age"],
        weight: json["weight"],
        height: json["height"],
        goal: json["goal"] == null
            ? []
            : List<String>.from(json["goal"].map((x) => x)),
        activityLevel: json["activity_level"],
        image: json["image"],
        fullName: json["full_name"],
        nickName: json["nick_name"],
        phone: json["phone"],
        emailVerifiedAt: json["email_verified_at"],
        lat: json["lat"] as double?,
        lng: json["long"],
      );
}
