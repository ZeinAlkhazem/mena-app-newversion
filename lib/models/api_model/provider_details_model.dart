// To parse this JSON data, do
//
//     final providerDetailsModel = providerDetailsModelFromJson(jsonString);

import 'package:mena/models/api_model/home_section_model.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

ProviderDetailsModel providerDetailsModelFromJson(String str) => ProviderDetailsModel.fromJson(json.decode(str));

String providerDetailsModelToJson(ProviderDetailsModel data) => json.encode(data.toJson());

class ProviderDetailsModel {
  ProviderDetailsModel({
    required this.message,
    required this.user,
  });

  String message;
  User user;

  factory ProviderDetailsModel.fromJson(Map<String, dynamic> json) => ProviderDetailsModel(
    message: json["message"],
    user: User.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    // "data": data.toJson(),
  };
}

// class Data {
//   Data({
//     required this.provider,
//
//     required this.avgRate,
//     required this.totalRates,
//     required this.reviews,
//     required this.locations,
//     required this.buttons,
//     required this.rewards,
//   });
//
//   User? provider;
//   int avgRate;
//   int totalRates;
//   MenaReviews? reviews;
//   List<ProviderLocationModel>? locations;
//   List<Button>? buttons;
//   List<Reward>? rewards;
//
//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//     provider:json["main_data"]==null?null: User.fromJson(json["main_data"]),
//     avgRate: json["avg_rate"],
//     totalRates: json["total_rates"],
//     reviews: MenaReviews.fromJson(json["reviews"]),
//     buttons:json["buttons"]==null?null: List<Button>.from(json["buttons"].map((x) => Button.fromJson(x))),
//     locations:json["locations"]==null?null: List<ProviderLocationModel>.from(json["locations"].map((x) => ProviderLocationModel.fromJson(x))),
//     rewards:json["awards"]==null?null: List<Reward>.from(json["awards"].map((x) => Reward.fromJson(x))),
//   );
//
//   // Map<String, dynamic> toJson() => {
//   //   "main_data": provider.toJson(),
//   //   "avg_rate": avgRate,
//   //   "total_rates": totalRates,
//   //   "reviews": reviews.toJson(),
//   //   "buttons": List<dynamic>.from(buttons.map((x) => x.toJson())),
//   //   "awards": List<dynamic>.from(awards.map((x) => x.toJson())),
//   // };
// }

class Awards {
  Awards({
    required this.link,
    required this.image,
  });

  String link;
  String image;

  factory Awards.fromJson(Map<String, dynamic> json) => Awards(
    link: json["link"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "link": link,
    "image": image,
  };
}

class Button {
  Button({
    required this.type,
    required this.title,
    required this.description,
  });

  String type;
  String title;
  String description;

  factory Button.fromJson(Map<String, dynamic> json) => Button(
    type: json["type"],
    title: json["title"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "title": title,
    "description": description,
  };
}

// class MainData {
//   MainData({
//     @required this.id,
//     @required this.personalPicture,
//     @required this.fullName,
//     @required this.userName,
//     @required this.email,
//     @required this.phone,
//     @required this.fax,
//     @required this.whatsapp,
//     @required this.instagram,
//     @required this.facebook,
//     @required this.tiktok,
//     @required this.youtube,
//     @required this.linkedin,
//     @required this.platform,
//     @required this.phoneVerifiedAt,
//     @required this.emailVerifiedAt,
//     @required this.providerTypeFields,
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
//     @required this.createdAt,
//     @required this.updatedAt,
//     @required this.roleId,
//     @required this.roleName,
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
//   dynamic fax;
//   dynamic whatsapp;
//   dynamic instagram;
//   dynamic facebook;
//   dynamic tiktok;
//   dynamic youtube;
//   dynamic linkedin;
//   Platform platform;
//   dynamic phoneVerifiedAt;
//   dynamic emailVerifiedAt;
//   dynamic providerTypeFields;
//   Abbreviation abbreviation;
//   dynamic expertise;
//   String summary;
//   dynamic subscription;
//   String registrationNumber;
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
//   DateTime createdAt;
//   DateTime updatedAt;
//   int roleId;
//   String roleName;
//   List<Category> specialities;
//   List<dynamic> features;
//
//   factory MainData.fromJson(Map<String, dynamic> json) => MainData(
//     id: json["id"],
//     personalPicture: json["personal_picture"],
//     fullName: json["full_name"],
//     userName: json["user_name"],
//     email: json["email"],
//     phone: json["phone"],
//     fax: json["fax"],
//     whatsapp: json["whatsapp"],
//     instagram: json["instagram"],
//     facebook: json["facebook"],
//     tiktok: json["tiktok"],
//     youtube: json["youtube"],
//     linkedin: json["linkedin"],
//     platform: Platform.fromJson(json["platform"]),
//     phoneVerifiedAt: json["phone_verified_at"],
//     emailVerifiedAt: json["email_verified_at"],
//     providerTypeFields: json["provider_type_fields"],
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
//     createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),
//     roleId: json["role_id"],
//     roleName: json["role_name"],
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
//     "fax": fax,
//     "whatsapp": whatsapp,
//     "instagram": instagram,
//     "facebook": facebook,
//     "tiktok": tiktok,
//     "youtube": youtube,
//     "linkedin": linkedin,
//     "platform": platform.toJson(),
//     "phone_verified_at": phoneVerifiedAt,
//     "email_verified_at": emailVerifiedAt,
//     "provider_type_fields": providerTypeFields,
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
//     "created_at": createdAt.toIso8601String(),
//     "updated_at": updatedAt.toIso8601String(),
//     "role_id": roleId,
//     "role_name": roleName,
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

class MenaReviews {
  MenaReviews({
    required this.totalSize,
    required this.limit,
    required this.offset,
    required this.data,
  });

