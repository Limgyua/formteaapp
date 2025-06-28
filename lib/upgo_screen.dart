import 'package:flutter/material.dart';
import '../store/store_setup_screen.dart';
import '../store/my_store_manage_screen.dart';

class UpgoScreen extends StatelessWidget {
  void _showStoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.store_mall_directory),
              title: Text('개인 매장 개설하기'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => StoreSetupScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('내 매장 관리하기'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MyStoreManageScreen()),
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
      appBar: AppBar(title: Text('업고')),
      body: Center(child: Text('업고 화면')),
      
      
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showStoreOptions(context),
        backgroundColor: Colors.black,
        child: Icon(Icons.add, color: Colors.white),
        tooltip: '글쓰기 또는 매장 개설',
      ),
    );
  }
}
