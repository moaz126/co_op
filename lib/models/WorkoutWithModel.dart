// To parse required this JSON data, do
//
//     final workoutWithModel = workoutWithModelFromJson(jsonString);

import 'dart:convert';

List<WorkoutWithModel> workoutWithModelFromJson(String str) =>
    List<WorkoutWithModel>.from(
        json.decode(str).map((x) => WorkoutWithModel.fromJson(x)));

String workoutWithModelToJson(List<WorkoutWithModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WorkoutWithModel {
  WorkoutWithModel({
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
    required this.workoutUser,
    required this.rating,
    required this.bookmark,
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
  double? rating;
  int bookmark;
  List<WorkoutUser> workoutUser;

  factory WorkoutWithModel.fromJson(Map<String, dynamic> json) =>
      WorkoutWithModel(
        id: json["id"],
        requestedById: json["requested_by_id"],
        requestedToId: json["requested_to_id"],
        long: json["long"].toDouble(),
        lat: json["lat"].toDouble(),
        meetUpDate: DateTime.parse(json["meet_up_date"]),
        meetUpTime: json["meet_up_time"],
        status: json["status"],
        view: json["view"],
        rating: json["u_rating"] == null ? 0.0 : json["u_rating"].toDouble(),
        bookmark: json["is_bookmark"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        meetupEndTime: json["meetup_end_time"],
        workoutUser: List<WorkoutUser>.from(
            json["workout_user"].map((x) => WorkoutUser.fromJson(x))),
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
        "meetup_end_time": meetupEndTime,
        "workout_user": List<dynamic>.from(workoutUser.map((x) => x.toJson())),
      };
}

class WorkoutUser {
  WorkoutUser({
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
  String? image;
  dynamic fullName;
  String? nickName;
  dynamic phone;
  dynamic emailVerifiedAt;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic otp;
  dynamic fcmTokken;

  factory WorkoutUser.fromJson(Map<String, dynamic> json) => WorkoutUser(
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
        image: json["image"] == null ? null : json["image"],
        fullName: json["full_name"],
        nickName: json["nick_name"] == null ? null : json["nick_name"],
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
        "image": image == null ? null : image,
        "full_name": fullName,
        "nick_name": nickName == null ? null : nickName,
        "phone": phone,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "otp": otp,
        "fcm_tokken": fcmTokken,
      };
}
