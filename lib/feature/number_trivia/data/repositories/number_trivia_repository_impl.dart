import 'package:dartz/dartz.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/number_trivia_local_data_source.dart';
import '../datasources/number_trivia_remote_data_source.dart';
import '../models/number_trivia_model.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/repositories/number_trivia_repository.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NetworkInfo networkInfo;
  final NumberTriviaRemoteDataSource numberTriviaRemoteDataSource;
  final NumberTriviaLocalDataSource numberTriviaLocalDataSource;

  NumberTriviaRepositoryImpl({
    required this.networkInfo,
    required this.numberTriviaRemoteDataSource,
    required this.numberTriviaLocalDataSource,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreateNumberTrivia(
    int number,
  ) async {
    return await _getNumberTrivia(
      () => numberTriviaRemoteDataSource.getConcreateNumberTrivia(number),
    );
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getNumberTrivia(
      numberTriviaRemoteDataSource.getRandomNumberTrivia,
    );
  }

  Future<Either<Failure, NumberTrivia>> _getNumberTrivia(
      Future<NumberTriviaModel> Function() _getConcreateOrRandom) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await _getConcreateOrRandom();
        await numberTriviaLocalDataSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } catch (e) {
        print(e);
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia =
            await numberTriviaLocalDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } catch (e) {
        return Left(CacheFailure());
      }
    }
  }
}
