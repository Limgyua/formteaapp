import 'package:flutter/material.dart';
import '../../store/store_setup_screen.dart';
import '../../store/my_store_manage_screen.dart';

class UpgoScreen extends StatelessWidget {
  const UpgoScreen({super.key}); // ← key 파라미터 및 const 생성자 추가
  void _showStoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.store_mall_directory),
              title: const Text('개인 매장 개설하기'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StoreSetupScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('내 매장 관리하기'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const MyStoreManageScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('업고')),
      body: const Center(child: Text('업고 화면')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showStoreOptions(context),
        backgroundColor: Colors.black,
        tooltip: '글쓰기 또는 매장 개설',
        child: const Icon(Icons.add, color: Colors.white), // ← 마지막에 위치
      ),
    );
  }
}
