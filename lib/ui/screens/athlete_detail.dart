import 'package:flutter/material.dart';
import 'package:tamdan/models/athlete.dart';
import 'package:tamdan/ui/screens/edit_athlete.dart';
import 'package:tamdan/ui/widgets/action_botton.dart';
import 'package:tamdan/ui/widgets/personal_info_card.dart';
import 'package:tamdan/ui/widgets/ptofile_header.dart';

class AthleteDetailScreen extends StatefulWidget {
  final Athlete athlete;
  const AthleteDetailScreen({super.key, required this.athlete});

  @override
  State<AthleteDetailScreen> createState() => _AthleteDetailScreenState();
}

class _AthleteDetailScreenState extends State<AthleteDetailScreen> {
  late Athlete athlete;

  @override
  void initState() {
    super.initState();
    athlete = widget.athlete;
  }

  String _fmt(DateTime d) {
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
          icon: Icon(Icons.arrow_back),
          onPressed: (){
          Navigator.pop(context, athlete); 
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: ProfileHeader(name: athlete.name, role: athlete.beltLevel)),
            const SizedBox(height: 24,),
            Center(child: const Text('Personal Info', style: TextStyle( fontSize: 18, color: Color.fromARGB(255, 77, 55, 55)))),
            const SizedBox(height: 8,),
            PersonalInfoCard(infoPairs: {
              'Name': athlete.name,
              'Date of Birth': _fmt(athlete.dateOfBirth),
              'Gender': athlete.gender,
              'Belt Level': athlete.beltLevel,
              'Status': athlete.status,
            }),
            const SizedBox(height: 36),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ActionButton(
                  onPressed: () async {
                    final updatedAthlete = await Navigator.push<Athlete>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditAthleteScreen(athlete: athlete),
                      ),
                    );
                    if (updatedAthlete != null) {
                      setState(() {
                        athlete = updatedAthlete;
                      });
                    }
                  },
                  icon: Icons.edit,
                  label: 'Edit',
                  backgroundColor: const Color(0xFF0A2940),
                ),
                const SizedBox(width: 24,),
                ActionButton(
                  onPressed: () {
                    showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Delete Athlete?'),
                        content: Text(
                          'Are you sure you want to delete ${widget.athlete.name}?',
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
                    ).then((confirm) {
                      if (!(context.mounted)) return;
                      if (confirm == true) {
                        Navigator.pop(context, 'deleted');
                      }
                    });
                  },
                  icon: Icons.delete,
                  label: "Delete",
                  backgroundColor: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
