import 'dart:convert';

ConfigModel configModelFromJson(String str) =>
    ConfigModel.fromJson(json.decode(str));

String configModelToJson(ConfigModel data) => json.encode(data.toJson());

class ConfigModel {
  ConfigModel({
    required this.message,
    required this.data,
  });

  String message;
  Data data;

  factory ConfigModel.fromJson(Map<String, dynamic> json) => ConfigModel(
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
    required this.languages,
    required this.platforms,
    required this.countries,
    required this.appointmentTypes,
  });

  List<Language> languages;
  List<MenaPlatform> platforms;
  List<Country> countries;
  List<AppointmentType> appointmentTypes;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        languages: List<Language>.from(
            json["languages"].map((x) => Language.fromJson(x))),
        platforms: List<MenaPlatform>.from(
            json["platforms"].map((x) => MenaPlatform.fromJson(x))),
        countries: List<Country>.from(
            json["countries"].map((x) => Country.fromJson(x))),
    appointmentTypes: List<AppointmentType>.from(json["appointment_types"].map((x) => AppointmentType.fromJson(x))),

  );

  Map<String, dynamic> toJson() => {
        "languages": List<dynamic>.from(languages.map((x) => x.toJson())),
        "platforms": List<dynamic>.from(platforms.map((x) => x.toJson())),
        "countries": List<dynamic>.from(countries.map((x) => x.toJson())),
      };
}
class AppointmentType {
  AppointmentType({
    required this.id,
    required this.title,
    required this.type,
  });

  int id;
  String title;
  int type;

  factory AppointmentType.fromJson(Map<String, dynamic> json) => AppointmentType(
    id: json["id"],
    title: json["title"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
  };
}
class Country {
  Country({
    required this.id,
    required this.flag,
    required this.coCode,
    required this.slug,
    required this.name,
    required this.phCode,
    required this.currencyCode,
    required this.cities,
  });

  String? id;
  String? flag;
  String? coCode;
  String? slug;
  String? name;
  String? phCode;
  String? currencyCode;
  List<City>? cities;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"].toString(),
        flag: json["flag"].toString(),
        coCode: json["co_code"].toString(),
        slug: json["slug"].toString(),
        name: json["name"].toString(),
        phCode: json["ph_code"].toString(),
        currencyCode: json["currency_code"].toString(),
        cities: List<City>.from(json["cities"].map((x) => City.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "flag": flag,
        "co_code": coCode,
        "slug": slug,
        "name": name,
        "ph_code": phCode,
        "currency_code": currencyCode,
        "cities": List<dynamic>.from(cities!.map((x) => x.toJson())),
      };
}

class City {
  City({
    required this.id,
    required this.subOf,
    required this.name,
    required this.capital,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  int? id;
  String? subOf;
  String? name;
  int? capital;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic deletedAt;

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"],
        subOf: json["sub_of"].toString(),
        name: json["name"],
        capital: json["capital"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sub_of": subOf,
        "name": name,
        "capital": capital,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "deleted_at": deletedAt,
      };
}

class Language {
  Language({
    required this.id,
    required this.name,
    required this.code,
    required this.direction,
    required this.isDefault,
  });

  String? id;
  String? name;
  String? code;
  String? direction;
  String? isDefault;

  factory Language.fromJson(Map<String, dynamic> json) => Language(
        id: json["id"].toString(),
        name: json["name"].toString(),
        code: json["code"].toString(),
        direction: json["direction"].toString(),
        isDefault: json["is_default"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "direction": direction,
        "is_default": isDefault,
      };
}

class MenaPlatform {
  MenaPlatform({
    required this.id,
    required this.name,
    required this.image,
  });

  String? id;
  String? name;
  String? image;

  factory MenaPlatform.fromJson(Map<String, dynamic> json) => MenaPlatform(
        id: json["id"].toString(),
        name: json["name"].toString(),
        image: json["image"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