  int totalSize;
  int limit;
  int offset;
  List<MenaReviewItem>? data;

  factory MenaReviews.fromJson(Map<String, dynamic> json) => MenaReviews(
    totalSize: json["total_size"],
    limit: json["limit"],
    offset: json["offset"],
    data:json["data"]==null?null: List<MenaReviewItem>.from(json["data"].map((x) => MenaReviewItem.fromJson(x))),
  );

  // Map<String, dynamic> toJson() => {
  //   "total_size": totalSize,
  //   "limit": limit,
  //   "offset": offset,
  //   "data": List<dynamic>.from(data.map((x) => x.toJson())),
  // };
}

class MenaReviewItem {
  MenaReviewItem({
    required this.image,
    required this.name,
    required this.content,
    required this.date,
    required this.rate,
  });

  String image;
  String name;
  String content;
  String date;
  double rate;

  factory MenaReviewItem.fromJson(Map<String, dynamic> json) => MenaReviewItem(
    image: json["image"],
    name: json["name"],
    content: json["content"],
    date: json["date"],
    rate: double.parse(json["rate"].toString()),
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "name": name,
    "content": content,
    "rate": rate,
  };
}



class Education {
  Education({
    required this.id,
    required this.universityName,
    required this.degree,
    required this.startingYear,
    required this.endingYear,
    required this.currentlyPursuing,
  });

  int id;
  String universityName;
  String? startingYear;
  String? endingYear;
  int currentlyPursuing;
  String degree;

  //
  // starting_year	:	2018
  // ending_year	:	null
  // currently_pursuing	:	1

  factory Education.fromJson(Map<String, dynamic> json) => Education(
    id: json["id"],
    universityName: json["university_name"],
    degree: json["degree"],
    startingYear: json["starting_year"],
    endingYear: json["ending_year"],
    currentlyPursuing: json["currently_pursuing"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "university_name": universityName,
    "degree": degree,
  };
}

class Experience {
  Experience({
    required this.id,
    required this.placeOfWork,
    required this.designation,
    required this.startingYear,
    required this.endingYear,
    required this.currentlyWorking,
  });

  int id;
  String placeOfWork;
  String designation;
  String startingYear;
  String? endingYear;
  int currentlyWorking;

  factory Experience.fromJson(Map<String, dynamic> json) => Experience(
    id: json["id"],
    placeOfWork: json["place_of_work"],
    designation: json["designation"],
    startingYear: json["starting_year"].toString(),
    endingYear: json["ending_year"],
    currentlyWorking: json["currently_working"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "place_of_work": placeOfWork,
    "designation": designation,
    // "starting_year": "${startingYear.year.toString().padLeft(4, '0')}-${startingYear.month.toString().padLeft(2, '0')}-${startingYear.day.toString().padLeft(2, '0')}",
    // "ending_year": "${endingYear.year.toString().padLeft(4, '0')}-${endingYear.month.toString().padLeft(2, '0')}-${endingYear.day.toString().padLeft(2, '0')}",
    "currently_working": currentlyWorking,
  };
}

class Membership {
  Membership({
    required this.id,
    required this.name,
    required this.authName,
  });

  int id;
  String name;
  String? authName;

  factory Membership.fromJson(Map<String, dynamic> json) => Membership(
    id: json["id"],
    name: json["name"],
    authName: json["authority_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class Publication {
  Publication({
    required this.id,
    required this.paperTitle,
    required this.summary,
    required this.publisher,
    required this.publishedUrl,
    required this.publishedDate,
  });

  int id;
  String paperTitle;
  String summary;
  String publisher;
  String publishedUrl;
  DateTime publishedDate;

  factory Publication.fromJson(Map<String, dynamic> json) => Publication(
    id: json["id"],
    paperTitle: json["paper_title"],
    summary: json["summary"],
    publisher: json["publisher"],
    publishedUrl: json["published_url"],
    publishedDate: DateTime.parse(json["published_date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "paper_title": paperTitle,
    "summary": summary,
    "publisher": publisher,
    "published_url": publishedUrl,
    "published_date": "${publishedDate.year.toString().padLeft(4, '0')}-${publishedDate.month.toString().padLeft(2, '0')}-${publishedDate.day.toString().padLeft(2, '0')}",
  };
}

class Reward {
  Reward({
    required this.id,
    required this.title,
    required this.year,
    // required this.authorityName,
  });

  int id;
  String title;
  String? year;
  // String authorityName;

  factory Reward.fromJson(Map<String, dynamic> json) => Reward(
    id: json["id"],
    title: json["title"],
    year: json["year"],
    // authorityName: json["authority_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    // "authority_name": authorityName,
  };
}

class Certificate {
  Certificate({
    required this.id,
    required this.certificateName,
    required this.issueDate,
  });

  int id;
  String certificateName;
  DateTime issueDate;

  factory Certificate.fromJson(Map<String, dynamic> json) => Certificate(
    id: json["id"],
    certificateName: json["certificate_name"],
    issueDate: DateTime.parse(json["issue_date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "certificate_name": certificateName,
    "issue_date": "${issueDate.year.toString().padLeft(4, '0')}-${issueDate.month.toString().padLeft(2, '0')}-${issueDate.day.toString().padLeft(2, '0')}",
  };
}