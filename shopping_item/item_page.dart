import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Product {
  final String name;
  final int price;
  final String imageUrl;

  Product({required this.name, required this.price, required this.imageUrl});
}

class ItemPage extends StatelessWidget {
  final Product product;

  const ItemPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("제품상세"),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 80), // 하단 버튼 공간 확보
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.imageUrl,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              product.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              '${NumberFormat('#,###').format(product.price)}원',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // 장바구니 추가 로직
                },
                icon: Icon(Icons.shopping_cart_outlined),
                label: Text("장바구니"),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // 구매 로직
                },
                child: Text("구입하기"),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color.fromARGB(255, 69, 49, 220), // 버튼 배경색
                  foregroundColor: Colors.white, // 글자색
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
