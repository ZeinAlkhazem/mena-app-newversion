// To parse this JSON data, do
//
//     final homeSectionModel = homeSectionModelFromJson(jsonString);

import 'dart:convert';

import 'package:mena/models/api_model/config_model.dart';
import 'package:mena/models/api_model/provider_details_model.dart';
// import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
// import 'package:sqflite/utils/utils.dart';

HomeSectionModel homeSectionModelFromJson(String str) => HomeSectionModel.fromJson(json.decode(str));

String homeSectionModelToJson(HomeSectionModel data) => json.encode(data.toJson());

class HomeSectionModel {
  HomeSectionModel({
    required this.message,
    required this.data,
  });

  String message;

  // String message;
  List<HomeSectionBlockModel> data;

  factory HomeSectionModel.fromJson(Map<String, dynamic> json) => HomeSectionModel(
        message: json["message"],
        data: List<HomeSectionBlockModel>.from(json["data"].map((x) => HomeSectionBlockModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class HomeSectionBlockModel {
  HomeSectionBlockModel({
    required this.type,
    required this.title,
    this.style,
    required this.data,
  });

  String type;
  String title;
  String? style;
  HomeSectionBlockDataModel data;

  factory HomeSectionBlockModel.fromJson(Map<String, dynamic> json) => HomeSectionBlockModel(
        type: json["type"],
        title: json["title"],
        style: json["style"],
        data: HomeSectionBlockDataModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        // "data": data!.toJson(),
      };
}

class HomeSectionBlockDataModel {
  HomeSectionBlockDataModel({
    required this.video,
    this.categories,
    required this.providersNearby,
    required this.providersOnAir,
    required this.items,
    required this.vacancies,
    required this.deals,
    required this.coupons,
    required this.events,
    required this.eventsNearby,
    required this.articles,
    required this.talk,
    required this.cme,
    required this.banner,
    required this.partner,
    this.providers,
  });

  String? video;
  List<MenaCategory>? categories;
  List<ProviderLocationModel>? providersNearby;
  List<ProvidersOnAir>? providersOnAir;
  List<Item>? items;
  List<Vacancy>? vacancies;
  List<Deal>? deals;
  List<Coupon>? coupons;
  List<Event>? events;
  List<EventsNearby>? eventsNearby;
  List<Article>? articles;
  List<Talk>? talk;
  List<Cme>? cme;
  List<MenaBanner>? banner;
  List<Partner>? partner;
  List<User>? providers;

  factory HomeSectionBlockDataModel.fromJson(Map<String, dynamic> json) => HomeSectionBlockDataModel(
        video: json["video"],
        categories: json["categories"] == null
            ? null
            : List<MenaCategory>.from(json["categories"].map((x) => MenaCategory.fromJson(x))),

        providersNearby: json["providers_nearby"] == null
            ? null
            : List<ProviderLocationModel>.from(json["providers_nearby"].map((x) => ProviderLocationModel.fromJson(x))),
        providersOnAir: json["providers_on_air"] == null
            ? null
            : List<ProvidersOnAir>.from(json["providers_on_air"].map((x) => ProvidersOnAir.fromJson(x))),
        // supplies: json["supplies"] == null
        //     ? null
        //     : List<Supplier>.from(
        //         json["supplies"].map((x) => Supplier.fromJson(x))),
        items: json["items"] == null ? null : List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        vacancies:
            json["vacancies"] == null ? null : List<Vacancy>.from(json["vacancies"].map((x) => Vacancy.fromJson(x))),
        deals: json["deals"] == null ? null : List<Deal>.from(json["deals"].map((x) => Deal.fromJson(x))),
        coupons: json["coupons"] == null ? null : List<Coupon>.from(json["coupons"].map((x) => Coupon.fromJson(x))),
        events: json["events"] == null ? null : List<Event>.from(json["events"].map((x) => Event.fromJson(x))),
        eventsNearby: json["events_nearby"] == null
            ? null
            : List<EventsNearby>.from(json["events_nearby"].map((x) => EventsNearby.fromJson(x))),
        articles:
            json["articles"] == null ? null : List<Article>.from(json["articles"].map((x) => Article.fromJson(x))),
        talk: json["talk"] == null ? null : List<Talk>.from(json["talk"].map((x) => Talk.fromJson(x))),
        cme: json["cme"] == null ? null : List<Cme>.from(json["cme"].map((x) => Cme.fromJson(x))),
        banner:
            json["banner"] == null ? null : List<MenaBanner>.from(json["banner"].map((x) => MenaBanner.fromJson(x))),
        partner: json["partner"] == null ? null : List<Partner>.from(json["partner"].map((x) => Partner.fromJson(x))),
        providers: json["providers"] == null ? null : List<User>.from(json["providers"].map((x) => User.fromJson(x))),
      );
}

class Article {
  Article({
    required this.id,
    required this.image,
    required this.title,
    required this.category,
    required this.createdAt,
  });

  int id;
  String image;
  String title;
  String category;
  String createdAt;

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        id: json["id"],
        image: json["image"],
        title: json["title"],
        category: json["category"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "title": title,
        "category": category,
        "created_at": createdAt,
      };
}

class MenaBanner {
  MenaBanner({
    required this.id,
    required this.title,
    required this.platformId,
    required this.bannerInLine,
    required this.image,
    required this.imagesStyle,
    required this.url,
    required this.resourceType,
    required this.resourceId,
  });

  int id;
  String title;
  String platformId;
  String bannerInLine;
  String image;
  String imagesStyle;
  String? url;
  String resourceType;
  String resourceId;

  factory MenaBanner.fromJson(Map<String, dynamic> json) => MenaBanner(
        id: json["id"],
        title: json["title"],
        platformId: json["platform_id"].toString(),
        image: json["image"],
        imagesStyle: json["images_style"].toString(),
        bannerInLine: json["banner_in_line"].toString(),
        url: json["url"],
        resourceType: json["resource_type"],
        resourceId: json["resource_id"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "url": url,
        "resource_type": resourceType,
        "resource_id": resourceId,
      };
}

class MenaCategory {
  MenaCategory({
    required this.id,
    this.image,
    this.filterId,
    this.name,
    this.ranking,
    this.design,
    this.childs,
  });

  int id;
  String? image;
  String? filterId;
  String? name;
  String? ranking;
  String? design;
  List<MenaCategory?>? childs;

  factory MenaCategory.fromJson(Map<String, dynamic> json) => MenaCategory(
        id: json["id"],
        image: json["image"].toString(),
        filterId: json["filter_id"].toString(),
        name: json["name"].toString(),
        ranking: json["ranking"].toString(),
        design: json["design"].toString(),
        childs: json["childs"] == null
            ? null
            : List<MenaCategory>.from(json["childs"].map((x) => MenaCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name": name,
        "ranking": ranking,
        "design": design,
        // "childs": List<dynamic>.from(childs.map((x) => x.toJson())),
      };
}

class Cme {
  Cme({
    required this.id,
    required this.title,
    required this.date,
    required this.distance,
    required this.description,
    required this.logos,
    required this.time,
    required this.reviews,
  });

  int id;
  String title;
  String date;
  String distance;
  String description;
  List<String?> logos;
  String time;
  double reviews;

  factory Cme.fromJson(Map<String, dynamic> json) => Cme(
        id: json["id"],
        title: json["title"],
        date: json["date"],
        distance: json["distance"],
        description: json["description"],
        logos: List<String>.from(json["logos"].map((x) => x)),
        time: json["time"],
        reviews: json["reviews"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "date": date,
        "distance": distance,
        "description": description,
        "logos": List<dynamic>.from(logos.map((x) => x)),
        "time": time,
        "reviews": reviews,
      };
}

class Coupon {
  Coupon({
    required this.id,
    required this.image,
    required this.description,
    required this.price,
    required this.offer,
    required this.rate,
    required this.likes,
    // required this.title,
    // required this.distance,
  });

  int id;
  String image;
  String description;
  String price;
  String offer;
  int rate;
  int likes;

  // String title;
  // String distance;

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
        id: json["id"],
        image: json["image"],
        description: json["description"],
        price: json["price"],
        offer: json["offer"],
        rate: json["rate"],
        likes: json["likes"],
        // title: json["title"],
        // distance: json["distance"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "description": description,
        // "price": priceValues.reverse[price],
        // "offer": offerValues.reverse[offer],
        "rate": rate,
        "likes": likes,
        // "title": title,
        // "distance": distance,
      };
}

class Deal {
  Deal({
    required this.id,
    required this.image,
    required this.title,
    required this.price,
    required this.offer,
    required this.rate,
    required this.distance,
    required this.likes,
  });

  int id;
  String image;
  String title;
  String price;
  String offer;
  int rate;
  String distance;
  int likes;

  factory Deal.fromJson(Map<String, dynamic> json) => Deal(
        id: json["id"],
        image: json["image"],
        title: json["title"],
        price: json["price"],
        offer: json["offer"],
        rate: json["rate"],
        distance: json["distance"],
        likes: json["likes"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "title": title,
        "price": price,
        "offer": offer,
        "rate": rate,
        "distance": distance,
        "likes": likes,
      };
}

class Event {
  Event({
    required this.id,
    required this.image,
    required this.title,
    required this.category,
    required this.userImg,
    required this.userName,
    required this.duration,
    required this.type,
    required this.date,
    required this.time,
  });

  int id;
  String image;
  String title;
  String category;
  String userImg;
  String userName;
  String duration;
  String type;
  String date;
  String time;

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json["id"],
        image: json["image"],
        title: json["title"],
        category: json["category"],
        userImg: json["user_img"],
        userName: json["user_name"],
        duration: json["duration"],
        type: json["type"],
        date: json["date"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "title": title,
        "category": category,
        "user_img": userImg,
        "user_name": userName,
        "duration": duration,
        "type": type,
        "date": date,
        "time": time,
      };
}

class EventsNearby {
  EventsNearby({
    required this.id,
    required this.image,
    required this.distance,
    required this.lat,
    required this.lng,
  });

  int id;
  String image;
  String distance;
  String lat;
  String lng;

  factory EventsNearby.fromJson(Map<String, dynamic> json) => EventsNearby(
        id: json["id"],
        image: json["image"],
        distance: json["distance"],
        lat: json["lat"],
        lng: json["lng"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
      };
}

class ProviderLocationModel {
  ProviderLocationModel({
    required this.id,
    required this.image,
    required this.phone,
    required this.name,
    required this.distance,
    required this.lat,
    required this.lng,
  });

  int id;
  String image;
  String phone;
  String name;
  String distance;
  String lat;
  String lng;

  factory ProviderLocationModel.fromJson(Map<String, dynamic> json) => ProviderLocationModel(
        id: json["id"],
        image: json["image"].toString(),
        phone: json["phone"].toString(),
        name: json["name"].toString(),
        distance: json["distance"].toString(),
        lat: json["lat"].toString(),
        lng: json["lng"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
      };
}

class Item {
  Item({
    required this.id,
    required this.image,
    required this.title,
    required this.price,
  });

  int id;
  String image;
  String title;
  String price;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        image: json["image"],
        title: json["title"],
        price: json["price"],


  );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "title": title,
        "price": price,
      };
}

class Partner {
  Partner({
    required this.id,
    required this.image,
    required this.url,
  });

  int id;
  String image;
  String url;

  factory Partner.fromJson(Map<String, dynamic> json) => Partner(
        id: json["id"],
        image: json["image"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "url": url,
      };
}

class User {
  User({
    required this.id,
    this.personalPicture,
    this.fullName,
    this.email,
    this.country,
    this.phone,
    this.website,
    this.whatsapp,
    this.instagram,
    this.facebook,
    this.tiktok,
    this.pinterest,
    this.youtube,
    this.linkedin,
    this.platform,
    this.address,
    this.abbreviation,
    this.speciality,
    this.expertise,
    this.summary,
    this.verified,
    this.subscription,
    this.phoneVerifiedAt,
    this.registrationNumber,
    this.lat,
    this.lng,
    this.likes,
    this.followers,
    this.reviewsRate,
    this.reviewsCount,
    this.isFollowing,
    this.distance,
    this.roleName,
    this.roleId,
    this.specialities,
    this.moreData,
  });

  int id;
  String? personalPicture;
  String? fullName;
  String? phoneVerifiedAt;
  String? email;
  String? address;
  String? website;
  String? phone;
  String? whatsapp;
  String? instagram;
  String? facebook;
  String? tiktok;
  String? pinterest;
  String? youtube;
  String? linkedin;
  String? country;
  MenaPlatform? platform;
  Abbreviation? abbreviation;
  dynamic speciality;
  String? expertise;
  String? summary;
  String? verified;
  dynamic subscription;
  dynamic registrationNumber;
  String? lat;
  String? lng;
  int? likes;
  String? followers;
  String? reviewsRate;
  String? reviewsCount;
  bool? isFollowing;
  String? distance;
  String? roleId;
  String? roleName;
  List<MenaCategory>? specialities;
  MoreData? moreData;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        personalPicture: json["personal_picture"],
        phoneVerifiedAt: json["phone_verified_at"],
        fullName: json["full_name"],
        email: json["email"],
        address: json["address"],
        country: json["country"],
        website: json["website"],
        phone: json["phone"],
        whatsapp: json["whatsapp"],
        instagram: json["instagram"],
        pinterest: json["pinterest"],
        facebook: json["facebook"],
        tiktok: json["tiktok"],
        youtube: json["youtube"],
        linkedin: json["linkedin"],
        platform: json["platform"] == null ? null : MenaPlatform.fromJson(json["platform"]),
        abbreviation: json["abbreviation"] == null ? null : Abbreviation.fromJson(json["abbreviation"]),
        speciality: json["speciality"],
        expertise: json["expertise"],
        summary: json["summary"],
        verified: json["verified"].toString(),
        subscription: json["subscription"],
        registrationNumber: json["registration_number"],
        lat: json["lat"].toString(),
        lng: json["lng"].toString(),
        likes: json["likes"],
        followers: json["followers"].toString(),
        reviewsRate: json["reviews_rate"].toString(),
        reviewsCount: json["reviews_count"].toString(),
        isFollowing: json["is_following"],
        distance: json["distance"],
        roleId: json["role_id"].toString(),
        roleName: json["role_name"].toString(),
        specialities: json["specialities"] == null
            ? null
            : List<MenaCategory>.from(json["specialities"].map((x) => MenaCategory.fromJson(x))),
        moreData: json["more_data"] == null ? null : MoreData.fromJson(json["more_data"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "personal_picture": personalPicture,
        "full_name": fullName,
        "email": email,
        "phone": phone,
        "platform": platform!.toJson(),
        "abbreviation": abbreviation!.toJson(),
        "speciality": speciality,
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
      };
}

class Abbreviation {
  Abbreviation({
    this.id,
    this.name,
    this.platformId,
  });

  int? id;
  String? name;
  String? platformId;

  factory Abbreviation.fromJson(Map<String, dynamic> json) => Abbreviation(
        id: json["id"],
        name: json["name"],
        platformId: json["platform_id"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "platform_id": platformId,
      };
}

class ProvidersOnAir {
  ProvidersOnAir({
    required this.id,
    required this.image,
    required this.name,
  });

  int id;
  String image;
  String name;

  factory ProvidersOnAir.fromJson(Map<String, dynamic> json) => ProvidersOnAir(
        id: json["id"],
        image: json["image"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name": name,
      };
}

class Talk {
  Talk({
    required this.id,
    required this.image,
    required this.url,
  });

  int id;
  String url;
  String? image;

  factory Talk.fromJson(Map<String, dynamic> json) => Talk(
        id: json["id"],
        image: json["image"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
      };
}

class Vacancy {
  Vacancy({
    required this.id,
    required this.image,
    required this.title,
    required this.location,
    required this.distance,
    required this.scope,
    required this.createdAt,
  });

  int id;
  String image;
  String title;
  String location;
  String distance;
  String scope;
  DateTime createdAt;

  factory Vacancy.fromJson(Map<String, dynamic> json) => Vacancy(
        id: json["id"],
        image: json["image"],
        title: json["title"],
        location: json["location"],
        distance: json["distance"],
        scope: json["scope"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "title": title,
        "location": location,
        "distance": distance,
        "scope": scope,
        "created_at":
            "${createdAt.year.toString().padLeft(4, '0')}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}",
      };
}

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap ??= map!.map((k, v) => MapEntry(v, k));
    return reverseMap!;
  }
}

class MoreData {
  MoreData({
    this.rewards,
    this.educations,
    this.experiences,
    this.memberships,
    this.publications,
    this.certifications,
    this.about,
    this.cmePoints,
    this.locations,
    this.avgRate,
    this.totalRates,
    this.reviews,
    this.buttons,
    this.awards,
  });

  List<Reward>? rewards;
  List<Education>? educations;
  List<Experience>? experiences;
  List<Membership>? memberships;
  List<Publication>? publications;
  List<Certificate>? certifications;
  String? about;
  String? cmePoints;
  List<ProviderLocationModel>? locations;
  int? avgRate;
  int? totalRates;
  MenaReviews? reviews;
  List<Button>? buttons;
  List<Awards>? awards;

  factory MoreData.fromJson(Map<String, dynamic> json) => MoreData(
        about: json["about"],
        cmePoints: json["points_cme"].toString(),
        rewards: json["rawards"] == null ? null : List<Reward>.from(json["rawards"].map((x) => Reward.fromJson(x))),
        educations: json["educations"] == null
            ? null
            : List<Education>.from(json["educations"].map((x) => Education.fromJson(x))),
        experiences: json["experiences"] == null
            ? null
            : List<Experience>.from(json["experiences"].map((x) => Experience.fromJson(x))),
        memberships: json["memberships"] == null
            ? null
            : List<Membership>.from(json["memberships"].map((x) => Membership.fromJson(x))),
        publications: json["publications"] == null
            ? null
            : List<Publication>.from(json["publications"].map((x) => Publication.fromJson(x))),
        certifications: json["vacations"] == null
            ? null
            : List<Certificate>.from(json["vacations"].map((x) => Certificate.fromJson(x))),
        locations: List<ProviderLocationModel>.from(json["locations"].map((x) => ProviderLocationModel.fromJson(x))),
        avgRate: json["avg_rate"],
        totalRates: json["total_rates"],
        reviews: MenaReviews.fromJson(json["reviews"]),
        buttons: List<Button>.from(json["buttons"].map((x) => Button.fromJson(x))),
        awards: json["awards"] == null ? null : List<Awards>.from(json["awards"].map((x) => Awards.fromJson(x))),
      );
//
// Map<String, dynamic> toJson() => {
//   "rawards": List<dynamic>.from(rawards.map((x) => x)),
//   "educations": List<dynamic>.from(educations.map((x) => x)),
//   "experiences": List<dynamic>.from(experiences.map((x) => x)),
//   "memberships": List<dynamic>.from(memberships.map((x) => x)),
//   "publications": List<dynamic>.from(publications.map((x) => x)),
//   "vacations": List<dynamic>.from(vacations.map((x) => x)),
//   // "locations": List<dynamic>.from(locations.map((x) => x.toJson())),
//   // "avg_rate": avgRate,
//   // "total_rates": totalRates,
//   // "reviews": reviews.toJson(),
//   // "buttons": List<dynamic>.from(buttons.map((x) => x.toJson())),
//   // "awards": List<dynamic>.from(awards.map((x) => x.toJson())),
// };
}

//
// {
// "message": "Data Got!",
// "data": [
// {
// "type": "video",
// "title": "oKGgjXA0nx",
// "data": {
// "video": "https://dashboard.menaplatforms.com/storage/platforms/October2022/0nxSUdrm61wDlegk5YXd.png",
// "categories": null,
// "providers_nearby": null,
// "providers_on_air": null,
// "items": null,
// "vacancies": null,
// "deals": null,
// "coupons": null,
// "events": null,
// "events_nearby": null,
// "articles": null,
// "talk": null,
// "cme": null,
// "banner": null,
// "partner": null
// }
// },
// {
// "type": "providers_nearby",
// "title": "X5Bcozhmgu",
// "data": {
// "video": null,
// "categories": null,
// "providers_nearby": [
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "distance": "1.7km"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "distance": "1.7km"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "distance": "1.7km"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "distance": "1.7km"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "distance": "1.7km"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "distance": "1.7km"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "distance": "1.7km"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "distance": "1.7km"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "distance": "1.7km"
// }
// ],
// "providers_on_air": null,
// "items": null,
// "vacancies": null,
// "deals": null,
// "coupons": null,
// "events": null,
// "events_nearby": null,
// "articles": null,
// "talk": null,
// "cme": null,
// "banner": null,
// "partner": null
// }
// },
// {
// "type": "providers_on_air",
// "title": "fGpp4qd9WF",
// "data": {
// "video": null,
// "categories": null,
// "providers_nearby": null,
// "providers_on_air": [
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "name": "Dr.Mohammed"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "name": "Dr.Mohammed"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "name": "Dr.Mohammed"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "name": "Dr.Mohammed"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "name": "Dr.Mohammed"
// }
// ],
// "items": null,
// "vacancies": null,
// "deals": null,
// "coupons": null,
// "events": null,
// "events_nearby": null,
// "articles": null,
// "talk": null,
// "cme": null,
// "banner": null,
// "partner": null
// }
// },
// {
// "type": "items",
// "title": "rNXfgBtzu6",
// "data": {
// "video": null,
// "categories": null,
// "providers_nearby": null,
// "providers_on_air": null,
// "items": [
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "title": "test name",
// "price": "1700 AED"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "title": "test name",
// "price": "1700 AED"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "title": "test name",
// "price": "1700 AED"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "title": "test name",
// "price": "1700 AED"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "title": "test name",
// "price": "1700 AED"
// }
// ],
// "vacancies": null,
// "deals": null,
// "coupons": null,
// "events": null,
// "events_nearby": null,
// "articles": null,
// "talk": null,
// "cme": null,
// "banner": null,
// "partner": null
// }
// },
// {
// "type": "vacancies",
// "title": "Vlu97RZj41",
// "data": {
// "video": null,
// "categories": null,
// "providers_nearby": null,
// "providers_on_air": null,
// "items": null,
// "vacancies": [
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "title": "test title",
// "location": "Dubai - UAE",
// "distance": "18km",
// "scope": "test scope test scope test scope test scope test scope",
// "created_at": "2022-10-12"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "title": "test title",
// "location": "Dubai - UAE",
// "distance": "18km",
// "scope": "test scope test scope test scope test scope test scope",
// "created_at": "2022-10-12"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "title": "test title",
// "location": "Dubai - UAE",
// "distance": "18km",
// "scope": "test scope test scope test scope test scope test scope",
// "created_at": "2022-10-12"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "title": "test title",
// "location": "Dubai - UAE",
// "distance": "18km",
// "scope": "test scope test scope test scope test scope test scope",
// "created_at": "2022-10-12"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "title": "test title",
// "location": "Dubai - UAE",
// "distance": "18km",
// "scope": "test scope test scope test scope test scope test scope",
// "created_at": "2022-10-12"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "title": "test title",
// "location": "Dubai - UAE",
// "distance": "18km",
// "scope": "test scope test scope test scope test scope test scope",
// "created_at": "2022-10-12"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "title": "test title",
// "location": "Dubai - UAE",
// "distance": "18km",
// "scope": "test scope test scope test scope test scope test scope",
// "created_at": "2022-10-12"
// }
// ],
// "deals": null,
// "coupons": null,
// "events": null,
// "events_nearby": null,
// "articles": null,
// "talk": null,
// "cme": null,
// "banner": null,
// "partner": null
// }
// },
// {
// "type": "deals",
// "title": "lWkzzDpv3Q",
// "data": {
// "video": null,
// "categories": null,
// "providers_nearby": null,
// "providers_on_air": null,
// "items": null,
// "vacancies": null,
// "deals": [
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "title": "test title",
// "price": "300 AED",
// "offer": "30%",
// "rate": 4,
// "distance": "18km",
// "likes": 220
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "title": "test title",
// "price": "300 AED",
// "offer": "30%",
// "rate": 4,
// "distance": "18km",
// "likes": 220
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "title": "test title",
// "price": "300 AED",
// "offer": "30%",
// "rate": 4,
// "distance": "18km",
// "likes": 220
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "title": "test title",
// "price": "300 AED",
// "offer": "30%",
// "rate": 4,
// "distance": "18km",
// "likes": 220
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "title": "test title",
// "price": "300 AED",
// "offer": "30%",
// "rate": 4,
// "distance": "18km",
// "likes": 220
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "title": "test title",
// "price": "300 AED",
// "offer": "30%",
// "rate": 4,
// "distance": "18km",
// "likes": 220
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "title": "test title",
// "price": "300 AED",
// "offer": "30%",
// "rate": 4,
// "distance": "18km",
// "likes": 220
// }
// ],
// "coupons": null,
// "events": null,
// "events_nearby": null,
// "articles": null,
// "talk": null,
// "cme": null,
// "banner": null,
// "partner": null
// }
// },
// {
// "type": "coupons",
// "title": "A2IPLmE4aN",
// "data": {
// "video": null,
// "categories": null,
// "providers_nearby": null,
// "providers_on_air": null,
// "items": null,
// "vacancies": null,
// "deals": null,
// "coupons": [
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "description": "coupon details coupon details coupon details coupon details",
// "price": "300 AED",
// "offer": "30%",
// "rate": 4,
// "likes": 220
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "description": "coupon details coupon details coupon details coupon details",
// "price": "300 AED",
// "offer": "30%",
// "rate": 4,
// "likes": 220
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "description": "coupon details coupon details coupon details coupon details",
// "price": "300 AED",
// "offer": "30%",
// "rate": 4,
// "likes": 220
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "description": "coupon details coupon details coupon details coupon details",
// "price": "300 AED",
// "offer": "30%",
// "rate": 4,
// "likes": 220
// }
// ],
// "events": null,
// "events_nearby": null,
// "articles": null,
// "talk": null,
// "cme": null,
// "banner": null,
// "partner": null
// }
// },
// {
// "type": "events",
// "title": "vJuP5JKpA8",
// "data": {
// "video": null,
// "categories": null,
// "providers_nearby": null,
// "providers_on_air": null,
// "items": null,
// "vacancies": null,
// "deals": null,
// "coupons": null,
// "events": [
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "title": "event title event title event title event title?",
// "category": "Biology",
// "user_img": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "user_name": "Dr.Fadi Name",
// "duration": "02 h 30 min",
// "type": "online",
// "date": "August 05,2022",
// "time": "02:00 pm"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "title": "event title event title event title event title?",
// "category": "Biology",
// "user_img": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "user_name": "Dr.Fadi Name",
// "duration": "02 h 30 min",
// "type": "online",
// "date": "August 05,2022",
// "time": "02:00 pm"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "title": "event title event title event title event title?",
// "category": "Biology",
// "user_img": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "user_name": "Dr.Fadi Name",
// "duration": "02 h 30 min",
// "type": "online",
// "date": "August 05,2022",
// "time": "02:00 pm"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "title": "event title event title event title event title?",
// "category": "Biology",
// "user_img": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "user_name": "Dr.Fadi Name",
// "duration": "02 h 30 min",
// "type": "online",
// "date": "August 05,2022",
// "time": "02:00 pm"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "title": "event title event title event title event title?",
// "category": "Biology",
// "user_img": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "user_name": "Dr.Fadi Name",
// "duration": "02 h 30 min",
// "type": "online",
// "date": "August 05,2022",
// "time": "02:00 pm"
// }
// ],
// "events_nearby": null,
// "articles": null,
// "talk": null,
// "cme": null,
// "banner": null,
// "partner": null
// }
// },
// {
// "type": "events_nearby",
// "title": "5RQadFKdtu",
// "data": {
// "video": null,
// "categories": null,
// "providers_nearby": null,
// "providers_on_air": null,
// "items": null,
// "vacancies": null,
// "deals": null,
// "coupons": null,
// "events": null,
// "events_nearby": [
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "distance": "1.7km"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "distance": "1.7km"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "distance": "1.7km"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "distance": "1.7km"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "distance": "1.7km"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "distance": "1.7km"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "distance": "1.7km"
// }
// ],
// "articles": null,
// "talk": null,
// "cme": null,
// "banner": null,
// "partner": null
// }
// },
// {
// "type": "articles",
// "title": "4yUXAy0a1H",
// "data": {
// "video": null,
// "categories": null,
// "providers_nearby": null,
// "providers_on_air": null,
// "items": null,
// "vacancies": null,
// "deals": null,
// "coupons": null,
// "events": null,
// "events_nearby": null,
// "articles": [
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "title": "Article Title",
// "category": "health",
// "created_at": "02/08/2022"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "title": "Article Title",
// "category": "health",
// "created_at": "02/08/2022"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "title": "Article Title",
// "category": "health",
// "created_at": "02/08/2022"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "title": "Article Title",
// "category": "health",
// "created_at": "02/08/2022"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "title": "Article Title",
// "category": "health",
// "created_at": "02/08/2022"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "title": "Article Title",
// "category": "health",
// "created_at": "02/08/2022"
// }
// ],
// "talk": null,
// "cme": null,
// "banner": null,
// "partner": null
// }
// },
// {
// "type": "talk",
// "title": "DJEPmhXwGN",
// "data": {
// "video": null,
// "categories": null,
// "providers_nearby": null,
// "providers_on_air": null,
// "items": null,
// "vacancies": null,
// "deals": null,
// "coupons": null,
// "events": null,
// "events_nearby": null,
// "articles": null,
// "talk": [
// {
// "id": 1,
// "url": "https://dashboard.menaplatforms.com/mov_bbb.mp4"
// },
// {
// "id": 1,
// "url": "https://dashboard.menaplatforms.com/mov_bbb.mp4"
// },
// {
// "id": 1,
// "url": "https://dashboard.menaplatforms.com/mov_bbb.mp4"
// },
// {
// "id": 1,
// "url": "https://dashboard.menaplatforms.com/mov_bbb.mp4"
// },
// {
// "id": 1,
// "url": "https://dashboard.menaplatforms.com/mov_bbb.mp4"
// },
// {
// "id": 1,
// "url": "https://dashboard.menaplatforms.com/mov_bbb.mp4"
// },
// {
// "id": 1,
// "url": "https://dashboard.menaplatforms.com/mov_bbb.mp4"
// },
// {
// "id": 1,
// "url": "https://dashboard.menaplatforms.com/mov_bbb.mp4"
// }
// ],
// "cme": null,
// "banner": null,
// "partner": null
// }
// },
// {
// "type": "cme",
// "title": "KFIG2Mgu8x",
// "data": {
// "video": null,
// "categories": null,
// "providers_nearby": null,
// "providers_on_air": null,
// "items": null,
// "vacancies": null,
// "deals": null,
// "coupons": null,
// "events": null,
// "events_nearby": null,
// "articles": null,
// "talk": null,
// "cme": [
// {
// "id": 1,
// "title": "CME Title CME Title CME Title CME Title CME Title CME Title?",
// "date": "August 05, 2022",
// "distance": "30km",
// "description": "CME description, CME description CME description CME description CME description",
// "logos": [
// "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png"
// ],
// "time": "02 h 30 m",
// "reviews": 4.5
// },
// {
// "id": 1,
// "title": "CME Title CME Title CME Title CME Title CME Title CME Title?",
// "date": "August 05, 2022",
// "distance": "30km",
// "description": "CME description, CME description CME description CME description CME description",
// "logos": [
// "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png"
// ],
// "time": "02 h 30 m",
// "reviews": 4.5
// },
// {
// "id": 1,
// "title": "CME Title CME Title CME Title CME Title CME Title CME Title?",
// "date": "August 05, 2022",
// "distance": "30km",
// "description": "CME description, CME description CME description CME description CME description",
// "logos": [
// "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png"
// ],
// "time": "02 h 30 m",
// "reviews": 4.5
// },
// {
// "id": 1,
// "title": "CME Title CME Title CME Title CME Title CME Title CME Title?",
// "date": "August 05, 2022",
// "distance": "30km",
// "description": "CME description, CME description CME description CME description CME description",
// "logos": [
// "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png"
// ],
// "time": "02 h 30 m",
// "reviews": 4.5
// },
// {
// "id": 1,
// "title": "CME Title CME Title CME Title CME Title CME Title CME Title?",
// "date": "August 05, 2022",
// "distance": "30km",
// "description": "CME description, CME description CME description CME description CME description",
// "logos": [
// "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png"
// ],
// "time": "02 h 30 m",
// "reviews": 4.5
// },
// {
// "id": 1,
// "title": "CME Title CME Title CME Title CME Title CME Title CME Title?",
// "date": "August 05, 2022",
// "distance": "30km",
// "description": "CME description, CME description CME description CME description CME description",
// "logos": [
// "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png"
// ],
// "time": "02 h 30 m",
// "reviews": 4.5
// },
// {
// "id": 1,
// "title": "CME Title CME Title CME Title CME Title CME Title CME Title?",
// "date": "August 05, 2022",
// "distance": "30km",
// "description": "CME description, CME description CME description CME description CME description",
// "logos": [
// "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png"
// ],
// "time": "02 h 30 m",
// "reviews": 4.5
// }
// ],
// "banner": null,
// "partner": null
// }
// },
// {
// "type": "banner",
// "title": "C0sfJL28I7",
// "data": {
// "video": null,
// "categories": null,
// "providers_nearby": null,
// "providers_on_air": null,
// "items": null,
// "vacancies": null,
// "deals": null,
// "coupons": null,
// "events": null,
// "events_nearby": null,
// "articles": null,
// "talk": null,
// "cme": null,
// "banner": [
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "url": "#",
// "resource_type": "provider",
// "resource_id": 1
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "url": "#",
// "resource_type": "provider",
// "resource_id": 1
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "url": "#",
// "resource_type": "provider",
// "resource_id": 1
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "url": "#",
// "resource_type": "provider",
// "resource_id": 1
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "url": "#",
// "resource_type": "provider",
// "resource_id": 1
// }
// ],
// "partner": null
// }
// },
// {
// "type": "partner",
// "title": "vC5Xjy8qh4",
// "data": {
// "video": null,
// "categories": null,
// "providers_nearby": null,
// "providers_on_air": null,
// "items": null,
// "vacancies": null,
// "deals": null,
// "coupons": null,
// "events": null,
// "events_nearby": null,
// "articles": null,
// "talk": null,
// "cme": null,
// "banner": null,
// "partner": [
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "url": "#"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "url": "#"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "url": "#"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "url": "#"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "url": "#"
// },
// {
// "id": 1,
// "image": "https://dashboard.menaplatforms.com/storage/settings/September2022/50B3VXV38WqV2X5ORsN8.png",
// "url": "#"
// }
// ]
// }
// }
// ]
// }
