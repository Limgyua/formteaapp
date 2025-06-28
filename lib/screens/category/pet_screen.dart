import 'package:flutter/material.dart';

class PetScreen extends StatelessWidget {
  const PetScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('반려동물')),
      body: const Center(child: Text('반려동물 페이지입니다')),
    );
  }
}
