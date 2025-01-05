import 'package:flutter/material.dart';
import 'package:plant_id_project/models/current_weather.dart';
import 'package:plant_id_project/pages/city_select_page.dart';
import 'package:plant_id_project/pages/edit_reminder_page.dart';
import 'package:plant_id_project/services/firestore_service.dart';
import '../services/weather_api.dart' as weather_api;
import '../models/watering_reminder.dart';
import '../pages/add_reminder_page.dart';
import './plant_search_page.dart';
// sk-bD7Q672d553e780f27563

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePage> {
  CurrentWeather? aWeather;
  String _currentCity = "Spruce Grove"; // Default

  Future<void> _fetchWeather(String city) async {
    try {
      CurrentWeather weather = await weather_api.weatherProvider(city: city);
      setState(() {
        aWeather = weather;
        _currentCity = city;
      });
    } catch (e) {
      debugPrint("Error fetching weather: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather(_currentCity);
  }

  // Select City Method
  Future<void> _selectCity() async {
    final selectedCity = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CitySelectPage()),
    );

    if (selectedCity != null) {
      _fetchWeather(selectedCity.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.green.shade100,
        actions: [
          IconButton(
              onPressed: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PlantSearchPage()))
                  },
              icon: const Icon(Icons.search))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            aWeather == null
                ? const Center(child: CircularProgressIndicator())
                :
                // Weather Bar
                Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.wb_sunny,
                              color: Colors.orange,
                              size: 32,
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${aWeather!.currentTemp.round()}\u2103',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  aWeather!.description,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          aWeather!.city,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        ElevatedButton(
                            onPressed: _selectCity,
                            child: const Icon(Icons.search))
                      ],
                    ),
                  ),

            const SizedBox(height: 16),

            // New Reminders Section
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<List<WateringReminder>>(
                    future: FirestoreService().getReminders(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text("Error: ${snapshot.error}"),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text("No reminders found."),
                        );
                      }
                      final reminders = snapshot.data!;
                      return SizedBox(
                        height: 200,
                        child: ListView.builder(
                          itemCount: reminders.length,
                          itemBuilder: (context, index) {
                            final reminder = reminders[index];
                            final now = DateTime.now();
                            final reminderDate = reminder.reminderTime;
                            final difference =
                                reminderDate.difference(now).inDays;
                            return ListTile(
                              leading: const Icon(Icons.water_drop,
                                  color: Colors.blue),
                              title: Text(reminder.plantName),
                              subtitle: difference > 0
                                  ? Text("Water in $difference days")
                                  : const Text("Water Today!"),
                              trailing: ElevatedButton(
                                  onPressed: () async {
                                    const int intervalDays = 32;
                                    await FirestoreService().markAsWatered(
                                        reminder.documentId, intervalDays);
                                    setState(() {});
                                  },
                                  child: const Text("Watered")),
                              onTap: () {
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditReminderPage(
                                                    reminder: reminder)))
                                    .then((_) => setState(() {}));
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16.0),

                  ///
                  /// Delete all reminders
                  ///
                  // Center(
                  //   child: TextButton(
                  //     onPressed: () {
                  //       FirestoreService().deleteAllReminders();
                  //     },
                  //     child: const Text("Delete All Reminders"),
                  //   ),
                  // ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tips",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text("PlaceHolder Tip")
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
