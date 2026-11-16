import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:travel_diary_app/main.dart';
import 'package:travel_diary_app/providers/theme_provider.dart';
import 'package:travel_diary_app/providers/trip_provider.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => TripProvider()),
        ],
        child: const TravelDiaryApp(),
      ),
    );
  });
}
