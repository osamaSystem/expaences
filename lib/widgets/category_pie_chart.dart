import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../data/models/expense.dart';

class CategoryPieChart extends StatelessWidget {
  const CategoryPieChart({
    super.key,
    required this.categoryTotals,
    required this.currencySymbol,
  });

  final Map<ExpenseCategory, double> categoryTotals;
  final String currencySymbol;

  @override
  Widget build(BuildContext context) {
    final entries =
        categoryTotals.entries.where((entry) => entry.value > 0).toList();

    if (entries.isEmpty) {
      return const Card(
        child: SizedBox(
          height: 220,
          child: Center(child: Text('No category data available.')),
        ),
      );
    }

    final colors = <Color>[
      Colors.orange,
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.grey,
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          height: 220,
          child: Row(
            children: [
              Expanded(
                child: PieChart(
                  PieChartData(
                    sections: entries.asMap().entries.map((entry) {
                      final index = entry.key;
                      final data = entry.value;
                      return PieChartSectionData(
                        color: colors[index % colors.length],
                        value: data.value,
                        title: data.value.toStringAsFixed(0),
                        radius: 58,
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ListView(
                  children: entries
                      .asMap()
                      .entries
                      .map(
                        (entry) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                color: colors[entry.key % colors.length],
                              ),
                              const SizedBox(width: 8),
                              Expanded(child: Text(entry.value.key.label)),
                              Text(
                                '$currencySymbol${entry.value.value.toStringAsFixed(2)}',
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
