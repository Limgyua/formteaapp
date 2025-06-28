import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('게임/취미')),
      body: const Center(child: Text('게임/취미 페이지입니다')),
    );
  }
}
