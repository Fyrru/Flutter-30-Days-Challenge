import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int questionNumber = 0;
  List<Widget> scoreKeeper = [];

  List<Question> questionsBank = [
    Question(questionText: 'The earth is round?', questionAnswer: true),
    Question(questionText: 'Cats can fly.', questionAnswer: false),
    Question(
      questionText: 'There are 30 days in February?',
      questionAnswer: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(194, 232, 221, 221),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 5,
              child: Center(
                child: Text(
                  questionsBank[questionNumber].questionText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 25, color: Colors.black),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    bool correctAnswer =
                        questionsBank[questionNumber].questionAnswer;
                    if (correctAnswer == true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Красавчик, угадал!'),
                          backgroundColor: Colors.green,
                          duration: Duration(milliseconds: 500),
                        ),
                      );
                      scoreKeeper.add(Icon(Icons.check, color: Colors.green));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Мимо!'),
                          backgroundColor: Colors.red,
                          duration: Duration(milliseconds: 500),
                        ),
                      );
                      scoreKeeper.add(Icon(Icons.close, color: Colors.red));
                    }
                    setState(() {
                      questionNumber =
                          (questionNumber + 1) % questionsBank.length;
                    });
                  },
                  child: const Text(
                    'True',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    bool correctAnswer =
                        questionsBank[questionNumber].questionAnswer;
                    if (correctAnswer == false) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Красавчик, угадал!'),
                          backgroundColor: Colors.green,
                          duration: Duration(milliseconds: 500),
                        ),
                      );
                      scoreKeeper.add(Icon(Icons.check, color: Colors.green));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Мимо!'),
                          backgroundColor: Colors.red,
                          duration: Duration(milliseconds: 500),
                        ),
                      );
                      scoreKeeper.add(Icon(Icons.close, color: Colors.red));
                    }
                    setState(() {
                      questionNumber =
                          (questionNumber + 1) % questionsBank.length;
                    });
                  },
                  child: const Text(
                    'False',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
            Row(children: scoreKeeper),
          ],
        ),
      ),
    );
  }
}

class Question {
  String questionText;
  bool questionAnswer;

  Question({required this.questionText, required this.questionAnswer});
}
