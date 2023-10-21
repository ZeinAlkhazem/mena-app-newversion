// To parse this JSON data, do
//
//     final registerModel = registerModelFromJson(jsonString);

import 'package:mena/models/api_model/config_model.dart';
import 'dart:convert';

import 'home_section_model.dart';

RegisterModel registerModelFromJson(String str) => RegisterModel.fromJson(json.decode(str));

String registerModelToJson(RegisterModel data) => json.encode(data.toJson());

class RegisterModel {
  RegisterModel({
    required this.message,
    required this.data,
  });

  String message;
  Data data;

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
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
    required this.token,
    required this.user,
  });

  String token;
  User user;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    token: json["token"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    // "user": user.toJson(),
  };
}

// class User {
//   User({
//     required this.id,
//     required this.personalPicture,
//     required this.fullName,
//     required this.email,
//     required this.phone,
//     required this.platform,
//     required this.roleName,
//     required this.phoneVerifiedAt,
//     required this.emailVerifiedAt,
//     required this.createdAt,
//     required this.updatedAt,
//   });
//
//   int id;
//   String personalPicture;
//   String fullName;
//   String roleName;
//   String email;
//   String phone;
//   MenaPlatform platform;
//   DateTime? phoneVerifiedAt;
//   DateTime? emailVerifiedAt;
//   DateTime createdAt;
//   DateTime updatedAt;
//
//   factory User.fromJson(Map<String, dynamic> json) => User(
//     id: json["id"],
//     personalPicture: json["personal_picture"],
//     fullName: json["full_name"],
//     roleName: json["role_name"],
//     email: json["email"],
//     phone: json["phone"],
//     platform: MenaPlatform.fromJson(json["platform"]),
//     phoneVerifiedAt: json["phone_verified_at"]==null?null:DateTime.parse(json["phone_verified_at"]),
//     emailVerifiedAt: json["email_verified_at"]==null?null:DateTime.parse(json["email_verified_at"]),
//     createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),
//   );
//
//   // Map<String, dynamic> toJson() => {
//   //   "id": id,
//   //   "personal_picture": personalPicture,
//   //   "full_name": fullName,
//   //   "email": email,
//   //   "phone": phone,
//   //   "platform": platform.toJson(),
//   //   "phone_verified_at": phoneVerifiedAt,
//   //   "email_verified_at": emailVerifiedAt,
//   //   "created_at": createdAt.toIso8601String(),
//   //   "updated_at": updatedAt.toIso8601String(),
//   // };
// }


