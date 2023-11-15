// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class HealthcareCategory extends Equatable {
  final int id;
  final String image;
  final String name;
  final List<HealthcareSubCategory> childs;
  HealthcareCategory({
    required this.id,
    required this.image,
    required this.name,
    required this.childs,
  });

  @override
  List<Object> get props => [id, image, name, childs];
}

class HealthcareSubCategory extends Equatable {
  final int id;
  final String image;
  final String name;
  final List<HealthcareSubSubCategory> childs;
  HealthcareSubCategory({
    required this.id,
    required this.image,
    required this.name,
    required this.childs,
  });

  @override
  List<Object> get props => [id, image, name, childs];
}

class HealthcareSubSubCategory extends Equatable {
  final int id;
  final String image;
  final String name;
  HealthcareSubSubCategory({
    required this.id,
    required this.image,
    required this.name,
  });

  @override
  List<Object> get props => [id, image, name];
}
