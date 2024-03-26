import 'package:flutter/material.dart';
import 'package:flutter_snake_game/Screen/Snake_Game_Screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Snake Game',
      theme: ThemeData.dark(),
      home: const SnakeGameScreen(),
    );
  }
}
