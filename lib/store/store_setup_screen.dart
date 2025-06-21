import 'package:flutter/material.dart';
import 'business_number_guide_screen.dart'; // 가이드 페이지 import

class StoreSetupScreen extends StatefulWidget {
  @override
  _StoreSetupScreenState createState() => _StoreSetupScreenState();
}

class _StoreSetupScreenState extends State<StoreSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  String storeName = '';
  String businessNumber = '';

  // 매장 크기 및 가격 맵
  final Map<String, int> storeSizes = {
    '3평': 0,
    '5평': 300,
    '10평': 500,
    '15평': 1000,
    '20평': 1300,
    '25평': 1500,
    '무제한': 4000,
  };
  String selectedStoreSize = '3평';

  // 간판 디자인 옵션과 가격
  final Map<String, int> signboards = {
    '민자(무료)': 0,
    '돌출': 100,
    '돌출 + LED': 200,
    '돌출 + LED + 서치 라이트': 300,
  };
  String selectedSignboard = '민자(무료)';

  // 광고 배너 노출 여부
  bool showAdBanner = false;
  final int adBannerPrice = 2000;

  @override
  Widget build(BuildContext context) {
    int storeSizePrice = storeSizes[selectedStoreSize] ?? 0;
    int signboardPrice = signboards[selectedSignboard] ?? 0;
    int totalPrice = storeSizePrice + signboardPrice + (showAdBanner ? adBannerPrice : 0);

    return Scaffold(
      appBar: AppBar(
        title: Text('개인 매장 개설하기'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: '매장 이름'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '매장 이름을 입력하세요';
                  }
                  return null;
                },
                onSaved: (value) => storeName = value ?? '',
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: '사업자 등록번호'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '사업자 등록번호를 입력하세요';
                  }
                  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    return '유효한 10자리 숫자를 입력하세요';
                  }
                  return null;
                },
                onSaved: (value) => businessNumber = value ?? '',
              ),
              SizedBox(height: 4),

              // 가이드 작은 글씨 버튼
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => BusinessNumberGuideScreen()),
                    );
                  },
                  child: Text(
                    'GATE ai 사업자 쇼핑몰 가이드 >',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24),

              Text('매장 크기 선택 (가격 단위: 원)', style: TextStyle(fontWeight: FontWeight.bold)),
              ...storeSizes.entries.map((entry) {
                return RadioListTile<String>(
                  title: Text('${entry.key} (${entry.value == 0 ? "무료" : "${entry.value}원"})'),
                  value: entry.key,
                  groupValue: selectedStoreSize,
                  onChanged: (value) {
                    setState(() {
                      selectedStoreSize = value ?? '3평';
                    });
                  },
                );
              }).toList(),

              SizedBox(height: 24),
              Text('간판 디자인 선택 (가격 단위: 원)', style: TextStyle(fontWeight: FontWeight.bold)),
              ...signboards.entries.map((entry) {
                return RadioListTile<String>(
                  title: Text('${entry.key} (${entry.value == 0 ? "무료" : "${entry.value}원"})'),
                  value: entry.key,
                  groupValue: selectedSignboard,
                  onChanged: (value) {
                    setState(() {
                      selectedSignboard = value ?? '민자(무료)';
                    });
                  },
                );
              }).toList(),

              SizedBox(height: 24),
              CheckboxListTile(
                title: Text('광고 배너에 노출하기 (2,000원)'),
                value: showAdBanner,
                onChanged: (value) {
                  setState(() {
                    showAdBanner = value ?? false;
                  });
                },
              ),

              SizedBox(height: 24),
              Text('총 예상 비용: $totalPrice 원', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

              SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                child: Text('개설 신청'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // TODO: 실제 서버 연동 로직 작성
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('신청 완료'),
                        content: Text('매장 개설 신청이 접수되었습니다.\n\n'
                            '매장명: $storeName\n'
                            '사업자번호: $businessNumber\n'
                            '매장 크기: $selectedStoreSize\n'
                            '간판 디자인: $selectedSignboard\n'
                            '광고 배너 노출: ${showAdBanner ? "예" : "아니오"}\n'
                            '총 비용: $totalPrice 원'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // 다이얼로그 닫기
                              Navigator.pop(context); // 화면 닫기
                            },
                            child: Text('확인'),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
