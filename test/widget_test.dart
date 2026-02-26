import 'package:expense_tracker_pro/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app boots', (tester) async {
    await tester.pumpWidget(const ExpenseTrackerProApp());
    await tester.pump();

    expect(find.textContaining('Expense Tracker Pro'), findsOneWidget);
  });
}
