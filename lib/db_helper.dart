import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'users.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, birth TEXT, phone TEXT, email TEXT, username TEXT, password TEXT)',
        );
      },
      version: 1,
    );
  }

  static Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await DBHelper.database();
    await db.insert('users', user, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await DBHelper.database();
    return db.query('users');
  }

  static Future<Map<String, dynamic>?> loginUser(String username, String password) async {
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

  static Future<Map<String, dynamic>?> getUserByUsername(String username) async {
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