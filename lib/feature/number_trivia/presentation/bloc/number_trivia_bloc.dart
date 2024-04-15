import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:number_trivia/core/error/failure.dart';
import 'package:number_trivia/core/usercases/usecase.dart';
import 'package:number_trivia/core/utils/input_convertor.dart';
import 'package:number_trivia/feature/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/feature/number_trivia/domain/usecases/get_concreate_number_trivia.dart';
import 'package:number_trivia/feature/number_trivia/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid input - the number must be a positive integer';
String SERVER_FAILURE = 'Server Failure';
String CACHE_FAILURE = 'Cache Failure';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final InputConvertor inputConvertor;
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;

  NumberTriviaBloc({
    required this.inputConvertor,
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
  }) : super(Empty()) {
    on<GetNumberTriviaForConcreteNumber>((event, emit) async {
      Completer completer = Completer();
      final inputEither =
          inputConvertor.stringToUnsignedInteger(event.numberString);

      inputEither.fold((failure) {
        emit(Error(message: INVALID_INPUT_FAILURE_MESSAGE));
      }, (number) async {
        print('emit loading');
        emit(Loading());
        final numberTriviaEither =
            await getConcreteNumberTrivia(params: Params(number: number));
        numberTriviaEither.fold((failure) {
          print('emit error');
          emit(Error(message: _mapFailureToMessage(failure)));
          completer.complete();
        }, (numberTrivia) {
          print('emit loaded');
          emit(Loaded(numberTrivia: numberTrivia));
          completer.complete();
        });
      });

      await completer.future;
      print('final on<GetNumberTriviaForConcreteNumber> call');
    });

    on<GetNumberTriviaForRandomNumber>((event, emit) async {
      emit(Loading());
      final numberTriviaEither =
          await getRandomNumberTrivia(params: NoParams());
      numberTriviaEither.fold((failure) {
        emit(Error(message: _mapFailureToMessage(failure)));
      }, (numberTrivia) {
        emit(Loaded(numberTrivia: numberTrivia));
      });
    });
  }

  String _mapFailureToMessage(Failure failure) {
    return switch (failure) {
      ServerFailure() => SERVER_FAILURE,
      CacheFailure() => CACHE_FAILURE,
      _ => 'Unexpected Error'
    };
  }
}
