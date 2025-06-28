import 'package:flutter/material.dart';

class BookScreen extends StatelessWidget {
  const BookScreen({super.key}); // key 파라미터 추가 및 const 생성자
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('도서')),
      body: const Center(child: Text('도서 페이지입니다')),
    );
  }
}
