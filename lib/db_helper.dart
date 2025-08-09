import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

class DBHelper {
  // 아이디(username)로 로그인
  static Future<Map<String, dynamic>?> loginUserByUsername(
      String username, String password) async {
    final db = await DBHelper.database();
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  // 중고글 테이블 생성 (이미 있으면 무시)
  static Future<void> createUsedTable(Database db) async {
    await db.execute(
      'CREATE TABLE IF NOT EXISTS used_items ('
      'id INTEGER PRIMARY KEY AUTOINCREMENT, '
      'title TEXT, content TEXT, price TEXT, location TEXT, '
      'imagePaths TEXT, productState TEXT, category TEXT, dealType TEXT, author TEXT, createdAt TEXT'
      ')',
    );
  }

  static Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'users.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, birth TEXT, phone TEXT, email TEXT, username TEXT, password TEXT)',
        );
        await createUsedTable(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // 기존 테이블에 category 컬럼 추가
          await db.execute('ALTER TABLE used_items ADD COLUMN category TEXT');
        }
      },
      version: 2,
    );
  }

  // 중고글 저장
  static Future<void> insertUsedItem(Map<String, dynamic> item) async {
    final db = await DBHelper.database();
    // 이미지 경로 리스트를 문자열로 변환 (구분자: |)
    final images = item['images'] ?? [];
    final imagePaths =
        images.isNotEmpty ? images.map((f) => f.path).join('|') : '';
    final data = Map<String, dynamic>.from(item);
    data['imagePaths'] = imagePaths;
    data.remove('images');
    await db.insert('used_items', data);
  }

  // 중고글 전체 조회 (최신순)
  static Future<List<Map<String, dynamic>>> getAllUsedItems() async {
    final db = await DBHelper.database();
    final result = await db.query('used_items', orderBy: 'id DESC');
    // imagePaths를 images(List<File>)로 변환해서 반환
    return result.map((row) {
      final paths = (row['imagePaths'] ?? '').toString();
      final images = paths.isNotEmpty ? paths.split('|') : [];
      return {
        ...row,
        'images': images.isNotEmpty ? images.map((p) => File(p)).toList() : [],
      };
    }).toList();
  }

  // 카테고리별 중고글 조회 (최신순)
  static Future<List<Map<String, dynamic>>> getUsedItemsByCategory(
      String category) async {
    final db = await DBHelper.database();
    final result = await db.query('used_items',
        where: 'category = ?', whereArgs: [category], orderBy: 'id DESC');
    // imagePaths를 images(List<File>)로 변환해서 반환
    return result.map((row) {
      final paths = (row['imagePaths'] ?? '').toString();
      final images = paths.isNotEmpty ? paths.split('|') : [];
      return {
        ...row,
        'images': images.isNotEmpty ? images.map((p) => File(p)).toList() : [],
      };
    }).toList();
  }

  static Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await DBHelper.database();
    await db.insert('users', user);
  }

  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await DBHelper.database();
    return db.query('users');
  }

  static Future<Map<String, dynamic>?> loginUser(
      String email, String password) async {
    final db = await DBHelper.database();
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  static Future<Map<String, dynamic>?> getUserByUsername(
      String username) async {
    final db = await DBHelper.database();
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  static Future<void> updateUser(Map<String, dynamic> user) async {
    final db = await DBHelper.database();
    await db.update(
      'users',
      {
        'name': user['name'],
        'birth': user['birth'],
        'password': user['password'],
      },
      where: 'id = ?',
      whereArgs: [user['id']],
    );
  }

  static Future<void> deleteUser(int id) async {
    final db = await DBHelper.database();
    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
