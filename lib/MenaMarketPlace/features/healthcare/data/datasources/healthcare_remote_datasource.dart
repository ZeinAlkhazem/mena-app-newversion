// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:mena/MenaMarketPlace/Market%20Core/Api/api_consumer.dart';

import '../../../../Market Core/Api/end_points.dart';
import '../models/healthcare_category_model.dart';

abstract class HealthcareRemoteDatasource {
  Future<List<HealthcareCategoryModel>> getHealthcareCategories(
      Map<String, dynamic>? catData);
}

class HealthcareRemoteDatasourceImp implements HealthcareRemoteDatasource {
  final ApiConsumer apiConsumer;
  HealthcareRemoteDatasourceImp({
    required this.apiConsumer,
  });

  @override
  Future<List<HealthcareCategoryModel>> getHealthcareCategories(
      Map<String, dynamic>? catData) async {
    var res = await apiConsumer.get(EndPoints.healthcareCategories,
        queryParameter: catData);
    return List<HealthcareCategoryModel>.from(
        (res['data'] as List).map((e) => HealthcareCategoryModel.fromJson(e)));
  }
}
