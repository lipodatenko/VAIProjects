import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'hurdle_provider.dart';
import 'word_hurdle_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => HurdleProvider()..init(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Word Hurdle',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 18, 18),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
      ),
      home: const WordHurdlePage(),
    );
  }
}
