import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:favorite_places/models/place.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<LocationInput> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    try {
      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          _setDefaultLocation();
          return;
        }
      }

      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          _setDefaultLocation();
          return;
        }
      }

      setState(() {
        _isGettingLocation = true;
      });

      locationData = await location.getLocation();
      final lat = locationData.latitude ?? 48.3061;
      final lng = locationData.longitude ?? 18.0864;

      final placeLoc = PlaceLocation(
        latitude: lat,
        longitude: lng,
        address: 'Lat: ${lat.toStringAsFixed(4)}, Lng: ${lng.toStringAsFixed(4)} (Nitra)',
      );

      setState(() {
        _pickedLocation = placeLoc;
        _isGettingLocation = false;
      });

      widget.onSelectLocation(placeLoc);
    } catch (e) {
      _setDefaultLocation();
    }
  }

  void _setDefaultLocation() {
    const placeLoc = PlaceLocation(
      latitude: 48.3061,
      longitude: 18.0864,
      address: 'Trieda Andreja Hlinku 1, 949 74 Nitra',
    );
    setState(() {
      _pickedLocation = placeLoc;
      _isGettingLocation = false;
    });
    widget.onSelectLocation(placeLoc);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'No location chosen',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
    );

    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    } else if (_pickedLocation != null) {
      previewContent = Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on, size: 48, color: Colors.redAccent),
            const SizedBox(height: 8),
            Text(
              _pickedLocation!.address,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withAlpha(51),
            ),
          ),
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text('Get Current Location'),
              onPressed: _getCurrentLocation,
            ),
            TextButton.icon(
              icon: const Icon(Icons.map),
              label: const Text('Set Nitra Location'),
              onPressed: _setDefaultLocation,
            ),
          ],
        ),
      ],
    );
  }
}
