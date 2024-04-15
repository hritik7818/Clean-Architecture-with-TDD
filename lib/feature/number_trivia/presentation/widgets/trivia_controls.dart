import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/feature/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class TriviaControls extends StatelessWidget {
  const TriviaControls({super.key});

  @override
  Widget build(BuildContext context) {
    final textEditingController = TextEditingController();
    return Column(
      children: [
        TextFormField(
          controller: textEditingController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter the number here',
          ),
          onFieldSubmitted: (value) {
            context
                .read<NumberTriviaBloc>()
                .add(GetNumberTriviaForConcreteNumber(numberString: value));
            textEditingController.clear();
          },
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      context.read<NumberTriviaBloc>().add(
                          GetNumberTriviaForConcreteNumber(
                              numberString: textEditingController.text));
                      textEditingController.clear();
                    },
                    child: Text('Search'))),
            SizedBox(width: 20),
            Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      context
                          .read<NumberTriviaBloc>()
                          .add(GetNumberTriviaForRandomNumber());
                    },
                    child: Text('Get Random Trivia'))),
          ],
        )
      ],
    );
  }
}
