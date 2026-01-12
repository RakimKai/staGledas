// This is a basic Flutter widget test.

import 'package:flutter_test/flutter_test.dart';
import 'package:stagledas_mobile/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const StaGledasMobile());

    // Verify that login screen is shown
    expect(find.text('Sta Gledas?'), findsOneWidget);
  });
}
