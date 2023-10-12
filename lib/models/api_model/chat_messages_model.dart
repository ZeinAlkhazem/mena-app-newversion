// To parse this JSON data, do
//
//     final chatMessagesModel = chatMessagesModelFromJson(jsonString);

import 'package:mena/models/api_model/config_model.dart';
import 'package:mena/models/api_model/feeds_model.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

ChatMessagesModel chatMessagesModelFromJson(String str) => ChatMessagesModel.fromJson(json.decode(str));

String chatMessagesModelToJson(ChatMessagesModel data) => json.encode(data.toJson());

class ChatMessagesModel {
  ChatMessagesModel({
    required this.message,
    required this.data,
  });

  String message;
  Data data;

  factory ChatMessagesModel.fromJson(Map<String, dynamic> json) => ChatMessagesModel(
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
    required this.chatId,
    required this.messages,
  });

  int totalSize;
  int limit;
  int offset;
  int chatId;
  List<ChatMessage> messages;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalSize: json["total_size"],
        limit: json["limit"],
        offset: json["offset"],
        chatId: json["chat_id"],
        messages: List<ChatMessage>.from(json["data"].map((x) => ChatMessage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_size": totalSize,
        "limit": limit,
        "offset": offset,
        "chat_id": chatId,
        "data": List<dynamic>.from(messages.map((x) => x.toJson())),
      };
}

class ChatMessage {
  ChatMessage({
    required this.id,
    required this.isMyMessage,
    required this.message,
    required this.files,
    required this.type,
    required this.fromId,
    this.from,
    this.to,
    required this.fromName,
    required this.toId,
    required this.toName,
    required this.readAt,
    required this.createdAt,
  });

  int id;
  bool isMyMessage;
  String message;
  String type;
  List<FileElement>? files;
  String? fromId;
  String? fromName;
  String? toId;
  ChatUSer? from;
  ChatUSer? to;
  String? toName;
  DateTime? readAt;
  DateTime createdAt;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json["id"],
        message: json["message"],
        from: json["from"] == null ? null : ChatUSer.fromJson(json["from"]),
        to: json["to"] == null ? null : ChatUSer.fromJson(json["to"]),
        isMyMessage: json["is_you"],
        files: json["files"] == null ? null : List<FileElement>.from(json["files"].map((x) => FileElement.fromJson(x))),
        type: json["type"],
        fromId: json["from_id"].toString(),
        fromName: json["from_name"],
        toId: json["to_id"].toString(),
        toName: json["to_name"],
        readAt: json["read_at"] != null ? DateTime.parse(json["read_at"]) :  null,
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "message": message,
        "type": type,
        "from_id": fromId,
        "from_name": fromName,
        "to_id": toId,
        "to_name": toName,
        "read_at": readAt?.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
      };
}

class ChatUSer {
  ChatUSer({
    this.id,
    this.personalPicture,
    this.fullName,
    this.email,
    this.phone,
    this.platform,
    this.providerType,
    this.roleId,
    this.roleName,
    this.phoneVerifiedAt,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? personalPicture;
  String? fullName;
  String? email;
  String? phone;
  MenaPlatform? platform;
  dynamic providerType;
  dynamic roleId;
  String? roleName;
  DateTime? phoneVerifiedAt;
  dynamic emailVerifiedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory ChatUSer.fromJson(Map<String, dynamic> json) => ChatUSer(
        id: json["id"],
        personalPicture: json["personal_picture"],
        fullName: json["full_name"],
        email: json["email"],
        phone: json["phone"],
        platform: json["platform"] == null ? null : MenaPlatform.fromJson(json["platform"]),
        providerType: json["provider_type"],
        roleId: json["role_id"],
        roleName: json["role_name"],
        phoneVerifiedAt: json["phone_verified_at"] == null ? null : DateTime.parse(json["phone_verified_at"]),
        emailVerifiedAt: json["email_verified_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "personal_picture": personalPicture,
        "full_name": fullName,
        "email": email,
        "phone": phone,
        "platform": platform!.toJson(),
        "provider_type": providerType,
        "role_id": roleId,
        "role_name": roleName,
        "phone_verified_at": phoneVerifiedAt?.toIso8601String(),
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
