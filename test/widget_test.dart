import 'package:flutter_test/flutter_test.dart';
import 'package:cloudguard/main.dart';

void main() {
  testWidgets('Aegira application loads', (WidgetTester tester) async {
    await tester.pumpWidget(const AegiraApp());

    expect(find.text('Aegira'), findsWidgets);
    expect(find.text('Security Overview'), findsOneWidget);
    expect(find.text('Total Assets'), findsOneWidget);
    expect(find.text('Security Issues'), findsOneWidget);
  });
}