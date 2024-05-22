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
      home: HomePage(),
      theme: ThemeData(
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
