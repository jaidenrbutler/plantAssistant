import 'package:flutter/material.dart';
import 'package:plant_id_project/services/geoapify_api.dart';
import '../models/city_model.dart';

class CitySelectPage extends StatefulWidget {
  const CitySelectPage({super.key});

  @override
  State<CitySelectPage> createState() => _CitySelectPageState();
}

class _CitySelectPageState extends State<CitySelectPage> {
  final TextEditingController _searchController = TextEditingController();
  List<City> _suggestions = [];
  bool _isLoading = false;

  // Fetch suggestions based on input
  Future<void> _fetchSuggestions(String query) async {
    if (query.isEmpty) {
      setState(() {
        _suggestions = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      List<City> cities = await fetchCities(query);
      setState(() {
        _suggestions = cities;
      });
    } catch (e) {
      debugPrint('Error loading suggestions: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a City'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Field
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for a city',
                border: const OutlineInputBorder(),
                suffixIcon: _isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      )
                    : null,
              ),
              onChanged: (query) => _fetchSuggestions(query),
            ),
            // Suggestions List
            Expanded(
                child: _suggestions.isNotEmpty
                    ? ListView.builder(
                        itemCount: _suggestions.length,
                        itemBuilder: (context, index) {
                          final city = _suggestions[index];
                          return ListTile(
                            title: Text(city.name),
                            subtitle: Text(city.country),
                            onTap: () {
                              Navigator.pop(context, city);
                            },
                          );
                        },
                      )
                    : const Center(
                        child: Text('Start typing to seach for cities'),
                      ))
          ],
        ),
      ),
    );
  }
}
