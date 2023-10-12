// To parse this JSON data, do
//
//     final liveCategories = liveCategoriesFromJson(jsonString);

import 'dart:convert';

LiveCategories liveCategoriesFromJson(String str) => LiveCategories.fromJson(json.decode(str));

String liveCategoriesToJson(LiveCategories data) => json.encode(data.toJson());

class LiveCategories {
  LiveCategories({
    required this.message,
    required this.liveCategories,
  });

  String message;
  List<LiveCategory> liveCategories;

  factory LiveCategories.fromJson(Map<String, dynamic> json) => LiveCategories(
    message: json["message"],
    liveCategories: List<LiveCategory>.from(json["data"].map((x) => LiveCategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(liveCategories.map((x) => x.toJson())),
  };
}




class LiveCategory {
  LiveCategory({
    required this.id,
    required this.platformId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int platformId;
  String name;
  DateTime createdAt;
  DateTime updatedAt;

  factory LiveCategory.fromJson(Map<String, dynamic> json) => LiveCategory(
    id: json["id"],
    platformId: json["platform_id"],
    name: json["name"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "platform_id": platformId,
    "name": name,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
