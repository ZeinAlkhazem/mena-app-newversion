/// https://blasanka.github.io/watch-ads/lib/data/ads.json
///
///
// To parse this JSON data, do
//
//     final test = testFromJson(jsonString);

import 'dart:convert';

List<TestModel> testFromJson(String str) => List<TestModel>.from(json.decode(str).map((x) => TestModel.fromJson(x)));

String testToJson(List<TestModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TestModel {
  TestModel({
    this.title,
    this.price,
    this.imageUrl,
    this.location,
  });

  String? title;
  String? price;
  String? imageUrl;
  String? location;

  factory TestModel.fromJson(Map<String, dynamic> json) => TestModel(
    title: json["title"],
    price: json["price"],
    imageUrl: json["imageUrl"],
    location: json["location"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "price": price,
    "imageUrl": imageUrl,
    "location": location,
  };
}



