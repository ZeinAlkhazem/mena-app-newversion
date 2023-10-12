// To parse this JSON data, do
//
//     final plansModel = plansModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

PlansModel plansModelFromJson(String str) => PlansModel.fromJson(json.decode(str));

String plansModelToJson(PlansModel data) => json.encode(data.toJson());

class PlansModel {
  PlansModel({
    required this.message,
    required this.data,
  });

  String message;
  List<PlanItemModel> data;

  factory PlansModel.fromJson(Map<String, dynamic> json) => PlansModel(
    message: json["message"],
    data: List<PlanItemModel>.from(json["data"].map((x) => PlanItemModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class PlanItemModel {
  PlanItemModel({
    required this.id,
    required this.name,
    required this.providerType,
    required this.features,
    required this.monthlyFee,
    required this.yearlyFee,
  });

  int id;
  String name;
  ProviderType providerType;
  List<ProviderType> features;
  String monthlyFee;
  String yearlyFee;

  factory PlanItemModel.fromJson(Map<String, dynamic> json) => PlanItemModel(
    id: json["id"],
    name: json["name"],
    providerType: ProviderType.fromJson(json["provider_type"]),
    features: List<ProviderType>.from(json["features"].map((x) => ProviderType.fromJson(x))),
    monthlyFee: json["monthly_fee"],
    yearlyFee: json["yearly_fee"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "provider_type": providerType.toJson(),
    "features": List<dynamic>.from(features.map((x) => x.toJson())),
    "monthly_fee": monthlyFee,
    "yearly_fee": yearlyFee,
  };
}

class ProviderType {
  ProviderType({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory ProviderType.fromJson(Map<String, dynamic> json) => ProviderType(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
