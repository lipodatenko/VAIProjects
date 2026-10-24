import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:travel_diary/models/travel_entry.dart';
import 'package:travel_diary/providers/diary_provider.dart';

class EntryDetailScreen extends StatelessWidget {
  const EntryDetailScreen({super.key, required this.entry});

  final TravelEntry entry;

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Zmazať záznam?'),
        content: Text('Naozaj chcete zmazať výlet "${entry.title}"?'),
        actions: [
          TextButton(
            child: const Text('Zrušiť'),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Zmazať'),
            onPressed: () {
              Provider.of<DiaryProvider>(context, listen: false).deleteEntry(entry.id);
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(entry.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            tooltip: 'Zmazať výlet',
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hlavná fotografia
            Container(
              height: 240,
              width: double.infinity,
              color: Theme.of(context).colorScheme.primaryContainer,
              child: entry.imagePath != null
                  ? (entry.imagePath!.startsWith('assets/')
                      ? Image.asset(entry.imagePath!, fit: BoxFit.cover)
                      : Image.file(File(entry.imagePath!), fit: BoxFit.cover))
                  : Center(
                      child: Icon(
                        Icons.landscape,
                        size: 90,
                        color: Theme.of(context).colorScheme.primary.withAlpha(128),
                      ),
                    ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Názov
                  Text(
                    entry.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Hodnotenie hviezdičkami
                  Row(
                    children: [
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < entry.rating.round() ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 26,
                          );
                        }),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(${entry.rating.toStringAsFixed(1)} / 5)',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Dátum a lokalita
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.indigo),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat('dd. MMMM yyyy').format(entry.date),
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on, size: 18, color: Colors.redAccent),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          entry.location,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 28),

                  // OpenStreetMap vizualizácia
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'OpenStreetMap mapa výletu',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${entry.latitude.toStringAsFixed(3)}°N, ${entry.longitude.toStringAsFixed(3)}°E',
                        style: const TextStyle(fontSize: 12, color: Colors.blueGrey, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(entry.latitude, entry.longitude),
                          initialZoom: 13.5,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.travel_diary',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: LatLng(entry.latitude, entry.longitude),
                                width: 45,
                                height: 45,
                                child: const Icon(
                                  Icons.location_on,
                                  color: Colors.redAccent,
                                  size: 42,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 28),

                  // Poznámky
                  const Text(
                    'Zážitky a poznámky',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      entry.notes.isNotEmpty ? entry.notes : 'Bez dodatočných poznámok.',
                      style: const TextStyle(fontSize: 14, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
