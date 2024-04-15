import 'package:flutter/material.dart';
import 'package:number_trivia/feature/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:number_trivia/injection_container.dart' as di;

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.red,
      ),
      debugShowCheckedModeBanner: false,
      home: NumberTriviaPage(),
    );
  }
}
