import 'package:flutter/material.dart';
import 'package:plant_id_project/models/watering_reminder.dart';
import 'package:plant_id_project/services/firestore_service.dart';

class EditReminderPage extends StatefulWidget {
  final WateringReminder reminder;

  const EditReminderPage({required this.reminder, super.key});

  @override
  State<EditReminderPage> createState() => _EditReminderPageState();
}

class _EditReminderPageState extends State<EditReminderPage> {
  late TextEditingController _plantNameController;
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _plantNameController =
        TextEditingController(text: widget.reminder.plantName);
    _selectedDateTime = widget.reminder.reminderTime;
  }

  @override
  void dispose() {
    _plantNameController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
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
  }

  // void _saveReminder() {
  //   final plantName = _plantNameController.text;

  //   if (plantName.isNotEmpty && _selectedDateTime != null) {
  //     final updatedReminder = WateringReminder(
  //       documentId: widget.reminder.documentId,
  //       plantName: plantName,
  //       reminderTime: _selectedDateTime!,
  //       plantId: widget.reminder.plantId,
  //     );

  //     FirestoreService().updateReminder(updatedReminder).then((_) {
  //       Navigator.pop(context, updatedReminder);
  //     }).catchError((error) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Failed to save reminder: $error")),
  //       );
  //     });
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Please complete all fields")),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Watering Reminder"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Plant Name TextField
            TextField(
              controller: _plantNameController,
              decoration: const InputDecoration(labelText: "Plant Name"),
            ),
            const SizedBox(height: 16),

            // Date and Time Picker Button
            ElevatedButton(
              onPressed: _selectDateTime,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade200),
              child: Text(
                _selectedDateTime == null
                    ? "Select Reminder Time"
                    : "Reminder: ${_selectedDateTime.toString()}",
                style: const TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 16),

            // Save Button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text(
                "Save Reminder",
                style: TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await FirestoreService()
                    .deleteReminder(widget.reminder.documentId);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade300),
              child: const Text(
                "Delete Reminder",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
