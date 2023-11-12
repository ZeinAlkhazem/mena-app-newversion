// To parse this JSON data, do
//
//     final livesModel = livesModelFromJson(jsonString);

import 'dart:convert';

import 'home_section_model.dart';

LivesModel livesModelFromJson(String str) =>
    LivesModel.fromJson(json.decode(str));

String livesModelToJson(LivesModel data) => json.encode(data.toJson());

class LivesModel {
  LivesModel({
    required this.message,
    required this.data,
  });

  String message;
  Data data;

  factory LivesModel.fromJson(Map<String, dynamic> json) => LivesModel(
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.lives,
    required this.livesByCategory,
  });

  List<LiveItem> lives;
  LivesByCategory livesByCategory;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        lives:
            List<LiveItem>.from(json["lives"].map((x) => LiveItem.fromJson(x))),
        livesByCategory: LivesByCategory.fromJson(json["lives_by_category"]),
      );

  Map<String, dynamic> toJson() => {
        "lives": List<dynamic>.from(lives.map((x) => x.toJson())),
        "lives_by_category": livesByCategory.toJson(),
      };
}

class LiveItem {
  LiveItem({
    required this.id,
    required this.image,
    required this.name,
    required this.phone,
    required this.email,
    required this.roomId,
    required this.distance,
    required this.lat,
    required this.lng,
    required this.likes,
    required this.followers,
    required this.reviewsRate,
    required this.reviewsCount,
    required this.isFollowing,
    required this.verified,
  });

  int id;
  String image;
  String name;
  String phone;
  String email;
  String distance;
  String roomId;
  String lat;
  String lng;
  int likes;
  int followers;
  int reviewsRate;
  int reviewsCount;
  bool isFollowing;
  int verified;

  factory LiveItem.fromJson(Map<String, dynamic> json) => LiveItem(
        id: json["id"],
        image: json["image"],
        name: json["name"],
        phone: json["phone"],
        roomId: json["room_id"],
        email: json["email"],
        distance: json["distance"],
        lat: json["lat"],
        lng: json["lng"],
        likes: json["likes"],
        followers: json["followers"],
        reviewsRate: json["reviews_rate"],
        reviewsCount: json["reviews_count"],
        isFollowing: json["is_following"],
        verified: json["verified"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name": name,
        "phone": phone,
        "email": email,
        "distance": distance,
        "lat": lat,
        "lng": lng,
        "likes": likes,
        "followers": followers,
        "reviews_rate": reviewsRate,
        "reviews_count": reviewsCount,
        "is_following": isFollowing,
        "verified": verified,
      };
}

class LivesByCategory {
  LivesByCategory({
    required this.totalSize,
    required this.limit,
    required this.offset,
    required this.livesByCategoryItem,
  });

  int totalSize;
  int limit;
  int offset;
  List<LiveByCategoryItem> livesByCategoryItem;

  factory LivesByCategory.fromJson(Map<String, dynamic> json) =>
      LivesByCategory(
        totalSize: json["total_size"],
        limit: json["limit"],
        offset: json["offset"],
        livesByCategoryItem: List<LiveByCategoryItem>.from(
            json["data"].map((x) => LiveByCategoryItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_size": totalSize,
        "limit": limit,
        "offset": offset,
        // "data": List<dynamic>.from(livesByCategoryItem.map((x) => x.toJson())),
      };
}


class LiveByCategoryItem {
  LiveByCategoryItem({
    required this.id,
    this.image,
    this.liveNowCategory,
    this.title,
    this.goal,
    this.topic,
    this.duration,
    this.roomId,
    this.status,
    this.isCoHost,
    this.provider,
    this.createdAt,
    this.dateTime,
  });

  int id;
  String? image;
  LiveNowCategory? liveNowCategory;
  String? title;
  String? goal;
  String? topic;
  String? duration;
  String? roomId;
  String? status;
  bool? isCoHost;
  User? provider;
  DateTime? createdAt;
  DateTime? dateTime;

  factory LiveByCategoryItem.fromJson(Map<String, dynamic> json) =>
      LiveByCategoryItem(
        id: json["id"],
        image: json["image"],
        liveNowCategory: LiveNowCategory.fromJson(json["category"]),
        title: json["title"],
        goal: json["goal"],
        topic: json["topic"],
        duration: json["duration"].toString(),
        roomId: json["room_id"],
        status: json["status"]!.toString(),
        isCoHost: json["is_co_host"],
        provider:
            json["provider"] == null ? null : User.fromJson(json["provider"]),
        createdAt: DateTime.parse(json["created_at"]),
        dateTime: json["date_time"] == null
            ? null
            : DateTime.parse(json["date_time"]),
      );
}

class LiveNowCategory {

  LiveNowCategory({
    required this.id,
    this.name,
  });

  int id;
  String? name;

  factory LiveNowCategory.fromJson(Map<String, dynamic> json) =>
      LiveNowCategory(
        id: json["id"],
        name: json["name"],
      );
}
class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;
  EnumValues(this.map);
  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}