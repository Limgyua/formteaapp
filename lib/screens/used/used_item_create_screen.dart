import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import '../../db_helper.dart';
import '../../global.dart';

class UsedItemCreateScreen extends StatefulWidget {
  const UsedItemCreateScreen({super.key});

  @override
  State<UsedItemCreateScreen> createState() => _UsedItemCreateScreenState();
}

class _UsedItemCreateScreenState extends State<UsedItemCreateScreen> {
  @override
  void initState() {
    super.initState();
    priceController.addListener(_formatPriceInput);
  }

  void _formatPriceInput() {
    final text = priceController.text.replaceAll(',', '');
    if (text.isEmpty) return;
    // 숫자가 아니면 리턴
    if (int.tryParse(text) == null) return;
    final formatted = _addCommaToNumber(text);
    if (priceController.text != formatted) {
      final selectionIndex = formatted.length -
          (priceController.text.length - priceController.selection.end);
      priceController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(
            offset: selectionIndex < 0 ? 0 : selectionIndex),
      );
    }
  }

  String _addCommaToNumber(String value) {
    final number = int.tryParse(value);
    if (number == null) return value;
    return number.toString().replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => ',',
        );
  }

  String productState = '중고상품';
  String category = '가구';
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<XFile> images = [];
  String dealType = '판매하기';

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    priceController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('중고 글쓰기',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 사진 추가
            Row(
              children: [
                const Icon(Icons.camera_alt, color: Colors.black, size: 22),
                const SizedBox(width: 8),
                const Text('사진 추가',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black)),
                const Spacer(),
                Text('${images.length}/10',
                    style: const TextStyle(color: Colors.black54)),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final picked = await _picker.pickMultiImage();
                      if (picked.isNotEmpty) {
                        setState(() {
                          images = (images + picked).take(10).toList();
                        });
                      }
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 4,
                            offset: const Offset(1, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.add,
                          size: 32, color: Colors.black38),
                    ),
                  ),
                  ...images.map((img) => Stack(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.black12),
                              image: DecorationImage(
                                image: Image.file(
                                  File(img.path),
                                ).image,
                                fit: BoxFit.cover,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 4,
                                  offset: const Offset(1, 2),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 2,
                            right: 2,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  images.remove(img);
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.close,
                                    color: Colors.white, size: 18),
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Divider(color: Colors.black12, thickness: 1),
            const SizedBox(height: 18),
            // 제목
            const Text('제목',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 8),
            TextField(
              controller: titleController,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintText: '상품 제목을 입력하세요',
                hintStyle: const TextStyle(color: Colors.black38),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
            const SizedBox(height: 20),
            // 자세한 설명
            const Text('자세한 설명',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 8),
            TextField(
              controller: contentController,
              maxLines: 6,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: '상품의 상태, 특징, 거래 희망 조건 등을 자세히 적어주세요.',
                hintStyle: const TextStyle(color: Colors.black38),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
            const SizedBox(height: 20),
            // 상품 상태
            const Text('상품 상태',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: productState,
                  isExpanded: true,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded,
                      color: Colors.black54, size: 28),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  dropdownColor: Colors.white,
                  elevation: 8,
                  menuMaxHeight: 300,
                  items: const [
                    DropdownMenuItem(
                      value: '중고상품',
                      child: Row(
                        children: [
                          Icon(Icons.circle, color: Colors.orange, size: 8),
                          SizedBox(width: 8),
                          Text('중고상품'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: '새상품',
                      child: Row(
                        children: [
                          Icon(Icons.circle, color: Colors.green, size: 8),
                          SizedBox(width: 8),
                          Text('새상품'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: '거의 새것',
                      child: Row(
                        children: [
                          Icon(Icons.circle, color: Colors.lightGreen, size: 8),
                          SizedBox(width: 8),
                          Text('거의 새것'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: '사용감 있음',
                      child: Row(
                        children: [
                          Icon(Icons.circle, color: Colors.amber, size: 8),
                          SizedBox(width: 8),
                          Text('사용감 있음'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: '고장/파손',
                      child: Row(
                        children: [
                          Icon(Icons.circle, color: Colors.red, size: 8),
                          SizedBox(width: 8),
                          Text('고장/파손'),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        productState = newValue;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            // 카테고리
            const Text('카테고리',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: category,
                  isExpanded: true,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded,
                      color: Colors.black54, size: 28),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  dropdownColor: Colors.white,
                  elevation: 8,
                  menuMaxHeight: 300,
                  items: const [
                    DropdownMenuItem(
                      value: '가구',
                      child: Row(
                        children: [
                          Icon(Icons.chair, color: Colors.brown, size: 16),
                          SizedBox(width: 8),
                          Text('가구'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: '의류',
                      child: Row(
                        children: [
                          Icon(Icons.checkroom, color: Colors.purple, size: 16),
                          SizedBox(width: 8),
                          Text('의류'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: '전자제품',
                      child: Row(
                        children: [
                          Icon(Icons.devices, color: Colors.blue, size: 16),
                          SizedBox(width: 8),
                          Text('전자제품'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: '유아용품',
                      child: Row(
                        children: [
                          Icon(Icons.child_care, color: Colors.pink, size: 16),
                          SizedBox(width: 8),
                          Text('유아용품'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: '생활용품',
                      child: Row(
                        children: [
                          Icon(Icons.home, color: Colors.green, size: 16),
                          SizedBox(width: 8),
                          Text('생활용품'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: '스포츠/레저',
                      child: Row(
                        children: [
                          Icon(Icons.sports_soccer,
                              color: Colors.orange, size: 16),
                          SizedBox(width: 8),
                          Text('스포츠/레저'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: '식품',
                      child: Row(
                        children: [
                          Icon(Icons.restaurant, color: Colors.red, size: 16),
                          SizedBox(width: 8),
                          Text('식품'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: '반려동물',
                      child: Row(
                        children: [
                          Icon(Icons.pets, color: Colors.amber, size: 16),
                          SizedBox(width: 8),
                          Text('반려동물'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: '자전거',
                      child: Row(
                        children: [
                          Icon(Icons.directions_bike,
                              color: Colors.teal, size: 16),
                          SizedBox(width: 8),
                          Text('자전거'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: '도서',
                      child: Row(
                        children: [
                          Icon(Icons.menu_book, color: Colors.indigo, size: 16),
                          SizedBox(width: 8),
                          Text('도서'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: '게임/취미',
                      child: Row(
                        children: [
                          Icon(Icons.games, color: Colors.deepPurple, size: 16),
                          SizedBox(width: 8),
                          Text('게임/취미'),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: '기타',
                      child: Row(
                        children: [
                          Icon(Icons.more_horiz, color: Colors.grey, size: 16),
                          SizedBox(width: 8),
                          Text('기타'),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        category = newValue;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            // 거래방식
            const Text('거래방식',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        dealType = '판매하기';
                        // 판매하기 선택 시 가격 입력 가능, 기존 값 유지
                        if (priceController.text == '0')
                          priceController.text = '';
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor:
                          dealType == '판매하기' ? Colors.black : Colors.white,
                      foregroundColor:
                          dealType == '판매하기' ? Colors.white : Colors.black,
                      side: BorderSide(
                          color: dealType == '판매하기'
                              ? Colors.black
                              : Colors.black26),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    child: const Text('판매하기'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        dealType = '나눔하기';
                        // 나눔하기 선택 시 가격 0으로 고정
                        priceController.text = '0';
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor:
                          dealType == '나눔하기' ? Colors.black : Colors.white,
                      foregroundColor:
                          dealType == '나눔하기' ? Colors.white : Colors.black,
                      side: BorderSide(
                          color: dealType == '나눔하기'
                              ? Colors.black
                              : Colors.black26),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    child: const Text('나눔하기'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // 가격
            const Text('가격',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 8),
            dealType == '나눔하기'
                ? Container(
                    width: double.infinity,
                    height: 54,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: const Text(
                      '나눔',
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  )
                : TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.black),
                    enabled: true,
                    decoration: InputDecoration(
                      hintText: '가격을 입력해주세요.',
                      hintStyle: const TextStyle(color: Colors.black38),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      suffixText: '원',
                      suffixStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
            const SizedBox(height: 20),
            // 거래희망장소
            const Text('거래희망장소',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 8),
            TextField(
              controller: locationController,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: '장소를 입력해주세요.',
                hintStyle: const TextStyle(color: Colors.black38),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
            const SizedBox(height: 32),
            // 작성완료 버튼
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () async {
                  // 유효성 검사
                  if (titleController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('제목을 입력해주세요.')),
                    );
                    return;
                  }

                  if (contentController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('상품 설명을 입력해주세요.')),
                    );
                    return;
                  }

                  if (dealType == '판매하기' &&
                      priceController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('가격을 입력해주세요.')),
                    );
                    return;
                  }

                  try {
                    final priceText = dealType == '나눔하기'
                        ? ''
                        : priceController.text.replaceAll(',', '').trim();
                    final item = {
                      'title': titleController.text.trim(),
                      'content': contentController.text.trim(),
                      'price': priceText,
                      'location': locationController.text.trim(),
                      'images': images.isNotEmpty
                          ? images.map((x) => File(x.path)).toList()
                          : [],
                      'productState': productState,
                      'category': category,
                      'dealType': dealType,
                      // 로그인한 사용자의 별명(userName.value)만 저장
                      'author': userName.value,
                      'createdAt': DateTime.now().toIso8601String(),
                    };

                    // DB에 저장
                    await DBHelper.insertUsedItem(item);

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('글이 등록되었습니다.')),
                      );
                      Navigator.pop(context, true);
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('오류가 발생했습니다: $e')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text('작성완료'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
