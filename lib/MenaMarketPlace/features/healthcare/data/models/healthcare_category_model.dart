import 'package:mena/MenaMarketPlace/features/healthcare/domain/entities/healthcare_category.dart';

class HealthcareCategoryModel extends HealthcareCategory {
  HealthcareCategoryModel(
      {required super.id,
      required super.image,
      required super.name,
      required super.childs});
  factory HealthcareCategoryModel.fromJson(Map<String, dynamic> json) {
    return HealthcareCategoryModel(
        id: json['id'],
        image: json['image'],
        name: json['name'],
        childs: List<HealthcareSubCategoryModel>.from((json['childs'] as List)
            .map((e) => HealthcareSubCategoryModel.fromJson(e))));
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'image': image, 'name': name, 'childs': childs};
  }
}

class HealthcareSubCategoryModel extends HealthcareSubCategory {
  HealthcareSubCategoryModel(
      {required super.id,
      required super.image,
      required super.name,
      required super.childs});
  factory HealthcareSubCategoryModel.fromJson(Map<String, dynamic> json) {
    return HealthcareSubCategoryModel(
        id: json['id'],
        image: json['image'],
        name: json['name'],
        childs: List<HealthcareSubSubCategoryModel>.from(
            (json['childs'] as List)
                .map((e) => HealthcareSubSubCategoryModel.fromJson(e))));
  }
  Map<String, dynamic> toJson() {
    return {'id': id, 'image': image, 'name': name, 'childs': childs};
  }
}

class HealthcareSubSubCategoryModel extends HealthcareSubSubCategory {
  HealthcareSubSubCategoryModel(
      {required super.id, required super.image, required super.name});
  factory HealthcareSubSubCategoryModel.fromJson(Map<String, dynamic> json) {
    return HealthcareSubSubCategoryModel(
      id: json['id'],
      image: json['image'],
      name: json['name'],
    );
  }
  Map<String, dynamic> toJson() {
    return {'id': id, 'image': image, 'name': name};
  }
}
