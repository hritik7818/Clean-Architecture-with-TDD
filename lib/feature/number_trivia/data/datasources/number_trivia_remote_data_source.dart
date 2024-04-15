import 'dart:convert';

import 'package:number_trivia/core/error/exception.dart';

import '../models/number_trivia_model.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreateNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({required this.client});
  @override
  Future<NumberTriviaModel> getConcreateNumberTrivia(int number) =>
      getRemoteDataFromUrl('http://numbersapi.com/$number');

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() =>
      getRemoteDataFromUrl('http://numbersapi.com/random');

  Future<NumberTriviaModel> getRemoteDataFromUrl(String url) async {
    final response = await client.get(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      print('reponse : ${response.body}');
      return NumberTriviaModel.fromJson(json.decode(response.body));
    }

    throw ServerException();
  }
}
