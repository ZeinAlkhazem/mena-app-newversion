// To parse this JSON data, do
//
//     final goLiveModel = goLiveModelFromJson(jsonString);

import 'dart:convert';

import 'home_section_model.dart';

GoLiveModel goLiveModelFromJson(String str) => GoLiveModel.fromJson(json.decode(str));

String goLiveModelToJson(GoLiveModel data) => json.encode(data.toJson());

class GoLiveModel {
  GoLiveModel({
    required this.message,
    required this.data,
  });

  String message;
  Data data;

  factory GoLiveModel.fromJson(Map<String, dynamic> json) => GoLiveModel(
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
    required this.id,
    required this.liveNowCategory,
    required this.title,
    required this.goal,
    required this.topic,
    required this.duration,
    required this.roomId,
    required this.status,
    required this.provider,
    required this.createdAt,
  });

  int id;
  LiveNowCategory liveNowCategory;
  String title;
  String goal;
  String topic;
  int duration;
  String roomId;
  int status;
  User provider;
  DateTime createdAt;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    liveNowCategory: LiveNowCategory.fromJson(json["category"]),
    title: json["title"],
    goal: json["goal"],
    topic: json["topic"],
    duration: 60,
    roomId: json["room_id"],
    status: json["status"],
    provider: User.fromJson(json["provider"]),
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "live_now_category": liveNowCategory.toJson(),
    "title": title,
    "goal": goal,
    "topic": topic,
    "duration": duration,
    "room_id": roomId,
    "status": status,
    "provider": provider.toJson(),
    "created_at": createdAt.toIso8601String(),
  };
}

class LiveNowCategory {
  LiveNowCategory({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory LiveNowCategory.fromJson(Map<String, dynamic> json) => LiveNowCategory(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}