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
        // 스마트 한글 변환 함수
        String convertToKorean(String englishName) {
          // 이미 한글이면 그대로 반환
          if (RegExp(r'[가-힣]').hasMatch(englishName)) return englishName;

          String result = englishName;

          // 1. 기본 패턴 변환
          result = result.replaceAll('-dong', '동');
          result = result.replaceAll('-gu', '구');
          result = result.replaceAll('-si', '시');
          result = result.replaceAll('-gun', '군');
          result = result.replaceAll('-ro', '로');
          result = result.replaceAll('-gil', '길');
          result = result.replaceAll('Street', '로');
          result = result.replaceAll('Road', '로');

          // 2. 주요 지역명 자동 변환
          final Map<String, String> regionMap = {
            'Seoul': '서울',
            'Busan': '부산',
            'Daegu': '대구',
            'Incheon': '인천',
            'Gwangju': '광주',
            'Daejeon': '대전',
            'Ulsan': '울산',
            'Sejong': '세종',
            'Gyeonggi': '경기',
            'Gangwon': '강원',
            'Chungbuk': '충북',
            'Chungnam': '충남',
            'Jeonbuk': '전북',
            'Jeonnam': '전남',
            'Gyeongbuk': '경북',
            'Gyeongnam': '경남',
            'Jeju': '제주',
            'Bucheon': '부천',
            'Suwon': '수원',
            'Yongin': '용인',
            'Goyang': '고양',
            'Changwon': '창원',
            'Seongnam': '성남',
            'Anyang': '안양',
            'Ansan': '안산',
            'Gangnam': '강남',
            'Gangdong': '강동',
            'Gangbuk': '강북',
            'Gangseo': '강서',
            'Gwanak': '관악',
            'Gwangjin': '광진',
            'Guro': '구로',
            'Geumcheon': '금천',
            'Nowon': '노원',
            'Dobong': '도봉',
            'Dongdaemun': '동대문',
            'Dongjak': '동작',
            'Mapo': '마포',
            'Seodaemun': '서대문',
            'Seocho': '서초',
            'Seongdong': '성동',
            'Seongbuk': '성북',
            'Songpa': '송파',
            'Yangcheon': '양천',
            'Yeongdeungpo': '영등포',
            'Yongsan': '용산',
            'Eunpyeong': '은평',
            'Jongno': '종로',
            'Jung': '중',
            'Jungnang': '중랑',
            'Bupyeong': '부평',
            'Wonmi': '원미',
            'Sang': '상',
            'Simgok': '심곡',
            'Yeokgok': '역곡',
            'Sosa': '소사',
            'Ojeong': '오정',
            'Galsan': '갈산',
            'Cheongcheon': '청천',
            'Samsan': '삼산',
          };

          // 3. 단어별 변환 적용
          for (String english in regionMap.keys) {
            result = result.replaceAll(english, regionMap[english]!);
          }

          // 4. 불필요한 접미사 제거
          result = result.replaceAll(' Metropolitan City', '');
          result = result.replaceAll(' Special City', '');
          result = result.replaceAll(' Province', '');
          result = result.replaceAll(' City', '');
          result = result.replaceAll(' County', '');
          result = result.replaceAll(' District', '');

          return result;
        }

        // placemark의 city/district/dong을 한글로 변환
        String cityKo = convertToKorean(city);
        String districtKo = convertToKorean(district);
        String dongKo = convertToKorean(dong);
        // 필요시 추가 맵핑
        print('city: $cityKo, district: $districtKo, dong: $dongKo');
        // 행정동(동)만 반환하도록 수정
        String matchRegion = '';

        // 1. 동 이름이 있으면 동만 반환 (한글로 변환된 것 우선)
        if (dongKo.isNotEmpty) {
          matchRegion = dongKo;
        }
        // 2. 동이 없으면 구/군 이름 반환
        else if (districtKo.isNotEmpty) {
          matchRegion = districtKo;
        }
        // 3. 그것도 없으면 시/도 이름 반환
        else if (cityKo.isNotEmpty) {
          matchRegion = cityKo;
        }

        // 새로운 지역을 최근 목록에 추가
        if (matchRegion.isNotEmpty && !recentRegions.contains(matchRegion)) {
          recentRegions.insert(0, matchRegion);
          if (recentRegions.length > 20)
            recentRegions.removeLast(); // 최대 20개만 유지
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

  // 사용자가 이전에 선택했던 지역들을 저장 (동적으로 추가)
  List<String> recentRegions = [
    '서울특별시 강남구',
    '경기도 부천시',
    '인천광역시 부평구',
    '경기도 안양시',
    '서울특별시 종로구'
  ];
  List<String> filteredList = [];
  final TextEditingController searchController = TextEditingController();
  String? selectedRegion;

  @override
  void initState() {
    super.initState();
    // 최근 지역 목록으로 초기화
    filteredList = List<String>.from(recentRegions);
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
                  filteredList = recentRegions
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
                      // 선택된 지역을 최근 목록에 동적 추가
                      if (!recentRegions.contains(region)) {
                        setState(() {
                          recentRegions.insert(0, region);
                          if (recentRegions.length > 20)
                            recentRegions.removeLast(); // 최대 20개만 유지
                        });
                      } else {
                        // 이미 있는 경우 맨 앞으로 이동
                        setState(() {
                          recentRegions.remove(region);
                          recentRegions.insert(0, region);
                        });
                      }
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
