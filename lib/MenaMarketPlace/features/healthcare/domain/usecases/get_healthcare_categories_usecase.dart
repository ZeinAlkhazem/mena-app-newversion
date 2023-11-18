import 'package:dartz/dartz.dart';
import 'package:mena/MenaMarketPlace/Market%20Core/error/failures.dart';
import 'package:mena/MenaMarketPlace/features/healthcare/domain/entities/healthcare_category.dart';
import 'package:mena/MenaMarketPlace/features/healthcare/domain/repositories/healthcare_repository.dart';

import '../../../../Market Core/usecases/usecase.dart';

class GetHealthcareCategoriesUsecase
    implements UseCase<List<HealthcareCategory>, Map<String, dynamic>?> {
  final HealthcareRepository healthcareRepository;

  GetHealthcareCategoriesUsecase({
    required this.healthcareRepository
  });

  @override
  Future<Either<Failure, List<HealthcareCategory>>> call(
      Map<String, dynamic>? params) async {
    return await healthcareRepository.getHealthcareCategories(params);
  }
}
