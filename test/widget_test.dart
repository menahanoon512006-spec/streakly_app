import 'package:flutter_test/flutter_test.dart';
import 'package:streakly_app/main.dart';

void main() {
  testWidgets('Dawem Streakly smoke test', (WidgetTester tester) async {
    // بناء التطبيق باستخدام اسم الكلاس الصحيح MyApp
    await tester.pumpWidget(const MyApp());
    
    // التحقق من وجود الـ MyApp في شجرة الـ widgets
    expect(find.byType(MyApp), findsOneWidget);
  });
}