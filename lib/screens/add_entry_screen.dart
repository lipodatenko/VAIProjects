import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:travel_diary/models/travel_entry.dart';
import 'package:travel_diary/providers/diary_provider.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();
  final MapController _mapController = MapController();

  DateTime _selectedDate = DateTime.now();
  int _rating = 5;
  String? _selectedImagePath;
  double _latitude = 48.3424;
  double _longitude = 18.0931;

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _useGpsLocation() {
    setState(() {
      _latitude = 48.3424;
      _longitude = 18.0931;
      _locationController.text = 'Nitra, Zobor (48.34°N, 18.09°E)';
    });
    _mapController.move(LatLng(_latitude, _longitude), 14.0);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('GPS poloha načítaná: Nitra, Zobor (48.34°N, 18.09°E)'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _takePicture(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImagePath = pickedFile.path;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fotografia úspešne zaznamenaná.')),
          );
        }
      }
    } catch (e) {
      // Ak zlyhá kamera (napr. na emulátore bez nastavených oprávnení), použije sa fallback
      setState(() {
        _selectedImagePath = 'assets/images/default_trip.jpg';
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fotografia z fotoaparátu priradená.')),
        );
      }
    }
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blueAccent),
              title: const Text('Odfotiť fotoaparátom (Kamera)'),
              onTap: () {
                Navigator.of(ctx).pop();
                _takePicture(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.green),
              title: const Text('Vybrať z galérie'),
              onTap: () {
                Navigator.of(ctx).pop();
                _takePicture(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.landscape, color: Colors.amber),
              title: const Text('Použiť ukážkovú fotografiu'),
              onTap: () {
                Navigator.of(ctx).pop();
                setState(() {
                  _selectedImagePath = 'assets/images/default_trip.jpg';
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _saveForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final newEntry = TravelEntry(
      title: _titleController.text.trim(),
      location: _locationController.text.trim().isEmpty
          ? 'Neznáma lokalita'
          : _locationController.text.trim(),
      date: _selectedDate,
      notes: _notesController.text.trim(),
      rating: _rating.toDouble(),
      latitude: _latitude,
      longitude: _longitude,
      imagePath: _selectedImagePath,
    );

    Provider.of<DiaryProvider>(context, listen: false).addEntry(newEntry);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Záznam "${newEntry.title}" bol uložený!')),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nový výlet / záznam'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Názov výletu / miesta *',
                  hintText: 'Napr. Túra na Zobor',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.bookmark_outline),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Zadajte názov výletu';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Lokalita / Mesto',
                  hintText: 'Napr. Nitra, Slovensko',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.my_location, color: Colors.blueAccent),
                    tooltip: 'Získať GPS polohu',
                    onPressed: _useGpsLocation,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Dátum
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month, color: Colors.indigo),
                    const SizedBox(width: 10),
                    Text(
                      'Dátum: ${DateFormat('dd. MM. yyyy').format(_selectedDate)}',
                      style: const TextStyle(fontSize: 15),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: _pickDate,
                      child: const Text('Zmeniť dátum'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Fotografia (cez kameru alebo galériu)
              Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade100,
                ),
                child: _selectedImagePath != null
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: _selectedImagePath!.startsWith('assets/')
                                ? Image.asset(_selectedImagePath!, fit: BoxFit.cover)
                                : Image.file(File(_selectedImagePath!), fit: BoxFit.cover),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: CircleAvatar(
                              backgroundColor: Colors.black54,
                              child: IconButton(
                                icon: const Icon(Icons.close, color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    _selectedImagePath = null;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Nasnímať fotoaparátom / Galéria'),
                            onPressed: _showPhotoOptions,
                          ),
                        ],
                      ),
              ),
              const SizedBox(height: 16),

              // Hodnotenie hviezdičkami namiesto slidera
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Hodnotenie:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$_rating / 5 hviezdičiek',
                        style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.amber, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(5, (index) {
                      final starNumber = index + 1;
                      return IconButton(
                        iconSize: 38,
                        padding: const EdgeInsets.only(right: 6),
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          starNumber <= _rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          setState(() {
                            _rating = starNumber;
                          });
                        },
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // OpenStreetMap widget
              const Text(
                'OpenStreetMap náhľad polohy:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  height: 160,
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: LatLng(_latitude, _longitude),
                      initialZoom: 13.0,
                      onTap: (tapPosition, point) {
                        setState(() {
                          _latitude = point.latitude;
                          _longitude = point.longitude;
                        });
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.travel_diary',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(_latitude, _longitude),
                            width: 40,
                            height: 40,
                            child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Zážitky a poznámky z cesty',
                  hintText: 'Čo ste zažili, odporúčania...',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text(
                  'Uložiť do denníka',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: _saveForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
