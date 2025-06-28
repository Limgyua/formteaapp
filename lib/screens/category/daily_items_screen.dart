import 'package:flutter/material.dart';

class LivingScreen extends StatelessWidget {
  const LivingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('생활용품')),
      body: const Center(child: Text('생활용품 페이지입니다')),
    );
  }
}
