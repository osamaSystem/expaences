import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../app/routes/app_routes.dart';
import '../../../data/models/expense.dart';
import '../../../widgets/category_pie_chart.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/expense_tile.dart';
import '../../../widgets/monthly_bar_chart.dart';
import '../../../widgets/summary_card.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../expense/controllers/expense_controller.dart';
import '../../expense/widgets/add_edit_expense_sheet.dart';

class HomeView extends GetView<ExpenseController> {
  HomeView({super.key});

  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () =>
              Text('Hi, ${_authController.currentUser.value?.name ?? 'User'}'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Get.toNamed(AppRoutes.settings),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openExpenseSheet(context),
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.loadExpenses,
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              _buildSummarySection(),
              const SizedBox(height: 8),
              _buildFilters(context),
              const SizedBox(height: 8),
              _buildExportButtons(),
              const SizedBox(height: 8),
              Text(
                'Monthly Chart',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              MonthlyBarChart(
                monthlyTotals: controller.monthlyTotalsForCurrentYear,
              ),
              const SizedBox(height: 8),
              Text(
                'Category Chart',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              CategoryPieChart(
                categoryTotals: controller.categoryTotals,
                currencySymbol: _authController.currencySymbol,
              ),
              const SizedBox(height: 8),
              Text('Expenses', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              _buildExpenseList(context),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSummarySection() {
    final symbol = _authController.currencySymbol;

    return Column(
      children: [
        SummaryCard(
          title: 'Total Expenses',
          value: '$symbol${controller.totalExpenses.toStringAsFixed(2)}',
          icon: Icons.account_balance_wallet,
        ),
        SummaryCard(
          title: 'Monthly Total',
          value: '$symbol${controller.monthlyTotal.toStringAsFixed(2)}',
          icon: Icons.calendar_month,
        ),
      ],
    );
  }

  Widget _buildFilters(BuildContext context) {
    final selectedMonth = controller.selectedMonth.value;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search by title or note',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => controller.searchQuery.value = value,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => controller.pickFilterMonth(context),
                    icon: const Icon(Icons.filter_alt),
                    label: Text(
                      selectedMonth == null
                          ? 'Filter Month'
                          : DateFormat.yMMM().format(selectedMonth),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<ExpenseCategory?>(
                    initialValue: controller.selectedCategory.value,
                    items: [
                      const DropdownMenuItem<ExpenseCategory?>(
                        value: null,
                        child: Text('All Categories'),
                      ),
                      ...ExpenseCategory.values.map(
                        (category) => DropdownMenuItem<ExpenseCategory?>(
                          value: category,
                          child: Text(category.label),
                        ),
                      ),
                    ],
                    onChanged: (value) =>
                        controller.selectedCategory.value = value,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: controller.clearFilters,
                icon: const Icon(Icons.clear),
                label: const Text('Clear Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportButtons() {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: controller.exportExcel,
            icon: const Icon(Icons.table_view),
            label: const Text('Export Excel'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: FilledButton.icon(
            onPressed: controller.exportPdf,
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text('Export PDF'),
          ),
        ),
      ],
    );
  }

  Widget _buildExpenseList(BuildContext context) {
    final data = controller.filteredExpenses;

    if (data.isEmpty) {
      return const SizedBox(
        height: 180,
        child: EmptyState(
          message: 'No expenses found. Add one using + button.',
        ),
      );
    }

    return ListView.builder(
      itemCount: data.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final expense = data[index];

        return ExpenseTile(
          expense: expense,
          currencySymbol: _authController.currencySymbol,
          onEdit: () => _openExpenseSheet(context, expense: expense),
          onDelete: () => controller.deleteExpense(expense.id!),
        );
      },
    );
  }

  void _openExpenseSheet(BuildContext context, {Expense? expense}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => AddEditExpenseSheet(expense: expense),
    );
  }
}
