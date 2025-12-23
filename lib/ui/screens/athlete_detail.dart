import 'package:flutter/material.dart';
import 'package:tamdan/models/athlete.dart';

class AthleteDetailScreen extends StatelessWidget {
  final Athlete athlete;
  const AthleteDetailScreen({super.key, required this.athlete});

  String _fmt(DateTime d) {
    const m = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
    return "${d.day} ${m[d.month - 1]} ${d.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Athlete Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(athlete.name, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            const Text('Date of Birth', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(_fmt(athlete.dateOfBirth), style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            const Text('Gender', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(athlete.gender, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            const Text('Belt Level', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(athlete.beltLevel, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            const Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(athlete.status, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    // TODO: Navigate to EditAthleteScreen and handle result in caller
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Delete Athlete?'),
                        content: Text('Are you sure you want to delete ${athlete.name}?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
                        ],
                      ),
                    ).then((confirm) {
                      if (!(context.mounted)) return;
                      if (confirm == true) {
                        Navigator.pop(context, 'deleted');
                      }
                    });
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
