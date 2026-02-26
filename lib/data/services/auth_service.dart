import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../database/database_helper.dart';
import '../models/app_user.dart';

class AuthService {
  final DatabaseHelper _databaseHelper = Get.find<DatabaseHelper>();

  static const _sessionKey = 'session_user_id';

  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
    required String currencyCode,
  }) async {
    final db = await _databaseHelper.database;

    final existing = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email.trim().toLowerCase()],
      limit: 1,
    );

    if (existing.isNotEmpty) {
      throw Exception('Email already exists.');
    }

    final user = AppUser(
      name: name.trim(),
      email: email.trim().toLowerCase(),
      password: password,
      currencyCode: currencyCode,
    );

    final id = await db.insert('users', user.toMap());
    final created = user.toMap()..['id'] = id;

    await saveSession(id);
    return AppUser.fromMap(created);
  }

  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    final db = await _databaseHelper.database;

    final results = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email.trim().toLowerCase(), password],
      limit: 1,
    );

    if (results.isEmpty) {
      throw Exception('Invalid credentials.');
    }

    final user = AppUser.fromMap(results.first);
    await saveSession(user.id!);
    return user;
  }

  Future<AppUser?> getUserById(int id) async {
    final db = await _databaseHelper.database;
    final results = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (results.isEmpty) {
      return null;
    }

    return AppUser.fromMap(results.first);
  }

  Future<int?> getSessionUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_sessionKey);
  }

  Future<void> saveSession(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_sessionKey, userId);
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }
}
