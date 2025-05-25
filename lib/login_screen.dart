import 'package:flutter/material.dart';
import 'signup_screen.dart'; // 회원가입 화면 import

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // 상단 앱바 추가
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.home, color: Colors.black), // 홈 아이콘
          onPressed: () {
            // 홈 화면으로 이동 또는 이전 화면으로 돌아가기
            Navigator.of(context).pop(); // 이전 화면으로 돌아가기
            // 혹은 Navigator.pushReplacementNamed(context, '/home'); 처럼 홈 라우트로 이동 가능
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
                Text(
                  'GATE ai',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 40),
                TextField(
                  controller: emailController,
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
                    onPressed: () {
                      print("로그인 시도");
                      // TODO: 로그인 로직
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
