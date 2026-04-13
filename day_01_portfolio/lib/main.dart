import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[900],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 100,
            backgroundImage: AssetImage('assets/images/profile_picture.jpg'),
          ),
          SizedBox(height: 20),
          Text(
            ' Fyrru',
            style: GoogleFonts.pacifico(fontSize: 35, color: Colors.white),
          ),
          Divider(
            color: Colors.grey[400],
            thickness: 1,
            indent: 50,
            endIndent: 50,
          ),
          SizedBox(height: 10),
          Text(
            'FLUTTER DEVELOPER',
            style: GoogleFonts.lato(letterSpacing: 2, color: Colors.grey[600]),
          ),
          SizedBox(height: 20),
          CardWidget(),
        ],
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  const CardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Card(
            margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: ListTile(
              leading: Icon(Icons.phone, color: Colors.indigo),
              title: Text('+380 999 999 99'),
              onTap: null,
            ),
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10)),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: ListTile(
              leading: Icon(Icons.email, color: Colors.indigo),
              title: Text('fyrru@example.com'),
              onTap: null,
            ),
          ),
        ],
      ),
    );
  }
}
