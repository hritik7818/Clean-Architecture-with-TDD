import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/feature/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:number_trivia/injection_container.dart';

import '../widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _buildNumberTriviaBody(context),
    );
  }

  BlocProvider _buildNumberTriviaBody(BuildContext context) {
    return BlocProvider<NumberTriviaBloc>(
      create: (_) => sl<NumberTriviaBloc>(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // upper part
              SizedBox(height: 20),
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  return switch (state) {
                    Empty() => MessageDisplay(message: 'Search Number Trivia!'),
                    Loading() => LoadingWidget(),
                    Loaded() => TriviaDisplay(numberTrivia: state.numberTrivia),
                    Error() => MessageDisplay(message: state.message),
                  };
                },
              ),
              SizedBox(height: 20),
              // control part
              TriviaControls(),
            ],
          ),
        ),
      ),
    );
  }
}
