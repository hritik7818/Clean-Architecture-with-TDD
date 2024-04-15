import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/utils/input_convertor.dart';

void main() {
  late InputConvertor inputConvertor;
  setUp(() {
    {
      inputConvertor = InputConvertor();
    }
  });

  group('string to unsigned interger', () {
    test('should return a string when string represent the unsigned interger',
        () async {
      // arrange
      String str = '123';
      // act
      final result = inputConvertor.stringToUnsignedInteger(str);
      // assert
      expect(result, Right(123));
    });

    test('should return a failure when string does not represent the integer',
        () async {
      // arrange
      String str = 'asklf';
      // act
      final result = inputConvertor.stringToUnsignedInteger(str);
      // assert
      expect(result, Left(InvalidInputFailure()));
    });
    test('should return failure when string is a negative integer', () async {
      // arrange
      String str = '-123';
      // act
      final result = inputConvertor.stringToUnsignedInteger(str);
      // assert
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
