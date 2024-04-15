import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/error/failure.dart';
import 'package:number_trivia/core/usercases/usecase.dart';
import 'package:number_trivia/core/utils/input_convertor.dart';
import 'package:number_trivia/feature/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/feature/number_trivia/domain/usecases/get_concreate_number_trivia.dart';
import 'package:number_trivia/feature/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia/feature/number_trivia/presentation/bloc/number_trivia_bloc.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([
  InputConvertor,
  GetRandomNumberTrivia,
  GetConcreteNumberTrivia,
])
void main() {
  late NumberTriviaBloc bloc;
  late MockInputConvertor mockInputConvertor;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  setUp(() {
    mockInputConvertor = MockInputConvertor();
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    bloc = NumberTriviaBloc(
      inputConvertor: mockInputConvertor,
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
    );
  });
  test('initial state should be [Empty]', () async {
    // assert
    expect(bloc.state, equals(Empty()));
  });
  group('GetConcreateNumberTrivia', () {
    int tNumber = 1;
    String tNumberString = tNumber.toString();
    NumberTrivia numberTrivia =
        NumberTrivia(text: 'test text', number: tNumber);

    blocTest(
      'should call input convertor to validate and convert the string to unsigned integer',
      build: () {
        when(mockInputConvertor.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));
        return bloc;
      },
      act: (bloc) => bloc
          .add(GetNumberTriviaForConcreteNumber(numberString: tNumberString)),
      verify: (bloc) =>
          verify(mockInputConvertor.stringToUnsignedInteger(tNumberString)),
    );

    blocTest(
      'should emit [Error]  when input is invalid',
      build: () {
        when(mockInputConvertor.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));
        return bloc;
      },
      act: (bloc) => bloc
          .add(GetNumberTriviaForConcreteNumber(numberString: tNumberString)),
      wait: Duration(seconds: 1),
      expect: () => [
        Error(
          message: INVALID_INPUT_FAILURE_MESSAGE,
        ),
      ],
    );

    blocTest(
      'should call getConcreteNumber trivia usecase',
      build: () {
        when(mockInputConvertor.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumber));

        when(mockGetConcreteNumberTrivia(params: anyNamed('params')))
            .thenAnswer((_) async => Right(numberTrivia));
        return bloc;
      },
      act: (bloc) => bloc
          .add(GetNumberTriviaForConcreteNumber(numberString: tNumberString)),
      verify: (bloc) =>
          verify(mockGetConcreteNumberTrivia(params: Params(number: tNumber))),
    );

    blocTest(
      'should emit [loaded] when data get successfully',
      build: () {
        when(mockInputConvertor.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumber));

        when(mockGetConcreteNumberTrivia(params: anyNamed('params')))
            .thenAnswer((_) async => Right(numberTrivia));
        return bloc;
      },
      act: (bloc) => bloc
          .add(GetNumberTriviaForConcreteNumber(numberString: tNumberString)),
      expect: () => [
        Loading(),
        Loaded(numberTrivia: numberTrivia),
      ],
    );

    blocTest(
      'should [error with server failure message] when server faliure error',
      build: () {
        when(mockInputConvertor.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumber));

        when(mockGetConcreteNumberTrivia(params: anyNamed('params')))
            .thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (bloc) => bloc
          .add(GetNumberTriviaForConcreteNumber(numberString: tNumberString)),
      expect: () => [
        Loading(),
        Error(message: SERVER_FAILURE),
      ],
    );

    blocTest(
      'should [error with cache failure message] when cache faliure error',
      build: () {
        when(mockInputConvertor.stringToUnsignedInteger(any))
            .thenReturn(Right(tNumber));

        when(mockGetConcreteNumberTrivia(params: anyNamed('params')))
            .thenAnswer((_) async => Left(CacheFailure()));
        return bloc;
      },
      act: (bloc) => bloc
          .add(GetNumberTriviaForConcreteNumber(numberString: tNumberString)),
      expect: () => [
        Loading(),
        Error(message: CACHE_FAILURE),
      ],
    );
  });
  group('GetRandomNumberTrivia', () {
    NumberTrivia numberTrivia = NumberTrivia(text: 'test text', number: 1);

    blocTest(
      'should call getRandomNumber trivia usecase',
      build: () {
        when(mockGetRandomNumberTrivia(params: anyNamed('params')))
            .thenAnswer((_) async => Right(numberTrivia));
        return bloc;
      },
      act: (bloc) => bloc.add(GetNumberTriviaForRandomNumber()),
      verify: (bloc) => verify(mockGetRandomNumberTrivia(params: NoParams())),
    );

    blocTest(
      'should emit [loaded] when data get successfully',
      build: () {
        when(mockGetRandomNumberTrivia(params: anyNamed('params')))
            .thenAnswer((_) async => Right(numberTrivia));
        return bloc;
      },
      act: (bloc) => bloc.add(GetNumberTriviaForRandomNumber()),
      expect: () => [
        Loading(),
        Loaded(numberTrivia: numberTrivia),
      ],
    );

    blocTest(
      'should [error with server failure message] when server faliure error',
      build: () {
        when(mockGetRandomNumberTrivia(params: anyNamed('params')))
            .thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetNumberTriviaForRandomNumber()),
      expect: () => [
        Loading(),
        Error(message: SERVER_FAILURE),
      ],
    );

    blocTest(
      'should [error with cache failure message] when cache faliure error',
      build: () {
        when(mockGetRandomNumberTrivia(params: anyNamed('params')))
            .thenAnswer((_) async => Left(CacheFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetNumberTriviaForRandomNumber()),
      expect: () => [
        Loading(),
        Error(message: CACHE_FAILURE),
      ],
    );
  });
}
