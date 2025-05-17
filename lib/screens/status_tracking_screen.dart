import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../local_stores/local_store.dart';

class StatusTrackingScreen extends StatefulWidget {
  final void Function(Locale) setLocale;
  const StatusTrackingScreen({super.key, required this.setLocale});

  @override
  State<StatusTrackingScreen> createState() => _StatusTrackingScreenState();
}

class _StatusTrackingScreenState extends State<StatusTrackingScreen> {
  String applicationId = '';
  List<dynamic> steps = [];

  @override
  void initState() {
    super.initState();
    _loadStatusData();
  }

  Future<void> _loadStatusData() async {
    final jsonStr =
        await rootBundle.loadString('assets/dashboard/status_tracking.json');
    final data = json.decode(jsonStr);
    setState(() {
      applicationId = data['application_id'];
      steps = data['steps'];
    });
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'done':
        return Colors.green;
      case 'in_progress':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'done':
        return Icons.check_circle;
      case 'in_progress':
        return Icons.sync;
      default:
        return Icons.radio_button_unchecked;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(t.translate('status_tracking')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(child: Text("JD")),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('English'),
                  onTap: () {
                    widget.setLocale(const Locale('en'));
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('ไทย'),
                  onTap: () {
                    widget.setLocale(const Locale('th'));
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.language),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "${t.translate('ltr_visa')}\n#${applicationId}",
                style: const TextStyle(color: Colors.blue),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: steps.length,
                itemBuilder: (context, index) {
                  final step = steps[index];
                  return ListTile(
                    leading: Column(
                      children: [
                        Icon(_statusIcon(step['status']),
                            color: _statusColor(step['status'])),
                        if (index < steps.length - 1)
                          Container(
                              width: 2,
                              height: 40,
                              color: Colors.grey.shade300),
                      ],
                    ),
                    title: Text(step['title']),
                    subtitle: Text(
                      step['timestamp'] != null
                          ? DateTime.parse(step['timestamp'])
                              .toLocal()
                              .toString()
                          : step['status'] == 'in_progress'
                              ? 'In progress'
                              : 'Pending',
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
