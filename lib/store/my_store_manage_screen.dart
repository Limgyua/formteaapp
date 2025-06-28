import 'package:flutter/material.dart';

class MyStoreManageScreen extends StatefulWidget {
  const MyStoreManageScreen({super.key});
  @override
  MyStoreManageScreenState createState() =>
      MyStoreManageScreenState(); // 언더스코어 제거
}

class MyStoreManageScreenState extends State<MyStoreManageScreen> {
  // 임시 저장용 변수 (나중에 실제 DB나 API 연동 필요)
  String storeName = '나의 매장';
  String businessNumber = '1234567890';
  String storeSize = '5평';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 매장 관리하기'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('매장 이름', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(storeName, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            const Text('사업자 등록번호',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(businessNumber, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            const Text('매장 크기', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(storeSize, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('매장 정보 수정 기능은 곧 구현됩니다.')),
                );
              },
              child: const Text('매장 정보 수정'),
            ),
          ],
        ),
      ),
    );
  }
}
