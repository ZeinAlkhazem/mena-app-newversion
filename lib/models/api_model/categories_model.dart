// To parse this JSON data, do
//
//     final categoriesModel = categoriesModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

import 'home_section_model.dart';

CategoriesModel categoriesModelFromJson(String str) => CategoriesModel.fromJson(json.decode(str));

String categoriesModelToJson(CategoriesModel data) => json.encode(data.toJson());

class CategoriesModel {
  CategoriesModel({
    required this.message,
    required this.data,
  });

  String message;
  List<MenaCategory> data;

  factory CategoriesModel.fromJson(Map<String, dynamic> json) => CategoriesModel(
    message: json["message"],
    data: List<MenaCategory>.from(json["data"].map((x) => MenaCategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}


