import 'package:flutter/material.dart';
import '../global.dart';
import '../db_helper.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  final nameController = TextEditingController();
  final birthController = TextEditingController();
  final passwordController = TextEditingController();

  bool editable = false;
  bool passwordEditable = false;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  void enableEdit() {
    setState(() {
      editable = true;
    });
  }

  Future<void> loadUser() async {
    if (userId.value == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    final user = await DBHelper.getUserByUsername(userId.value!);
    setState(() {
      userData = user;
      nameController.text = user?['name'] ?? '';
      birthController.text = user?['birth'] ?? '';
      passwordController.text = user?['password'] ?? '';
      passwordEditable = false;
      isLoading = false;
    });
  }

  Future<void> updateUser() async {
    if (userData == null) return;
    final updatedUser = {
      'id': userData!['id'],
      'name': nameController.text,
      'birth': birthController.text,
      'password': passwordController.text,
    };
    await DBHelper.updateUser(updatedUser);
    userName.value = nameController.text;

    if (!mounted) return; // 여기만 수정

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('정보가 수정되었습니다.')),
    );
    await loadUser();
  }

  Future<void> deleteUser() async {
    if (userData == null) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('회원탈퇴'),
        content: const Text('정말로 회원탈퇴 하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('아니요'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('예', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (!mounted) return; // 여기로 변경

    if (confirm == true) {
      await DBHelper.deleteUser(userData!['id']);
      isLoggedIn.value = false;
      userName.value = null;
      userId.value = null;

      if (!mounted) return; // 여기도 변경

      Navigator.of(context).popUntil((route) => route.isFirst);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('회원탈퇴가 완료되었습니다.')),
      );
    }
  }

  Future<void> showIdDialog() async {
    final idController = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('아이디 확인'),
        content: TextField(
          controller: idController,
          decoration: const InputDecoration(
            hintText: '아이디를 입력하세요',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              if (idController.text.trim() == (userData?['username'] ?? '')) {
                Navigator.of(context).pop(true);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('아이디가 일치하지 않습니다.')),
                );
              }
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );

    if (!context.mounted) return;

    if (result == true) {
      setState(() {
        passwordEditable = true;
      });
      // 비밀번호 입력란에 포커스 주기
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          FocusScope.of(context).requestFocus(_passwordFocusNode);
        }
      });
    }
  }

  final FocusNode _passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('내 정보')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 정보'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.grey),
            tooltip: '수정하기',
            onPressed: enableEdit,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            const Text('아이디', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            TextField(
              controller:
                  TextEditingController(text: userData?['username'] ?? ''),
              enabled: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Color.fromARGB(255, 224, 224, 224),
              ),
            ),
            const SizedBox(height: 20),
            const Text('이름', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            TextField(
              controller: nameController,
              enabled: editable,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '이름',
              ),
            ),
            const SizedBox(height: 20),
            const Text('생년월일', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            TextField(
              controller: birthController,
              enabled: editable,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '생년월일',
              ),
            ),
            const SizedBox(height: 20),
            const Text('비밀번호', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            GestureDetector(
              onTap: () async {
                if (!passwordEditable && editable) {
                  await showIdDialog();
                }
              },
              child: AbsorbPointer(
                absorbing: !passwordEditable,
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  focusNode: _passwordFocusNode,
                  enabled: editable,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '비밀번호',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '비밀번호 변경 시 아이디를 한 번 더 입력하세요',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            if (editable)
              ElevatedButton(
                onPressed: updateUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('수정하기'),
              ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: deleteUser,
                  child: Text(
                    '회원탈퇴',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                GestureDetector(
                  onTap: () {
                    isLoggedIn.value = false;
                    userName.value = null;
                    userId.value = null;
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('로그아웃 되었습니다.')),
                    );
                  },
                  child: Text(
                    '로그아웃',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
