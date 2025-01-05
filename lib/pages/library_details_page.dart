import 'package:flutter/material.dart';
import 'package:plant_id_project/models/plant_details.dart';
import 'package:plant_id_project/models/plant_identification.dart';
import 'package:plant_id_project/models/watering_reminder.dart';
import 'package:plant_id_project/pages/add_reminder_page.dart';
import 'package:plant_id_project/services/firestore_service.dart';
import 'package:url_launcher/url_launcher.dart';

class LibraryDetailsPage extends StatelessWidget {
  final PlantDetails plant;

  const LibraryDetailsPage({required this.plant, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          plant.commonNames,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green.shade100,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  plant.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),

            _buildSectionCard(
              title: "Plant Details",
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name: ${plant.commonNames}",
                    style: const TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text("Class: ${plant.plantClass}"),
                  Text("Genus: ${plant.plantGenus}"),
                  const SizedBox(height: 8),

                  // Code for opening the WikiLink
                  GestureDetector(
                    onTap: () {
                      _launchURL();
                    },
                    child: Text(
                      "More Info: ${plant.wikiUrl}",
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Watering tips section
            _buildSectionCard(
              title: "Watering Tips",
              content: Text(
                plant.wateringTips,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // FirestoreService().addReminder(WateringReminder(
                  //     plantName: plant.commonNames,
                  //     reminderTime: DateTime.now(),
                  //     plantId: "2"));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddReminderPage(plant: plant)));
                },
                icon: const Icon(Icons.water_drop, color: Colors.blue),
                label: const Text("Add watering reminder"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade100,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Delete Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  FirestoreService().deletePlant(plant.documentID);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.delete, color: Colors.white),
                label: const Text("Delete Plant"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build card method
  Widget _buildSectionCard({required String title, required Widget content}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            content,
          ],
        ),
      ),
    );
  }

  _launchURL() async {
    final Uri url = Uri.parse(plant.wikiUrl);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
