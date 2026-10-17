import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_data_provider.dart';
import 'pages/home_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppDataProvider()..getEarthquakeData(),
      child: const EarthquakeApp(),
    ),
  );
}

class EarthquakeApp extends StatelessWidget {
  const EarthquakeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Earthquake App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
