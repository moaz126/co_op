// To parse required this JSON data, do
//
//     final addressModel = addressModelFromJson(jsonString);

import 'dart:convert';

List<AddressModel> addressModelFromJson(String str) => List<AddressModel>.from(
    json.decode(str).map((x) => AddressModel.fromJson(x)));

String addressModelToJson(List<AddressModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AddressModel {
  AddressModel({
    required this.id,
    required this.userId,
    required this.locationName,
    required this.long,
    required this.lat,
    required this.rememberToken,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
  });

  int id;
  int userId;
  String locationName;
  String? name;
  double long;
  double lat;
  dynamic rememberToken;
  DateTime createdAt;
  DateTime updatedAt;

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        locationName: json["location_name"],
        long: json["long"].toDouble(),
        lat: json["lat"].toDouble(),
        rememberToken: json["remember_token"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "location_name": locationName,
        "long": long,
        "lat": lat,
        "remember_token": rememberToken,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
