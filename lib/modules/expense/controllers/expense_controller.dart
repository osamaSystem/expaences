import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/app_user.dart';
import '../../../data/models/expense.dart';
import '../../../data/services/expense_service.dart';
import '../../../data/services/export_service.dart';
import '../../auth/controllers/auth_controller.dart';

class ExpenseController extends GetxController {
  final ExpenseService _expenseService = Get.find<ExpenseService>();
  final ExportService _exportService = Get.find<ExportService>();
  final AuthController _authController = Get.find<AuthController>();

  final expenses = <Expense>[].obs;
  final isLoading = false.obs;

  final selectedMonth = Rxn<DateTime>();
  final selectedCategory = Rxn<ExpenseCategory>();
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    ever<AppUser?>(_authController.currentUser, (_) {
      loadExpenses();
    });
    loadExpenses();
  }

  int? get _currentUserId => _authController.currentUser.value?.id;

  Future<void> loadExpenses() async {
    final userId = _currentUserId;
    if (userId == null) {
      expenses.clear();
      return;
    }

    isLoading.value = true;
    try {
      final data = await _expenseService.getExpensesForUser(userId);
      expenses.assignAll(data);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addExpense({
    required String title,
    required double amount,
    required ExpenseCategory category,
    required DateTime date,
    String? note,
  }) async {
    final userId = _currentUserId;
    if (userId == null) {
      return;
    }

    final expense = Expense(
      userId: userId,
      title: title,
      amount: amount,
      category: category,
      date: date,
      note: note,
    );

    await _expenseService.addExpense(expense);
    await loadExpenses();
    Get.snackbar('Success', 'Expense added successfully.');
  }

  Future<void> updateExpense(Expense expense) async {
    await _expenseService.updateExpense(expense);
    await loadExpenses();
    Get.snackbar('Updated', 'Expense updated successfully.');
  }

  Future<void> deleteExpense(int expenseId) async {
    await _expenseService.deleteExpense(expenseId);
    await loadExpenses();
    Get.snackbar('Deleted', 'Expense deleted successfully.');
  }

  void clearFilters() {
    selectedMonth.value = null;
    selectedCategory.value = null;
    searchQuery.value = '';
  }

  List<Expense> get filteredExpenses {
    final query = searchQuery.value.trim().toLowerCase();

    return expenses.where((expense) {
      final categoryMatch = selectedCategory.value == null ||
          expense.category == selectedCategory.value;

      final month = selectedMonth.value;
      final monthMatch = month == null ||
          (expense.date.month == month.month &&
              expense.date.year == month.year);

      final queryMatch = query.isEmpty ||
          expense.title.toLowerCase().contains(query) ||
          (expense.note?.toLowerCase().contains(query) ?? false);

      return categoryMatch && monthMatch && queryMatch;
    }).toList();
  }

  double get totalExpenses =>
      expenses.fold(0.0, (sum, expense) => sum + expense.amount);

  double get monthlyTotal {
    final month = selectedMonth.value ?? DateTime.now();
    return expenses
        .where(
          (expense) =>
              expense.date.month == month.month &&
              expense.date.year == month.year,
        )
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }

  Map<ExpenseCategory, double> get categoryTotals {
    final totals = <ExpenseCategory, double>{
      for (final category in ExpenseCategory.values) category: 0,
    };

    for (final expense in filteredExpenses) {
      totals.update(
        expense.category,
        (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }

    return totals;
  }

  Map<int, double> get monthlyTotalsForCurrentYear {
    final year = DateTime.now().year;
    final totals = <int, double>{
      for (var month = 1; month <= 12; month++) month: 0,
    };

    for (final expense in expenses) {
      if (expense.date.year == year) {
        totals.update(
          expense.date.month,
          (value) => value + expense.amount,
          ifAbsent: () => expense.amount,
        );
      }
    }

    return totals;
  }

  Future<void> exportExcel() async {
    if (filteredExpenses.isEmpty) {
      Get.snackbar('No Data', 'No expenses available to export.');
      return;
    }

    try {
      final path = await _exportService.exportToExcel(filteredExpenses);
      Get.snackbar('Exported', 'Excel file saved to: $path');
    } catch (error) {
      Get.snackbar(
        'Export Failed',
        error.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> exportPdf() async {
    if (filteredExpenses.isEmpty) {
      Get.snackbar('No Data', 'No expenses available to export.');
      return;
    }

    try {
      final path = await _exportService.exportToPdf(filteredExpenses);
      Get.snackbar('Exported', 'PDF file saved to: $path');
    } catch (error) {
      Get.snackbar(
        'Export Failed',
        error.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> pickFilterMonth(BuildContext context) async {
    final now = DateTime.now();
    final current = selectedMonth.value ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      initialDatePickerMode: DatePickerMode.year,
    );

    if (picked != null) {
      selectedMonth.value = DateTime(picked.year, picked.month);
    }
  }
}
