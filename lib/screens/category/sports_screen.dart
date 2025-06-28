import 'package:flutter/material.dart';

class SportsScreen extends StatelessWidget {
  const SportsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('스포츠/레저')),
      body: const Center(child: Text('스포츠/레저 페이지입니다')),
    );
  }
}
