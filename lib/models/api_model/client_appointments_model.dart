// To parse this JSON data, do
//
//     final clientAppointmentsModel = clientAppointmentsModelFromJson(jsonString);

import 'dart:convert';

import 'package:mena/models/api_model/config_model.dart';

import 'home_section_model.dart';

AppointmentsModel clientAppointmentsModelFromJson(String str) => AppointmentsModel.fromJson(json.decode(str));

String clientAppointmentsModelToJson(AppointmentsModel data) => json.encode(data.toJson());

class AppointmentsModel {
  AppointmentsModel({
    required this.message,
    required this.data,
  });

  String message;
  Data data;

  factory AppointmentsModel.fromJson(Map<String, dynamic> json) => AppointmentsModel(
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
    required this.appointments,
  });

  int totalSize;
  int limit;
  int offset;
  List<AppointmentItemModel> appointments;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    totalSize: json["total_size"],
    limit: json["limit"],
    offset: json["offset"],
    appointments: List<AppointmentItemModel>.from(json["data"].map((x) => AppointmentItemModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total_size": totalSize,
    "limit": limit,
    "offset": offset,
    // "data": List<dynamic>.from(appointments.map((x) => x.toJson())),
  };
}

class AppointmentItemModel {
  AppointmentItemModel({
    required this.id,
    required this.forWho,
    required this.userId,
    required this.userData,
    required this.professionalId,
    required this.professionalData,
    required this.facilityId,
    required this.facilityData,
    required this.appointmentSlotId,
    required this.appointmentSlotData,
    required this.fullName,
    required this.birthdate,
    required this.idNumber,
    required this.mobileNumber,
    required this.email,
    required this.idFront,
    required this.idBack,
    required this.insuranceFront,
    required this.insuranceBack,
    this.comments,
    required this.paymentStatus,
    required this.state,
    required this.qr,
  });

  int id;
  String forWho;
  String userId;
  User? userData;
  String professionalId;
  User? professionalData;
  String facilityId;
  User? facilityData;
  String appointmentSlotId;
  AppointmentSlotData appointmentSlotData;
  String fullName;
  DateTime birthdate;
  String idNumber;
  String mobileNumber;
  String email;
  String idFront;
  String idBack;
  String insuranceFront;
  String insuranceBack;
  dynamic comments;
  String paymentStatus;
  String state;
  String qr;

  factory AppointmentItemModel.fromJson(Map<String, dynamic> json) => AppointmentItemModel(
    id: json["id"],
    forWho: json["for_who"],
    userId: json["user_id"],
    userData:json["user_data"]==null?null: User.fromJson(json["user_data"]),
    professionalId: json["professional_id"],
    professionalData:json["professional_data"]==null?null: User.fromJson(json["professional_data"]),
    facilityId: json["facility_id"],
    facilityData:json["facility_data"]==null?null: User.fromJson(json["facility_data"]),
    appointmentSlotId: json["appointment_slot_id"],
    appointmentSlotData: AppointmentSlotData.fromJson(json["appointment_slot_data"]),
    fullName: json["full_name"],
    birthdate: DateTime.parse(json["birthdate"]),
    idNumber: json["id_number"],
    mobileNumber: json["mobile_number"],
    email: json["email"],
    idFront: json["id_front"],
    idBack: json["id_back"],
    insuranceFront: json["insurance_front"],
    insuranceBack: json["insurance_back"],
    comments: json["comments"],
    paymentStatus: json["payment_status"],
    state: json["state"],
    qr: json["qr"],
  );

  // Map<String, dynamic> toJson() => {
  //   "id": id,
  //   "for_who": forWho,
  //   "user_id": userId,
  //   "user_data": userData.toJson(),
  //   "professional_id": professionalId,
  //   "professional_data": professionalData.toJson(),
  //   "facility_id": facilityId,
  //   "facility_data": facilityData.toJson(),
  //   "appointment_slot_id": appointmentSlotId,
  //   "appointment_slot_data": appointmentSlotData.toJson(),
  //   "full_name": fullName,
  //   "birthdate": "${birthdate.year.toString().padLeft(4, '0')}-${birthdate.month.toString().padLeft(2, '0')}-${birthdate.day.toString().padLeft(2, '0')}",
  //   "id_number": idNumber,
  //   "mobile_number": mobileNumber,
  //   "email": email,
  //   "id_front": idFront,
  //   "id_back": idBack,
  //   "insurance_front": insuranceFront,
  //   "insurance_back": insuranceBack,
  //   "comments": comments,
  //   "payment_status": paymentStatus,
  //   "state": state,
  //   "qr": qr,
  // };
}

