import 'dart:async';
import 'package:flutter/material.dart';
import '../region_select_screen.dart';

import 'category/furniture_screen.dart'; 
import 'category/clothes_screen.dart';
import 'category/electronics_screen.dart';
import 'category/baby_items_screen.dart';
import 'category/hobby_screen.dart';
import 'category/sports_screen.dart';
import 'category/food_screen.dart';
import 'category/pet_screen.dart';
import 'category/bicycle_screen.dart';
import 'category/book_screen.dart';
import 'category/daily_items_screen.dart';

class UsedScreen extends StatefulWidget {
  @override
  _UsedScreenState createState() => _UsedScreenState();
}

class _UsedScreenState extends State<UsedScreen> {
  final List<String> categories = ['전자제품', '가구', '자전거', '가방', '도서'];
  int currentCategoryIndex = 0;
  Timer? _timer;
  String currentLocation = '부평동';

  final List<Map<String, dynamic>> customCategories = [
    {'name': '가구', 'icon': Icons.chair, 'color': Colors.brown, 'screen': FurnitureScreen()},
    {'name': '의류', 'icon': Icons.checkroom, 'color': Colors.pink, 'screen': ClothingScreen()},
    {'name': '전자제품', 'icon': Icons.tv, 'color': Colors.blue, 'screen': ElectronicsScreen()},
    {'name': '유아용품', 'icon': Icons.child_friendly, 'color': Colors.orange, 'screen': BabyScreen()},
    {'name': '생활용품', 'icon': Icons.kitchen, 'color': Colors.green, 'screen': LivingScreen()},
    {'name': '스포츠/레저', 'icon': Icons.sports_soccer, 'color': Colors.deepPurple, 'screen': SportsScreen()},
    {'name': '식품', 'icon': Icons.fastfood, 'color': Colors.red, 'screen': FoodScreen()},
    {'name': '반려동물', 'icon': Icons.pets, 'color': Colors.teal, 'screen': PetScreen()},
    {'name': '자전거', 'icon': Icons.directions_bike, 'color': Colors.indigo, 'screen': BikeScreen()},
    {'name': '도서', 'icon': Icons.menu_book, 'color': Colors.deepOrange, 'screen': BookScreen()},
    {'name': '게임/취미', 'icon': Icons.videogame_asset, 'color': Colors.purple, 'screen': GameScreen()},
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        currentCategoryIndex = (currentCategoryIndex + 1) % categories.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _selectLocation() async {
    final selectedRegion = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RegionSelectScreen(),
      ),
    );

    if (selectedRegion != null) {
      setState(() {
        currentLocation = selectedRegion;
      });
    }
  }
  

  @override
  Widget build(BuildContext context) {
    String currentCategory = categories[currentCategoryIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('중고', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            TextButton.icon(
              onPressed: _selectLocation,
              icon: Icon(Icons.location_on, color: Colors.black, size: 18),
              label: Text('위치 변경', style: TextStyle(color: Colors.black)),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.black, width: 1),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            )
          ],
        ),
        centerTitle: false,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.black),
                SizedBox(width: 6),
                Text(
                  '$currentLocation 에서',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              '「$currentCategory」 찾고 계신가요?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            SizedBox(height: 24),
            Text(
              '⏳ 중고상품 리스트 UI는 이 아래에 붙일 수 있어요!',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 32),
            Text(
              '카테고리',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: customCategories.map((category) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => category['screen']),
                    );
                  },
                  child: Container(
                    width: 100,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                      color: category['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: category['color'].withOpacity(0.3),
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                      border: Border.all(color: category['color']),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          category['icon'],
                          size: 28,
                          color: category['color'],
                        ),
                        SizedBox(height: 6),
                        Text(
                          category['name'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
