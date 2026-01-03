import 'package:flutter/material.dart';
import 'package:tamdan/models/athlete.dart';
import 'package:tamdan/ui/screens/add_athlete.dart';
import 'package:tamdan/ui/screens/athlete_detail.dart';
import 'package:tamdan/ui/widgets/athlete_card.dart';
import 'package:tamdan/ui/widgets/custom_app_bar.dart';
import 'package:tamdan/ui/widgets/custom_searchbar.dart';
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
      appBar: const CustomAppBar(
        title: 'Atheletes',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: CustomSearchBar(
              onChanged: _search,
              hintText: 'Search by name...',        
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
                        onTap: () async {
                          // Navigate to details
                          final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => AthleteDetailScreen(athlete: athlete),)
                          );
                          if ( result is Athlete ){
                            setState(() {
                              final index = mockAthletes.indexWhere((a) => a.id == result.id );
                              if (index != -1 ){
                                mockAthletes[index] = result;
                              }
                              _search(_searchQuery);
                            });
                          }
                          if (result == 'deleted'){
                            setState(() {
                              mockAthletes.removeWhere((a) => a.id == athlete.id);
                              _search(_searchQuery);
                            });
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to AddAthlete and await result
          final newAthelete = await Navigator.push<Athlete>(
            context,
            MaterialPageRoute(builder: (_) => AddAthleteScreen())
          );
          if ( newAthelete != null ){
            mockAthletes.add(newAthelete);
            _search(_searchQuery);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
