// To parse this JSON data, do
//
//     final onlineUsers = onlineUsersFromJson(jsonString);

import 'dart:convert';

import 'home_section_model.dart';

OnlineUsersModel? onlineUsersFromJson(String str) =>
    OnlineUsersModel.fromJson(json.decode(str));

String onlineUsersToJson(OnlineUsersModel? data) => json.encode(data!.toJson());

class OnlineUsersModel {
  OnlineUsersModel({
    this.message,
    this.data,
  });

  String? message;
  Data? data;

  factory OnlineUsersModel.fromJson(Map<String, dynamic> json) => OnlineUsersModel(
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
    this.totalSize,
    this.limit,
    this.offset,
    this.onlineUsers,
  });

  int? totalSize;
  int? limit;
  int? offset;
  List<OnlineUser?>? onlineUsers;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalSize: json["total_size"],
        limit: json["limit"],
        offset: json["offset"],
        onlineUsers: json["data"] == null
            ? []
            : List<OnlineUser?>.from(json["data"]!.map((x) => OnlineUser.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_size": totalSize,
        "limit": limit,
        "offset": offset,
        "data": onlineUsers == null
            ? []
            : List<dynamic>.from(onlineUsers!.map((x) => x!.toJson())),
      };
}

class OnlineUser {
  OnlineUser({
    this.id,
    this.personalPicture,
    this.fullName,
    this.user,
    this.abbreviation,
    this.chatId,
  });

  int? id;
  String? personalPicture;
  String? fullName;
  User? user;
  String? abbreviation;
  String? chatId;

  factory OnlineUser.fromJson(Map<String, dynamic> json) => OnlineUser(
        id: json["id"],
        personalPicture: json["personal_picture"],
        fullName: json["full_name"],
        abbreviation: json["abbreviation"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        chatId: json["chat_id"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "personal_picture": personalPicture,
        "full_name": fullName,
      };
}
