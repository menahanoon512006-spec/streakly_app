import 'package:flutter_test/flutter_test.dart';
import 'package:streakly_app/main.dart';

void main() {
  testWidgets('Dawem Streakly smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const DawemStreaklyApp());
    expect(find.byType(DawemStreaklyApp), findsOneWidget);
  });
}
