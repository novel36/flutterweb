import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/models/answer.dart';
import 'package:http/http.dart' as http;

class QuestionAnswerPage extends StatefulWidget {
  const QuestionAnswerPage({Key? key}) : super(key: key);

  @override
  State<QuestionAnswerPage> createState() => _QuestionAnswerPageState();
}

class _QuestionAnswerPageState extends State<QuestionAnswerPage> {
  late TextEditingController _questionFieldController;

  /// To Store Current Answer Object
  Answer? _currentAnswer;

  /// Scaffold key
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _questionFieldController = TextEditingController();
  }

// The Function That Get Yes Or No From The Api
  _handleGetAnswer() async {
    String questionText = _questionFieldController.text.toString().trim();
    if (questionText.isEmpty || questionText.endsWith("?") != true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please Ask a Valid Question"),
        duration: Duration(seconds: 2),
      ));
      return 0;
    }

    try {
      http.Response response =
          await http.get(Uri(scheme: "https", host: "yesno.wtf", path: "/api"));
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        Answer answer = Answer.fromMap(responseBody);
        setState(() {
          _currentAnswer = answer;
        });
      }
      print(response.statusCode);
    } catch (err, stacktrace) {
      print(err);
      print(stacktrace);
    }
  }

  _handleResetOperation() {
    _questionFieldController.clear();
    setState(() {
      _currentAnswer = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("I Know Everything"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.teal,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              width: 0.5 * MediaQuery.of(context).size.width,
              child: TextField(
                onSubmitted: (text) {
                  _handleGetAnswer();
                },
                controller: _questionFieldController,
                decoration: const InputDecoration(
                    label: Text("Ask a Question?"),
                    border: OutlineInputBorder()),
              )),
          const SizedBox(
            height: 20,
          ),
          if (_currentAnswer != null)
            Stack(
              children: [
                Container(
                  height: 250,
                  width: 500,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(_currentAnswer!.image))),
                ),
                Positioned.fill(
                    child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    _currentAnswer!.answer.toUpperCase(),
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ))
              ],
            ),
          if (_currentAnswer != null)
            const SizedBox(
              height: 20,
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  _handleGetAnswer();
                },
                icon: const Icon(Icons.question_answer),
                label: const Text("Get Answer"),
                // ignore: prefer_const_constructors
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                    primary: Theme.of(context).primaryColor),
              ),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton.icon(
                onPressed: _handleResetOperation,
                icon: const Icon(Icons.question_answer),
                label: const Text("Reset"),
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                    primary: Theme.of(context).primaryColor),
              )
            ],
          )
        ],
      ),
    );
  }
}
