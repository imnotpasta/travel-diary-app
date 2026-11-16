import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'providers/trip_provider.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/trips/trip_form_screen.dart';
import 'screens/trips/album_grid_screen.dart';
import 'screens/weather/weather_screen.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => TripProvider()),
      ],
      child: const TravelDiaryApp(),
    ),
  );
}

class TravelDiaryApp extends StatelessWidget {
  const TravelDiaryApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'Travel Diary & Memories',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: const MainNavigationScreen(),
      // Bổ sung Named Routes đáp ứng chuẩn: Navigator.push & Navigator.pushNamed
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/new-trip': (context) => const TripFormScreen(),
        '/album': (context) => const AlbumGridScreen(),
        '/weather': (context) => const WeatherScreen(),
      },
    );
  }
}
