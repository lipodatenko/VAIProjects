import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:travel_diary/models/travel_entry.dart';

class DiaryProvider with ChangeNotifier {
  DiaryProvider() {
    _initSampleData();
  }

  final List<TravelEntry> _entries = [];

  List<TravelEntry> get entries => List.unmodifiable(_entries);

  void _initSampleData() {
    _entries.addAll([
      TravelEntry(
        title: 'Výstup na Zobor',
        location: 'Nitra, Slovensko',
        date: DateTime.now().subtract(const Duration(days: 2)),
        notes: 'Krásna jesenná túra s výhľadom na celé mesto a Tribečské pohorie. Skvelé počasie a čistý vzduch.',
        rating: 5.0,
        latitude: 48.3424,
        longitude: 18.0931,
        imagePath: 'assets/images/default_trip.jpg',
      ),
      TravelEntry(
        title: 'Bratislavský hrad',
        location: 'Bratislava, Staré Mesto',
        date: DateTime.now().subtract(const Duration(days: 7)),
        notes: 'Prechádzka popri Dunaji a návšteva hradného areálu s výhľadom na most SNP.',
        rating: 4.0,
        latitude: 48.1422,
        longitude: 17.1004,
      ),
      TravelEntry(
        title: 'Štrbské Pleso',
        location: 'Vysoké Tatry',
        date: DateTime.now().subtract(const Duration(days: 14)),
        notes: 'Prechádzka okolo jazera vo výške 1346 m n. m., nádherná panoráma tatranských štítov.',
        rating: 5.0,
        latitude: 49.1190,
        longitude: 20.0633,
      ),
    ]);
    _loadFromLocalFile();
  }

  void addEntry(TravelEntry entry) {
    _entries.insert(0, entry);
    _saveToLocalFile();
    notifyListeners();
  }

  void deleteEntry(String id) {
    _entries.removeWhere((e) => e.id == id);
    _saveToLocalFile();
    notifyListeners();
  }

  File _getStorageFile() {
    return File('${Directory.systemTemp.path}/travel_diary_storage.json');
  }

  void _saveToLocalFile() {
    try {
      final file = _getStorageFile();
      final data = _entries.map((e) => e.toJson()).toList();
      file.writeAsStringSync(jsonEncode(data));
    } catch (e) {
      debugPrint('Chyba pri ukladaní do lokálneho súboru: $e');
    }
  }

  void _loadFromLocalFile() {
    try {
      final file = _getStorageFile();
      if (file.existsSync()) {
        final content = file.readAsStringSync();
        final List<dynamic> jsonList = jsonDecode(content);
        if (jsonList.isNotEmpty) {
          _entries.clear();
          for (final item in jsonList) {
            _entries.add(TravelEntry.fromJson(item as Map<String, dynamic>));
          }
        }
      }
    } catch (e) {
      debugPrint('Chyba pri načítavaní z lokálneho súboru: $e');
    }
  }
}
