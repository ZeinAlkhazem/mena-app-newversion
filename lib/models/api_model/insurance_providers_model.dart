// To parse this JSON data, do
//
//     final insuranceProvidersModel = insuranceProvidersModelFromJson(jsonString);

import 'dart:convert';

InsuranceProvidersModel insuranceProvidersModelFromJson(String str) => InsuranceProvidersModel.fromJson(json.decode(str));

String insuranceProvidersModelToJson(InsuranceProvidersModel data) => json.encode(data.toJson());

class InsuranceProvidersModel {
  InsuranceProvidersModel({
    required this.message,
    required this.insuranceProvidersList,
  });

  String message;
  List<InsuranceProvider> insuranceProvidersList;

  factory InsuranceProvidersModel.fromJson(Map<String, dynamic> json) => InsuranceProvidersModel(
    message: json["message"],
    insuranceProvidersList: List<InsuranceProvider>.from(json["data"].map((x) => InsuranceProvider.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": List<dynamic>.from(insuranceProvidersList.map((x) => x.toJson())),
  };
}

class InsuranceProvider {
  InsuranceProvider({
    required this.id,
    required this.name,
    required this.logo,
  });

  int id;
  String name;
  String logo;

  factory InsuranceProvider.fromJson(Map<String, dynamic> json) => InsuranceProvider(
    id: json["id"],
    name: json["name"],
    logo: json["logo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "logo": logo,
  };
}
