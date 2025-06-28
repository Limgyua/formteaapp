import 'package:flutter/material.dart';
import '../db_helper.dart';
import 'signup_screen.dart';
import 'main.dart'; 

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.home, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
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
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          );
                        },
                      );
                    } else {
                      return Text(
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
                SizedBox(height: 40),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    hintText: '아이디',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: '비밀번호',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  obscureText: true,
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(height: 24),
                Container(
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

                      if (user != null) {
                        isLoggedIn.value = true; 
                        userName.value = user['name']; 
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${user['name']}님, 환영합니다!')),
                        );
                        
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => HomeScreen()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('아이디 또는 비밀번호가 올바르지 않습니다.')),
                        );
                      }
                    },
                    child: Text('로그인'),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SignupScreen()),
                    );
                  },
                  child: Text('회원가입', style: TextStyle(color: Colors.black)),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset('assets/kakao.png', width: 60, height: 60),
                    Image.asset('assets/google.png', width: 60, height: 60),
                    Image.asset('assets/naver.png', width: 60, height: 60),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final users = await DBHelper.getAllUsers();
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('DB 저장된 회원'),
                        content: SingleChildScrollView(
                          child: Text(users.isEmpty
                              ? '저장된 회원이 없습니다.'
                              : users.map((u) => u.toString()).join('\n\n')),
                        ),
                        actions: [
                          TextButton(
                            child: Text('닫기'),
                            onPressed: () => Navigator.of(context).pop(),
                          )
                        ],
                      ),
                    );
                  },
                  child: Text('DB 목록 보기'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}