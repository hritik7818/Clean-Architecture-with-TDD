import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usercases/usecase.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  const GetRandomNumberTrivia({required this.numberTriviaRepository});
  final NumberTriviaRepository numberTriviaRepository;

  @override
  Future<Either<Failure, NumberTrivia>> call({required NoParams params}) async {
    return await numberTriviaRepository.getRandomNumberTrivia();
  }
}
