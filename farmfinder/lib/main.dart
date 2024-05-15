import 'package:flutter/material.dart';
import 'package:farmfinder/screens/home_page.dart';

void main() {
  runApp(const FarmFinderApp());
}

class FarmFinderApp extends StatelessWidget {
  const FarmFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FarmFinder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Farm Finder Home Page'),
    );
  }
}
