import 'dart:io';
import 'package:thirty_green_events/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thirty Green Events',
      home: const HomePage(),
      theme: ThemeData( /** definiamo un tema per l'intera applicazione */
        colorScheme: ColorScheme.fromSwatch(
          accentColor: Colors.red[300],
          backgroundColor: Colors.teal[50],
          cardColor: Colors.tealAccent,
          errorColor: Colors.red,
          primarySwatch: Colors.teal)
      )
    );
  }

}
