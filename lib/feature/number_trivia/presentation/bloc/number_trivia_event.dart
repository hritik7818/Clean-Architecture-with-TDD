part of 'number_trivia_bloc.dart';

sealed class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();

  @override
  List<Object> get props => [];
}

class GetNumberTriviaForConcreteNumber extends NumberTriviaEvent {
  final String numberString;
  const GetNumberTriviaForConcreteNumber({required this.numberString});
  @override
  List<Object> get props => [numberString];
}

class GetNumberTriviaForRandomNumber extends NumberTriviaEvent {}
