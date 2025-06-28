import 'package:flutter/material.dart';

class ElectronicsScreen extends StatelessWidget {
  const ElectronicsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('전자제품')),
      body: const Center(child: Text('전자제품 페이지입니다')),
    );
  }
}
