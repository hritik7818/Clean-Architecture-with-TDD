import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'core/utils/input_convertor.dart';
import 'feature/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'feature/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'feature/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'feature/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'feature/number_trivia/domain/usecases/get_concreate_number_trivia.dart';
import 'feature/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'feature/number_trivia/presentation/bloc/number_trivia_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Feature
  //bloc
  sl.registerFactory(
    () => NumberTriviaBloc(
      inputConvertor: sl(),
      getConcreteNumberTrivia: sl(),
      getRandomNumberTrivia: sl(),
    ),
  );

  // use cases
  sl.registerLazySingleton(
    () => GetConcreteNumberTrivia(
      numberTriviaRepository: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetRandomNumberTrivia(
      numberTriviaRepository: sl(),
    ),
  );

  //repository
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      networkInfo: sl(),
      numberTriviaLocalDataSource: sl(),
      numberTriviaRemoteDataSource: sl(),
    ),
  );

  //data sources
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(
      client: sl(),
    ),
  );

  //! Core
  sl.registerLazySingleton(() => InputConvertor());
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      internetConnection: sl(),
    ),
  );

  //! External
  final sharedPreference = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreference);
  sl.registerLazySingleton(() => http.Client());
  // sl.registerLazySingleton(() => InternetConnectionChecker.createInstance ());

  sl.registerLazySingleton(() => InternetConnection());
}
