import 'package:flutter/material.dart';

class BabyScreen extends StatelessWidget {
  const BabyScreen({super.key}); // key 파라미터 추가 및 const 생성자
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('유아용품')),
      body: const Center(child: Text('유아용품 페이지입니다')),
    );
  }
}
