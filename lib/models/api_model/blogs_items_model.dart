// To parse this JSON data, do
//
//     final blogsItemsModel = blogsItemsModelFromJson(jsonString);

import 'dart:convert';

import 'package:mena/models/api_model/blogs_info_model.dart';

BlogsItemsModel blogsItemsModelFromJson(String str) => BlogsItemsModel.fromJson(json.decode(str));

String blogsItemsModelToJson(BlogsItemsModel data) => json.encode(data.toJson());

class BlogsItemsModel {
  String message;
  Data data;

  BlogsItemsModel({
    required this.message,
    required this.data,
  });

  factory BlogsItemsModel.fromJson(Map<String, dynamic> json) => BlogsItemsModel(
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  int totalSize;
  int limit;
  int offset;
  List<MenaArticle> articles;

  Data({
    required this.totalSize,
    required this.limit,
    required this.offset,
    required this.articles,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    totalSize: json["total_size"],
    limit: json["limit"],
    offset: json["offset"],
    articles: List<MenaArticle>.from(json["data"].map((x) => MenaArticle.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total_size": totalSize,
    "limit": limit,
    "offset": offset,
    "data": List<dynamic>.from(articles.map((x) => x.toJson())),
  };
}

// class DataDatum {
//   int id;
//   String banner;
//   String title;
//   String content;
//   String categoryId;
//   String providerId;
//   DatumCategory category;
//   Provider provider;
//   DateTime createdAt;
//   bool isMine;
//
//   DataDatum({
//     required this.id,
//     required this.banner,
//     required this.title,
//     required this.content,
//     required this.categoryId,
//     required this.providerId,
//     required this.category,
//     required this.provider,
//     required this.createdAt,
//     required this.isMine,
//   });
//
//   factory DataDatum.fromJson(Map<String, dynamic> json) => DataDatum(
//     id: json["id"],
//     banner: json["banner"],
//     title: json["title"],
//     content: json["content"],
//     categoryId: json["category_id"],
//     providerId: json["provider_id"],
//     category: DatumCategory.fromJson(json["category"]),
//     provider: Provider.fromJson(json["provider"]),
//     createdAt: DateTime.parse(json["created_at"]),
//     isMine: json["is_mine"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "banner": banner,
//     "title": title,
//     "content": content,
//     "category_id": categoryId,
//     "provider_id": providerId,
//     "category": category.toJson(),
//     "provider": provider.toJson(),
//     "created_at": "${createdAt.year.toString().padLeft(4, '0')}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}",
//     "is_mine": isMine,
//   };
// }
