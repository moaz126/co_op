// To parse required this JSON data, do
//
//     final inProgressModel = inProgressModelFromJson(jsonString);

import 'dart:convert';

List<InProgressModel> inProgressModelFromJson(String str) => List<InProgressModel>.from(json.decode(str).map((x) => InProgressModel.fromJson(x)));

String inProgressModelToJson(List<InProgressModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class InProgressModel {
  InProgressModel({
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
    required this.startTime,
    required this.endTime,
    required this.duration,
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
  String activityLevel;
  String image;
  String? fullName;
  String? nickName;
  String? phone;
  dynamic emailVerifiedAt;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic otp;
  dynamic fcmTokken;
  String? startTime;
  String? endTime;
  String duration;

  factory InProgressModel.fromJson(Map<String, dynamic> json) => InProgressModel(
    id: json["id"],
    subCategoryId: List<String>.from(json["sub_category_id"].map((x) => x)),
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
    startTime: json["start_time"],
    endTime: json["end_time"],
    duration: json["duration"],
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
    "start_time": startTime,
    "end_time": endTime,
    "duration": duration,
  };
}
