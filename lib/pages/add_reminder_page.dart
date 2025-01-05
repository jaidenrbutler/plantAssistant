import 'package:flutter/material.dart';
import 'package:plant_id_project/models/plant_details.dart';
import 'package:plant_id_project/models/watering_reminder.dart';
import 'package:plant_id_project/services/firestore_service.dart';

class AddReminderPage extends StatefulWidget {
  final PlantDetails plant;

  const AddReminderPage({required this.plant, super.key});

  @override
  State<AddReminderPage> createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  final TextEditingController _plantNameController = TextEditingController();
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();

    _plantNameController.text = widget.plant.commonNames;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Watering Reminder"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _plantNameController,
              decoration: const InputDecoration(labelText: "Plant Name"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );

                if (pickedDate != null) {
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (pickedTime != null) {
                    setState(() {
                      _selectedDateTime = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                    });
                  }
                }
              },
              child: Text(
                _selectedDateTime == null
                    ? "Select ReminderTime"
                    : "Reminder : ${_selectedDateTime.toString()}",
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_plantNameController.text.isNotEmpty &&
                    _selectedDateTime != null) {
                  final reminder = WateringReminder(
                    documentId: "",
                    plantName: _plantNameController.text,
                    reminderTime: _selectedDateTime!,
                    plantId: "",
                  );
                  FirestoreService().addReminder(reminder);
                  Navigator.pop(context);
                }
              },
              child: const Text("Save Reminder"),
            ),
          ],
        ),
      ),
    );
  }
}
