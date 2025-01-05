import 'package:flutter/material.dart';
import 'package:plant_id_project/pages/details_page_dev.dart';
import 'package:plant_id_project/services/plant_details_api.dart';
import '../models/plant_details.dart';
import '../services/plant_search_api.dart';

class PlantSearchPage extends StatefulWidget {
  const PlantSearchPage({super.key});

  @override
  State<PlantSearchPage> createState() => _PlantSearchPageState();
}

class _PlantSearchPageState extends State<PlantSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<PlantDetails> _plantDetails = [];

  bool _isLoading = false;

  Future<void> _searchPlants() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final token = await plantSearchTokenApiCall(query);

      final plantDetails = await plantDetailApiCall(token.accessToken);

      setState(() {
        _plantDetails.add(plantDetails);
      });
    } catch (e) {
      debugPrint("Error Searching Plants: $e");
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
        title: const Text("Search Plants"),
        backgroundColor: Colors.green.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Search for a plant!",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                suffixIcon: IconButton(
                  onPressed: _searchPlants,
                  icon: const Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: _plantDetails.isEmpty
                        ? const Center(child: Text("No results found."))
                        : ListView.builder(
                            itemCount: _plantDetails.length,
                            itemBuilder: (context, index) {
                              final plant = _plantDetails[index];
                              return ListTile(
                                title: Text(plant.commonNames),
                                subtitle: Text(plant.plantClass),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DetailsPageDev(plant: plant)));
                                  debugPrint(
                                      "Tapped on plant: ${plant.commonNames}");
                                },
                              );
                            },
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}
