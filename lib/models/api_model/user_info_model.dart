// To parse this JSON data, do
//
//     final userInfoModel = userInfoModelFromJson(jsonString);

import 'package:mena/models/api_model/config_model.dart';
import 'dart:convert';

import 'home_section_model.dart';


UserInfoModel userInfoModelFromJson(String str) => UserInfoModel.fromJson(json.decode(str));

String userInfoModelToJson(UserInfoModel data) => json.encode(data.toJson());


class UserInfoModel {
  UserInfoModel({
    required this.message,
    required this.data,
  });

  String message;

  UserData data;

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => UserInfoModel(
    message: json["message"],
    data: UserData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data.toJson(),
  };
}

class UserData {
  UserData({
    required this.user,
    required this.platformFields,
    required this.dataCompleted,
  });

  User user;
  List<PlatformField> platformFields;
  DataCompleted dataCompleted;

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    user: User.fromJson(json["user"]),
    platformFields: List<PlatformField>.from(json["platform_fields"].map((x) => PlatformField.fromJson(x))),
    dataCompleted: DataCompleted.fromJson(json["data_completed"]),
  );

  Map<String, dynamic> toJson() => {
    "platform_fields": List<dynamic>.from(platformFields.map((x) => x.toJson())),
    "data_completed": dataCompleted.toJson(),
  };
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

// class User {
//   User({
//     required this.id,
//     required this.personalPicture,
//     required this.fullName,
//     required this.userName,
//     required this.email,
//     required this.phone,
//     required this.platform,
//     required this.phoneVerifiedAt,
//     required this.emailVerifiedAt,
//     required this.providerTypeFields,
//     required this.abbreviation,
//     required this.summary,
//     required this.subscription,
//     required this.registrationNumber,
//     required this.lat,
//     required this.lng,
//     required this.likes,
//     required this.followers,
//     required this.reviewsRate,
//     required this.reviewsCount,
//     required this.isFollowing,
//     required this.distance,
//     required this.verified,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.roleId,
//     required this.roleName,
//     required this.specialities,
//     required this.features,
//   });
//
//   int id;
//   String personalPicture;
//   String fullName;
//   String userName;
//   String email;
//   String phone;
//   MenaPlatform platform;
//   dynamic phoneVerifiedAt;
//   dynamic emailVerifiedAt;
//   dynamic providerTypeFields;
//   dynamic abbreviation;
//   dynamic summary;
//   dynamic subscription;
//   dynamic registrationNumber;
//   String? lat;
//   String? lng;
//   int? likes;
//   int? followers;
//   int? reviewsRate;
//   int? reviewsCount;
//   bool? isFollowing;
//   String? distance;
//   int? verified;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//   int? roleId;
//   String? roleName;
//   List<MenaPlatform>? specialities;
//   List<dynamic>? features;
//
//   factory User.fromJson(Map<String, dynamic> json) => User(
//     id: json["id"],
//     personalPicture: json["personal_picture"],
//     fullName: json["full_name"],
//     userName: json["user_name"].toString(),
//     email: json["email"],
//     phone: json["phone"],
//     platform: MenaPlatform.fromJson(json["platform"]),
//     phoneVerifiedAt: json["phone_verified_at"],
//     emailVerifiedAt: json["email_verified_at"],
//     providerTypeFields: json["provider_type_fields"],
//     abbreviation: json["abbreviation"],
//     summary: json["summary"],
//     subscription: json["subscription"],
//     registrationNumber: json["registration_number"],
//     lat: json["lat"],
//     lng: json["lng"],
//     likes: json["likes"],
//     followers: json["followers"],
//     reviewsRate: json["reviews_rate"],
//     reviewsCount: json["reviews_count"],
//     isFollowing: json["is_following"],
//     distance: json["distance"],
//     verified: json["verified"],
//     createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),
//     roleId: json["role_id"],
//     roleName: json["role_name"],
//     specialities:
//     json["specialities"]==null?null:
//     List<MenaPlatform>.from(json["specialities"].map((x) => MenaPlatform.fromJson(x))),
//     features:
//     json["features"]==null?null:
//     List<dynamic>.from(json["features"].map((x) => x)),
//   );
//
//
// }


