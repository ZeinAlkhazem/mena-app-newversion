// To parse this JSON data, do
//
//     final usersToChatModel = usersToChatModelFromJson(jsonString);

import 'dart:convert';

import 'package:mena/models/api_model/home_section_model.dart';

UsersToChatModel usersToChatModelFromJson(String str) => UsersToChatModel.fromJson(json.decode(str));

String usersToChatModelToJson(UsersToChatModel data) => json.encode(data.toJson());

class UsersToChatModel {
  UsersToChatModel({
    this.message,
    this.data,
  });

  String? message;
  Data? data;

  factory UsersToChatModel.fromJson(Map<String, dynamic> json) => UsersToChatModel(
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data!.toJson(),
  };
}

class Data {
  Data({
   required this.totalSize,
   required this.limit,
   required this.offset,
   required this.users,
  });

  int totalSize;
  int limit;
  int offset;
  List<User> users;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    totalSize: json["total_size"],
    limit: json["limit"],
    offset: json["offset"],
    users: List<User>.from(json["data"].map((x) => User.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total_size": totalSize,
    "limit": limit,
    "offset": offset,
    "data": List<dynamic>.from(users.map((x) => x.toJson())),
  };
}
