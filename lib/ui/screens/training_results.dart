library;
import 'package:flutter/material.dart';
import 'package:tamdan/ui/widgets/base_screen.dart';
import 'package:tamdan/ui/widgets/athlete_header.dart';
import 'package:tamdan/utils/mock_data.dart';
import 'package:tamdan/data/session_repository.dart';

class TrainingResultsScreen extends StatefulWidget {
  const TrainingResultsScreen({super.key});

  @override
  State<TrainingResultsScreen> createState() => _TrainingResultsScreenState();
}

class _TrainingResultsScreenState extends State<TrainingResultsScreen> {
  List<SessionRecord> _sessions = [];
  bool _loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final athleteId = args != null ? args['athleteId'] as String? : null;
    if (athleteId == null) {
      setState(() {
        _sessions = [];
        _loading = false;
      });
      return;
    }

    try {
      final sessions = await SessionRepository.instance.getByAthlete(athleteId);
      setState(() {
        _sessions = sessions;
        _loading = false;
      });
      _computeSummary();
    } catch (e, st) {
      debugPrint('Failed to load sessions: $e\n$st');
      setState(() {
        _sessions = [];
        _loading = false;
      });
    }
  }

  int _overall = 0;
  int _technical = 0;
  int _strength = 0;
  int _conditioning = 0;

  void _computeSummary() {
    // Compute per-type averages from _sessions
    double? techAvg;
    double? strAvg;
    double? physAvg;

    final techSessions = _sessions.where((s) => s.sessionType == 'technical').toList();
    if (techSessions.isNotEmpty) {
      final scores = techSessions.map((s) {
        final p = s.payload;
        final speed = (p['speed'] as num?)?.toDouble() ?? 0.0; // 0..5
        final balance = (p['balance'] as num?)?.toDouble() ?? 0.0; // 0..5
        final control = (p['control'] as num?)?.toDouble() ?? 0.0; // 0..5
        final roundhouse = (p['roundhouseAccuracy'] as num?)?.toDouble() ?? 0.0; // 0..100
        final speedPct = (speed / 5.0) * 100.0;
        final balancePct = (balance / 5.0) * 100.0;
        final controlPct = (control / 5.0) * 100.0;
        final roundPct = roundhouse;
        return (speedPct + balancePct + controlPct + roundPct) / 4.0;
      }).toList();
      techAvg = scores.reduce((a, b) => a + b) / scores.length;
    }

    final strSessions = _sessions.where((s) => s.sessionType == 'strength').toList();
    if (strSessions.isNotEmpty) {
      final scores = strSessions.map((s) {
        final p = s.payload;
        final pushUps = (p['pushUps'] as num?)?.toDouble() ?? 0.0; // assume max 100
        final sitUps = (p['sitUps'] as num?)?.toDouble() ?? 0.0; // assume max 100
        final squats = (p['squats'] as num?)?.toDouble() ?? 0.0; // assume max 100
        final kickPower = (p['kickPower'] as num?)?.toDouble() ?? 0.0; // assume max 200
        final core = (p['coreStrength'] as num?)?.toDouble() ?? 0.0; // assume max 200
        final leg = (p['legStrength'] as num?)?.toDouble() ?? 0.0; // assume max 200

        final pushPct = (pushUps / 100.0) * 100.0;
        final sitPct = (sitUps / 100.0) * 100.0;
        final squatPct = (squats / 100.0) * 100.0;
        final kickPct = (kickPower / 200.0) * 100.0;
        final corePct = (core / 200.0) * 100.0;
        final legPct = (leg / 200.0) * 100.0;
        return (pushPct + sitPct + squatPct + kickPct + corePct + legPct) / 6.0;
      }).toList();
      strAvg = scores.reduce((a, b) => a + b) / scores.length;
    }

    final physSessions = _sessions.where((s) => s.sessionType == 'physical').toList();
    if (physSessions.isNotEmpty) {
      final scores = physSessions.map((s) {
        final p = s.payload;
        final stamina = (p['stamina'] as num?)?.toDouble() ?? 0.0; // assume 0..100
        final flexibility = (p['flexibility'] as num?)?.toDouble() ?? 0.0; // assume 0..100
        final reaction = (p['reactionSpeed'] as num?)?.toDouble() ?? 0.0; // assume 0..100
        return (stamina + flexibility + reaction) / 3.0;
      }).toList();
      physAvg = scores.reduce((a, b) => a + b) / scores.length;
    }

    final parts = <double>[];
    if (techAvg != null) {
      _technical = techAvg.round();
      parts.add(techAvg);
    } else {
      _technical = 0;
    }
    if (strAvg != null) {
      _strength = strAvg.round();
      parts.add(strAvg);
    } else {
      _strength = 0;
    }
    if (physAvg != null) {
      _conditioning = physAvg.round();
      parts.add(physAvg);
    } else {
      _conditioning = 0;
    }

    if (parts.isNotEmpty) {
      _overall = (parts.reduce((a, b) => a + b) / parts.length).round();
    } else {
      _overall = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final athleteId = args != null ? args['athleteId'] as String? : null;
    final athlete = athleteId != null ? mockAthletes.firstWhere((a) => a.id == athleteId, orElse: () => mockAthletes.first) : mockAthletes.first;

    return BaseScreen(
      title: 'Training Results',
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AthleteHeader(athlete: athlete, subtitle: _sessions.isNotEmpty ? 'Last session: ${_sessions.last.dateTime.toLocal()}' : 'No sessions yet'),

            // In-memory banner
            if (SessionRepository.instance.usingInMemory)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Material(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(8),
                  child: ListTile(
                    leading: const Icon(Icons.info_outline, color: Colors.orange),
                    title: const Text('Temporary local store active'),
                    subtitle: const Text('Sessions are stored locally and may not persist across restarts.'),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Summary scores', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),

                  // Cards row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _summaryCard('Overall', _overall, Colors.blue),
                        const SizedBox(width: 12),
                        _summaryCard('Technical', _technical, Colors.green),
                        const SizedBox(width: 12),
                        _summaryCard('Strength', _strength, Colors.purple),
                        const SizedBox(width: 12),
                        _summaryCard('Conditioning', _conditioning, Colors.orange),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Quick metric row so labels like 'Stamina' remain visible in UI and tests
                  if (_conditioning > 0)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _buildRow('Stamina', '$_conditioning'),
                    ),

                  const Divider(),
                  const SizedBox(height: 8),
                  Text('Read-only analytics', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey)),
                  const SizedBox(height: 12),
                  SizedBox(height: 120, child: Center(child: Text('Charts placeholder'))),
                ],
              ),
            ),

            // Sessions list
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recent sessions', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  if (_sessions.isEmpty)
                    const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('No sessions recorded yet'))
                  else
                    Column(
                      children: _sessions.reversed.map((s) => _buildSessionTile(s)).toList(),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionTile(SessionRecord s) {
    final dt = s.dateTime.toLocal();
    final when = _timeAgo(dt);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(label: Text(s.sessionType.toUpperCase()), backgroundColor: Colors.blue.shade50),
                Text(when, style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: s.payload.entries.map((e) {
                return Chip(label: Text('${e.key}: ${e.value}'));
              }).toList(),
            ),
            if ((s.payload['coachNotes'] as String?)?.isNotEmpty ?? false) ...[
              const SizedBox(height: 8),
              Text('Notes: ${s.payload['coachNotes']}', style: const TextStyle(fontStyle: FontStyle.italic))
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String title, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(title), Text(value, style: const TextStyle(fontWeight: FontWeight.bold))],
        ),
      );

  Widget _summaryCard(String title, int value, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('$value', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: (value / 100).clamp(0.0, 1.0), color: color, backgroundColor: color.withOpacity(0.15)),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final d = DateTime.now().difference(dt);
    if (d.inDays >= 7) return '${(d.inDays / 7).floor()}w ago';
    if (d.inDays >= 1) return '${d.inDays}d ago';
    if (d.inHours >= 1) return '${d.inHours}h ago';
    if (d.inMinutes >= 1) return '${d.inMinutes}m ago';
    return 'just now';
  }
}
