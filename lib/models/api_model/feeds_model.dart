// To parse this JSON data, do
//
//     final feedsModel = feedsModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

import 'home_section_model.dart';

FeedsModel feedsModelFromJson(String str) => FeedsModel.fromJson(json.decode(str));

String feedsModelToJson(FeedsModel data) => json.encode(data.toJson());

class FeedsModel {
  FeedsModel({
    required this.message,
    required this.data,
  });

  String message;
  Data data;

  factory FeedsModel.fromJson(Map<String, dynamic> json) => FeedsModel(
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
    this.feeds,
  });

  int totalSize;
  int limit;
  int offset;
  List<MenaFeed>? feeds;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalSize: json["total_size"],
        limit: json["limit"],
        offset: json["offset"],
        feeds: List<MenaFeed>.from(json["data"].map((x) => MenaFeed.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_size": totalSize,
        "limit": limit,
        "offset": offset,
      };
}

class MenaFeed {
  MenaFeed({
    required this.id,
    required this.text,
    required this.audience,
    this.files,
    required this.type,
    required this.canComment,
    required this.commentsCounter,
    required this.lat,
    required this.lng,
    required this.likes,
    required this.isLiked,
    required this.isMine,
    required this.views,
    this.top10Comments = const [],
    this.user,
    required this.createdAt,
  });

  int id;
  String? text;
  String audience;
  List<FileElement>? files;
  String type;
  int canComment;
  int commentsCounter;
  int likes;
  String? views;
  String? lat;
  String? lng;
  bool isLiked;
  bool isMine;
  List<MenaFeedComment?>? top10Comments;
  User? user;
  DateTime createdAt;

  factory MenaFeed.fromJson(Map<String, dynamic> json) => MenaFeed(
        id: json["id"],
        text: json["text"],
        audience: json["audience"],
        lat: json["lat"],
        lng: json["lng"],
        files: json["files"] == null
            ? null
            : List<FileElement>.from(json["files"].map((x) => FileElement.fromJson(x))),
        type: json["type"].toString(),
        views: json["views"].toString(),
        canComment: json["can_comment"],
        commentsCounter: json["comments"],
        likes: json["likes"],
        isLiked: json["is_liked"],
        isMine: json["is_mine"],
        top10Comments: json["top_10_comments"] == null
            ? null
            : List<MenaFeedComment>.from(
                json["top_10_comments"].map((x) => MenaFeedComment.fromJson(x))),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "text": text,
        "file": files,
        "type": type,
        "can_comment": canComment,
        "comments": commentsCounter,
        "likes": likes,
        "is_liked": isLiked,
        "top_10_comments": List<MenaFeedComment>.from(top10Comments!.map((x) => x)),
        "user": user?.toJson(),
        "created_at": createdAt.toIso8601String(),
      };
}

class FileElement {
  FileElement({
    this.path,
    this.type,
  });

  String? path;
  String? type;

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
        path: json["path"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "path": path,
        "type": type,
      };
}

class MenaFeedComment {
  MenaFeedComment({
    required this.id,
    this.user,
    required this.comment,
    required this.replies,
    required this.isLiked,
    required this.isDisLiked,
    required this.likesCount,
    required this.disLikesCount,
    required this.createdAt,
  });

  int id;
  User? user;
  String comment;
  List<MenaFeedComment>? replies;
  bool isLiked;
  bool isDisLiked;
  String likesCount;
  String disLikesCount;
  DateTime createdAt;

