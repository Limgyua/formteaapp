import 'package:flutter/material.dart';
import 'login_screen.dart'; // LoginScreen 파일 import

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GATE ai',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 전체 배경 흰색
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'GATE ai',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        leading: Icon(Icons.menu, color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.person_outline, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
          ),
          SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 30), // 앱바 아래 여백
            Container(
              width: 300,
              height: 40,
              margin: EdgeInsets.only(bottom: 10), // 아래 여백 살짝 줄임
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.black, width: 1.5),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search, color: Colors.black),
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey[600]),
                ),
                style: TextStyle(color: Colors.black),
                cursorColor: Colors.black,
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20), // 여백 줄임
                  child: Image.asset(
                    'assets/logo.png',
                    width: 300,
                    height: 300,
                  ),
                ),
                Positioned(
                  bottom: 40,
                  child: Text('중고', style: TextStyle(fontSize: 20)),
                ),
                Positioned(
                  left: 0,
                  child: Text('업고', style: TextStyle(fontSize: 20)),
                ),
                Positioned(
                  right: 0,
                  child: Text('쇼핑', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
