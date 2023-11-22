// To parse this JSON data, do
//
//     final blogsInfoModel = blogsInfoModelFromJson(jsonString);

import 'dart:convert';

import 'package:mena/models/api_model/categories_model.dart';
import 'package:mena/models/api_model/category-details.dart';
import 'package:mena/models/api_model/home_section_model.dart';
import 'package:mena/modules/create_articles/model/pubish_article_model.dart';

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
  List<Category> categories;
  List<MenaArticle> topArticles;

  Data({
    required this.banners,
    required this.categories,
    required this.topArticles,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    banners: List<BlogBanner>.from(json["banners"].map((x) => BlogBanner.fromJson(x))),
    categories: json["categories"]!=[]?List<Category>.from(json["categories"].map((x) => Category.fromJson(x))):[],
    topArticles: List<MenaArticle>.from(json["top_articles"].map((x) => MenaArticle.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "banners": List<dynamic>.from(banners.map((x) => x.toJson())),
    "categories": categories!=null?List<dynamic>.from(categories!.map((x) => x.toJson())):null,
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
  String slug;
  String content;
  int categoryId;
  dynamic subCategoryId;
  int providerId;
  BlogBanner? category;
  dynamic subCategory;
  User? provider;
  DateTime createdAt;
  int? view;
  String shareLink;
  int sharesCount;
  bool isMine;
  bool isLiked;
  int likesCount;

  MenaArticle({
    required this.id,
    required this.banner,
    required this.title,
    required this.slug,
    required this.content,
    required this.categoryId,
    required this.subCategoryId,
    required this.providerId,
   this.category,
    required this.subCategory,
   this.provider,
    required this.createdAt,
      this.view,
    required this.shareLink,
    required this.sharesCount,
    required this.isMine,
    required this.isLiked,
    required this.likesCount,
  });

  factory MenaArticle.fromJson(Map<String, dynamic> json) =>
      MenaArticle(
        id: json["id"],
        banner: json["banner"],
        title: json["title"],
        slug: json["slug"],
        likesCount: json['likes_count'],
        content: json["content"],
        categoryId: json["category_id"],
        providerId: json["provider_id"],
        category:
        json["category"] != null ?
        BlogBanner.fromJson(json["category"]) :null,
        provider:
        json["provider"] != null ?
        User.fromJson(json["provider"]) : null,
        createdAt: DateTime.parse(json["created_at"]),
        isMine: json["is_mine"],
        view:  json['view'],
        subCategoryId: json["sub_category_id"],
        subCategory: json["sub_category"],
        shareLink: json["share_link"],
        sharesCount: json["shares_count"],
        isLiked: json["is_liked"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "banner": banner,
    "title": title,
    "content": content,
    "likes_count" :likesCount,
    "category_id": categoryId,
    "provider_id": providerId,
    "category": category?.toJson(),
    "provider": provider?.toJson(),
    "created_at": "${createdAt.year.toString().padLeft(4, '0')}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}",
    "is_mine": isMine,
    "view":view,
    "slug": slug,
    "sub_category_id": subCategoryId,
    "sub_category": subCategory,
    "share_link": shareLink,
    "shares_count": sharesCount,
    "is_liked": isLiked,
  };
}
