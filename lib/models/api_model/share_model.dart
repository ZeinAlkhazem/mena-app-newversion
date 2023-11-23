// To parse this JSON data, do
//
//     final shareModel = shareModelFromJson(jsonString);

import 'dart:convert';

ShareModel shareModelFromJson(String str) => ShareModel.fromJson(json.decode(str));

String shareModelToJson(ShareModel data) => json.encode(data.toJson());

class ShareModel {
  int? id;
  String? banner;
  String? title;
  String? slug;
  String? content;
  int? categoryId;
  dynamic subCategoryId;
  int? providerId;
  Category? category;
  dynamic subCategory;
  Provider? provider;
  DateTime? createdAt;
  int? view;
  String? shareLink;
  int? sharesCount;
  int? likesCount;
  bool? isMine;
  bool? isLiked;

  ShareModel({
    this.id,
    this.banner,
    this.title,
    this.slug,
    this.content,
    this.categoryId,
    this.subCategoryId,
    this.providerId,
    this.category,
    this.subCategory,
    this.provider,
    this.createdAt,
    this.view,
    this.shareLink,
    this.sharesCount,
    this.likesCount,
    this.isMine,
    this.isLiked,
  });

  factory ShareModel.fromJson(Map<String, dynamic> json) => ShareModel(
    id: json["id"],
    banner: json["banner"],
    title: json["title"],
    slug: json["slug"],
    content: json["content"],
    categoryId: json["category_id"],
    subCategoryId: json["sub_category_id"],
    providerId: json["provider_id"],
    category: json["category"] == null ? null : Category.fromJson(json["category"]),
    subCategory: json["sub_category"],
    provider: json["provider"] == null ? null : Provider.fromJson(json["provider"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    view: json["view"],
    shareLink: json["share_link"],
    sharesCount: json["shares_count"],
    likesCount: json["likes_count"],
    isMine: json["is_mine"],
    isLiked: json["is_liked"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "banner": banner,
    "title": title,
    "slug": slug,
    "content": content,
    "category_id": categoryId,
    "sub_category_id": subCategoryId,
    "provider_id": providerId,
    "category": category?.toJson(),
    "sub_category": subCategory,
    "provider": provider?.toJson(),
    "created_at": "${createdAt!.year.toString().padLeft(4, '0')}-${createdAt!.month.toString().padLeft(2, '0')}-${createdAt!.day.toString().padLeft(2, '0')}",
    "view": view,
    "share_link": shareLink,
    "shares_count": sharesCount,
    "likes_count": likesCount,
    "is_mine": isMine,
    "is_liked": isLiked,
  };
}

class Category {
  int? id;
  String? title;
  String? image;
  int? platformId;
  List<dynamic>? children;

  Category({
    this.id,
    this.title,
    this.image,
    this.platformId,
    this.children,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    title: json["title"],
    image: json["image"],
    platformId: json["platform_id"],
    children: json["children"] == null ? [] : List<dynamic>.from(json["children"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image": image,
    "platform_id": platformId,
    "children": children == null ? [] : List<dynamic>.from(children!.map((x) => x)),
  };
}

class Provider {
  int? id;
  String? personalPicture;
  String? fullName;
  String? userName;
  String? email;
  dynamic phone;
  DateTime? phoneVerifiedAt;
  dynamic emailVerifiedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? roleId;
  String? roleName;
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
  String? qualificationCertificate;
  String? professionalLicense;
  dynamic abbreviation;
  dynamic expertise;
  dynamic summary;
  dynamic subscription;
  dynamic registrationNumber;
  String? lat;
  String? lng;
  int? likes;
  int? followers;
  int? reviewsRate;
  int? reviewsCount;
  bool? isFollowing;
  String? distance;
  int? verified;
  Platform? platform;
  List<dynamic>? category;
  List<dynamic>? specialitiesGroup;
  List<Speciality>? specialities;
  List<dynamic>? features;
  MoreData? moreData;

  Provider({
    this.id,
    this.personalPicture,
    this.fullName,
    this.userName,
    this.email,
    this.phone,
    this.phoneVerifiedAt,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.roleId,
    this.roleName,
    this.recoveryEmail,
    this.website,
    this.fax,
    this.whatsapp,
    this.instagram,
    this.facebook,
    this.tiktok,
    this.youtube,
    this.linkedin,
    this.providerTypeFields,
    this.address,
    this.qualificationCertificate,
    this.professionalLicense,
    this.abbreviation,
    this.expertise,
    this.summary,
    this.subscription,
    this.registrationNumber,
    this.lat,
    this.lng,
    this.likes,
    this.followers,
    this.reviewsRate,
    this.reviewsCount,
    this.isFollowing,
    this.distance,
    this.verified,
    this.platform,
    this.category,
    this.specialitiesGroup,
    this.specialities,
    this.features,
    this.moreData,
  });

  factory Provider.fromJson(Map<String, dynamic> json) => Provider(
    id: json["id"],
    personalPicture: json["personal_picture"],
    fullName: json["full_name"],
    userName: json["user_name"],
    email: json["email"],
    phone: json["phone"],
    phoneVerifiedAt: json["phone_verified_at"] == null ? null : DateTime.parse(json["phone_verified_at"]),
    emailVerifiedAt: json["email_verified_at"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
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
    platform: json["platform"] == null ? null : Platform.fromJson(json["platform"]),
    category: json["category"] == null ? [] : List<dynamic>.from(json["category"]!.map((x) => x)),
    specialitiesGroup: json["specialities_group"] == null ? [] : List<dynamic>.from(json["specialities_group"]!.map((x) => x)),
    specialities: json["specialities"] == null ? [] : List<Speciality>.from(json["specialities"]!.map((x) => Speciality.fromJson(x))),
    features: json["features"] == null ? [] : List<dynamic>.from(json["features"]!.map((x) => x)),
    moreData: json["more_data"] == null ? null : MoreData.fromJson(json["more_data"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "personal_picture": personalPicture,
    "full_name": fullName,
    "user_name": userName,
    "email": email,
    "phone": phone,
    "phone_verified_at": phoneVerifiedAt?.toIso8601String(),
    "email_verified_at": emailVerifiedAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
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
    "platform": platform?.toJson(),
    "category": category == null ? [] : List<dynamic>.from(category!.map((x) => x)),
    "specialities_group": specialitiesGroup == null ? [] : List<dynamic>.from(specialitiesGroup!.map((x) => x)),
    "specialities": specialities == null ? [] : List<dynamic>.from(specialities!.map((x) => x.toJson())),
    "features": features == null ? [] : List<dynamic>.from(features!.map((x) => x)),
    "more_data": moreData?.toJson(),
  };
}

class MoreData {
  List<dynamic>? rawards;
  List<dynamic>? educations;
  List<dynamic>? experiences;
  List<dynamic>? memberships;
  List<dynamic>? publications;
  List<dynamic>? vacations;
  dynamic about;
  int? pointsCme;
  List<Location>? locations;
  int? avgRate;
  int? totalRates;
  Reviews? reviews;
  List<Button>? buttons;
  List<Award>? awards;

  MoreData({
    this.rawards,
    this.educations,
    this.experiences,
    this.memberships,
    this.publications,
    this.vacations,
    this.about,
    this.pointsCme,
    this.locations,
    this.avgRate,
    this.totalRates,
    this.reviews,
    this.buttons,
    this.awards,
  });

  factory MoreData.fromJson(Map<String, dynamic> json) => MoreData(
    rawards: json["rawards"] == null ? [] : List<dynamic>.from(json["rawards"]!.map((x) => x)),
    educations: json["educations"] == null ? [] : List<dynamic>.from(json["educations"]!.map((x) => x)),
    experiences: json["experiences"] == null ? [] : List<dynamic>.from(json["experiences"]!.map((x) => x)),
    memberships: json["memberships"] == null ? [] : List<dynamic>.from(json["memberships"]!.map((x) => x)),
    publications: json["publications"] == null ? [] : List<dynamic>.from(json["publications"]!.map((x) => x)),
    vacations: json["vacations"] == null ? [] : List<dynamic>.from(json["vacations"]!.map((x) => x)),
    about: json["about"],
    pointsCme: json["points_cme"],
    locations: json["locations"] == null ? [] : List<Location>.from(json["locations"]!.map((x) => Location.fromJson(x))),
    avgRate: json["avg_rate"],
    totalRates: json["total_rates"],
    reviews: json["reviews"] == null ? null : Reviews.fromJson(json["reviews"]),
    buttons: json["buttons"] == null ? [] : List<Button>.from(json["buttons"]!.map((x) => Button.fromJson(x))),
    awards: json["awards"] == null ? [] : List<Award>.from(json["awards"]!.map((x) => Award.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "rawards": rawards == null ? [] : List<dynamic>.from(rawards!.map((x) => x)),
    "educations": educations == null ? [] : List<dynamic>.from(educations!.map((x) => x)),
    "experiences": experiences == null ? [] : List<dynamic>.from(experiences!.map((x) => x)),
    "memberships": memberships == null ? [] : List<dynamic>.from(memberships!.map((x) => x)),
    "publications": publications == null ? [] : List<dynamic>.from(publications!.map((x) => x)),
    "vacations": vacations == null ? [] : List<dynamic>.from(vacations!.map((x) => x)),
    "about": about,
    "points_cme": pointsCme,
    "locations": locations == null ? [] : List<dynamic>.from(locations!.map((x) => x.toJson())),
    "avg_rate": avgRate,
    "total_rates": totalRates,
    "reviews": reviews?.toJson(),
    "buttons": buttons == null ? [] : List<dynamic>.from(buttons!.map((x) => x.toJson())),
    "awards": awards == null ? [] : List<dynamic>.from(awards!.map((x) => x.toJson())),
  };
}

class Award {
  String? link;
  String? image;

  Award({
    this.link,
    this.image,
  });

  factory Award.fromJson(Map<String, dynamic> json) => Award(
    link: json["link"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "link": link,
    "image": image,
  };
}

class Button {
  String? type;
  String? title;
  String? description;

  Button({
    this.type,
    this.title,
    this.description,
  });

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

class Location {
  int? id;
  String? image;
  String? name;
  dynamic phone;
  String? distance;
  String? lat;
  String? lng;

  Location({
    this.id,
    this.image,
    this.name,
    this.phone,
    this.distance,
    this.lat,
    this.lng,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    id: json["id"],
    image: json["image"],
    name: json["name"],
    phone: json["phone"],
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
  int? totalSize;
  int? limit;
  int? offset;
  List<Datum>? data;

  Reviews({
    this.totalSize,
    this.limit,
    this.offset,
    this.data,
  });

  factory Reviews.fromJson(Map<String, dynamic> json) => Reviews(
    totalSize: json["total_size"],
    limit: json["limit"],
    offset: json["offset"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total_size": totalSize,
    "limit": limit,
    "offset": offset,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String? image;
  String? name;
  DateTime? date;
  String? content;
  int? rate;

  Datum({
    this.image,
    this.name,
    this.date,
    this.content,
    this.rate,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    image: json["image"],
    name: json["name"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    content: json["content"],
    rate: json["rate"],
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "name": name,
    "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "content": content,
    "rate": rate,
  };
}

class Platform {
  int? id;
  String? name;
  String? image;
  int? ranking;
  String? video;

  Platform({
    this.id,
    this.name,
    this.image,
    this.ranking,
    this.video,
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

class Speciality {
  int? id;
  String? filterId;
  String? name;
  int? ranking;
  String? design;
  dynamic childs;

  Speciality({
    this.id,
    this.filterId,
    this.name,
    this.ranking,
    this.design,
    this.childs,
  });

  factory Speciality.fromJson(Map<String, dynamic> json) => Speciality(
    id: json["id"],
    filterId: json["filter_id"],
    name: json["name"],
    ranking: json["ranking"],
    design: json["design"],
    childs: json["childs"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "filter_id": filterId,
    "name": name,
    "ranking": ranking,
    "design": design,
    "childs": childs,
  };
}
