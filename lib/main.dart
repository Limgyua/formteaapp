import 'package:flutter/material.dart';
import 'auth/login_screen.dart';
import 'screens/used/used_screen.dart';
import 'upgo/upgo_screen.dart';
import 'shopping/shopping_screen.dart';

import 'auth/my_page_screen.dart';
import 'global.dart';

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
      drawer: FractionallySizedBox(
        widthFactor: 0.7,
        child: Drawer(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: ValueListenableBuilder<String?>(
                    valueListenable: userName,
                    builder: (context, name, _) {
                      if (name != null && name.trim().isNotEmpty) {
                        return Row(
                          children: [
                            Expanded(
                              child: Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  size: 20, color: Colors.grey),
                              tooltip: '개인정보 수정',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const MyPageScreen()),
                                );
                              },
                            ),
                          ],
                        );
                      } else {
                        return const Padding(
                          padding: EdgeInsets.only(top: 4.0),
                          child: Text(
                            '로그인 해주세요',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onDrawerChanged: (isOpened) {
        if (isOpened) setState(() {});
      },
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
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
                        if (details.primaryVelocity! > 0) {
                          // 오른쪽 드래그: 쇼핑
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const ShoppingScreen()));
                        } else if (details.primaryVelocity! < 0) {
                          // 왼쪽 드래그: 업고
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
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
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
                                        builder: (_) =>
                                            const ShoppingScreen()));
                              },
                              child: const Text(
                                '쇼핑',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
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
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
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
      ),
    );
  }
}
