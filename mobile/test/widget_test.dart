import 'package:flutter_test/flutter_test.dart';

import 'package:gosp_lojas/main.dart';

void main() {
  testWidgets('App shows splash screen with app name', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const GospLojasApp());

    expect(find.text('GOSP LOJAS'), findsOneWidget);
  });
}
