import 'dart:convert';

import 'package:number_trivia/core/error/exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTriviaModel);
  Future<NumberTriviaModel> getLastNumberTrivia();
}

const String CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSourceImpl extends NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});
  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final numberTriviaJson = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if (numberTriviaJson != null) {
      final numberTrivia =
          NumberTriviaModel.fromJson(json.decode(numberTriviaJson));
      return Future.value(numberTrivia);
    }
    throw CacheException();
  }

  @override
  Future<bool> cacheNumberTrivia(NumberTriviaModel numberTriviaModel) {
    return sharedPreferences.setString(
        CACHED_NUMBER_TRIVIA, json.encode(numberTriviaModel.toMap()));
  }
}
