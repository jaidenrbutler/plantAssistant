import 'package:flutter/material.dart';
import '../models/plant_details.dart';
import '../services/firestore_service.dart';

class DetailsPageDev extends StatelessWidget {
  final PlantDetails plant;

  const DetailsPageDev({required this.plant, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(plant.commonNames),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${plant.commonNames}",
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text("Class: ${plant.plantClass}"),
            Text("Genus: ${plant.plantGenus}"),
            Text("URL: ${plant.wikiUrl}"),
            Image.network(plant.imageUrl, height: 400),
            Text("Watering: ${plant.wateringTips}"),
            // Button to save the plant if you want to
            ElevatedButton(
                onPressed: () {
                  FirestoreService().savePlantforUser(
                      plant.commonNames,
                      plant.plantClass,
                      plant.plantGenus,
                      plant.wikiUrl,
                      plant.imageUrl,
                      plant.wateringTips);
                  Navigator.pop(context);
                },
                child: const Text("Save PLant")),
          ],
        ),
      ),
    );
  }
}
