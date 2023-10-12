// To parse this JSON data, do
//
//     final mySlotsModel = mySlotsModelFromJson(jsonString);

import 'dart:convert';

import 'client_appointments_model.dart';
import 'home_section_model.dart';

MySlotsModel mySlotsModelFromJson(String str) => MySlotsModel.fromJson(json.decode(str));

String mySlotsModelToJson(MySlotsModel data) => json.encode(data.toJson());

class MySlotsModel {
  MySlotsModel({
    required this.message,
    required this.data,
  });

  String message;
  Data data;

  factory MySlotsModel.fromJson(Map<String, dynamic> json) => MySlotsModel(
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
    required this.slots,
  });

  int totalSize;
  int limit;
  int offset;
  List<MySLot> slots;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        totalSize: json["total_size"],
        limit: json["limit"],
        offset: json["offset"],
        slots: List<MySLot>.from(json["data"].map((x) => MySLot.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_size": totalSize,
        "limit": limit,
        "offset": offset,
        "data": List<dynamic>.from(slots.map((x) => x.toJson())),
      };
}

class MySLot {
  MySLot({
    required this.id,
    required this.providerId,
    required this.appointmentTypeData,
    required this.appointmentType,
    required this.dateTime,
    required this.days,
    required this.professionalData,
    required this.facilityData,
    required this.facilityId,
    required this.professionalId,
    required this.fees,
    required this.type,
    required this.currency,
    required this.isFree,
    required this.price,
    required this.times,
  });

  int id;
  String providerId;
  AppointmentTypeData appointmentTypeData;
  String appointmentType;
  String? type;
  DateTime dateTime;
  List<String>? days;
  User? professionalData;
  User? facilityData;
  String? facilityId;
  String? professionalId;
  String fees;
  String? currency;
  bool isFree;
  String price;
  List<Time> times;

  factory MySLot.fromJson(Map<String, dynamic> json) => MySLot(
        id: json["id"],
        providerId: json["provider_id"],
        type: json["type"],
        days: List<String>.from(json["days"].map((x) => x)),
        appointmentTypeData: AppointmentTypeData.fromJson(json["appointment_type_data"]),
        appointmentType: json["appointment_type"],
        dateTime: DateTime.parse(json["date_time"]),
        professionalData: json["professional_data"] == null
            ? null
            : User.fromJson(json["professional_data"]),
        facilityData:
            json["facility_data"] == null ? null : User.fromJson(json["facility_data"]),
        facilityId: json["facility_id"],
        professionalId: json["professional_id"],
        fees: json["fees"],
        currency: json["currency"],
        isFree: json["is_free"],
        price: json["price"],
        times: List<Time>.from(json["times"].map((x) => Time.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "provider_id": providerId,
        "appointment_type_data": appointmentTypeData.toJson(),
        "appointment_type": appointmentType,
        "date_time": dateTime.toIso8601String(),
        // "professional_data": professionalData.toJson(),
        // "facility_data": facilityData.toJson(),
        "facility_id": facilityId,
        "professional_id": professionalId,
        "fees": fees,
        "currency": currency,
        "is_free": isFree,
        "price": price,
      };
}

class Time {
  Time({
    required this.id,
    required this.fromTime,
    required this.toTime,
  });

  int id;
  String fromTime;
  String toTime;

  factory Time.fromJson(Map<String, dynamic> json) => Time(
        id: json["id"],
        fromTime: json["from_time"],
        toTime: json["to_time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "from_time": fromTime,
        "to_time": toTime,
      };
}
