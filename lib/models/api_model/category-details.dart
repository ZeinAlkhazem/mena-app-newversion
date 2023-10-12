// To parse this JSON data, do
//
//     final categoryDetailsModel = categoryDetailsModelFromJson(jsonString);
import 'dart:convert';

import 'home_section_model.dart';



// To parse this JSON data, do
//
//     final caVideos = caVideosFromJson(jsonString);

import 'dart:convert';

// To parse this JSON data, do
//
//     final categoryDetailsModel = categoryDetailsModelFromJson(jsonString);

import 'dart:convert';

CategoryDetailsModel categoryDetailsModelFromJson(String str) => CategoryDetailsModel.fromJson(json.decode(str));

String categoryDetailsModelToJson(CategoryDetailsModel data) => json.encode(data.toJson());

class CategoryDetailsModel {
  String message;
  CategoryDetailsModelData data;

  CategoryDetailsModel({
    required this.message,
    required this.data,
  });

  factory CategoryDetailsModel.fromJson(Map<String, dynamic> json) => CategoryDetailsModel(
    message: json["message"],
    data: CategoryDetailsModelData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data.toJson(),
  };
}

class CategoryDetailsModelData {
  MenaCategory category;
  List<HomeSectionBlockModel> categoryLayoutSections;

  CategoryDetailsModelData({
    required this.category,
    required this.categoryLayoutSections,
  });

  factory CategoryDetailsModelData.fromJson(Map<String, dynamic> json) => CategoryDetailsModelData(
    category: MenaCategory.fromJson(json["category"]),
    categoryLayoutSections: List<HomeSectionBlockModel>.from(json["data"].map((x) => HomeSectionBlockModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "category": category.toJson(),
    "data": List<dynamic>.from(categoryLayoutSections.map((x) => x.toJson())),
  };
}


//
// CategoryDetailsModel categoryDetailsModelFromJson(String str) => CategoryDetailsModel.fromJson(json.decode(str));
//
// String categoryDetailsModelToJson(CategoryDetailsModel data) => json.encode(data.toJson());
//
// class CategoryDetailsModel {
//   CategoryDetailsModel({
//     required this.message,
//     required this.categoryLayoutSections,
//   });
//
//   String message;
//   List<HomeSectionBlockModel> categoryLayoutSections;
//
//   factory CategoryDetailsModel.fromJson(Map<String, dynamic> json) => CategoryDetailsModel(
//     message: json["message"],
//     categoryLayoutSections: List<HomeSectionBlockModel>.from(json["data"].map((x) => HomeSectionBlockModel.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "message": message,
//     "data": List<dynamic>.from(categoryLayoutSections.map((x) => x.toJson())),
//   };
// }

// class CategoryDetailsBlockSection {
//   CategoryDetailsBlockSection({
//     required this.data,
//     required this.type,
//     required this.style,
//     required this.title,
//   });
//
//   HomeSectionBlockDataModel data;
//   String type;
//   String style;
//   String title;
//
//   factory CategoryDetailsBlockSection.fromJson(Map<String, dynamic> json) => CategoryDetailsBlockSection(
//     data: HomeSectionBlockDataModel.fromJson(json["data"]),
//     type: json["type"],
//     style: json["style"],
//     title: json["title"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     // "data": data.toJson(),
//     "type": type,
//     "style": style,
//     "title": title,
//   };
// }



