import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_data_provider.dart';
import '../utils/helper_functions.dart';
import 'settings_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showSortDialog(BuildContext context, AppDataProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Sort Earthquakes'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text('Most Recent First'),
                trailing: provider.orderBy == 'time'
                    ? const Icon(Icons.check, color: Colors.teal)
                    : null,
                onTap: () {
                  provider.setOrder('time');
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('Oldest First'),
                trailing: provider.orderBy == 'time-asc'
                    ? const Icon(Icons.check, color: Colors.teal)
                    : null,
                onTap: () {
                  provider.setOrder('time-asc');
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: const Icon(Icons.trending_up),
                title: const Text('Highest Magnitude'),
                trailing: provider.orderBy == 'magnitude'
                    ? const Icon(Icons.check, color: Colors.teal)
                    : null,
                onTap: () {
                  provider.setOrder('magnitude');
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: const Icon(Icons.trending_down),
                title: const Text('Lowest Magnitude'),
                trailing: provider.orderBy == 'magnitude-asc'
                    ? const Icon(Icons.check, color: Colors.teal)
                    : null,
                onTap: () {
                  provider.setOrder('magnitude-asc');
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppDataProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Earthquake App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            tooltip: 'Sort Earthquakes',
            onPressed: () => _showSortDialog(context, provider),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.getEarthquakeData(),
        child: _buildBody(context, provider),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AppDataProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading earthquake data...'),
          ],
        ),
      );
    }

    if (provider.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 54, color: Colors.red),
              const SizedBox(height: 12),
              Text(
                provider.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => provider.getEarthquakeData(),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (!provider.hasData) {
      return const Center(
        child: Text(
          'No earthquakes found for selected criteria.',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: provider.earthquakes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final eq = provider.earthquakes[index];
        final badgeColor = getAlertColor(eq.alert, eq.magnitude);

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              radius: 26,
              backgroundColor: badgeColor,
              child: Text(
                eq.magnitude.toStringAsFixed(1),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            title: Text(
              eq.place,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Row(
                children: [
                  const Icon(Icons.access_time, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    formatDate(eq.time),
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                  ),
                ],
              ),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          ),
        );
      },
    );
  }
}
