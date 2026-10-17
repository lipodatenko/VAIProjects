class EarthquakeModel {
  final String id;
  final double magnitude;
  final String place;
  final DateTime time;
  final String? alert;
  final String url;

  EarthquakeModel({
    required this.id,
    required this.magnitude,
    required this.place,
    required this.time,
    this.alert,
    required this.url,
  });

  factory EarthquakeModel.fromJson(Map<String, dynamic> json) {
    final properties = json['properties'] as Map<String, dynamic>? ?? {};
    final magValue = properties['mag'];
    double mag = 0.0;
    if (magValue is num) {
      mag = magValue.toDouble();
    }

    final timeValue = properties['time'] as int? ?? 0;
    final time = DateTime.fromMillisecondsSinceEpoch(timeValue);

    return EarthquakeModel(
      id: json['id'] as String? ?? '',
      magnitude: mag,
      place: properties['place'] as String? ?? 'Unknown Location',
      time: time,
      alert: properties['alert'] as String?,
      url: properties['url'] as String? ?? '',
    );
  }
}
