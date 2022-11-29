import 'dart:convert';

List<GetFilterModel> GetFilterModelFromJson(String str) =>
    List<GetFilterModel>.from(
        json.decode(str).map((x) => GetFilterModel.fromJson(x)));

class GetFilterModel {
  GetFilterModel({
    required this.id,
    required this.title,
    required this.status,
    required this.rememberToken,
    required this.createdAt,
    required this.updatedAt,
    required this.getSubCate,
    required this.filterId,
  });

  int id;
  String title;
  int status;
  dynamic rememberToken;
  DateTime createdAt;
  DateTime updatedAt;
  List<GetFilterModel>? getSubCate;
  int? filterId;

  factory GetFilterModel.fromJson(Map<String, dynamic> json) => GetFilterModel(
        id: json["id"],
        title: json["title"],
        status: json["status"],
        rememberToken: json["remember_token"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        getSubCate: json["get_sub_cate"] == null
            ? []
            : List<GetFilterModel>.from(
                json["get_sub_cate"].map((x) => GetFilterModel.fromJson(x))),
        filterId: json["filter_id"] == null ? null : json["filter_id"],
      );
}
