import 'package:flutter/material.dart';
import '../db_helper.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // (중복된 initState 선언 제거, 아래에 하나만 남김)
  @override
  void initState() {
    super.initState();
    emailController.addListener(() {
      setState(() {});
    });
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool agreeAll = false;
  bool agree14 = false;
  bool agreeTerms = false;
  bool agreePrivacyMarketing = false;
  bool agreeReceiveInfo = false;

  void checkAgreeAll() {
    setState(() {
      agreeAll =
          agree14 && agreeTerms && agreePrivacyMarketing && agreeReceiveInfo;
    });
  }

  // 네이버 스타일 입력창
  Widget buildNaverTextField({
    required TextEditingController controller,
    String? hint,
    bool obscure = false,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 16, color: Color(0xFF222222)),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF8F9FA),
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFB0B8C1)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE3E5E8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE3E5E8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 16, 16, 16), width: 2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('이메일로 회원가입',
            style: TextStyle(
                color: Color(0xFF222222),
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('인테리어 전문가이시다면 >',
                style: TextStyle(color: Color(0xFF888888), fontSize: 13)),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildNaverTextField(
                        controller: emailController, hint: '이메일'),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: emailController.text.isNotEmpty
                            ? () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('이메일 인증 요청! (실제 인증 로직은 추후 구현)')),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: emailController.text.isNotEmpty
                              ? Colors.black
                              : const Color(0xFFF2F3F6),
                          foregroundColor: emailController.text.isNotEmpty
                              ? Colors.white
                              : const Color(0xFFB0B8C1),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        child: const Text('이메일 인증하기'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    buildNaverTextField(
                        controller: passwordController,
                        hint: '비밀번호',
                        obscure: true),
                    const SizedBox(height: 10),
                    buildNaverTextField(
                        controller: confirmPasswordController,
                        hint: '비밀번호 확인',
                        obscure: true),
                    const SizedBox(height: 10),
                    buildNaverTextField(
                        controller: nameController, hint: '별명 (중복 불가)'),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE3E5E8)),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: agreeAll,
                                onChanged: (val) {
                                  if (val == null) return;
                                  setState(() {
                                    agreeAll = val;
                                    agree14 = val;
                                    agreeTerms = val;
                                    agreePrivacyMarketing = val;
                                    agreeReceiveInfo = val;
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                                activeColor: Colors.black,
                                checkColor: Colors.white,
                              ),
                              const Text('약관 전체동의',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              const SizedBox(width: 6),
                              const Text('선택항목에 대한 동의 포함',
                                  style: TextStyle(
                                      color: Color(0xFFB0B8C1), fontSize: 13)),
                            ],
                          ),
                          const Divider(color: Color(0xFFE3E5E8), height: 24),
                          buildAgreementCheckbox(
                            value: agree14,
                            labelWidget: const Row(
                              children: [
                                Text('만 14세 이상입니다.',
                                    style: TextStyle(fontSize: 15)),
                                SizedBox(width: 4),
                                Text('(필수)',
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.black)),
                              ],
                            ),
                            onChanged: (val) {
                              if (val == null) return;
                              setState(() {
                                agree14 = val;
                                checkAgreeAll();
                              });
                            },
                          ),
                          buildAgreementCheckbox(
                            value: agreeTerms,
                            labelWidget: const Row(
                              children: [
                                Text('이용약관', style: TextStyle(fontSize: 15)),
                                SizedBox(width: 4),
                                Text('(필수)',
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.black)),
                              ],
                            ),
                            onChanged: (val) {
                              if (val == null) return;
                              setState(() {
                                agreeTerms = val;
                                checkAgreeAll();
                              });
                            },
                            trailing: IconButton(
                              icon: const Icon(Icons.arrow_forward_ios,
                                  size: 16, color: Color(0xFFB0B8C1)),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => const AgreementDialog(
                                    title: '이용약관',
                                    content:
                                        '''1. 서비스 이용에 관한 기본 조건\n2. 회원의 의무와 권리\n3. 서비스 이용 제한 및 해지 등''',
                                  ),
                                );
                              },
                            ),
                          ),
                          buildAgreementCheckbox(
                            value: agreePrivacyMarketing,
                            labelWidget: const Row(
                              children: [
                                Text('개인정보 마케팅 활용 동의',
                                    style: TextStyle(fontSize: 15)),
                                SizedBox(width: 4),
                                Text('(선택)',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFFB0B8C1))),
                              ],
                            ),
                            onChanged: (val) {
                              if (val == null) return;
                              setState(() {
                                agreePrivacyMarketing = val;
                                checkAgreeAll();
                              });
                            },
                            trailing: IconButton(
                              icon: const Icon(Icons.arrow_forward_ios,
                                  size: 16, color: Color(0xFFB0B8C1)),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => const AgreementDialog(
                                    title: '개인정보 마케팅 활용 동의',
                                    content:
                                        '''- 수집하는 개인정보 항목: 이름, 연락처, 이메일 등\n- 마케팅 목적 활용 동의''',
                                  ),
                                );
                              },
                            ),
                          ),
                          buildAgreementCheckbox(
                            value: agreeReceiveInfo,
                            labelWidget: const Row(
                              children: [
                                Expanded(
                                    child: Text(
                                        '이벤트, 쿠폰, 특가 알림 메일, 앱푸시 및 SMS 등 수신',
                                        style: TextStyle(fontSize: 15))),
                                SizedBox(width: 4),
                                Text('(선택)',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFFB0B8C1))),
                              ],
                            ),
                            onChanged: (val) {
                              if (val == null) return;
                              setState(() {
                                agreeReceiveInfo = val;
                                checkAgreeAll();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: agree14 && agreeTerms
                            ? () async {
                                if (passwordController.text !=
                                    confirmPasswordController.text) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('비밀번호가 일치하지 않습니다.')),
                                  );
                                  return;
                                }
                                final user = {
                                  'name': nameController.text,
                                  'birth': birthController.text,
                                  'phone': phoneController.text,
                                  'email': emailController.text,
                                  'username': usernameController.text,
                                  'password': passwordController.text,
                                };
                                await DBHelper.insertUser(user);

                                if (!context.mounted) return;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('회원가입 완료!')),
                                );
                                Navigator.pushReplacementNamed(
                                    context, '/login');
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: agree14 && agreeTerms
                              ? Colors.black
                              : const Color(0xFFF2F3F6),
                          foregroundColor: agree14 && agreeTerms
                              ? Colors.white
                              : const Color(0xFFB0B8C1),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        child: const Text('회원가입'),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    String? hint,
    bool obscure = false,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
    );
  }

  Widget buildAgreementCheckbox({
    required bool value,
    String? label,
    Widget? labelWidget,
    Widget? trailing,
    required ValueChanged<bool?> onChanged,
    bool isBold = false,
  }) {
    Widget effectiveLabel;
    if (labelWidget != null) {
      effectiveLabel = labelWidget;
    } else if (label != null) {
      effectiveLabel = Text(
        label,
        style: TextStyle(
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: Colors.black,
          fontSize: 14,
        ),
      );
    } else {
      effectiveLabel = const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            activeColor: Colors.black,
            checkColor: Colors.white,
          ),
          Expanded(child: effectiveLabel),
          if (trailing != null) trailing,
        ],
      ),
    );
  }
}

class AgreementDialog extends StatelessWidget {
  final String title;
  final String content;

  const AgreementDialog(
      {required this.title, required this.content, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Text(content,
            style: const TextStyle(fontSize: 14, color: Colors.black87)),
      ),
      actions: [
        TextButton(
          child: const Text('닫기'),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }
}
