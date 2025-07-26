import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class RegionSelectScreen extends StatefulWidget {
  const RegionSelectScreen({super.key}); // ← 최신 스타일

  @override
  State<RegionSelectScreen> createState() => _RegionSelectScreenState();
}

class _RegionSelectScreenState extends State<RegionSelectScreen> {
  Future<void> _useCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('위치 권한이 필요합니다.')),
        );
        return;
      }
      Position position = await Geolocator.getCurrentPosition();
      print('position: ${position.latitude}, ${position.longitude}');
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        print('placemark: ${placemark.toString()}');
        // city/district/dong이 비어있을 때 다른 필드도 활용
        String city = placemark.administrativeArea ?? placemark.locality ?? '';
        String district =
            placemark.subAdministrativeArea ?? placemark.subLocality ?? '';
        String dong = placemark.thoroughfare ?? placemark.name ?? '';
        if (city.isEmpty)
          city = placemark.locality ?? placemark.subAdministrativeArea ?? '';
        if (district.isEmpty)
          district = placemark.subLocality ?? placemark.locality ?? '';
        if (dong.isEmpty) dong = placemark.name ?? placemark.thoroughfare ?? '';
        // placemark의 city/locality 조합으로 한글 변환
        String cityKo = city;
        if ((city == 'Gyeonggi-do' && placemark.locality == 'Bucheon') ||
            city == 'Bucheon') cityKo = '경기도 부천시';
        if (city == 'Seoul') cityKo = '서울특별시';
        if (city == 'Incheon') cityKo = '인천광역시';
        if (city == 'Busan') cityKo = '부산광역시';
        if (city == 'Daegu') cityKo = '대구광역시';
        if (city == 'Gwangju') cityKo = '광주광역시';
        if (city == 'Daejeon') cityKo = '대전광역시';
        if (city == 'Ulsan') cityKo = '울산광역시';
        if (city == 'Sejong') cityKo = '세종특별자치시';
        // 동 영문→한글 변환
        String dongKo = dong;
        if (dong == 'Wonmi-dong') dongKo = '원미동';
        // 필요시 추가 맵핑
        print('city: $cityKo, district: $district, dong: $dongKo');
        // 여러 조합으로 매칭 시도
        String matchRegion = '';
        List<String> candidates = [
          '$cityKo $dongKo', // 가장 구체적인 후보를 맨 앞에
          '$cityKo $district $dongKo',
          '$cityKo $district',
          '$cityKo',
          '$district $dongKo',
          '$district',
          '$dongKo',
        ];
        // 1. 정확히 일치하는 지역명 우선 매칭
        matchRegion = regionList.firstWhere(
          (r) => r == '$cityKo $dongKo',
          orElse: () => '',
        );
        // 2. 없으면 기존 방식대로 startsWith로 fallback
        if (matchRegion.isEmpty) {
          for (final candidate in candidates) {
            matchRegion = regionList.firstWhere(
              (r) => r.startsWith(candidate),
              orElse: () => '',
            );
            if (matchRegion.isNotEmpty) break;
          }
        }
        if (matchRegion.isNotEmpty) {
          Navigator.pop(context, matchRegion);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    '현재 위치의 행정동을 찾을 수 없습니다.\nplacemark: ${placemark.toString()}')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('위치 정보를 가져올 수 없습니다: $e')),
      );
    }
  }

  final List<Map<String, dynamic>> cities = [
    {
      'name': '경기도 부천시',
      'subs': [
        '중동',
        '상동',
        '송내동',
        '심곡동',
        '역곡동',
        '춘의동',
        '도당동',
        '약대동',
        '고강동',
        '괴안동',
        '범박동',
        '옥길동',
        '소사본동',
        '원종동',
        '삼정동',
        '내동',
        '여월동',
        '작동',
        '대장동',
        '오정동',
        '원미동' // 추가
      ]
    },
    {
      'name': '서울특별시',
      'subs': ['종로구', '중구', '용산구', '성동구', '광진구']
    },
    {
      'name': '부산광역시',
      'subs': ['중구', '서구', '동구', '영도구', '부산진구']
    },
    {
      'name': '대구광역시',
      'subs': ['중구', '동구', '서구', '남구', '북구']
    },
    {
      'name': '인천광역시',
      'subs': [
        '중구',
        '동구',
        '미추홀구',
        '연수구',
        '남동구',
        '부평구',
        '계양구',
        '서구',
        // 각 구별 동 세분화 (예시)
        '중구 신흥동', '중구 신포동', '중구 운서동',
        '동구 송림동', '동구 송현동',
        '미추홀구 주안동', '미추홀구 관교동', '미추홀구 용현동',
        '연수구 송도동', '연수구 옥련동', '연수구 연수동',
        '남동구 구월동', '남동구 간석동', '남동구 논현동',
        // 부평구 동 전체 세분화
        '부평구 부평1동', '부평구 부평2동', '부평구 부평3동', '부평구 부평4동', '부평구 부평5동', '부평구 부평6동',
        '부평구 갈산1동', '부평구 갈산2동',
        '부평구 삼산1동', '부평구 삼산2동',
        '부평구 부개1동', '부평구 부개2동', '부평구 부개3동',
        '부평구 일신동',
        '부평구 산곡1동', '부평구 산곡2동', '부평구 산곡3동', '부평구 산곡4동',
        '부평구 십정1동', '부평구 십정2동',
        '부평구 청천1동', '부평구 청천2동',
        '계양구 계산동', '계양구 작전동', '계양구 임학동',
        '서구 청라동', '서구 가정동', '서구 석남동',
      ]
    },
    {
      'name': '광주광역시',
      'subs': ['동구', '서구', '남구', '북구', '광산구']
    },
    {
      'name': '대전광역시',
      'subs': ['동구', '중구', '서구', '유성구', '대덕구']
    },
    {
      'name': '울산광역시',
      'subs': ['중구', '남구', '동구', '북구', '울주군']
    },
    {
      'name': '세종특별자치시',
      'subs': ['세종시']
    },
  ];
  List<String> regionList = [];
  List<String> filteredList = [];
  final TextEditingController searchController = TextEditingController();
  String? selectedRegion;

  @override
  void initState() {
    super.initState();
    // 모든 지역을 하나의 리스트로 합침 (ex: 서울특별시 종로구)
    regionList = [
      for (var city in cities)
        for (var sub in city['subs']) '${city['name']} $sub'
    ];
    filteredList = List<String>.from(regionList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('지역 변경', style: TextStyle(color: Colors.black)),
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
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: '지역이나 동네로 검색하기',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  filteredList = regionList
                      .where((region) => region.contains(value))
                      .toList();
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFE5DB),
                foregroundColor: Colors.deepOrange,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onPressed: _useCurrentLocation,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.my_location, color: Colors.deepOrange),
                  SizedBox(width: 8),
                  Text('현재 내 위치 사용하기',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: filteredList.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: Colors.grey[200]),
                itemBuilder: (context, idx) {
                  final region = filteredList[idx];
                  return ListTile(
                    title: Text(region),
                    onTap: () {
                      Navigator.pop(context, region);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
