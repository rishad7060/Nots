import 'package:flutter/material.dart';
import 'package:notes/screens/note_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note Management',
      theme: ThemeData(
          useMaterial3: true,
          primaryColor: Colors.blueGrey[900],
          textTheme: const TextTheme(
            bodyMedium: TextStyle(fontSize: 16.0),
            bodySmall: TextStyle(fontSize: 14.0),
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            backgroundColor: Color(0xFF1F363D),
            iconTheme: IconThemeData(color: Colors.white),
          )),
      home: const NoteList(),
    );
  }
}
