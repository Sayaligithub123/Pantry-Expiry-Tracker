import 'package:flutter_test/flutter_test.dart';
import 'package:pantry_ex/main.dart';

void main() {
  testWidgets("App loads", (tester) async {
    await tester.pumpWidget(const PantryExpiryApp());
    expect(find.byType(PantryExpiryApp), findsOneWidget);
  });
}
