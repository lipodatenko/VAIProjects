import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_data_provider.dart';
import '../utils/helper_functions.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppDataProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Time Range Filter',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.calendar_today, color: Colors.teal),
                    title: const Text('Start Date'),
                    subtitle: Text(formatDateOnly(provider.startTime)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () async {
                      final selected = await showDatePicker(
                        context: context,
                        initialDate: provider.startTime,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (selected != null) {
                        provider.setStartTime(selected);
                      }
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.event, color: Colors.teal),
                    title: const Text('End Date'),
                    subtitle: Text(formatDateOnly(provider.endTime)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () async {
                      final selected = await showDatePicker(
                        context: context,
                        initialDate: provider.endTime,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (selected != null) {
                        provider.setEndTime(selected);
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      onPressed: () {
                        provider.getEarthquakeData();
                        showMsg(context, 'Times are updated');
                      },
                      label: const Text(
                        'Update Time Changes',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Minimum Magnitude',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Min: ${provider.minMagnitude.toStringAsFixed(1)} M'),
                      Text(
                        provider.minMagnitude >= 4.5
                            ? 'Strong'
                            : (provider.minMagnitude >= 2.5 ? 'Moderate' : 'All'),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Slider(
                    value: provider.minMagnitude,
                    min: 1.0,
                    max: 7.0,
                    divisions: 12,
                    label: provider.minMagnitude.toStringAsFixed(1),
                    onChanged: (val) {
                      provider.setMinMagnitude(val);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
