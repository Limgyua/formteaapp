import 'package:flutter/material.dart';
import 'dart:io';
import '../../db_helper.dart';

class FurnitureScreen extends StatefulWidget {
  const FurnitureScreen({super.key});

  @override
  State<FurnitureScreen> createState() => _FurnitureScreenState();
}

class _FurnitureScreenState extends State<FurnitureScreen> {
  List<Map<String, dynamic>> furnitureItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFurnitureItems();
  }

  Future<void> _loadFurnitureItems() async {
    setState(() {
      isLoading = true;
    });
    final items = await DBHelper.getUsedItemsByCategory('가구');
    setState(() {
      furnitureItems = items;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('가구',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : furnitureItems.isEmpty
              ? const Center(
                  child: Text('아직 등록된 가구 상품이 없습니다.',
                      style: TextStyle(color: Colors.grey, fontSize: 16)))
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: furnitureItems.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, idx) {
                    final item = furnitureItems[idx];
                    // 가격 표시 포맷
                    String priceText = '';
                    final price = item['price'];
                    if (price == null ||
                        price == 0 ||
                        price.toString().trim().isEmpty) {
                      priceText = '나눔';
                    } else {
                      priceText = '${_formatPrice(price)}원';
                    }
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.black12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 4,
                            offset: const Offset(1, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading:
                            item['images'] != null && item['images'].isNotEmpty
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      item['images'][0],
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(Icons.chair,
                                        color: Colors.brown, size: 32),
                                  ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'] ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: item['productState'] == '새상품'
                                    ? Colors.brown
                                    : Colors.white,
                                border: Border.all(color: Colors.brown),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item['productState'] ?? '',
                                style: TextStyle(
                                  color: item['productState'] == '새상품'
                                      ? Colors.white
                                      : Colors.brown,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('글쓴이: ${item['author'] ?? '익명'}',
                                style: const TextStyle(color: Colors.black54)),
                            const SizedBox(height: 4),
                            if ((item['location'] ?? '').toString().isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  item['location'],
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            Text(
                              priceText,
                              style: TextStyle(
                                color: priceText == '나눔'
                                    ? Colors.green
                                    : Colors.brown,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {},
                      ),
                    );
                  },
                ),
    );
  }

  // 가격 쉼표 포맷 함수
  String _formatPrice(dynamic price) {
    if (price == null) return '';
    try {
      final intPrice =
          price is int ? price : int.tryParse(price.toString()) ?? 0;
      return intPrice.toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},',
          );
    } catch (e) {
      return price.toString();
    }
  }
}
