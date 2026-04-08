import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const DicePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class DicePage extends StatefulWidget {
  const DicePage({super.key, required this.title});
  final String title;

  @override
  State<DicePage> createState() => _DicePageState();
}

class _DicePageState extends State<DicePage> {
  int leftDiceNumber = 1;
  int rightDiceNumber = 1;

  void rollDice() {
    setState(() {
      leftDiceNumber = Random().nextInt(6) + 1;
      rightDiceNumber = Random().nextInt(6) + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(108, 80, 240, 63),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: TextButton(
                onPressed: () {
                  rollDice();
                },
                child: Image.asset('assets/dice-$leftDiceNumber.png'),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: TextButton(
                onPressed: () {
                  rollDice();
                },
                child: Image.asset('assets/dice-$rightDiceNumber.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
