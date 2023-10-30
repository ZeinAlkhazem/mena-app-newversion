class UserTypeInfoModel {
  int? id;
  String? title;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserTypeInfoModel({
     this.id,
     this.title,
     this.description,
     this.createdAt,
     this.updatedAt,
  });

  factory UserTypeInfoModel.fromJson(Map<String, dynamic> json) {
    return UserTypeInfoModel(
        id: json.containsKey("id") ? json['id'] : null,
        title: json.containsKey("title") ? json['title'] : null,
        description: json.containsKey("description") ? json['description'] : null,
        createdAt: json.containsKey("created_at")
            ? DateTime.tryParse(json['created_at'])
            : null,
        updatedAt: json.containsKey("updated_at")
            ? DateTime.tryParse(json['updated_at'])
            : null);
  }
}
