import 'package:equatable/equatable.dart';

import '../../domain/entities/number_trivia.dart';

class NumberTriviaModel extends NumberTrivia implements Equatable {
  NumberTriviaModel({
    required int number,
    required String text,
  }) : super(number: number, text: text);

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(
      number: (json['number'] as num).toInt(),
      text: json['text'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'number': number,
    };
  }
}
