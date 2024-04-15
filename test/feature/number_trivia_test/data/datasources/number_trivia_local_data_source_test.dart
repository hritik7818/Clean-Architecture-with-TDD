import 'dart:convert';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/feature/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia/feature/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late MockSharedPreferences mockSharedPreferences;
  late NumberTriviaLocalDataSourceImpl numberTriviaLocalDataSourceImpl;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    numberTriviaLocalDataSourceImpl = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('get last cached number trivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('cache_trivia.json')));
    test('should return a cached number trivia if shared preference has data',
        () async {
      // arrange
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('cache_trivia.json'));
      // act
      final result =
          await numberTriviaLocalDataSourceImpl.getLastNumberTrivia();
      // assert
      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw exception when sharedpreference has no data', () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      // act
      final call = numberTriviaLocalDataSourceImpl.getLastNumberTrivia;
      // assert
      expect(call, throwsA(TypeMatcher<CacheException>()));
    });
  });
  group('cache number trivia', () {
    NumberTriviaModel tNumberTriviaModel =
        NumberTriviaModel(number: 1, text: 'text');
    test('should call setString method', () async {
      // arrange
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((_) async => true);
      // act
      numberTriviaLocalDataSourceImpl.cacheNumberTrivia(tNumberTriviaModel);
      // assert
      verify(mockSharedPreferences.setString(
          CACHED_NUMBER_TRIVIA, json.encode(tNumberTriviaModel.toMap())));
    });
  });
}
