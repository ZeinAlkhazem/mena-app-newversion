// To parse this JSON data, do
//
//     final myBlogInfoModel = myBlogInfoModelFromJson(jsonString);

import 'dart:convert';

MyBlogInfoModel myBlogInfoModelFromJson(String str) =>
    MyBlogInfoModel.fromJson(json.decode(str));

String myBlogInfoModelToJson(MyBlogInfoModel data) =>
    json.encode(data.toJson());

class MyBlogInfoModel {
  String message;
  Data data;

  MyBlogInfoModel({
    required this.message,
    required this.data,
  });

  factory MyBlogInfoModel.fromJson(Map<String, dynamic> json) =>
      MyBlogInfoModel(
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  int totalReaders;
  int blogsCount;
  int followers;
  Provider provider;
  List<DataDatum> data;

  Data({
    required this.totalReaders,
    required this.blogsCount,
    required this.followers,
    required this.provider,
    required this.data,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalReaders: json["total_readers"],
        blogsCount: json["blogs_count"],
        followers: json["followers"],
        provider: Provider.fromJson(json["provider"]),
        data: List<DataDatum>.from(
            json["data"].map((x) => DataDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_readers": totalReaders,
        "blogs_count": blogsCount,
        "followers": followers,
        "provider": provider.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DataDatum {
  int id;
  String banner;
  String title;
  String content;
  int categoryId;
  dynamic subCategoryId;
  int providerId;
  Category category;
  dynamic subCategory;
  Provider provider;
  DateTime createdAt;
  int view;
  bool isMine;

  DataDatum({
    required this.id,
    required this.banner,
    required this.title,
    required this.content,
    required this.categoryId,
    required this.subCategoryId,
    required this.providerId,
    required this.category,
    required this.subCategory,
    required this.provider,
    required this.createdAt,
    required this.view,
    required this.isMine,
  });

  factory DataDatum.fromJson(Map<String, dynamic> json) => DataDatum(
        id: json["id"],
        banner: json["banner"],
        title: json["title"],
        content: json["content"],
        categoryId: json["category_id"],
        subCategoryId: json["sub_category_id"],
        providerId: json["provider_id"],
        category: Category.fromJson(json["category"]),
        subCategory: json["sub_category"],
        provider: Provider.fromJson(json["provider"]),
        createdAt: DateTime.parse(json["created_at"]),
        view: json["view"],
        isMine: json["is_mine"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "banner": banner,
        "title": title,
        "content": content,
        "category_id": categoryId,
        "sub_category_id": subCategoryId,
        "provider_id": providerId,
        "category": category.toJson(),
        "sub_category": subCategory,
        "provider": provider.toJson(),
        "created_at":
            "${createdAt.year.toString().padLeft(4, '0')}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}",
        "view": view,
        "is_mine": isMine,
      };
}

class Category {
  int id;
  String title;
  String image;
  int platformId;
  List<dynamic> children;

  Category({
    required this.id,
    required this.title,
    required this.image,
    required this.platformId,
    required this.children,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        platformId: json["platform_id"],
        children: List<dynamic>.from(json["children"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "platform_id": platformId,
        "children": List<dynamic>.from(children.map((x) => x)),
      };
}

class Provider {
  int id;
  String personalPicture;
  String fullName;
  String userName;
  String email;
  String phone;
  dynamic phoneVerifiedAt;
  dynamic emailVerifiedAt;
  DateTime createdAt;
  DateTime updatedAt;
  int roleId;
  String roleName;
  dynamic recoveryEmail;
  dynamic website;
  dynamic fax;
  dynamic whatsapp;
  dynamic instagram;
  dynamic facebook;
  dynamic tiktok;
  dynamic youtube;
  dynamic linkedin;
  dynamic providerTypeFields;
  dynamic address;
  String qualificationCertificate;
  String professionalLicense;
  dynamic abbreviation;
  dynamic expertise;
  dynamic summary;
  dynamic subscription;
  dynamic registrationNumber;
  String lat;
  String lng;
  int likes;
  int followers;
  int reviewsRate;
  int reviewsCount;
  bool isFollowing;
  String distance;
  int verified;
  Platform platform;
  List<dynamic> category;
  List<dynamic> specialitiesGroup;
  List<dynamic> specialities;
  List<dynamic> features;
  MoreData moreData;

  Provider({
    required this.id,
    required this.personalPicture,
    required this.fullName,
    required this.userName,
    required this.email,
    required this.phone,
    required this.phoneVerifiedAt,
    required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.roleId,
    required this.roleName,
    required this.recoveryEmail,
    required this.website,
    required this.fax,
    required this.whatsapp,
    required this.instagram,
    required this.facebook,
    required this.tiktok,
    required this.youtube,
    required this.linkedin,
    required this.providerTypeFields,
    required this.address,
    required this.qualificationCertificate,
    required this.professionalLicense,
    required this.abbreviation,
    required this.expertise,
    required this.summary,
    required this.subscription,
    required this.registrationNumber,
    required this.lat,
    required this.lng,
    required this.likes,
    required this.followers,
    required this.reviewsRate,
    required this.reviewsCount,
    required this.isFollowing,
    required this.distance,
    required this.verified,
    required this.platform,
    required this.category,
    required this.specialitiesGroup,
    required this.specialities,
    required this.features,
    required this.moreData,
  });

  factory Provider.fromJson(Map<String, dynamic> json) => Provider(
        id: json["id"],
        personalPicture: json["personal_picture"],
        fullName: json["full_name"],
        userName: json["user_name"],
        email: json["email"],
        phone: json["phone"] != null ? json["phone"] : "",
        phoneVerifiedAt: json["phone_verified_at"],
        emailVerifiedAt: json["email_verified_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        roleId: json["role_id"],
        roleName: json["role_name"],
        recoveryEmail: json["recovery_email"],
        website: json["website"],
        fax: json["fax"],
        whatsapp: json["whatsapp"],
        instagram: json["instagram"],
        facebook: json["facebook"],
        tiktok: json["tiktok"],
        youtube: json["youtube"],
        linkedin: json["linkedin"],
        providerTypeFields: json["provider_type_fields"],
        address: json["address"],
        qualificationCertificate: json["qualification_certificate"],
        professionalLicense: json["professional_license"],
        abbreviation: json["abbreviation"],
        expertise: json["expertise"],
        summary: json["summary"],
        subscription: json["subscription"],
        registrationNumber: json["registration_number"],
        lat: json["lat"],
        lng: json["lng"],
        likes: json["likes"],
        followers: json["followers"],
        reviewsRate: json["reviews_rate"],
        reviewsCount: json["reviews_count"],
        isFollowing: json["is_following"],
        distance: json["distance"],
        verified: json["verified"],
        platform: Platform.fromJson(json["platform"]),
        category: List<dynamic>.from(json["category"].map((x) => x)),
        specialitiesGroup:
            List<dynamic>.from(json["specialities_group"].map((x) => x)),
        specialities: List<dynamic>.from(json["specialities"].map((x) => x)),
        features: List<dynamic>.from(json["features"].map((x) => x)),
        moreData: MoreData.fromJson(json["more_data"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "personal_picture": personalPicture,
        "full_name": fullName,
        "user_name": userName,
        "email": email,
        "phone": phone,
        "phone_verified_at": phoneVerifiedAt,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "role_id": roleId,
        "role_name": roleName,
        "recovery_email": recoveryEmail,
        "website": website,
        "fax": fax,
        "whatsapp": whatsapp,
        "instagram": instagram,
        "facebook": facebook,
        "tiktok": tiktok,
        "youtube": youtube,
        "linkedin": linkedin,
        "provider_type_fields": providerTypeFields,
        "address": address,
        "qualification_certificate": qualificationCertificate,
        "professional_license": professionalLicense,
        "abbreviation": abbreviation,
        "expertise": expertise,
        "summary": summary,
        "subscription": subscription,
        "registration_number": registrationNumber,
        "lat": lat,
        "lng": lng,
        "likes": likes,
        "followers": followers,
        "reviews_rate": reviewsRate,
        "reviews_count": reviewsCount,
        "is_following": isFollowing,
        "distance": distance,
        "verified": verified,
        "platform": platform.toJson(),
        "category": List<dynamic>.from(category.map((x) => x)),
        "specialities_group":
            List<dynamic>.from(specialitiesGroup.map((x) => x)),
        "specialities": List<dynamic>.from(specialities.map((x) => x)),
        "features": List<dynamic>.from(features.map((x) => x)),
        "more_data": moreData.toJson(),
      };
}

class MoreData {
  List<dynamic> rawards;
  List<dynamic> educations;
  List<dynamic> experiences;
  List<dynamic> memberships;
  List<dynamic> publications;
  List<dynamic> vacations;
  dynamic about;
  int pointsCme;
  List<Location> locations;
  int avgRate;
  int totalRates;
  Reviews reviews;
  List<Button> buttons;
  List<Award> awards;

  MoreData({
    required this.rawards,
    required this.educations,
    required this.experiences,
    required this.memberships,
    required this.publications,
    required this.vacations,
    required this.about,
    required this.pointsCme,
    required this.locations,
    required this.avgRate,
    required this.totalRates,
    required this.reviews,
    required this.buttons,
    required this.awards,
  });

  factory MoreData.fromJson(Map<String, dynamic> json) => MoreData(
        rawards: List<dynamic>.from(json["rawards"].map((x) => x)),
        educations: List<dynamic>.from(json["educations"].map((x) => x)),
        experiences: List<dynamic>.from(json["experiences"].map((x) => x)),
        memberships: List<dynamic>.from(json["memberships"].map((x) => x)),
        publications: List<dynamic>.from(json["publications"].map((x) => x)),
        vacations: List<dynamic>.from(json["vacations"].map((x) => x)),
        about: json["about"],
        pointsCme: json["points_cme"],
        locations: List<Location>.from(
            json["locations"].map((x) => Location.fromJson(x))),
        avgRate: json["avg_rate"],
        totalRates: json["total_rates"],
        reviews: Reviews.fromJson(json["reviews"]),
        buttons:
            List<Button>.from(json["buttons"].map((x) => Button.fromJson(x))),
        awards: List<Award>.from(json["awards"].map((x) => Award.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "rawards": List<dynamic>.from(rawards.map((x) => x)),
        "educations": List<dynamic>.from(educations.map((x) => x)),
        "experiences": List<dynamic>.from(experiences.map((x) => x)),
        "memberships": List<dynamic>.from(memberships.map((x) => x)),
        "publications": List<dynamic>.from(publications.map((x) => x)),
        "vacations": List<dynamic>.from(vacations.map((x) => x)),
        "about": about,
        "points_cme": pointsCme,
        "locations": List<dynamic>.from(locations.map((x) => x.toJson())),
        "avg_rate": avgRate,
        "total_rates": totalRates,
        "reviews": reviews.toJson(),
        "buttons": List<dynamic>.from(buttons.map((x) => x.toJson())),
        "awards": List<dynamic>.from(awards.map((x) => x.toJson())),
      };
}

class Award {
  Link link;
  String image;

  Award({
    required this.link,
    required this.image,
  });

  factory Award.fromJson(Map<String, dynamic> json) => Award(
        link: linkValues.map[json["link"]]!,
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "link": linkValues.reverse[link],
        "image": image,
      };
}

enum Link { EMPTY }

final linkValues = EnumValues({"#": Link.EMPTY});

class Button {
  String type;
  String title;
  Description description;

  Button({
    required this.type,
    required this.title,
    required this.description,
  });

  factory Button.fromJson(Map<String, dynamic> json) => Button(
        type: json["type"],
        title: json["title"],
        description: descriptionValues.map[json["description"]]!,
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "title": title,
        "description": descriptionValues.reverse[description],
      };
}

enum Description { LEARN_MORE_ABOUT, PROFESSIONALS_WORK_WITH_US }

final descriptionValues = EnumValues({
  "Learn more about ...": Description.LEARN_MORE_ABOUT,
  "Professionals work with us": Description.PROFESSIONALS_WORK_WITH_US
});

class Location {
  int id;
  String image;
  String name;
  String phone;
  String distance;
  String lat;
  String lng;

  Location({
    required this.id,
    required this.image,
    required this.name,
    required this.phone,
    required this.distance,
    required this.lat,
    required this.lng,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        id: json["id"],
        image: json["image"],
        name: json["name"],
        phone: json["phone"] != null ? json["phone"] : "",
        distance: json["distance"],
        lat: json["lat"],
        lng: json["lng"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name": name,
        "phone": phone,
        "distance": distance,
        "lat": lat,
        "lng": lng,
      };
}

class Reviews {
  int totalSize;
  int limit;
  int offset;
  List<ReviewsDatum> data;

  Reviews({
    required this.totalSize,
    required this.limit,
    required this.offset,
    required this.data,
  });

  factory Reviews.fromJson(Map<String, dynamic> json) => Reviews(
        totalSize: json["total_size"],
        limit: json["limit"],
        offset: json["offset"],
        data: List<ReviewsDatum>.from(
            json["data"].map((x) => ReviewsDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_size": totalSize,
        "limit": limit,
        "offset": offset,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ReviewsDatum {
  String image;
  String name;
  DateTime date;
  String content;
  int rate;

  ReviewsDatum({
    required this.image,
    required this.name,
    required this.date,
    required this.content,
    required this.rate,
  });

  factory ReviewsDatum.fromJson(Map<String, dynamic> json) => ReviewsDatum(
        image: json["image"],
        name: json["name"],
        date: DateTime.parse(json["date"]),
        content: json["content"],
        rate: json["rate"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "name": name,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "content": content,
        "rate": rate,
      };
}

class Platform {
  int id;
  String name;
  String image;
  int ranking;
  String video;

  Platform({
    required this.id,
    required this.name,
    required this.image,
    required this.ranking,
    required this.video,
  });

  factory Platform.fromJson(Map<String, dynamic> json) => Platform(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        ranking: json["ranking"],
        video: json["video"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "ranking": ranking,
        "video": video,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
