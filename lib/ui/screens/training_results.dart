import 'package:flutter/material.dart';
import 'package:tamdan/ui/widgets/base_screen.dart';
import 'package:tamdan/ui/widgets/ptofile_header.dart';
import 'package:tamdan/ui/widgets/result_dashboard.dart';
import 'package:tamdan/ui/widgets/session_tile.dart';
import 'package:tamdan/utils/mock_data.dart';
import 'package:tamdan/data/session_repository.dart';
import 'package:tamdan/utils/time_utils.dart';

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

  int? _overall;
  int? _technical;
  int? _strength;
  int? _conditioning;

  double? _avgOf(List<SessionRecord> sessions, double Function(SessionRecord) score) {
    if (sessions.isEmpty) return null;
    final scores = sessions.map(score).toList();
    return scores.reduce((a, b) => a + b) / scores.length;
  }

  void _computeSummary() {
    double norm(num? v, double max) => (v?.toDouble() ?? 0.0) / max * 10.0;

    final techAvg = _avgOf(_sessions.where((s) => s.sessionType == 'technical').toList(), (s) {
      final p = s.payload;
      final speed = norm(p['speed'], 5.0);
      final balance = norm(p['balance'], 5.0);
      final control = norm(p['control'], 5.0);
      final roundhouse = norm(p['roundhouseAccuracy'], 100.0);
      return (speed + balance + control + roundhouse) / 4.0;
    });

    final strAvg = _avgOf(_sessions.where((s) => s.sessionType == 'strength').toList(), (s) {
      final p = s.payload;
      final push = norm(p['pushUps'], 100.0);
      final sit = norm(p['sitUps'], 100.0);
      final squat = norm(p['squats'], 100.0);
      final kick = norm(p['kickPower'], 200.0);
      final core = norm(p['coreStrength'], 200.0);
      final leg = norm(p['legStrength'], 200.0);
      return (push + sit + squat + kick + core + leg) / 6.0;
    });

    final physSessions = _sessions.where((s) => s.sessionType == 'physical').toList();
    final physAvg = physSessions.isEmpty
        ? null
        : _avgOf(physSessions, (s) {
            final p = s.payload;
            final stamina = norm(p['stamina'], 100.0);
            final flexibility = norm(p['flexibility'], 100.0);
            final reaction = norm(p['reactionSpeed'], 100.0);
            return (stamina + flexibility + reaction) / 3.0;
          });

    _technical = techAvg?.round();
    _strength = strAvg?.round();
    _conditioning = (physAvg != null && physAvg > 0) ? physAvg.round() : null;

    final parts = [techAvg, strAvg, physAvg].whereType<double>().toList();
    _overall = parts.isNotEmpty ? (parts.reduce((a, b) => a + b) / parts.length).round() : null;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final athleteId = args != null ? args['athleteId'] as String? : null;
    final athlete = athleteId != null ? mockAthletes.firstWhere((a) => a.id == athleteId, orElse: () => mockAthletes.first) : mockAthletes.first;

    final cs = Theme.of(context).colorScheme;

    return BaseScreen(
      title: 'Training Results',
      child: _loading
          ? SizedBox(height: 300, child: Center(child: CircularProgressIndicator(color: cs.primary)))
          : SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: ProfileHeader(name: athlete.name, role: athlete.beltLevel)),
                  if (_sessions.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6, left: 16, right: 16),
                      child: Text('Last session • ${timeAgoShort(_sessions.last.dateTime)}', style: Theme.of(context).textTheme.bodySmall),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.only(top: 6, left: 16, right: 16),
                      child: Text('No sessions yet', style: Theme.of(context).textTheme.bodySmall),
                    ),

            if (SessionRepository.instance.usingInMemory)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Material(
                  color: cs.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                  child: ListTile(
                    leading: Icon(Icons.info_outline, color: cs.secondary),
                    title: Text('Temporary local store active', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                    subtitle: Text('Sessions are stored locally and may not persist across restarts.'),
                    trailing: IconButton(
                      icon: Icon(Icons.close, color: cs.onSurface),
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
                  ResultDashboard(
                    overall: _overall,
                    technical: _technical,
                    strength: _strength,
                    conditioning: _conditioning,
                  ),
                ],
              ),
            ),
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
                      children: _sessions.reversed.map((s) => SessionTile(session: s)).toList(),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
