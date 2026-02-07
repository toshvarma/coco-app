import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coco_app/presentation/screens/home_screen.dart';
import 'package:coco_app/core/constants/app_themes.dart';
import 'package:coco_app/data/services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return MaterialApp(
      title: 'COCO - Social Media Helper',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: themeService.themeMode,
      home: const HomeScreen(),
    );
  }
}