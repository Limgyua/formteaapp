import 'package:flutter/material.dart';

class EtcScreen extends StatelessWidget {
  const EtcScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('기타')),
      body: const Center(child: Text('기타 페이지입니다')),
    );
  }
}
