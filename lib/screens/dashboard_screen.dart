import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../local_stores/local_store.dart';

class DashboardScreen extends StatefulWidget {
  final void Function(Locale) setLocale;
  const DashboardScreen({super.key, required this.setLocale});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String visaStatus = '';
  String visaId = '';
  List<dynamic> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    final jsonStr =
        await rootBundle.loadString('assets/dashboard/dashboard.json');
    final data = json.decode(jsonStr);
    setState(() {
      visaStatus = data['visa_status'];
      visaId = data['visa_id'];
      notifications = data['notifications'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final localtext = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          localtext.translate('dashboard'),
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(child: Text("JD")),
          )
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
                  leading: const Icon(Icons.language, color: Colors.black),
                  title: const Text('English'),
                  onTap: () {
                    widget.setLocale(const Locale('en'));
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.language, color: Colors.black),
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
        child: const Icon(Icons.language, color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localtext.translate('current_status'),
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            visaStatus,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                              '${localtext.translate('application')} #$visaId'),
                        ],
                      ),
                    ),
                    const Icon(Icons.hourglass_bottom,
                        color: Colors.amber, size: 32),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              localtext.translate('recent_notifications'),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...notifications.map((notif) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: Container(
                      width: 4,
                      height: 40,
                      color:
                          notif['type'] == 'review' ? Colors.blue : Colors.grey,
                    ),
                    title: Text(notif['title']),
                    subtitle: Text(notif['message']),
                    trailing: Text(notif['time']),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
