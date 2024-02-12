// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import './tasks.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO List',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
            primary: Colors.black,
            secondary: Colors.white,
            tertiary: Colors.red),
      ),
      home: const HomePage(title: 'HOME'),
    );
  }
}