class AppointmentSlotData {
  AppointmentSlotData({
    required this.id,
    required this.providerId,
    required this.appointmentTypeData,
    required this.appointmentType,
    required this.dateTime,
    required this.professionalData,
    required this.facilityData,
    required this.facilityId,
    required this.professionalId,
    required this.fees,
    required this.currency,
    required this.isFree,
    required this.type,
    required this.price,
  });

  int id;
  String providerId;
  AppointmentTypeData appointmentTypeData;
  String appointmentType;
  String? type;
  DateTime dateTime;
  User? professionalData;
  User? facilityData;
  String facilityId;
  String professionalId;
  String fees;
  String currency;
  bool isFree;
  String price;

  factory AppointmentSlotData.fromJson(Map<String, dynamic> json) => AppointmentSlotData(
    id: json["id"],
    providerId: json["provider_id"],
    appointmentTypeData: AppointmentTypeData.fromJson(json["appointment_type_data"]),
    appointmentType: json["appointment_type"],
    type: json["type"],
    dateTime: DateTime.parse(json["date_time"]),
    professionalData:json["professional_data"]==null?null: User.fromJson(json["professional_data"]),
    facilityData:json["facility_data"]==null?null: User.fromJson(json["facility_data"]),
    facilityId: json["facility_id"],
    professionalId: json["professional_id"],
    fees: json["fees"],
    currency: json["currency"],
    isFree: json["is_free"],
    price: json["price"],
  );
  //
  // Map<String, dynamic> toJson() => {
  //   "id": id,
  //   "provider_id": providerId,
  //   "appointment_type_data": appointmentTypeData.toJson(),
  //   "appointment_type": appointmentType,
  //   "date_time": dateTime.toIso8601String(),
  //   "professional_data": professionalData.toJson(),
  //   "facility_data": facilityData.toJson(),
  //   "facility_id": facilityId,
  //   "professional_id": professionalId,
  //   "fees": fees,
  //   "currency": currency,
  //   "is_free": isFree,
  //   "price": price,
  // };
}

class AppointmentTypeData {
  AppointmentTypeData({
    required this.id,
    required this.title,
    required this.type,
  });

  int id;
  String title;
  String type;

