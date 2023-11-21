// To parse this JSON data, do
//
//     final myMessagesModel = myMessagesModelFromJson(jsonString);

import 'package:mena/models/api_model/home_section_model.dart';
import 'package:mena/models/api_model/register_model.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

MyMessagesModel myMessagesModelFromJson(String str) =>
    MyMessagesModel.fromJson(json.decode(str));

String myMessagesModelToJson(MyMessagesModel data) =>
    json.encode(data.toJson());

class MyMessagesModel {
  MyMessagesModel({
    required this.message,
    required this.data,
  });

  String? message;
  Data data;

  factory MyMessagesModel.fromJson(Map<String, dynamic> json) =>
      MyMessagesModel(
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
    required this.totalSize,
    required this.limit,
    required this.offset,
    required this.myChats,
  });

  int totalSize;
  int limit;
  int offset;
  List<ChatItem>? myChats;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalSize: json["total_size"],
        limit: json["limit"],
        offset: json["offset"],
        myChats: json["data"] == null
            ? null
            : List<ChatItem>.from(
                json["data"].map((x) => ChatItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_size": totalSize,
        "limit": limit,
        "offset": offset,
        // "data": List<dynamic>.from(myChats.map((x) => x.toJson())),
      };
}

class ChatItem {
  ChatItem({
    required this.id,
    required this.user,
    required this.lastMessage,
    required this.numOfUnread,
    required this.lastMessageFrom,
    required this.createdAt,
    required this.messageType,
    required this.receiveType,
  });

  int? id;
  User? user;
  String? lastMessage;
  int? numOfUnread;
  String? lastMessageFrom;
  DateTime? createdAt;
  String? messageType;
  String? receiveType;

  factory ChatItem.fromJson(Map<String, dynamic> json) => ChatItem(
        id: json["id"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        lastMessage: json["last_message"],
        numOfUnread: json["num_unread"],
        lastMessageFrom: json["last_message_from"],
        createdAt: DateTime.parse(
          json["created_at"],
        ),
        messageType: json.containsKey('message_type')? json["message_type"]:"text",
        receiveType: json.containsKey('receive_Type')?json["receive_Type"]:"1",
      );

  Map<String, dynamic> toJson() => {
        // "id": id,
        // "user": user.toJson(),
        // "last_message": lastMessage,
        // "last_message_from": lastMessageFrom,
        // "created_at": createdAt.toIso8601String(),
      };
}
