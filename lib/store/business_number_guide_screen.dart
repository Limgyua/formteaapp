import 'package:flutter/material.dart';

class BusinessNumberGuideScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('가이드입니다. 여기를 클릭해주세요.'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Text(
          '설명서 입니다 \n 추후에 설명을 넣어주세요.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
      ),
    );
  }
}
