import 'package:flutter/material.dart';
import 'package:plant_id_project/models/plant_identification.dart';
import '../models/plant_details.dart';
import '../services/firestore_service.dart';

class DetailsPage extends StatelessWidget {
  final PlantIdentification plant;

  const DetailsPage({required this.plant, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(plant.plantName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${plant.accessToken}",
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text("Probability: ${plant.probability * 100}"),

            // Setting the watering interval manualy
            TextField(
              decoration:
                  InputDecoration(labelText: "Watering Interval (days)"),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                // updateWateringInterval()
              },
            ),
          ],
        ),
      ),
    );
  }
}
