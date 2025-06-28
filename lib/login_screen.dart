import 'package:flutter/material.dart';
import '../db_helper.dart';
import 'signup_screen.dart';
import 'main.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static final TextEditingController usernameController =
      TextEditingController();
  static final TextEditingController passwordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: isLoggedIn,
                  builder: (context, loggedIn, _) {
                    if (loggedIn) {
                      return ValueListenableBuilder<String?>(
                        valueListenable: userName,
                        builder: (context, name, _) {
                          return Text(
                            name != null ? '$name님 안녕하세요' : '',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          );
                        },
                      );
                    } else {
                      return const Text(
                        'GATE ai',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    hintText: '아이디',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                  ),
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    hintText: '비밀번호',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                  ),
                  obscureText: true,
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      elevation: 0,
                    ),
                    onPressed: () async {
                      final username = usernameController.text.trim();
                      final password = passwordController.text.trim();

                      final user = await DBHelper.loginUser(username, password);

                      if (!context.mounted) return;

                      if (user != null) {
                        isLoggedIn.value = true;
                        userName.value = user['name'];
                        userId.value = user['username'];
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${user['name']}님, 환영합니다!')),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('아이디 또는 비밀번호가 올바르지 않습니다.')),
                        );
                      }
                    },
                    child: const Text('로그인'),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignupScreen()),
                    );
                  },
                  child:
                      const Text('회원가입', style: TextStyle(color: Colors.black)),
                ),
                const SizedBox(height: 30),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image(
                      image: AssetImage('assets/kakao.png'),
                      width: 60,
                      height: 60,
                    ),
                    Image(
                      image: AssetImage('assets/google.png'),
                      width: 60,
                      height: 60,
                    ),
                    Image(
                      image: AssetImage('assets/naver.png'),
                      width: 60,
                      height: 60,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final users = await DBHelper.getAllUsers();

                    if (!context.mounted) return;

                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('DB 저장된 회원'),
                        content: SingleChildScrollView(
                          child: Text(users.isEmpty
                              ? '저장된 회원이 없습니다.'
                              : users.map((u) => u.toString()).join('\n\n')),
                        ),
                        actions: [
                          TextButton(
                            child: const Text('닫기'),
                            onPressed: () => Navigator.of(context).pop(),
                          )
                        ],
                      ),
                    );
                  },
                  child: const Text('DB 목록 보기'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
