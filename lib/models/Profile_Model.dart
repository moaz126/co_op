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
    required this.imageList,
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
    this.complete,
    this.inProgress,
    this.requested,
    this.time,
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
  List<GetWorkoutImage> imageList;
  String? activityLevel;
  String? image;
  String? fullName;
  String? nickName;
  String? phone;
  dynamic emailVerifiedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  double? lat;
  double? lng;
  int? complete;
  int? inProgress;
  int? requested;
  int? time;

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
        imageList: json["get_workout_images"] == null
            ? []
            : List<GetWorkoutImage>.from(json["get_workout_images"]
                .map((x) => GetWorkoutImage.fromJson(x))),
        activityLevel: json["activity_level"],
        image: json["image"],
        fullName: json["full_name"],
        nickName: json["nick_name"],
        phone: json["phone"],
        emailVerifiedAt: json["email_verified_at"],
        lat: json["lat"].toDouble(),
        lng: json["long"].toDouble(),
        complete: json["completed"],
        inProgress: json["inprogress"],
        requested: json["requests"],
        time: json["time_in_minutes"],
      );
}

class GetWorkoutImage {
  GetWorkoutImage({
    required this.id,
    required this.userId,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int userId;
  List<String> images;
  DateTime createdAt;
  DateTime updatedAt;

  factory GetWorkoutImage.fromJson(Map<String, dynamic> json) =>
      GetWorkoutImage(
        id: json["id"],
        userId: json["user_id"],
        images: List<String>.from(json["images"].map((x) => x)),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "images": List<dynamic>.from(images.map((x) => x)),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
