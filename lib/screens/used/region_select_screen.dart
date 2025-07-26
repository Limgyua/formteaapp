import 'package:flutter/material.dart';

class RegionSelectScreen extends StatefulWidget {
  const RegionSelectScreen({super.key}); // ← 최신 스타일

  @override
  State<RegionSelectScreen> createState() => _RegionSelectScreenState();
}

class _RegionSelectScreenState extends State<RegionSelectScreen> {
  final List<Map<String, dynamic>> cities = [
    {
      'code': '11',
      'name': '서울특별시',
      'subs': ['종로구', '중구', '용산구', '성동구', '광진구']
    },
    {
      'code': '26',
      'name': '부산광역시',
      'subs': ['중구', '서구', '동구', '영도구', '부산진구']
    },
    {
      'code': '27',
      'name': '대구광역시',
      'subs': ['중구', '동구', '서구', '남구', '북구']
    },
    {
      'code': '28',
      'name': '인천광역시',
      'subs': ['중구', '동구', '미추홀구', '연수구', '남동구']
    },
    {
      'code': '29',
      'name': '광주광역시',
      'subs': ['동구', '서구', '남구', '북구', '광산구']
    },
    {
      'code': '30',
      'name': '대전광역시',
      'subs': ['동구', '중구', '서구', '유성구', '대덕구']
    },
    {
      'code': '31',
      'name': '울산광역시',
      'subs': ['중구', '남구', '동구', '북구', '울주군']
    },
    {
      'code': '36',
      'name': '세종특별자치시',
      'subs': ['세종시']
    },
    // ... 필요시 추가 ...
  ];
  List<String> subRegionList = [];
  String? selectedCityCode;
  String? selectedCityName;
  String? selectedSubRegion;

  @override
  void initState() {
    super.initState();
    // 기본값 세팅
    if (cities.isNotEmpty) {
      selectedCityCode = cities[0]['code'];
      selectedCityName = cities[0]['name'];
      subRegionList = List<String>.from(cities[0]['subs']);
      selectedSubRegion = subRegionList.isNotEmpty ? subRegionList[0] : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('지역 선택', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('시/도',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedCityCode,
              isExpanded: true,
              items: cities.map((city) {
                return DropdownMenuItem<String>(
                  value: city['code'],
                  child: Text(city['name']),
                );
              }).toList(),
              onChanged: (value) {
                final city = cities.firstWhere((c) => c['code'] == value);
                setState(() {
                  selectedCityCode = value;
                  selectedCityName = city['name'];
                  subRegionList = List<String>.from(city['subs']);
                  selectedSubRegion =
                      subRegionList.isNotEmpty ? subRegionList[0] : null;
                });
              },
            ),
            const SizedBox(height: 30),
            const Text('시/군/구',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: subRegionList.contains(selectedSubRegion)
                  ? selectedSubRegion
                  : (subRegionList.isNotEmpty ? subRegionList[0] : null),
              isExpanded: true,
              hint: const Text('시/군/구 선택'),
              items: subRegionList.map((sub) {
                return DropdownMenuItem<String>(
                  value: sub,
                  child: Text(sub),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSubRegion = value;
                });
                if (value != null) {
                  Navigator.pop(context, '${selectedCityName ?? ''} $value');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
