// To parse this JSON data, do
//
//     final userInfoModel = userInfoModelFromJson(jsonString);

import 'package:mena/models/api_model/config_model.dart';
import 'package:mena/modules/create_articles/model/pubish_article_model.dart';
import 'dart:convert';

import 'home_section_model.dart';

ProviderModel userInfoModelFromJson(String str) =>
    ProviderModel.fromJson(json.decode(str));

class ProviderModel {
  ProviderModel({
    required this.message,
    required this.data,
  });

  String message;

  Data data;

  factory ProviderModel.fromJson(Map<String, dynamic> json) => ProviderModel(
        message: json["message"],
        data: Data.fromJson(json['data']),
      );
}

class Data {
  Data({required this.data});

  List<ProviderData> data;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        data: List<ProviderData>.from(
            json["data"].map((x) => ProviderData.fromJson(x))),
      );
}

class ProviderData {
  ProviderData({
    required this.id,
    required this.personal_picture,
    required this.full_name,
    required this.user_name,
    required this.email,
    required this.phone,
    required this.role_name,
    required this.website,
    required this.fax,
    required this.whatsapp,
    required this.instagram,
    required this.facebook,
    required this.tiktok,
    required this.youtube,
    required this.linkedin,
  });

  int id;
  String personal_picture;
  String full_name;
  String user_name;
  String email;
  String phone;
  String role_name;
  String website;
  String fax;
  String whatsapp;
  String instagram;
  String facebook;
  String tiktok;
  String youtube;
  String linkedin;

  factory ProviderData.fromJson(Map<String, dynamic> json) => ProviderData(
        // user: User.fromJson(json["user"]),
        // platformFields: List<PlatformField>.from(json["platform_fields"].map((x) => PlatformField.fromJson(x))),
        // dataCompleted: DataCompleted.fromJson(json["data_completed"]),
        id: json['id'],
        personal_picture:
            json['personal_picture'] != null ? json['personal_picture'] : "",
        full_name: json['full_name'] != null ? json['full_name'] : "",
        user_name: json['user_name'] != null ? json['user_name'] : "",
        email: json['email'] != null ? json['email'] : "",
        phone: json['phone'] != null ? json['phone'] : "",
        role_name: json['role_name'],
        website: json['website'] != null ? json['website'] : "",
        fax: json['fax'] != null ? json['fax'] : "",
        whatsapp: json['whatsapp'] != null ? json['whatsapp'] : "",
        instagram: json['instagram'] != null ? json['instagram'] : "",
        facebook: json['facebook'] != null ? json['facebook'] : "",
        tiktok: json['tiktok'] != null ? json['tiktok'] : "",
        youtube: json['youtube'] != null ? json['youtube'] : "",
        linkedin: json['linkedin'] != null ? json['linkedin'] : "",
      );
}

class DataCompleted {
  DataCompleted({
    required this.completed,
    required this.completedAt,
  });

  bool completed;
  dynamic completedAt;

  factory DataCompleted.fromJson(Map<String, dynamic> json) => DataCompleted(
        completed: json["completed"],
        completedAt: json["completed_at"],
      );

  Map<String, dynamic> toJson() => {
        "completed": completed,
        "completed_at": completedAt,
      };
}

class PlatformField {
  PlatformField({
    required this.id,
    required this.name,
    required this.title,
    required this.description,
    required this.required,
    required this.extensions,
    required this.type,
    required this.value,
    required this.updatedAt,
  });

  int id;
  String name;
  String title;
  String description;
  int required;
  List<String> extensions;
  String type;
  dynamic value;
  DateTime updatedAt;

  factory PlatformField.fromJson(Map<String, dynamic> json) => PlatformField(
        id: json["id"],
        name: json["name"],
        title: json["title"],
        description: json["description"].toString(),
        required: json["required"],
        //  required: 2,
        extensions: List<String>.from(json["extensions"].map((x) => x)),
        type: json["type"],
        value: json["value"],
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "title": title,
        "description": description,
        "required": required,
        "extensions": List<dynamic>.from(extensions.map((x) => x)),
        "type": type,
        "value": value,
        "updated_at": updatedAt.toIso8601String(),
      };
}
