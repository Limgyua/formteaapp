import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'screens/used_screen.dart';
import 'upgo_screen.dart';
import 'shopping_screen.dart';
import 'my_page_screen.dart';

// 로그인 상태와 사용자 이름을 앱 전체에서 공유
ValueNotifier<bool> isLoggedIn = ValueNotifier<bool>(false);
ValueNotifier<String?> userName = ValueNotifier<String?>(null);
ValueNotifier<String?> userId = ValueNotifier<String?>(null);

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GATE ai',
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      routes: {
        '/login': (_) => const LoginScreen(),
        '/mypage': (_) => const MyPageScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double verticalDragDistance = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: FractionallySizedBox(
        widthFactor: 0.7,
        child: Drawer(
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 32),

                ValueListenableBuilder<bool>(
                  valueListenable: isLoggedIn,
                  builder: (context, loggedIn, _) {
                    if (loggedIn) {
                      return ValueListenableBuilder<String?>(
                        valueListenable: userName,
                        builder: (context, name, _) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const MyPageScreen()),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name != null ? '$name님' : '',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '마이페이지',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      return const Text(
                        '로그인 해주세요',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      );
                    }
                  },
                ),

                // 공지사항 메뉴 추가
                ListTile(
                  leading: const Icon(Icons.campaign, color: Colors.black),
                  title: const Text('공지사항'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => const AlertDialog(
                        title: Text('공지사항'),
                        content: Text('공지사항 화면을 구현하세요.'),
                      ),
                    );
                  },
                ),
                // 고객센터 메뉴 추가
                ListTile(
                  leading: const Icon(Icons.headset_mic, color: Colors.black),
                  title: const Text('고객센터'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => const AlertDialog(
                        title: Text('고객센터'),
                        content: Text('고객센터 화면을 구현하세요.'),
                      ),
                    );
                  },
                ),
                Divider(thickness: 1, height: 1, color: Colors.grey[300]),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'GATE ai',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: isLoggedIn,
            builder: (context, loggedIn, _) {
              if (loggedIn) {
                return IconButton(
                  icon: const Icon(Icons.logout, color: Colors.black),
                  tooltip: '로그아웃',
                  onPressed: () async {
                    final result = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('로그아웃'),
                        content: const Text('로그아웃하시겠습니까?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('아니요'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('예'),
                          ),
                        ],
                      ),
                    );
                    if (!context.mounted) return;
                    if (result == true) {
                      isLoggedIn.value = false;
                      userName.value = null;
                      userId.value = null;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('로그아웃 되었습니다.')),
                      );
                    }
                  },
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.person_outline, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                );
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.black, width: 1.5),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: const Icon(Icons.search, color: Colors.black),
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey[600]),
                  ),
                  style: const TextStyle(color: Colors.black),
                  cursorColor: Colors.black,
                ),
              ),
              const SizedBox(height: 100),
              SizedBox(
                height: 320,
                child: GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity != null) {
                      if (details.primaryVelocity! < 0) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ShoppingScreen()));
                      } else if (details.primaryVelocity! > 0) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const UpgoScreen()));
                      }
                    }
                  },
                  onVerticalDragUpdate: (details) {
                    verticalDragDistance += details.delta.dy;
                  },
                  onVerticalDragEnd: (details) {
                    if (verticalDragDistance > 50) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const UsedScreen()));
                    }
                    verticalDragDistance = 0;
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const UpgoScreen()));
                            },
                            child: const Text(
                              '업고',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 1,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const ShoppingScreen()));
                            },
                            child: const Text(
                              '쇼핑',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const UsedScreen()));
                            },
                            child: const Text(
                              '중고',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
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
