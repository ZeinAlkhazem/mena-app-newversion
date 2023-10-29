class CreateUserModel {
  String? fullName;
  String? userName;
  String? email;
  String? phone;
  String? password;
  int? platformId;
  List<int>? specialitList;
  String? dateOfBirth;
  int? countryId;

  CreateUserModel({
     this.fullName,
     this.userName,
     this.email,
     this.phone,
     this.password,
     this.platformId,
     this.specialitList,
     this.dateOfBirth,
     this.countryId,
  });
}
