import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool agreeAll = false;
  bool agree14 = false;
  bool agreeTerms = false;
  bool agreePrivacyMarketing = false;
  bool agreeReceiveInfo = false;

  @override
  Widget build(BuildContext context) {
    // 화면 너비 제한용 maxWidth 설정 (예: 400)
    double maxWidth = 400;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center( // 화면 가운데 정렬
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '회원가입',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 32),
                  buildLabel('이름'),
                  buildTextField(controller: nameController, hint: '이름 입력'),
                  SizedBox(height: 16),
                  buildLabel('생년월일 (YYYYMMDD)'),
                  buildTextField(controller: birthController, hint: '예) 19900101', keyboardType: TextInputType.number),
                  SizedBox(height: 16),
                  buildLabel('연락처'),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: buildTextField(controller: phoneController, hint: '연락처 입력', keyboardType: TextInputType.phone),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            print("인증번호 전송");
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text("인증", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 16),
                  buildLabel('이메일'),
                  buildTextField(controller: emailController, hint: '이메일 입력', keyboardType: TextInputType.emailAddress),
                  SizedBox(height: 16),
                  buildLabel('아이디'),
                  buildTextField(controller: usernameController, hint: '아이디 입력'),
                  SizedBox(height: 16),
                  buildLabel('비밀번호'),
                  buildTextField(controller: passwordController, hint: '비밀번호 입력', obscure: true),
                  SizedBox(height: 16),
                  buildLabel('비밀번호 확인'),
                  buildTextField(controller: confirmPasswordController, hint: '비밀번호 재입력', obscure: true),
                  SizedBox(height: 24),

                  // 약관동의
                  buildAgreementCheckbox(
                    value: agreeAll,
                    label: '전체 동의',
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
                    isBold: true,
                  ),
                  Divider(color: Colors.grey.shade300),
                  buildAgreementCheckbox(
                    value: agree14,
                    labelWidget: Row(
                      children: [
                        Text('만 14세 이상입니다', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                        SizedBox(width: 4),
                        Text('(필수)', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
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
                    labelWidget: Row(
                      children: [
                        Text('이용약관', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                        SizedBox(width: 4),
                        Text('(필수)', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
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
                      icon: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AgreementDialog(
                            title: '이용약관',
                            content: '''1. 서비스 이용에 관한 기본 조건
2. 회원의 권리와 의무
3. 개인정보 보호 및 처리 방침
4. 서비스 이용 제한 및 계약 해지 조건
5. 면책 조항 및 분쟁 해결''',
                          ),
                        );
                      },
                    ),
                  ),
                  buildAgreementCheckbox(
                    value: agreePrivacyMarketing,
                    labelWidget: Row(
                      children: [
                        Text('개인정보 마케팅 활용 동의',
                            style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black)),
                        SizedBox(width: 4),
                        Text('(선택)', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
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
                      icon: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AgreementDialog(
                            title: '개인정보 마케팅 활용 동의',
                            content: '''- 수집하는 개인정보 항목
- 개인정보의 수집 및 이용 목적
- 마케팅 정보 수신 동의 및 철회 방법
- 개인정보 보유 및 이용 기간''',
                          ),
                        );
                      },
                    ),
                  ),
                  buildAgreementCheckbox(
                    value: agreeReceiveInfo,
                    labelWidget: Row(
                      children: [
                        Text('이벤트, 쿠폰, 특가, 알림 메일 및 SMS 등 수신',
                            style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black)),
                        SizedBox(width: 4),
                        Text('(선택)', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
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
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: agree14 && agreeTerms
                        ? () {
                            print("회원가입 시도");
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      elevation: (agree14 && agreeTerms) ? 4 : 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text("회원가입", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void checkAgreeAll() {
    setState(() {
      agreeAll = agree14 && agreeTerms && agreePrivacyMarketing && agreeReceiveInfo;
    });
  }

  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(
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
        hintStyle: TextStyle(color: Colors.grey[500]),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
          borderSide: BorderSide(color: Colors.black),
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
      effectiveLabel = SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
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

  AgreementDialog({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Text(content, style: TextStyle(fontSize: 14, color: Colors.black87)),
      ),
      actions: [
        TextButton(
          child: Text('닫기'),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }
}
