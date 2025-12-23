import 'package:flutter/material.dart';
import 'package:tamdan/models/athlete.dart';
import 'package:tamdan/ui/widgets/athlete_card.dart';
import 'package:tamdan/utils/mock_data.dart';

class AthleteListScreen extends StatefulWidget {
  const AthleteListScreen({super.key});

  @override
  State<AthleteListScreen> createState() => _AthleteListScreenState();
}

class _AthleteListScreenState extends State<AthleteListScreen> {
  late List<Athlete> _filteredAthletes;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredAthletes = List.from(mockAthletes);
  }

  void _search(String query) {
    setState(() {
      _searchQuery = query;
      if (query.trim().isEmpty) {
        _filteredAthletes = List.from(mockAthletes);
      } else {
        _filteredAthletes = mockAthletes
            .where((a) => a.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Athletes')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search by name...'
              ),
              onChanged: _search,
            ),
          ),
          Expanded(
            child: _filteredAthletes.isEmpty
                ? Center(
                    child: Text(
                      _searchQuery.isEmpty
                          ? 'No athletes yet. Tap + to add one!'
                          : 'No athletes match your search',
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredAthletes.length,
                    itemBuilder: (context, index) {
                      final athlete = _filteredAthletes[index];
                      return AthleteCard(
                        athlete: athlete,
                        onTap: () {
                          // TODO: Navigate to details
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // TODO: Navigate to AddAthlete and await result
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
