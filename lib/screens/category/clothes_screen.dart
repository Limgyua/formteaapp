import 'package:flutter/material.dart';

class ClothingScreen extends StatelessWidget {
  const ClothingScreen({super.key}); // key 파라미터 추가 및 const 생성자

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('의류')), // const 추가
      body: const Center(child: Text('의류 페이지입니다')), // const 추가
    );
  }
}
