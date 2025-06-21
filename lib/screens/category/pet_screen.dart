import 'package:flutter/material.dart';

class PetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('반려동물')),
      body: Center(child: Text('반려동물 페이지입니다')),
    );
  }
}
