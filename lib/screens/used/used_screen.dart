import 'dart:async';
import 'package:flutter/material.dart';
import 'region_select_screen.dart';

import '../category/furniture_screen.dart';
import '../category/clothes_screen.dart';
import '../category/electronics_screen.dart';
import '../category/baby_items_screen.dart';
import '../category/hobby_screen.dart';
import '../category/sports_screen.dart';
import '../category/food_screen.dart';
import '../category/pet_screen.dart';
import '../category/bicycle_screen.dart';
import '../category/book_screen.dart';
import '../category/daily_items_screen.dart';
import 'used_item_create_screen.dart';
import 'used_item_detail_screen.dart';
import '../../db_helper.dart';
import '../../global.dart';

class UsedScreen extends StatefulWidget {
  const UsedScreen({super.key}); // const 생성자 및 super.key

  @override
  State<UsedScreen> createState() => _UsedScreenState();
}

class _UsedScreenState extends State<UsedScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isLoggedIn.removeListener(_refreshOnLogin); // 중복 등록 방지
    isLoggedIn.addListener(_refreshOnLogin);
  }

  void _refreshOnLogin() {
    if (mounted) setState(() {});
  }

  // DB에서 불러온 중고글 데이터
  List<Map<String, dynamic>> usedItems = [];
  bool isLoading = true;

  // DB에서 중고글 불러오기
  Future<void> _loadUsedItems() async {
    setState(() {
      isLoading = true;
    });
    final items = await DBHelper.getAllUsedItems();
    setState(() {
      usedItems = items;
      isLoading = false;
    });
  }

  // 글쓰기 완료 후 목록 새로고침 (로그인 체크)
  Future<void> _navigateToCreate() async {
    // main.dart의 isLoggedIn 사용
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    final bool loggedIn = (await Future.value(isLoggedIn.value));
    if (!loggedIn) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인 후 글쓰기가 가능합니다.')),
      );
      // 로그인 화면으로 이동 (원하면 주석 해제)
      Navigator.pushNamed(context, '/login');
      return;
    }
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const UsedItemCreateScreen(),
      ),
    );
    if (result == true) {
      await _loadUsedItems();
    }
  }

  final List<String> categories = ['전자제품', '가구', '자전거', '가방', '도서'];
  int currentCategoryIndex = 0;
  Timer? _timer;
  String currentLocation = '부평동';

  final List<Map<String, dynamic>> customCategories = [
    {
      'name': '가구',
      'icon': Icons.chair,
      'color': Colors.brown,
      'screen': const FurnitureScreen()
    },
    {
      'name': '의류',
      'icon': Icons.checkroom,
      'color': Colors.pink,
      'screen': const ClothingScreen()
    },
    {
      'name': '전자제품',
      'icon': Icons.tv,
      'color': Colors.blue,
      'screen': const ElectronicsScreen()
    },
    {
      'name': '유아용품',
      'icon': Icons.child_friendly,
      'color': Colors.orange,
      'screen': const BabyScreen()
    },
    {
      'name': '생활용품',
      'icon': Icons.kitchen,
      'color': Colors.green,
      'screen': const LivingScreen()
    },
    {
      'name': '스포츠/레저',
      'icon': Icons.sports_soccer,
      'color': Colors.deepPurple,
      'screen': const SportsScreen()
    },
    {
      'name': '식품',
      'icon': Icons.fastfood,
      'color': Colors.red,
      'screen': const FoodScreen()
    },
    {
      'name': '반려동물',
      'icon': Icons.pets,
      'color': Colors.teal,
      'screen': const PetScreen()
    },
    {
      'name': '자전거',
      'icon': Icons.directions_bike,
      'color': Colors.indigo,
      'screen': const BikeScreen()
    },
    {
      'name': '도서',
      'icon': Icons.menu_book,
      'color': Colors.deepOrange,
      'screen': const BookScreen()
    },
    {
      'name': '게임/취미',
      'icon': Icons.videogame_asset,
      'color': Colors.purple,
      'screen': const GameScreen()
    },
    {
      'name': '기타',
      'icon': Icons.more_horiz,
      'color': Colors.grey,
      'screen': const GameScreen() // 임시로 GameScreen 사용, 나중에 별도 화면 만들면 변경
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadUsedItems();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        currentCategoryIndex = (currentCategoryIndex + 1) % categories.length;
      });
    });
  }

  @override
  void dispose() {
    isLoggedIn.removeListener(_refreshOnLogin);
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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('중고',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            TextButton.icon(
              onPressed: _selectLocation,
              icon:
                  const Icon(Icons.location_on, color: Colors.black, size: 18),
              label: const Text('위치 변경', style: TextStyle(color: Colors.black)),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.black, width: 1),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.black),
                      const SizedBox(width: 6),
                      Text(
                        '$currentLocation 에서',
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '「$currentCategory」 찾고 계신가요?',
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '카테고리',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 90,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: customCategories.map((category) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => category['screen']),
                                );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      color:
                                          category['color'].withOpacity(0.12),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: category['color'], width: 2),
                                      boxShadow: [
                                        BoxShadow(
                                          color: category['color']
                                              .withOpacity(0.18),
                                          blurRadius: 4,
                                          offset: const Offset(1, 2),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Icon(
                                        category['icon'],
                                        size: 28,
                                        color: category['color'],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  SizedBox(
                                    width: 64,
                                    child: Text(
                                      category['name'],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // 중고글 리스트
                  if (usedItems.isEmpty)
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: const Text('아직 등록된 중고글이 없습니다.',
                          style: TextStyle(color: Colors.grey)),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: usedItems.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, idx) {
                        final item = usedItems[idx];
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
                            leading: item['images'] != null &&
                                    item['images'].isNotEmpty
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
                                    child: const Icon(Icons.image,
                                        color: Colors.grey, size: 32),
                                  ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        ? Colors.black
                                        : Colors.white,
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    item['productState'] ?? '',
                                    style: TextStyle(
                                      color: item['productState'] == '새상품'
                                          ? Colors.white
                                          : Colors.black,
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
                                    style:
                                        const TextStyle(color: Colors.black54)),
                                const SizedBox(height: 4),
                                if ((item['location'] ?? '')
                                    .toString()
                                    .isNotEmpty)
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
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UsedItemDetailScreen(item: item),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: isLoggedIn,
        builder: (context, loggedIn, _) {
          return FloatingActionButton(
            onPressed: _navigateToCreate,
            backgroundColor: Colors.black,
            tooltip: '중고 글쓰기',
            child: const Icon(Icons.add, color: Colors.white),
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
