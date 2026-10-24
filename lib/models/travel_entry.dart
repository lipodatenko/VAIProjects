import 'package:uuid/uuid.dart';

const uuid = Uuid();

class TravelEntry {
  TravelEntry({
    required this.title,
    required this.location,
    required this.date,
    required this.notes,
    required this.rating,
    this.latitude = 48.3424,
    this.longitude = 18.0931,
    this.imagePath,
    String? id,
  }) : id = id ?? uuid.v4();

  final String id;
  final String title;
  final String location;
  final DateTime date;
  final String notes;
  final double rating;
  final double latitude;
  final double longitude;
  final String? imagePath;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'date': date.toIso8601String(),
      'notes': notes,
      'rating': rating,
      'latitude': latitude,
      'longitude': longitude,
      'imagePath': imagePath,
    };
  }

  factory TravelEntry.fromJson(Map<String, dynamic> json) {
    return TravelEntry(
      id: json['id'] as String?,
      title: json['title'] as String,
      location: json['location'] as String,
      date: DateTime.parse(json['date'] as String),
      notes: json['notes'] as String,
      rating: (json['rating'] as num).toDouble(),
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : 48.3424,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : 18.0931,
      imagePath: json['imagePath'] as String?,
    );
  }
}
