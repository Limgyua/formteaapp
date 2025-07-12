import 'package:flutter/material.dart';
import 'package:formteaapp/main.dart';
import 'package:intl/intl.dart';

class ShoppingScreen extends StatelessWidget {
  const ShoppingScreen({super.key}); // const 생성자 및 super.key

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: ShoppingPage(),
    );
  }
}

class ShoppingPage extends StatelessWidget {
  final List<Tab> tabs = [
    Tab(text: '상의'),
    Tab(text: '하의'),
    Tab(text: '원피스'),
    Tab(text: '자켓'),
    Tab(text: '신발'),
    Tab(text: '액세서리'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // 홈으로 이동 (스택 모두 제거 후 이동)
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (route) => false,
              );
            },
          ),
          title: Text('쇼핑'),
          bottom: TabBar(
            tabs: tabs,
            isScrollable: true, // 탭이 많아지면 스크롤 가능
            indicatorColor: Colors.white,
            labelPadding: EdgeInsets.symmetric(horizontal: 8),
          ),
        ),
        body: TabBarView(
          children: [
            ProductListPage(category: '상의'),
            ProductListPage(category: '하의'),
            ProductListPage(category: '원피스'),
            ProductListPage(category: '자켓'),
            ProductListPage(category: '신발'),
            ProductListPage(category: '액세서리'),
          ],
        ),
      ),
    );
  }
}

class ProductListPage extends StatelessWidget {
  final String category;

  ProductListPage({required this.category});

  final List<Product> sampleProducts = [
    Product(name: 'Item', imageUrl: "", price: 15000),
    Product(name: 'Item', imageUrl: "", price: 35000),
    Product(name: 'Item', imageUrl: "", price: 50000),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: sampleProducts
          .map((product) => Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  leading: SizedBox(
                    width: 60,
                    height: 60,
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(8), // 이미지 모서리 둥글게 (선택)
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover, // 꽉 차게 자르기
                      ),
                    ),
                  ),
                  title: Text(product.name),
                  subtitle:
                      Text('${NumberFormat('#,###').format(product.price)}원'),
                  trailing: Icon(Icons.shopping_cart_outlined),
                ),
              ))
          .toList(),
    );
  }
}

class Product {
  final String name;
  final String imageUrl;
  final double price;

  Product({required this.name, required this.imageUrl, required this.price});
}
