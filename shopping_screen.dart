import 'package:flutter/material.dart';

void main() {
  runApp(ShoppingScreen());
}

class ShoppingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
          title: Text('쇼핑'),
          bottom: TabBar(
            tabs: tabs,
            isScrollable: true, // 탭이 많아지면 스크롤 가능
            indicatorColor: Colors.white,
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
    Product(name: 'Item', price: 15000),
    Product(name: 'Item', price: 35000),
    Product(name: 'Item', price: 50000),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: sampleProducts
          .map((product) => Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  //leading: Image.network(product.imageUrl),
                  title: Text(product.name),
                  subtitle: Text('${product.price}원'),
                  trailing: Icon(Icons.shopping_cart_outlined),
                ),
              ))
          .toList(),
    );
  }
}

class Product {
  final String name;
  //final String imageUrl;
  final double price;

  Product({required this.name, required this.price});
}
