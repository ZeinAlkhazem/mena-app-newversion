// To parse this JSON data, do
//
//     final providerTypesModel = providerTypesModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ProviderTypesModel providerTypesModelFromJson(String str) => ProviderTypesModel.fromJson(json.decode(str));

String providerTypesModelToJson(ProviderTypesModel data) => json.encode(data.toJson());

class ProviderTypesModel {
  ProviderTypesModel({
    required this.message,
    required this.data,
  });

  String message;
  List<ProviderTypeItem> data;

  factory ProviderTypesModel.fromJson(Map<String, dynamic> json) => ProviderTypesModel(
    message: json["message"],
    data: List<ProviderTypeItem>.from(json["data"].map((x) => ProviderTypeItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class ProviderTypeItem {
  ProviderTypeItem({
    required this.id,
     this.image,
     this.name,
     this.ranking,
     this.design,
     this.childs,
  });

  int id;
  String? image;
  String? name;
  String? ranking;
  String? design;
  List<ProviderTypeItem>? childs;

  factory ProviderTypeItem.fromJson(Map<String, dynamic> json) => ProviderTypeItem(
    id: json["id"],
    image: json["image"],
    name: json["name"],
    ranking: json["ranking"],
    design: json["design"],
    childs: json["childs"] == null ? null : List<ProviderTypeItem>.from(json["childs"].map((x) => ProviderTypeItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "name": name,
    "ranking": ranking,
    "design": design,
    "childs": childs == null ? null : List<dynamic>.from(childs!.map((x) => x.toJson())),
  };
}
