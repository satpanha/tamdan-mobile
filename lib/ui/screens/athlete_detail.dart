import 'package:flutter/material.dart';
import 'package:tamdan/data/session_repository.dart';
import 'package:tamdan/models/athlete.dart';
import 'package:tamdan/ui/screens/edit_athlete.dart';
import 'package:tamdan/ui/widgets/action_botton.dart';
import 'package:tamdan/ui/widgets/personal_info_card.dart';
import 'package:tamdan/ui/widgets/ptofile_header.dart';
import 'package:tamdan/ui/widgets/result_dashboard.dart';

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
    return FutureBuilder(
      future: SessionRepository.instance.getByAthlete(athlete.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final sessions = snapshot.data!;
        double norm(num? v, double max) => (v?.toDouble() ?? 0.0) / max * 10.0;
        double? avgOf(List sessions, double Function(dynamic) score) {
          if (sessions.isEmpty) return null;
          final scores = sessions.map(score).toList();
          return scores.reduce((a, b) => a + b) / scores.length;
        }
        final techAvg = avgOf(sessions.where((s) => s.sessionType == 'technical').toList(), (s) {
          final p = s.payload;
          final speed = norm(p['speed'], 5.0);
          final balance = norm(p['balance'], 5.0);
          final control = norm(p['control'], 5.0);
          final roundhouse = norm(p['roundhouseAccuracy'], 100.0);
          return (speed + balance + control + roundhouse) / 4.0;
        });
        final strAvg = avgOf(sessions.where((s) => s.sessionType == 'strength').toList(), (s) {
          final p = s.payload;
          final push = norm(p['pushUps'], 100.0);
          final sit = norm(p['sitUps'], 100.0);
          final squat = norm(p['squats'], 100.0);
          final kick = norm(p['kickPower'], 200.0);
          final core = norm(p['coreStrength'], 200.0);
          final leg = norm(p['legStrength'], 200.0);
          return (push + sit + squat + kick + core + leg) / 6.0;
        });
        final physSessions = sessions.where((s) => s.sessionType == 'physical').toList();
        final physAvg = physSessions.isEmpty
            ? null
            : avgOf(physSessions, (s) {
                final p = s.payload;
                final stamina = norm(p['stamina'], 100.0);
                final flexibility = norm(p['flexibility'], 100.0);
                final reaction = norm(p['reactionSpeed'], 100.0);
                return (stamina + flexibility + reaction) / 3.0;
              });
        final parts = [techAvg, strAvg, physAvg].whereType<double>().toList();
        final overall = parts.isNotEmpty ? (parts.reduce((a, b) => a + b) / parts.length).round() : null;
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
                const SizedBox(height: 16),
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
                ResultDashboard(
                  overall: overall,
                  technical: techAvg?.round(),
                  strength: strAvg?.round(),
                  conditioning: physAvg?.round(),
                ),
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
      },
    );
  }
}
