import 'package:flutter/material.dart';
import '../db_helper.dart';
import '../main.dart';
import '../global.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isButtonEnabled = false;

  void _updateButtonState() {
    setState(() {
      isButtonEnabled =
          emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    emailController.addListener(_updateButtonState);
    passwordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          '이메일로 로그인',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: -1,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: '이메일',
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFE3E5E8)),
                  borderRadius: BorderRadius.circular(6),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFE3E5E8)),
                  borderRadius: BorderRadius.circular(6),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFB0B8C1)),
                  borderRadius: BorderRadius.circular(6),
                ),
                hintStyle:
                    const TextStyle(color: Color(0xFFB0B8C1), fontSize: 16),
              ),
              style: const TextStyle(color: Colors.black, fontSize: 16),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                hintText: '비밀번호',
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFE3E5E8)),
                  borderRadius: BorderRadius.circular(6),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFE3E5E8)),
                  borderRadius: BorderRadius.circular(6),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFB0B8C1)),
                  borderRadius: BorderRadius.circular(6),
                ),
                hintStyle:
                    const TextStyle(color: Color(0xFFB0B8C1), fontSize: 16),
              ),
              style: const TextStyle(color: Colors.black, fontSize: 16),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: isButtonEnabled
                    ? () async {
                        final email = emailController.text.trim();
                        final password = passwordController.text.trim();
                        final user = await DBHelper.loginUser(email, password);
                        if (!context.mounted) return;
                        if (user != null) {
                          isLoggedIn.value = true;
                          userName.value = user['name'];
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${user['name']}님, 환영합니다!')),
                          );
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (_) => const HomeScreen()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('이메일 또는 비밀번호가 올바르지 않습니다.')),
                          );
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isButtonEnabled ? Colors.black : const Color(0xFFF2F3F6),
                  foregroundColor:
                      isButtonEnabled ? Colors.white : const Color(0xFFB0B8C1),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                child: const Text('완료'),
              ),
            ),
            const SizedBox(height: 32),
            const Center(
              child: Text(
                '비밀번호를 잊어버렸어요',
                style: TextStyle(color: Color(0xFFB0B8C1), fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
