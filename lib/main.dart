import 'package:flutter/material.dart';
import 'package:rgb_faded_plate_generator/screens/generator.dart';
import 'package:rgb_faded_plate_generator/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RGB Faden Plate Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