  factory MenaFeedComment.fromJson(Map<String, dynamic> json) => MenaFeedComment(
        id: json["id"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        comment: json["comment"],
        isLiked: json["is_liked"],
        isDisLiked: json["is_disliked"],
        likesCount: json["likes_count"].toString(),
        disLikesCount: json["dislikes_count"].toString(),
        replies: json["replies"] == null
            ? []
            : List<MenaFeedComment>.from(
                json["replies"]!.map((x) => MenaFeedComment.fromJson(x))),
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "comment": comment,
        "created_at": createdAt.toIso8601String(),
      };
}

// class User {
//   User({
//     @required this.id,
//     @required this.personalPicture,
//     @required this.fullName,
//     @required this.userName,
//     @required this.email,
//     @required this.phone,
//     @required this.platform,
//     @required this.phoneVerifiedAt,
//     @required this.emailVerifiedAt,
//     @required this.createdAt,
//     @required this.updatedAt,
//     @required this.roleId,
//     @required this.roleName,
//     @required this.recoveryEmail,
//     @required this.website,
//     @required this.fax,
//     @required this.whatsapp,
//     @required this.instagram,
//     @required this.facebook,
//     @required this.tiktok,
//     @required this.youtube,
//     @required this.linkedin,
//     @required this.providerTypeFields,
//     @required this.address,
//     @required this.qualificationCertificate,
//     @required this.professionalLicense,
//     @required this.abbreviation,
//     @required this.expertise,
//     @required this.summary,
//     @required this.subscription,
//     @required this.registrationNumber,
//     @required this.category,
//     @required this.lat,
//     @required this.lng,
//     @required this.likes,
//     @required this.followers,
//     @required this.reviewsRate,
//     @required this.reviewsCount,
//     @required this.isFollowing,
//     @required this.distance,
//     @required this.verified,
//     @required this.specialities,
//     @required this.features,
//   });
//
//   int id;
//   String personalPicture;
//   String fullName;
//   String userName;
//   String email;
//   String phone;
//   Platform platform;
//   DateTime phoneVerifiedAt;
//   dynamic emailVerifiedAt;
//   DateTime createdAt;
//   DateTime updatedAt;
//   int roleId;
//   String roleName;
//   dynamic recoveryEmail;
//   dynamic website;
//   dynamic fax;
//   dynamic whatsapp;
//   dynamic instagram;
//   dynamic facebook;
//   dynamic tiktok;
//   dynamic youtube;
//   dynamic linkedin;
//   dynamic providerTypeFields;
//   dynamic address;
//   String qualificationCertificate;
//   String professionalLicense;
//   Abbreviation abbreviation;
//   dynamic expertise;
//   dynamic summary;
//   dynamic subscription;
//   dynamic registrationNumber;
//   Category category;
//   String lat;
//   String lng;
//   int likes;
//   int followers;
//   int reviewsRate;
//   int reviewsCount;
//   bool isFollowing;
//   String distance;
//   int verified;
//   List<Category> specialities;
//   List<dynamic> features;
//
//   factory User.fromJson(Map<String, dynamic> json) => User(
//     id: json["id"],
//     personalPicture: json["personal_picture"],
//     fullName: json["full_name"],
//     userName: json["user_name"],
//     email: json["email"],
//     phone: json["phone"],
//     platform: Platform.fromJson(json["platform"]),
//     phoneVerifiedAt: DateTime.parse(json["phone_verified_at"]),
//     emailVerifiedAt: json["email_verified_at"],
//     createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),
//     roleId: json["role_id"],
//     roleName: json["role_name"],
//     recoveryEmail: json["recovery_email"],
//     website: json["website"],
//     fax: json["fax"],
//     whatsapp: json["whatsapp"],
//     instagram: json["instagram"],
//     facebook: json["facebook"],
//     tiktok: json["tiktok"],
//     youtube: json["youtube"],
//     linkedin: json["linkedin"],
//     providerTypeFields: json["provider_type_fields"],
//     address: json["address"],
//     qualificationCertificate: json["qualification_certificate"],
//     professionalLicense: json["professional_license"],
//     abbreviation: Abbreviation.fromJson(json["abbreviation"]),
//     expertise: json["expertise"],
//     summary: json["summary"],
//     subscription: json["subscription"],
//     registrationNumber: json["registration_number"],
//     category: Category.fromJson(json["category"]),
//     lat: json["lat"],
//     lng: json["lng"],
//     likes: json["likes"],
//     followers: json["followers"],
//     reviewsRate: json["reviews_rate"],
//     reviewsCount: json["reviews_count"],
//     isFollowing: json["is_following"],
//     distance: json["distance"],
//     verified: json["verified"],
//     specialities: List<Category>.from(json["specialities"].map((x) => Category.fromJson(x))),
//     features: List<dynamic>.from(json["features"].map((x) => x)),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "personal_picture": personalPicture,
//     "full_name": fullName,
//     "user_name": userName,
//     "email": email,
//     "phone": phone,
//     "platform": platform.toJson(),
//     "phone_verified_at": phoneVerifiedAt.toIso8601String(),
//     "email_verified_at": emailVerifiedAt,
//     "created_at": createdAt.toIso8601String(),
//     "updated_at": updatedAt.toIso8601String(),
//     "role_id": roleId,
//     "role_name": roleName,
//     "recovery_email": recoveryEmail,
//     "website": website,
//     "fax": fax,
//     "whatsapp": whatsapp,
//     "instagram": instagram,
//     "facebook": facebook,
//     "tiktok": tiktok,
//     "youtube": youtube,
//     "linkedin": linkedin,
//     "provider_type_fields": providerTypeFields,
//     "address": address,
//     "qualification_certificate": qualificationCertificate,
//     "professional_license": professionalLicense,
//     "abbreviation": abbreviation.toJson(),
//     "expertise": expertise,
//     "summary": summary,
//     "subscription": subscription,
//     "registration_number": registrationNumber,
//     "category": category.toJson(),
//     "lat": lat,
//     "lng": lng,
//     "likes": likes,
//     "followers": followers,
//     "reviews_rate": reviewsRate,
//     "reviews_count": reviewsCount,
//     "is_following": isFollowing,
//     "distance": distance,
//     "verified": verified,
//     "specialities": List<dynamic>.from(specialities.map((x) => x.toJson())),
//     "features": List<dynamic>.from(features.map((x) => x)),
//   };
// }
//
// class Abbreviation {
//   Abbreviation({
//     @required this.id,
//     @required this.name,
//     @required this.platformId,
//   });
//
//   int id;
//   String name;
//   String platformId;
//
//   factory Abbreviation.fromJson(Map<String, dynamic> json) => Abbreviation(
//     id: json["id"],
//     name: json["name"],
//     platformId: json["platform_id"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "platform_id": platformId,
//   };
// }
//
// class Category {
//   Category({
//     @required this.id,
//     @required this.filterId,
//     @required this.name,
//     @required this.ranking,
//     @required this.design,
//     @required this.childs,
//   });
//
//   int id;
//   String filterId;
//   String name;
//   String ranking;
//   String design;
//   dynamic childs;
//
//   factory Category.fromJson(Map<String, dynamic> json) => Category(
//     id: json["id"],
//     filterId: json["filter_id"],
//     name: json["name"],
//     ranking: json["ranking"],
//     design: json["design"],
//     childs: json["childs"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "filter_id": filterId,
//     "name": name,
//     "ranking": ranking,
//     "design": design,
//     "childs": childs,
//   };
// }
//
// class Platform {
//   Platform({
//     @required this.id,
//     @required this.name,
//     @required this.ranking,
//     @required this.video,
//   });
//
//   int id;
//   String name;
//   String ranking;
//   String video;
//
//   factory Platform.fromJson(Map<String, dynamic> json) => Platform(
//     id: json["id"],
//     name: json["name"],
//     ranking: json["ranking"],
//     video: json["video"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "ranking": ranking,
//     "video": video,
//   };
// }
