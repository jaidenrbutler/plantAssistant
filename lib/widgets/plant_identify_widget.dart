import 'package:flutter/material.dart';
import 'package:plant_id_project/models/plant_identification.dart';
import '../services/plant_id_api.dart' as api;
import '../services/picture_to_base64.dart' as image_conversion;

class PlantIdentifyWidget extends StatelessWidget {
  const PlantIdentifyWidget({super.key});

  Future<PlantIdentification> _fetchPlantIdentification() async {
    String base64Image = await image_conversion
        .convertImageToBase64('assets/african_violet.jpg');

    return await api.apiCall(base64Image);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PlantIdentification>(
      future: _fetchPlantIdentification(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          PlantIdentification plant = snapshot.data!;
          return Column(
            children: [
              Text(
                'Plant Name: ${plant.plantName}',
                style: const TextStyle(fontSize: 24),
              ),
              Text(
                'Prob: ${(plant.probability * 100).round()}%',
                style: const TextStyle(fontSize: 24),
              ),
            ],
          );
        } else {
          return const Text('No data');
        }
      },
    );
  }
}
