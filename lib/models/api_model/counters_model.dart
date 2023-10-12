// To parse this JSON data, do
//
//     final countersModel = countersModelFromJson(jsonString);

import 'dart:convert';

CountersModel countersModelFromJson(String str) => CountersModel.fromJson(json.decode(str));

String countersModelToJson(CountersModel data) => json.encode(data.toJson());

class CountersModel {
  String message;
  Data data;

  CountersModel({
    required this.message,
    required this.data,
  });

  factory CountersModel.fromJson(Map<String, dynamic> json) => CountersModel(
    message: json["message"],

    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  int notifications;
  int messages;

  Data({
    required this.notifications,
    required this.messages,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    notifications: json["notifications"],
    messages: json["messages"],
  );

  Map<String, dynamic> toJson() => {
    "notifications": notifications,
    "messages": messages,
  };
}
