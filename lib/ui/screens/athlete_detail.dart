import 'package:flutter/material.dart';
import 'package:tamdan/models/athlete.dart';
import 'package:tamdan/ui/screens/edit_athlete.dart';
import 'package:tamdan/ui/screens/add_athlete.dart';
import 'package:tamdan/data/dao/athlete_dao.dart';

class AthleteDetailScreen extends StatefulWidget {
  final Athlete? athlete;
  final dynamic dao;
  const AthleteDetailScreen({super.key, this.athlete, this.dao});

  @override
  State<AthleteDetailScreen> createState() => _AthleteDetailScreenState();
}

class _AthleteDetailScreenState extends State<AthleteDetailScreen> {
  Athlete? athlete;
  late final dynamic _dao;

  @override
  void initState() {
    super.initState();
    _dao = (widget.dao as dynamic?) ?? AthleteDao();
    athlete = widget.athlete;
  }

  String _fmt(DateTime? d) {
    if (d == null) return 'Unknown';
    const m = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return "${d.day} ${m[d.month - 1]} ${d.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Athlete Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, athlete);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: athlete == null ? _emptyView() : _detailView(),
      ),
      floatingActionButton: athlete == null
          ? FloatingActionButton(
              onPressed: () async {
                final newAthlete = await Navigator.push<Athlete?>(
                  context,
                  MaterialPageRoute(builder: (_) => AddAthleteScreen(dao: _dao)),
                );
                if (newAthlete != null) {
                  // Only insert if AddAthleteScreen didn't already persist (i.e., id is null)
                  if (newAthlete.id == null) {
                    await _dao.insert(newAthlete);
                  }
                  if (!mounted) return;
                  setState(() {
                    athlete = newAthlete;
                  });
                }
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _emptyView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.info_outline, size: 48, color: Colors.grey),
          SizedBox(height: 12),
          Text('No data yet. Please click + to input data',
              style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _detailView() {
    final a = athlete!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
        Text(a.fullName, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 12),
        const Text(
          'Date of Birth',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          _fmt(a.dateOfBirth),
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 12),
        const Text('Gender', style: TextStyle(fontWeight: FontWeight.bold)),
        Text(a.gender, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 12),
        const Text(
          'Belt Level',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(a.beltLevel, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 12),
        const Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
        Text(a.status, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                final updatedAthlete = await Navigator.push<Athlete?>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditAthleteScreen(athlete: a, dao: _dao),
                  ),
                );
                if (updatedAthlete != null) {
                  if (updatedAthlete.id != null) {
                    await _dao.update(updatedAthlete);
                  }
                  if (!mounted) return;
                  setState(() {
                    athlete = updatedAthlete;
                  });
                }
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit'),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete Athlete?'),
                    content: Text(
                      'Are you sure you want to delete ${a.fullName}?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );

                if (!mounted) return;
                if (confirm == true) {
                  if (a.id != null) {
                    await _dao.delete(a.id!);
                  }
                  if (!mounted) return;
                  Navigator.pop(context, 'deleted');
                }
              },
              icon: const Icon(Icons.delete),
              label: const Text('Delete'),
            ),
          ],
        ),
      ],
    );
  }
}