// To parse this JSON data, do
//
//     final profFacilityModel = profFacilityModelFromJson(jsonString);

import 'dart:convert';

import 'package:mena/models/api_model/home_section_model.dart';

ProfFacilityModel profFacilityModelFromJson(String str) => ProfFacilityModel.fromJson(json.decode(str));

String profFacilityModelToJson(ProfFacilityModel data) => json.encode(data.toJson());

class ProfFacilityModel {
  ProfFacilityModel({
    required this.message,
    required this.data,
  });

  String message;
  Data data;

  factory ProfFacilityModel.fromJson(Map<String, dynamic> json) => ProfFacilityModel(
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
    required this.type,
    required this.users,
  });

  String type;
  List<User> users;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    type: json["type"],
    users: List<User>.from(json["info"].map((x) => User.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "info": List<dynamic>.from(users.map((x) => x.toJson())),
  };
}
