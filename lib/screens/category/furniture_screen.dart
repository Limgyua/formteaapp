import 'package:flutter/material.dart';

class FurnitureScreen extends StatelessWidget {
  const FurnitureScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('가구')),
      body: const Center(child: Text('가구 페이지입니다')),
    );
  }
}
