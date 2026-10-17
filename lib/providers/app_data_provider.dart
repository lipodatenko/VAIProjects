import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/earthquake_model.dart';
import '../utils/helper_functions.dart';

class AppDataProvider extends ChangeNotifier {
  List<EarthquakeModel> _earthquakes = [];
  bool _isLoading = false;
  String? _errorMessage;

  DateTime _startTime = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endTime = DateTime.now();

  String _orderBy = 'time'; // 'time', 'time-asc', 'magnitude', 'magnitude-asc'
  double _minMagnitude = 2.5;

  List<EarthquakeModel> get earthquakes => _earthquakes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasData => _earthquakes.isNotEmpty;

  DateTime get startTime => _startTime;
  DateTime get endTime => _endTime;
  String get orderBy => _orderBy;
  double get minMagnitude => _minMagnitude;

  void setStartTime(DateTime dt) {
    _startTime = dt;
    notifyListeners();
  }

  void setEndTime(DateTime dt) {
    _endTime = dt;
    notifyListeners();
  }

  void setMinMagnitude(double value) {
    _minMagnitude = value;
    notifyListeners();
    getEarthquakeData();
  }

  void setOrder(String newOrder) {
    _orderBy = newOrder;
    _sortEarthquakes();
    notifyListeners();
  }

  void _sortEarthquakes() {
    switch (_orderBy) {
      case 'magnitude':
        _earthquakes.sort((a, b) => b.magnitude.compareTo(a.magnitude));
        break;
      case 'magnitude-asc':
        _earthquakes.sort((a, b) => a.magnitude.compareTo(b.magnitude));
        break;
      case 'time-asc':
        _earthquakes.sort((a, b) => a.time.compareTo(b.time));
        break;
      case 'time':
      default:
        _earthquakes.sort((a, b) => b.time.compareTo(a.time));
        break;
    }
  }

  Future<void> getEarthquakeData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final startStr = formatDateOnly(_startTime);
    final endStr = formatDateOnly(_endTime.add(const Duration(days: 1)));
    final url = Uri.parse(
      'https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=$startStr&endtime=$endStr&minmagnitude=$_minMagnitude&limit=100',
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final features = data['features'] as List<dynamic>? ?? [];

        _earthquakes = features
            .map((item) => EarthquakeModel.fromJson(item as Map<String, dynamic>))
            .toList();

        _sortEarthquakes();
      } else {
        _errorMessage = 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Network error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
