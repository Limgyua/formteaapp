import 'package:flutter/material.dart';

class BikeScreen extends StatelessWidget {
  const BikeScreen({super.key}); // key 파라미터 추가 및 const 생성자
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('자전거')),
      body: const Center(child: Text('자전거 페이지입니다')),
    );
  }
}
