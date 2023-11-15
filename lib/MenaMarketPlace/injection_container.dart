import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:mena/MenaMarketPlace/Market%20Core/Api/dio_interceptor.dart';
import 'package:mena/MenaMarketPlace/features/healthcare/presentation/cubit/healthcare_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Market Core/Api/api_consumer.dart';
import 'Market Core/Api/dio_consumer.dart';
import 'Market Core/network/network_info.dart';
import 'features/healthcare/data/datasources/healthcare_remote_datasource.dart';
import 'features/healthcare/data/repositories/healthcare_repository_imp.dart';
import 'features/healthcare/domain/repositories/healthcare_repository.dart';
import 'features/healthcare/domain/usecases/get_healthcare_categories_usecase.dart';


final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(() => HealthcareCubit(
      getHealthcareCategoriesUsecase: sl()));
 

  // Use cases
  sl.registerLazySingleton(() => GetHealthcareCategoriesUsecase(healthcareRepository: sl()));
 

  // Repository
  sl.registerLazySingleton<HealthcareRepository>(
    () => HealthcareRepositoryImp(
      networkInfo: sl(),
      healthcareRemoteDatasource: sl(),
    ),
  );
 

  // Data sources

  sl.registerLazySingleton<HealthcareRemoteDatasource>(
    () => HealthcareRemoteDatasourceImp(apiConsumer: sl()),
  );

  

  //! Core

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(client: sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => AppInterceptors());
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => Connectivity());
}
