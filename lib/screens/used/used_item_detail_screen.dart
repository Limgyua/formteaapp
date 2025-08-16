import 'package:flutter/material.dart';
import 'dart:io';
import '../chat/chat_screen.dart';
import '../chat/chat_list_screen.dart';
import '../../global.dart';
import '../../db_helper.dart';

class UsedItemDetailScreen extends StatelessWidget {
  final Map<String, dynamic> item;

  const UsedItemDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // images 처리를 안전하게 수정
    final imagesList = item['images'] as List<dynamic>? ?? [];
    final images = imagesList.cast<File>();
    final price = item['price'];
    String priceText = '';

    if (price == null || price == 0 || price.toString().trim().isEmpty) {
      priceText = '나눔';
    } else {
      priceText = '${_formatPrice(price)}원';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // 공유 기능 구현 가능
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // 더보기 메뉴 구현 가능
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 이미지 섹션
          Container(
            height: 300,
            width: double.infinity,
            color: Colors.grey[100],
            child: images.isNotEmpty
                ? PageView.builder(
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return Image.file(
                        images[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    },
                  )
                : const Center(
                    child: Icon(
                      Icons.image,
                      size: 80,
                      color: Colors.grey,
                    ),
                  ),
          ),

          // 이미지 인디케이터
          if (images.length > 1)
            Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),
            ),

          // 상품 정보 섹션
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 제목과 가격
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item['title'] ?? '제목 없음',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStateColor(item['productState']),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item['productState'] ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // 카테고리
                  if (item['category'] != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item['category'],
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 12,
                        ),
                      ),
                    ),

                  const SizedBox(height: 12),

                  // 가격
                  Text(
                    priceText,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: priceText == '나눔' ? Colors.green : Colors.black,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 위치 정보
                  if (item['location'] != null &&
                      item['location'].toString().isNotEmpty)
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          item['location'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 16),

                  // 구분선
                  Divider(color: Colors.grey[300]),

                  const SizedBox(height: 16),

                  // 판매자 정보
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.grey[300],
                        child: const Icon(Icons.person, color: Colors.grey),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['author'] ?? '익명',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            if (item['createdAt'] != null)
                              Text(
                                _formatDate(item['createdAt']),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // 구분선
                  Divider(color: Colors.grey[300]),

                  const SizedBox(height: 16),

                  // 상품 설명
                  const Text(
                    '상품 설명',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    item['content'] ?? '상품 설명이 없습니다.',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  const SizedBox(height: 100), // 하단 버튼 공간 확보
                ],
              ),
            ),
          ),
        ],
      ),

      // 하단 고정 버튼
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            // 찜하기 버튼
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {
                  // 찜하기 기능 구현 가능
                },
              ),
            ),

            const SizedBox(width: 12),

            // 판매자일 때 '채팅보기' 버튼, 구매자일 때 '채팅하기' 버튼
            Expanded(
              child: Builder(
                builder: (context) {
                  final myId = userId.value;
                  final sellerId = item['author'];
                  if (myId != null && myId == sellerId) {
                    // 판매자라면 '채팅보기' 버튼
                    return ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatListScreen(
                              filterItemId: item['id']?.toString(),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        '채팅보기',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  } else {
                    // 구매자라면 기존 '채팅하기' 버튼
                    return ElevatedButton(
                      onPressed: () async {
                        String sellerName = item['author'] ?? '익명';
                        if (item['author'] != null) {
                          final sellerInfo =
                              await DBHelper.getUserByUsername(item['author']);
                          if (sellerInfo != null) {
                            sellerName = sellerInfo['name'] ??
                                sellerInfo['username'] ??
                                '익명';
                          }
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              item: item,
                              sellerName: sellerName,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        '채팅하기',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStateColor(String? state) {
    switch (state) {
      case '새상품':
        return Colors.blue;
      case '거의새것':
        return Colors.green;
      case '좋음':
        return Colors.orange;
      case '나쁨':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

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

  String _formatDate(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return '${difference.inDays}일 전';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}시간 전';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}분 전';
      } else {
        return '방금 전';
      }
    } catch (e) {
      return dateString;
    }
  }
}
