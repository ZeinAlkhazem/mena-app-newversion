// To parse this JSON data, do
//
//     final blogsInfoModel = blogsInfoModelFromJson(jsonString);

import 'dart:convert';

import 'package:mena/models/api_model/home_section_model.dart';

BlogsInfoModel blogsInfoModelFromJson(String str) => BlogsInfoModel.fromJson(json.decode(str));

String blogsInfoModelToJson(BlogsInfoModel data) => json.encode(data.toJson());

class BlogsInfoModel {
  String message;
  Data data;

  BlogsInfoModel({
    required this.message,
    required this.data,
  });

  factory BlogsInfoModel.fromJson(Map<String, dynamic> json) => BlogsInfoModel(
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  List<BlogBanner> banners;
  List<BlogBanner> categories;
  List<MenaArticle> topArticles;

  Data({
    required this.banners,
    required this.categories,
    required this.topArticles,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    banners: List<BlogBanner>.from(json["banners"].map((x) => BlogBanner.fromJson(x))),
    categories: List<BlogBanner>.from(json["categories"].map((x) => BlogBanner.fromJson(x))),
    topArticles: List<MenaArticle>.from(json["top_articles"].map((x) => MenaArticle.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "banners": List<dynamic>.from(banners.map((x) => x.toJson())),
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
    "top_articles": List<dynamic>.from(topArticles.map((x) => x.toJson())),
  };
}

class BlogBanner {
  int id;
  String image;
  int platformId;
  int? articleBlogId;
  String? title;

  BlogBanner({
    required this.id,
    required this.image,
    required this.platformId,
    required this.articleBlogId,
    this.title,
  });

  factory BlogBanner.fromJson(Map<String, dynamic> json) => BlogBanner(
    id: json["id"],
    image: json["image"],
    platformId: json["platform_id"],
    articleBlogId: json["blog_id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "platform_id": platformId,
    "title": title,
  };
}

class MenaArticle {
  int id;
  String banner;
  String title;
  String content;
  int categoryId;
  int  providerId;
  BlogBanner category;
  User? provider;
  DateTime createdAt;
  bool isMine;
  int? view;

  MenaArticle({
    required this.id,
    required this.banner,
    required this.title,
    required this.content,
    required this.categoryId,
    required this.providerId,
    required this.category,
     this.provider,
    required this.createdAt,
    required this.isMine,
  this.view,
  });

  factory MenaArticle.fromJson(Map<String, dynamic> json) =>
MenaArticle(
    id: json["id"],
    banner: json["banner"],
    title: json["title"],
    content: json["content"],
    categoryId: json["category_id"],
    providerId: json["provider_id"],
    category: BlogBanner.fromJson(json["category"]),
    provider: 
    json["provider"] != null ?
    User.fromJson(json["provider"]) : null,
    createdAt: DateTime.parse(json["created_at"]),
    isMine: json["is_mine"],
    view:  json['view'],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "banner": banner,
    "title": title,

    "content": content,
    "category_id": categoryId,
    "provider_id": providerId,
    "category": category.toJson(),
    "provider": provider?.toJson(),
    "created_at": "${createdAt.year.toString().padLeft(4, '0')}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}",
    "is_mine": isMine,
    "view":view,
  };
}
