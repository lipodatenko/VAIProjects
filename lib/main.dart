import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_diary/providers/diary_provider.dart';
import 'package:travel_diary/screens/diary_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => DiaryProvider(),
      child: MaterialApp(
        title: 'Cestovateľský denník',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF006699),
            brightness: Brightness.light,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF006699),
            foregroundColor: Colors.white,
            elevation: 2,
          ),
        ),
        home: const DiaryListScreen(),
      ),
    );
  }
}
