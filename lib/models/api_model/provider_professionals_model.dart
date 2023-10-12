// To parse this JSON data, do
//
//     final providerProfessionalsMpdel = providerProfessionalsMpdelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

import 'home_section_model.dart';

ProviderProfessionalsModel providerProfessionalsMpdelFromJson(String str) => ProviderProfessionalsModel.fromJson(json.decode(str));

String providerProfessionalsMpdelToJson(ProviderProfessionalsModel data) => json.encode(data.toJson());

class ProviderProfessionalsModel {
  ProviderProfessionalsModel({
    required this.message,
    required this.data,
  });

  String message;
  Data data;

  factory ProviderProfessionalsModel.fromJson(Map<String, dynamic> json) => ProviderProfessionalsModel(
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
    required this.professionals,
    required this.specialities,
  });

  int totalSize;
  int limit;
  int offset;
  List<User> professionals;
  List<MenaCategory> specialities;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    totalSize: json["total_size"],
    limit: json["limit"],
    offset: json["offset"],
    professionals: List<User>.from(json["data"].map((x) => User.fromJson(x))),
    specialities: List<MenaCategory>.from(json["specialities"].map((x) => MenaCategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total_size": totalSize,
    "limit": limit,
    "offset": offset,
    "data": List<dynamic>.from(professionals.map((x) => x.toJson())),
    "specialities": List<dynamic>.from(specialities.map((x) => x.toJson())),
  };
}
