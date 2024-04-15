import 'dart:convert';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/error/exception.dart';

import 'package:number_trivia/feature/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/feature/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

import 'package:http/http.dart' as http;

import 'number_trivia_remote_date_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient mockClient;
  late NumberTriviaRemoteDataSourceImpl dataSource;

  setUp(() {
    mockClient = MockClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockClient);
  });

  void arrangeGetResquestForStatusCode200() {
    when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(fixture('trivia_response.json'), 200));
  }

  void arrangeGetResquestForStatusCodeNot200() {
    when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response('{"error":"something went wrong"}', 400));
  }

  group('get remote concreate number trivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
        json.decode(fixture('trivia_response.json')));
    test('should hit url with given number and header', () async {
      // arrange
      arrangeGetResquestForStatusCode200();
      // act
      dataSource.getConcreateNumberTrivia(tNumber);
      // assert
      verify(mockClient.get(Uri.parse('http://numbersapi.com/$tNumber'),
          headers: {'Content-Type': 'application/json'}));
    });
    test('should return a number trivia model if status code is 200', () async {
      // arrange
      arrangeGetResquestForStatusCode200();
      // act
      final result = await dataSource.getConcreateNumberTrivia(tNumber);
      // assert
      expect(result, equals(tNumberTriviaModel));
    });
    test('should throw ServerException if status code not 200', () async {
      // arrange
      arrangeGetResquestForStatusCodeNot200();
      // acts
      final call = dataSource.getConcreateNumberTrivia;
      // assert
      expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
    });
  });
  group('get remote random number trivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
        json.decode(fixture('trivia_response.json')));
    test('should hit url and header', () async {
      // arrange
      arrangeGetResquestForStatusCode200();
      // act
      dataSource.getRandomNumberTrivia();
      // assert
      verify(mockClient.get(Uri.parse('http://numbersapi.com/random'),
          headers: {'Content-Type': 'application/json'}));
    });
    test('should return a number trivia model if status code is 200', () async {
      // arrange
      arrangeGetResquestForStatusCode200();
      // act
      final result = await dataSource.getRandomNumberTrivia();
      // assert
      expect(result, equals(tNumberTriviaModel));
    });
    test('should throw ServerException if status code not 200', () async {
      // arrange
      arrangeGetResquestForStatusCodeNot200();
      // act
      final call = dataSource.getRandomNumberTrivia;
      // assert
      expect(call, throwsA(TypeMatcher<ServerException>()));
    });
  });
}
