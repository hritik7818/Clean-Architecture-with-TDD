import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/core/error/failure.dart';
import 'package:number_trivia/core/network/network_info.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/feature/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/feature/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/feature/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/feature/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia/feature/number_trivia/domain/entities/number_trivia.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateMocks(
    [NetworkInfo, NumberTriviaRemoteDataSource, NumberTriviaLocalDataSource])
void main() {
  late NumberTriviaRepositoryImpl numberTriviaRepositoryImpl;
  late MockNetworkInfo mockNetworkInfo;
  late MockNumberTriviaLocalDataSource mockNumberTriviaLocalDataSource;
  late MockNumberTriviaRemoteDataSource mockNumberTriviaRemoteDataSource;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockNumberTriviaRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockNumberTriviaLocalDataSource = MockNumberTriviaLocalDataSource();
    numberTriviaRepositoryImpl = NumberTriviaRepositoryImpl(
      networkInfo: mockNetworkInfo,
      numberTriviaRemoteDataSource: mockNumberTriviaRemoteDataSource,
      numberTriviaLocalDataSource: mockNumberTriviaLocalDataSource,
    );
  });

  group('getConcreateNumberTrivia', () {
    final tNumber = 1;
    final NumberTriviaModel tNumberTriviaModel =
        NumberTriviaModel(number: tNumber, text: 'test');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    group('when device is online', () {
      setUp(() {
        when(mockNumberTriviaRemoteDataSource.getConcreateNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      test('should check if a device is online', () async {
        await numberTriviaRepositoryImpl.getConcreateNumberTrivia(tNumber);
        verify(mockNetworkInfo.isConnected);
      });
      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        // arrange

        // act
        final result =
            await numberTriviaRepositoryImpl.getConcreateNumberTrivia(tNumber);
        // assert
        print(result);
        print(Right(tNumberTrivia));
        expect(result, Right(tNumberTrivia));
      });
      test(
          'should cache last respose from remote data source when successfully fetch data',
          () async {
        // arrange
        await numberTriviaRepositoryImpl.getConcreateNumberTrivia(tNumber);
        // act
        verify(
            mockNumberTriviaRemoteDataSource.getConcreateNumberTrivia(tNumber));
        verify(mockNumberTriviaLocalDataSource
            .cacheNumberTrivia(tNumberTriviaModel));
        // assert
      });
      test(
          'should return ServerFailure when remote data soure throw server exception',
          () async {
        // arrange
        when(mockNumberTriviaRemoteDataSource.getConcreateNumberTrivia(tNumber))
            .thenThrow(ServerException());
        // act
        final result =
            await numberTriviaRepositoryImpl.getConcreateNumberTrivia(tNumber);
        // assert
        verify(
            mockNumberTriviaRemoteDataSource.getConcreateNumberTrivia(tNumber));
        verifyZeroInteractions(mockNumberTriviaLocalDataSource);
        expect(result, Left(ServerFailure()));
      });
    });
    group('when device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      test('should return from cache when cache is present', () async {
        // arrange
        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result =
            await numberTriviaRepositoryImpl.getConcreateNumberTrivia(tNumber);
        // assert
        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
        verifyNoMoreInteractions(mockNumberTriviaRemoteDataSource);
        expect(result, Right(tNumberTrivia));
      });
      test(
          'should return cache failure when local data source throw cache exception',
          () async {
        // arrange
        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());
        // act
        final result =
            await numberTriviaRepositoryImpl.getConcreateNumberTrivia(tNumber);
        // assert
        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
        print(result);
        print(Left(CacheException()));
        expect(result, Left(CacheFailure()));
        // assert
      });
    });
  });
  group('getRandomNumberTrivia', () {
    final tNumber = 1;
    final NumberTriviaModel tNumberTriviaModel =
        NumberTriviaModel(number: tNumber, text: 'test');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    group('when device is online', () {
      setUp(() {
        when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      test('should check if a device is online', () async {
        await numberTriviaRepositoryImpl.getRandomNumberTrivia();
        verify(mockNetworkInfo.isConnected);
      });
      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        // arrange

        // act
        final result = await numberTriviaRepositoryImpl.getRandomNumberTrivia();
        // assert
        print(result);
        print(Right(tNumberTrivia));
        expect(result, Right(tNumberTrivia));
      });
      test(
          'should cache last respose from remote data source when successfully fetch data',
          () async {
        // arrange
        await numberTriviaRepositoryImpl.getRandomNumberTrivia();
        // act
        verify(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia());
        verify(mockNumberTriviaLocalDataSource
            .cacheNumberTrivia(tNumberTriviaModel));
        // assert
      });
      test(
          'should return ServerFailure when remote data soure throw server exception',
          () async {
        // arrange
        when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
            .thenThrow(ServerException());
        // act
        final result = await numberTriviaRepositoryImpl.getRandomNumberTrivia();
        // assert
        verify(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia());
        verifyZeroInteractions(mockNumberTriviaLocalDataSource);
        expect(result, Left(ServerFailure()));
      });
    });
    group('when device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      test('should return from cache when cache is present', () async {
        // arrange
        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        // act
        final result = await numberTriviaRepositoryImpl.getRandomNumberTrivia();
        // assert
        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
        verifyNoMoreInteractions(mockNumberTriviaRemoteDataSource);
        expect(result, Right(tNumberTrivia));
      });
      test(
          'should return cache failure when local data source throw cache exception',
          () async {
        // arrange
        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());
        // act
        final result = await numberTriviaRepositoryImpl.getRandomNumberTrivia();
        // assert
        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
        print(result);
        print(Left(CacheException()));
        expect(result, Left(CacheFailure()));
        // assert
      });
    });
  });
}
