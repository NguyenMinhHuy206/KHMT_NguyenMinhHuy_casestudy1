import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_first_app/main.dart';

void main() {
  testWidgets('Expense Manager welcome screen test', (tester) async {
    await tester.pumpWidget(const ExpenseManagerApp());

    expect(find.text('Expense Manager'), findsOneWidget);
    expect(find.text('Bắt đầu'), findsOneWidget);
    expect(find.byIcon(Icons.account_balance_wallet_rounded), findsOneWidget);
  });
}
