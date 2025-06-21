import 'package:flutter/material.dart';

class FoodScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('식품')),
      body: Center(child: Text('식품 페이지입니다')),
    );
  }
}
