// To parse this JSON data, do
//
//     final additionalRequiredDataModel = additionalRequiredDataModelFromJson(jsonString);
import 'dart:convert';

AdditionalRequiredDataModel additionalRequiredDataModelFromJson(String str) =>
    AdditionalRequiredDataModel.fromJson(json.decode(str));

String additionalRequiredDataModelToJson(AdditionalRequiredDataModel data) =>
    json.encode(data.toJson());

class AdditionalRequiredDataModel {
  AdditionalRequiredDataModel({
    required this.message,
    required this.data,
  });

  String message;
  List<AdditionalItem> data;

  factory AdditionalRequiredDataModel.fromJson(Map<String, dynamic> json) =>
      AdditionalRequiredDataModel(
        message: json["message"],
        data: List<AdditionalItem>.from(
            json["data"].map((x) => AdditionalItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class AdditionalItem {
  AdditionalItem({
    required this.id,
    required this.name,
    required this.title,
    required this.description,
    required this.required,
    required this.extensions,
    required this.type,
    required this.value,
  });

  int id;
  String name;
  String title;
  String description;
  String required;
  List<String> extensions;
  String type;
  dynamic value;

  factory AdditionalItem.fromJson(Map<String, dynamic> json) => AdditionalItem(
        id: json["id"],
        name: json["name"],
        title: json["title"],
        description: json["description"],
        required: json["required"],
        extensions: List<String>.from(json["extensions"].map((x) => x)),
        type: json["type"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "title": title,
        "description": description,
        "required": required,
        "type": type,
        "value": value,
      };
}
