// To parse required this JSON data, do
//
//     final getUsersModel = getUsersModelFromJson(jsonString);

import 'dart:convert';

List<GetUsersModel> getUsersModelFromJson(String str) =>
    List<GetUsersModel>.from(
        json.decode(str).map((x) => GetUsersModel.fromJson(x)));

String getUsersModelToJson(List<GetUsersModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetUsersModel {
  GetUsersModel({
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
    required this.isVisible,
    required this.getWorkoutImages,
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
  String? activityLevel;
  String? image;
  String? fullName;
  String? nickName;
  String? phone;
  dynamic emailVerifiedAt;
  DateTime createdAt;
  DateTime updatedAt;
  bool? isVisible;
  List<GetWorkoutImage> getWorkoutImages;

  factory GetUsersModel.fromJson(Map<String, dynamic> json) => GetUsersModel(
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
        fullName: json["full_name"] == null ? null : json["full_name"],
        nickName: json["nick_name"] == null ? null : json["nick_name"],
        phone: json["phone"] == null ? null : json["phone"],
        emailVerifiedAt: json["email_verified_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        isVisible: json["is_visible"],
        getWorkoutImages: json.containsKey("get_workout_images")
            ? List<GetWorkoutImage>.from(json["get_workout_images"]
                .map((x) => GetWorkoutImage.fromJson(x)))
            : [],
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
        "full_name": fullName == null ? null : fullName,
        "nick_name": nickName == null ? null : nickName,
        "phone": phone == null ? null : phone,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "is_visible": isVisible,
      };
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
