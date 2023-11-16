import 'package:dartz/dartz.dart';

import '../../../../Market Core/error/failures.dart';
import '../entities/healthcare_category.dart';

abstract class HealthcareRepository {
  Future<Either<Failure, List<HealthcareCategory>>> getHealthcareCategories(Map<String, dynamic>? catData);
}
