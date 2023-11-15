// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:mena/MenaMarketPlace/Market%20Core/error/failures.dart';
import 'package:mena/MenaMarketPlace/features/healthcare/data/datasources/healthcare_remote_datasource.dart';
import 'package:mena/MenaMarketPlace/features/healthcare/domain/entities/healthcare_category.dart';

import '../../../../Market Core/error/map_exception_to_failure.dart';
import '../../../../Market Core/network/network_info.dart';
import '../../domain/repositories/healthcare_repository.dart';

class HealthcareRepositoryImp implements HealthcareRepository {
  final HealthcareRemoteDatasource healthcareRemoteDatasource;
  final NetworkInfo networkInfo;
  HealthcareRepositoryImp({
    required this.healthcareRemoteDatasource,
    required this.networkInfo,
  });
  @override
  Future<Either<Failure, List<HealthcareCategory>>> getHealthcareCategories(
      Map<String, dynamic>? catData) async {
    if (await networkInfo.isConnected) {
      log("=========== Internet=========");
      try {
        final data =
            await healthcareRemoteDatasource.getHealthcareCategories(catData);

        return Right(data);
      } on Exception catch (e) {
        return left(mapExceptionToFailure(e));
      }
    } else {
      log("===========No Internet=========");
      return Left(NoInternetFailure());
    }
  }
}
