import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

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
  final AudioPlayer player = AudioPlayer();

  void _playAudio(String noteName) async {
    final player = AudioPlayer();
    player.play(AssetSource('$noteName.mp3'));
  }

  Expanded buildKey({required Color color, required String noteName}) {
    return Expanded(
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: color,
          shape: const RoundedRectangleBorder(),
        ),
        onPressed: () {
          _playAudio(noteName);
        },
        child: const SizedBox.expand(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildKey(color: Colors.red, noteName: 'note.A'),
            buildKey(color: Colors.orange, noteName: 'note.B'),
            buildKey(color: Colors.yellow, noteName: 'note.C'),
            buildKey(color: Colors.green, noteName: 'note.D'),
            buildKey(color: Colors.blue, noteName: 'note.E'),
            buildKey(color: Colors.indigo, noteName: 'note.F'),
            buildKey(color: Colors.purple, noteName: 'note.G'),
          ],
        ),
      ),
    );
  }
}
