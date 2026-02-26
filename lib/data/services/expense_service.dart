import 'package:get/get.dart';

import '../database/database_helper.dart';
import '../models/expense.dart';

class ExpenseService {
  final DatabaseHelper _databaseHelper = Get.find<DatabaseHelper>();

  Future<List<Expense>> getExpensesForUser(int userId) async {
    final db = await _databaseHelper.database;

    final results = await db.query(
      'expenses',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );

    return results.map(Expense.fromMap).toList();
  }

  Future<int> addExpense(Expense expense) async {
    final db = await _databaseHelper.database;
    return db.insert('expenses', expense.toMap());
  }

  Future<int> updateExpense(Expense expense) async {
    final db = await _databaseHelper.database;
    return db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<int> deleteExpense(int id) async {
    final db = await _databaseHelper.database;
    return db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }
}
