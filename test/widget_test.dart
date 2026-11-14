import 'package:flutter_test/flutter_test.dart';
import 'package:tugas_sesi_5/main.dart';

void main() {
  testWidgets('NusaEvent Hub menampilkan halaman utama', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const NusaEventApp());

    expect(find.text('NusaEvent Hub'), findsOneWidget);
    expect(find.text('Temukan Acara Menarik!'), findsOneWidget);
  });
}
