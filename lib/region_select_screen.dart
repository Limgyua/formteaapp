import 'package:flutter/material.dart';

// 시/도 리스트
final List<String> cities = [
  '서울특별시',
  '인천광역시',
  '부산광역시',
  '대구광역시',
  '대전광역시',
  '울산광역시',
  '세종특별자치시',
  '경기도',
  '강원도',
  '충청북도',
  '충청남도',
  '전라북도',
  '전라남도',
  '경상북도',
  '경상남도',
  '제주특별자치도',
];

// 구/군/읍/면/동 데이터
final Map<String, List<String>> subRegions = {
  '서울특별시': ['강남구', '강동구', '강북구', '강서구', '관악구'],
  '인천광역시': ['부평구', '계양구', '서구', '연수구', '남동구'],
  '경기도': ['수원시', '성남시', '고양시', '용인시', '부천시'],
  '전라남도': ['목포시', '여수시', '순천시', '나주시', '광양시'],
  '전라북도': ['전주시', '군산시', '익산시', '정읍시', '남원시'],
};

class RegionSelectScreen extends StatefulWidget {
  const RegionSelectScreen({Key? key}) : super(key: key);

  @override
  State<RegionSelectScreen> createState() => _RegionSelectScreenState();
}

class _RegionSelectScreenState extends State<RegionSelectScreen> {
  String selectedCity = cities[0];  // 기본 선택 시/도

  @override
  Widget build(BuildContext context) {
    final subRegionList = subRegions[selectedCity] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('지역 선택', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        elevation: 1,
      ),
      body: Row(
        children: [
          // 왼쪽 시/도 리스트
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
            ),
            child: ListView.builder(
              itemCount: cities.length,
              itemBuilder: (context, index) {
                final city = cities[index];
                final isSelected = city == selectedCity;

                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedCity = city;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                    color: isSelected ? Colors.grey.shade300 : Colors.white,
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_city,
                          color: isSelected ? Colors.grey.shade700 : Colors.grey,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            city,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? Colors.grey.shade700 : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // 오른쪽 하위 지역 리스트
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
                itemCount: subRegionList.length,
                itemBuilder: (context, index) {
                  final subRegion = subRegionList[index];

                  return ListTile(
                    title: Text(subRegion),
                    onTap: () {
                     
                      Navigator.pop(context, '$selectedCity $subRegion');
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
