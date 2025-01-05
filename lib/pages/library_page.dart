import 'package:flutter/material.dart';
import 'package:plant_id_project/models/plant_details.dart';
import 'package:plant_id_project/pages/detaIls_page.dart';
import 'package:plant_id_project/pages/library_details_page.dart';
import '../models/plant_identification.dart';
import '../services/firestore_service.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  late Future<List<PlantDetails>> _plantsFuture;

  @override
  void initState() {
    super.initState();
    _plantsFuture = _firestoreService.getAllPlants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Library"),
      ),
      body: FutureBuilder<List<PlantDetails>>(
        future: _plantsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No plants found in library."));
          } else {
            final plants = snapshot.data!;
            return ListView.builder(
              itemCount: plants.length,
              itemBuilder: (context, index) {
                final plant = plants[index];
                return ListTile(
                  title: Text(plant.commonNames),
                  subtitle: Text(
                      'Latin Name: ${plant.plantGenus} ${plant.plantClass}'),
                  onTap: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LibraryDetailsPage(plant: plant)))
                        .then((_) => setState(() {}));
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
