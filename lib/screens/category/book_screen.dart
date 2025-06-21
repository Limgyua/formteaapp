import 'package:flutter/material.dart';

class BookScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('도서')),
      body: Center(child: Text('도서 페이지입니다')),
    );
  }
}