  factory AppointmentTypeData.fromJson(Map<String, dynamic> json) => AppointmentTypeData(
    id: json["id"],
    title: json["title"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "type": type,
  };
}

// class FacilityDataClass {
//   FacilityDataClass({
//     required this.id,
//     required this.personalPicture,
//     required this.fullName,
//     required this.userName,
//     required this.email,
//     this.phone,
//     this.phoneVerifiedAt,
//     this.emailVerifiedAt,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.roleId,
//     required this.roleName,
//     this.recoveryEmail,
//     this.website,
//     this.fax,
//     this.whatsapp,
//     this.instagram,
//     this.facebook,
//     this.tiktok,
//     this.youtube,
//     this.linkedin,
//     this.providerTypeFields,
//     this.address,
//     required this.qualificationCertificate,
//     required this.professionalLicense,
//     this.abbreviation,
//     this.expertise,
//     this.summary,
//     this.subscription,
//     this.registrationNumber,
//     required this.lat,
//     required this.lng,
//     required this.likes,
//     required this.followers,
//     required this.reviewsRate,
//     required this.reviewsCount,
//     required this.isFollowing,
//     required this.distance,
//     required this.verified,
//     required this.platform,
//     required this.category,
//     required this.specialitiesGroup,
//     required this.specialities,
//     required this.features,
//   });
//
//   int id;
//   String personalPicture;
//   String fullName;
//   String userName;
//   String email;
//   String? phone;
//   DateTime? phoneVerifiedAt;
//   dynamic emailVerifiedAt;
//   DateTime createdAt;
//   DateTime updatedAt;
//   int roleId;
//   String roleName;
//   dynamic recoveryEmail;
//   dynamic website;
//   dynamic fax;
//   dynamic whatsapp;
//   dynamic instagram;
//   dynamic facebook;
//   dynamic tiktok;
//   dynamic youtube;
//   dynamic linkedin;
//   dynamic providerTypeFields;
//   dynamic address;
//   String qualificationCertificate;
//   String professionalLicense;
//   Abbreviation? abbreviation;
//   dynamic expertise;
//   String? summary;
//   dynamic subscription;
//   String? registrationNumber;
//   String lat;
//   String lng;
//   int likes;
//   int followers;
//   int reviewsRate;
//   int reviewsCount;
//   bool isFollowing;
//   String distance;
//   int verified;
//   MenaPlatform platform;
//   List<MenaCategory> category;
//   List<MenaCategory> specialitiesGroup;
//   List<MenaCategory> specialities;
//   List<dynamic> features;
//
//   factory FacilityDataClass.fromJson(Map<String, dynamic> json) => FacilityDataClass(
//     id: json["id"],
//     personalPicture: json["personal_picture"],
//     fullName: json["full_name"],
//     userName: json["user_name"],
//     email: json["email"],
//     phone: json["phone"],
//     phoneVerifiedAt: json["phone_verified_at"] == null ? null : DateTime.parse(json["phone_verified_at"]),
//     emailVerifiedAt: json["email_verified_at"],
//     createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),
//     roleId: json["role_id"],
//     roleName:json["role_name"],
//     recoveryEmail: json["recovery_email"],
//     website: json["website"],
//     fax: json["fax"],
//     whatsapp: json["whatsapp"],
//     instagram: json["instagram"],
//     facebook: json["facebook"],
//     tiktok: json["tiktok"],
//     youtube: json["youtube"],
//     linkedin: json["linkedin"],
//     providerTypeFields: json["provider_type_fields"],
//     address: json["address"],
//     qualificationCertificate: json["qualification_certificate"],
//     professionalLicense: json["professional_license"],
//     abbreviation: json["abbreviation"] == null ? null : Abbreviation.fromJson(json["abbreviation"]),
//     expertise: json["expertise"],
//     summary: json["summary"],
//     subscription: json["subscription"],
//     registrationNumber: json["registration_number"],
//     lat: json["lat"],
//     lng: json["lng"],
//     likes: json["likes"],
//     followers: json["followers"],
//     reviewsRate: json["reviews_rate"],
//     reviewsCount: json["reviews_count"],
//     isFollowing: json["is_following"],
//     distance: json["distance"],
//     verified: json["verified"],
//     platform: MenaPlatform.fromJson(json["platform"]),
//     category: List<MenaCategory>.from(json["category"].map((x) => MenaCategory.fromJson(x))),
//     specialitiesGroup: List<MenaCategory>.from(json["specialities_group"].map((x) => MenaCategory.fromJson(x))),
//     specialities: List<MenaCategory>.from(json["specialities"].map((x) => MenaCategory.fromJson(x))),
//     features: List<dynamic>.from(json["features"].map((x) => x)),
//   );
//
//   // Map<String, dynamic> toJson() => {
//   //   "id": id,
//   //   "personal_picture": personalPicture,
//   //   "full_name": fullNameValues.reverse[fullName],
//   //   "user_name": userNameValues.reverse[userName],
//   //   "email": emailValues.reverse[email],
//   //   "phone": phone,
//   //   "phone_verified_at": phoneVerifiedAt?.toIso8601String(),
//   //   "email_verified_at": emailVerifiedAt,
//   //   "created_at": createdAt.toIso8601String(),
//   //   "updated_at": updatedAt.toIso8601String(),
//   //   "role_id": roleId,
//   //   "role_name": roleNameValues.reverse[roleName],
//   //   "recovery_email": recoveryEmail,
//   //   "website": website,
//   //   "fax": fax,
//   //   "whatsapp": whatsapp,
//   //   "instagram": instagram,
//   //   "facebook": facebook,
//   //   "tiktok": tiktok,
//   //   "youtube": youtube,
//   //   "linkedin": linkedin,
//   //   "provider_type_fields": providerTypeFields,
//   //   "address": address,
//   //   "qualification_certificate": qualificationCertificate,
//   //   "professional_license": professionalLicense,
//   //   "abbreviation": abbreviation?.toJson(),
//   //   "expertise": expertise,
//   //   "summary": summary,
//   //   "subscription": subscription,
//   //   "registration_number": registrationNumber,
//   //   "lat": lat,
//   //   "lng": lng,
//   //   "likes": likes,
//   //   "followers": followers,
//   //   "reviews_rate": reviewsRate,
//   //   "reviews_count": reviewsCount,
//   //   "is_following": isFollowing,
//   //   "distance": distanceValues.reverse[distance],
//   //   "verified": verified,
//   //   "platform": platform.toJson(),
//   //   "category": List<dynamic>.from(category.map((x) => x.toJson())),
//   //   "specialities_group": List<dynamic>.from(specialitiesGroup.map((x) => x.toJson())),
//   //   "specialities": List<dynamic>.from(specialities.map((x) => x.toJson())),
//   //   "features": List<dynamic>.from(features.map((x) => x)),
//   // };
// }

// class Abbreviation {
//   Abbreviation({
//     required this.id,
//     required this.name,
//     required this.platformId,
//   });
//
//   int id;
//   AbbreviationName name;
//   String platformId;
//
//   factory Abbreviation.fromJson(Map<String, dynamic> json) => Abbreviation(
//     id: json["id"],
//     name: abbreviationNameValues.map[json["name"]]!,
//     platformId: json["platform_id"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": abbreviationNameValues.reverse[name],
//     "platform_id": platformId,
//   };
// }
//
// enum AbbreviationName { DR }
//
// final abbreviationNameValues = EnumValues({
//   "Dr.": AbbreviationName.DR
// });

// class Category {
//   Category({
//     required this.id,
//     required this.filterId,
//     this.image,
//     required this.name,
//     required this.ranking,
//     required this.design,
//     this.childs,
//   });
//
//   int id;
//   String filterId;
//   String? image;
//   String name;
//   String ranking;
//   String design;
//   dynamic childs;
//
//   factory Category.fromJson(Map<String, dynamic> json) => Category(
//     id: json["id"],
//     filterId: filterIdValues.map[json["filter_id"]]!,
//     image: json["image"],
//     name: categoryNameValues.map[json["name"]]!,
//     ranking: json["ranking"],
//     design: designValues.map[json["design"]]!,
//     childs: json["childs"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "filter_id": filterIdValues.reverse[filterId],
//     "image": image,
//     "name": categoryNameValues.reverse[name],
//     "ranking": ranking,
//     "design": designValues.reverse[design],
//     "childs": childs,
//   };
// }

// enum Design { FILTER }
//
// final designValues = EnumValues({
//   "filter": Design.FILTER
// });

// enum FilterId { CAT_92, CAT_SUB_SUB_152, CAT_SUB_92, CAT_42, CAT_SUB_SUB_25, CAT_SUB_42 }

// final filterIdValues = EnumValues({
//   "cat_42": FilterId.CAT_42,
//   "cat_92": FilterId.CAT_92,
//   "cat_sub_42": FilterId.CAT_SUB_42,
//   "cat_sub_92": FilterId.CAT_SUB_92,
//   "cat_sub_sub_152": FilterId.CAT_SUB_SUB_152,
//   "cat_sub_sub_25": FilterId.CAT_SUB_SUB_25
// });

// enum CategoryName { HOSPITALS, ONE_DAY_SURGERY_HOSPITALS, PLASTIC_SURGERY, SPECIALIST_PLASTIC_SURGEON }
//
// final categoryNameValues = EnumValues({
//   "Hospitals": CategoryName.HOSPITALS,
//   "One day surgery hospitals ": CategoryName.ONE_DAY_SURGERY_HOSPITALS,
//   " Plastic Surgery": CategoryName.PLASTIC_SURGERY,
//   "Specialist Plastic Surgeon": CategoryName.SPECIALIST_PLASTIC_SURGEON
// });
//
// enum Distance { THE_1110541_KM, THE_1299431_KM, THE_1300662_KM }
//
// final distanceValues = EnumValues({
//   "11105.41 km": Distance.THE_1110541_KM,
//   "12994.31 km": Distance.THE_1299431_KM,
//   "13006.62 km": Distance.THE_1300662_KM
// });
//
// enum Email { HEART_PROVIDER_COM, NIMER_PROVIDER_COM, GHADEER_MAYYA2_HOTMAIL_COM }
// //
// // final emailValues = EnumValues({
// //   "ghadeer.mayya2@hotmail.com": Email.GHADEER_MAYYA2_HOTMAIL_COM,
// //   "heart@provider.com": Email.HEART_PROVIDER_COM,
// //   "nimer@provider.com": Email.NIMER_PROVIDER_COM
// // });
// //
// // enum FullName { HEART_HOSPITAL, NIMER_TAYSEER_NIMER_AL_KHATIB, GHADEER_MAYYA }
// //
// // final fullNameValues = EnumValues({
// //   "Ghadeer Mayya": FullName.GHADEER_MAYYA,
// //   "Heart hospital ": FullName.HEART_HOSPITAL,
// //   "Nimer Tayseer Nimer ALKhatib": FullName.NIMER_TAYSEER_NIMER_AL_KHATIB
// // });
// //
// // class Platform {
// //   Platform({
// //     required this.id,
// //     required this.name,
// //     required this.ranking,
// //     required this.video,
// //   });
//
//   int id;
//   PlatformName name;
//   String ranking;
//   String video;
//
//   factory Platform.fromJson(Map<String, dynamic> json) => Platform(
//     id: json["id"],
//     name: platformNameValues.map[json["name"]]!,
//     ranking: json["ranking"],
//     video: json["video"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": platformNameValues.reverse[name],
//     "ranking": ranking,
//     "video": video,
//   };
// }
//
// enum PlatformName { MEDICAL_CARE }
//
// final platformNameValues = EnumValues({
//   "Medical care": PlatformName.MEDICAL_CARE
// });
//
// enum RoleName { PROVIDER }
//
// final roleNameValues = EnumValues({
//   "provider": RoleName.PROVIDER
// });
//
// enum UserName { RASHEDDXB20, RASHEDDXB1, MAYYAGHADEER5 }
//
// final userNameValues = EnumValues({
//   "mayyaghadeer5": UserName.MAYYAGHADEER5,
//   "rasheddxb1": UserName.RASHEDDXB1,
//   "rasheddxb20": UserName.RASHEDDXB20
// });

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
