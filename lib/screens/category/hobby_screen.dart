import 'package:flutter/material.dart';
import '../../db_helper.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<Map<String, dynamic>> gameItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGameItems();
  }

  Future<void> _loadGameItems() async {
    setState(() {
      isLoading = true;
    });
    final items = await DBHelper.getUsedItemsByCategory('게임/취미');
    setState(() {
      gameItems = items;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('게임/취미',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : gameItems.isEmpty
              ? const Center(
                  child: Text('아직 등록된 게임/취미 상품이 없습니다.',
                      style: TextStyle(color: Colors.grey, fontSize: 16)))
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: gameItems.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, idx) {
                    final item = gameItems[idx];
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
                                    child: const Icon(Icons.videogame_asset,
                                        color: Colors.purple, size: 32),
                                  ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                item['title'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: item['productState'] == '새상품'
                                    ? Colors.purple
                                    : Colors.white,
                                border: Border.all(color: Colors.purple),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item['productState'] ?? '',
                                style: TextStyle(
                                  color: item['productState'] == '새상품'
                                      ? Colors.white
                                      : Colors.purple[700],
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
                            if ((item['location'] ?? '').toString().isNotEmpty)
                              Text(item['location'],
                                  style: const TextStyle(
                                      color: Colors.black54, fontSize: 13)),
                            Text(priceText,
                                style: TextStyle(
                                    color: priceText == '나눔'
                                        ? Colors.green
                                        : Colors.purple[700],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                          ],
                        ),
                        onTap: () {},
                      ),
                    );
                  },
                ),
    );
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
}
