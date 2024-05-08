import 'dart:io';
import 'package:event_manager_app/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print("Pippo");
    print(Directory.current);
    return MaterialApp(
      title: 'Event Manager',
      home: HomePage(),
    );
  }

}
