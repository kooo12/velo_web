import 'package:flutter_test/flutter_test.dart';
import 'package:velo_web/main.dart';

void main() {
  testWidgets('Velo Web App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const VeloWebApp());
    expect(find.byType(VeloWebApp), findsOneWidget);
  });
}
