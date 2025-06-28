import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'screens/used_screen.dart';
import 'upgo_screen.dart';
import 'shopping_screen.dart';

// 로그인 상태를 앱 전체에서 공유
ValueNotifier<bool> isLoggedIn = ValueNotifier<bool>(false);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GATE ai',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      routes: {
        '/login': (_) => LoginScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double verticalDragDistance = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'GATE ai',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: Icon(Icons.menu, color: Colors.black),
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: isLoggedIn,
            builder: (context, loggedIn, _) {
              if (loggedIn) {
                // 로그인 상태: 로그아웃 아이콘
                return IconButton(
                  icon: Icon(Icons.logout, color: Colors.black),
                  tooltip: '로그아웃',
                  onPressed: () async {
                    final result = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('로그아웃'),
                        content: Text('로그아웃하시겠습니까?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('아니요'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text('예'),
                          ),
                        ],
                      ),
                    );
                    if (result == true) {
                      isLoggedIn.value = false;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('로그아웃 되었습니다.')),
                      );
                    }
                  },
                );
              } else {
                // 비로그인 상태: 로그인 아이콘
                return IconButton(
                  icon: Icon(Icons.person_outline, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                    );
                  },
                );
              }
            },
          ),
          SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            children: [
              SizedBox(height: 20), // 상단 여백

              // 검색창
              Container(
                width: double.infinity,
                height: 44,
                padding: EdgeInsets.symmetric(horizontal: 16),
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

              SizedBox(height: 100), // 검색창과 로고 사이 간격

              SizedBox(
                height: 320,
                child: GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity != null) {
                      if (details.primaryVelocity! < 0) {
                        // 왼쪽 스와이프 (쇼핑)
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => ShoppingScreen()));
                      } else if (details.primaryVelocity! > 0) {
                        // 오른쪽 스와이프 (업고)
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => UpgoScreen()));
                      }
                    }
                  },
                  onVerticalDragUpdate: (details) {
                    verticalDragDistance += details.delta.dy;
                  },
                  onVerticalDragEnd: (details) {
                    if (verticalDragDistance > 50) {
                      // 아래로 충분히 스와이프 (중고)
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => UsedScreen()));
                    }
                    verticalDragDistance = 0; // 초기화
                  },
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'assets/logo.png',
                          width: 450,
                          height: 450,
                        ),
                        Positioned(
                          left: 1,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => UpgoScreen()));
                            },
                            child: Text(
                              '업고',
                              style: TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 1,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => ShoppingScreen()));
                            },
                            child: Text(
                              '쇼핑',
                              style: TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => UsedScreen()));
                            },
                            child: Text(
                              '중고',
                              style: TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}