// To parse this JSON data, do
//
//     final slotsModel = slotsModelFromJson(jsonString);

import 'dart:convert';

SlotsModel slotsModelFromJson(String str) => SlotsModel.fromJson(json.decode(str));

String slotsModelToJson(SlotsModel data) => json.encode(data.toJson());

class SlotsModel {
  SlotsModel({
    required this.message,
    required this.allDatesAndSlots,
  });

  String message;
  Map<String, List<Slot>>? allDatesAndSlots;

  factory SlotsModel.fromJson(Map<String, dynamic> json) => SlotsModel(
        message: json["message"],
        allDatesAndSlots: json["data"] == null
            ? null
            : Map.from(json["data"]).map((k, v) => MapEntry<String, List<Slot>>(
                k, List<Slot>.from(v.map((x) => Slot.fromJson(x))))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        // "data": Map.from(allDatesAndSlots).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x.toJson())))),
      };
}

class Slot {
  Slot({
    required this.id,
    required this.dateTime,
    required this.fees,
  });

  int id;
  DateTime dateTime;
  String? fees;

  factory Slot.fromJson(Map<String, dynamic> json) => Slot(
        id: json["slot_id"],
        fees: json["fees"].toString(),
        dateTime: DateTime.parse(json["time"]),
      );

  Map<String, dynamic> toJson() => {
        "slot_id": id,
        "time": dateTime.toIso8601String(),
      };
}
