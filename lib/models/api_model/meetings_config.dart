// To parse this JSON data, do
//
//     final meetingsConfigModel = meetingsConfigModelFromJson(jsonString);

import 'dart:convert';

MeetingsConfigModel meetingsConfigModelFromJson(String str) => MeetingsConfigModel.fromJson(json.decode(str));

String meetingsConfigModelToJson(MeetingsConfigModel data) => json.encode(data.toJson());

class MeetingsConfigModel {
  String message;
  Data data;

  MeetingsConfigModel({
    required this.message,
    required this.data,
  });

  factory MeetingsConfigModel.fromJson(Map<String, dynamic> json) => MeetingsConfigModel(
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  List<Repeat> repeat;
  List<Repeat> timeZones;
  List<MeetingType> meetingTypes;
  List<MeetingType> participantsTypes;

  Data({
    required this.repeat,
    required this.timeZones,
    required this.meetingTypes,
    required this.participantsTypes,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    repeat: List<Repeat>.from(json["repeat"].map((x) => Repeat.fromJson(x))),
    timeZones: List<Repeat>.from(json["time_zones"].map((x) => Repeat.fromJson(x))),
    meetingTypes: List<MeetingType>.from(json["meeting_types"].map((x) => MeetingType.fromJson(x))),
    participantsTypes: List<MeetingType>.from(json["participants_types"].map((x) => MeetingType.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "repeat": List<dynamic>.from(repeat.map((x) => x.toJson())),
    "time_zones": List<dynamic>.from(timeZones.map((x) => x.toJson())),
    "meeting_types": List<dynamic>.from(meetingTypes.map((x) => x.toJson())),
    "participants_types": List<dynamic>.from(participantsTypes.map((x) => x.toJson())),
  };
}

class MeetingType {
  int id;
  String title;

  MeetingType({
    required this.id,
    required this.title,
  });

  factory MeetingType.fromJson(Map<String, dynamic> json) => MeetingType(
    id: json["id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
  };
}

class Repeat {
  String id;
  String title;

  Repeat({
    required this.id,
    required this.title,
  });

  factory Repeat.fromJson(Map<String, dynamic> json) => Repeat(
    id: json["id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
  };
}
