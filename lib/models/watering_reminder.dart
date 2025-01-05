import 'package:cloud_firestore/cloud_firestore.dart';

class WateringReminder {
  final String documentId;
  final String plantName;
  final DateTime reminderTime;
  final String plantId;

  WateringReminder({
    required this.documentId,
    required this.plantName,
    required this.reminderTime,
    required this.plantId,
  });

  Map<String, dynamic> toMap() {
    return {
      'plantName': plantName,
      'reminderTime': reminderTime,
      'plantId': plantId,
    };
  }

  factory WateringReminder.fromMap(Map<String, dynamic> map) {
    return WateringReminder(
      documentId: "",
      plantName: map['plantName'] ?? 'Unknown Plant',
      reminderTime: (map['reminderTime'] as Timestamp).toDate(),
      plantId: map['plantId'] ?? '',
    );
  }
}
