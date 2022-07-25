import 'package:flutter/material.dart';
import 'package:flutter_application/Pages/question_answer.dart';

void main() {
  runApp(const IKnowEverythingApp());
}

class IKnowEverythingApp extends StatelessWidget {
  const IKnowEverythingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "I Know Everything",
      home: QuestionAnswerPage(),
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
    );
  }
}
