import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plant_id_project/models/user_settings.dart';
import '../models/plant_details.dart';
import '../models/watering_reminder.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  final CollectionReference _plantsCollection =
      FirebaseFirestore.instance.collection('plants');

  final CollectionReference _reminderCollection =
      FirebaseFirestore.instance.collection('reminders');

  // Reference the database
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Getting the current user
  User? get currentUser => FirebaseAuth.instance.currentUser;

  Future<UserSettings> loadUserSettings(String userId) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
  }

  // Mark as watered method
  Future<void> markAsWatered(String reminderId, int intervalDays) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final nextWateringDate = DateTime.now().add(Duration(days: intervalDays));
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('reminders')
          .doc(reminderId)
          .update({'reminderTime': nextWateringDate});
    } catch (e) {
      debugPrint("Error updating reminder: $e");
    }
  }

  // Save a plant for the specific plant
  Future<void> savePlantforUser(
      String plantName,
      String plantClass,
      String plantGenus,
      String wikiUrl,
      String imageUrl,
      String wateringTips) async {
    final userId = currentUser?.uid;
    if (userId == null) return;

    try {
      await _db.collection('users').doc(userId).collection('plants').add({
        'commonName': plantName,
        'class': plantClass,
        'genus': plantGenus,
        'wikiUrl': wikiUrl,
        'imageUrl': imageUrl,
        'wateringTips': wateringTips,
      });
    } catch (e) {
      throw Exception("Error saving plant $e");
    }
  }

  Future<List<PlantDetails>> getAllPlants() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      throw Exception("User is not authenticated");
    }

    // Access the plants collection for the specific user
    final userPlantsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('plants');

    final querySnapshot = await userPlantsCollection.get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return PlantDetails(
        documentID: doc.id,
        commonNames: data['commonName'],
        plantClass: data['class'],
        plantGenus: data['genus'],
        wikiUrl: data['wikiUrl'],
        imageUrl: data['imageUrl'],
        wateringTips: data['wateringTips'],
      );
    }).toList();
  }

  Future<void> deletePlant(String documentId) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      await _db
          .collection('users')
          .doc(userId)
          .collection('plants')
          .doc(documentId)
          .delete();
      debugPrint("Plant with documentID: $documentId successfully deleted");
    } catch (e) {
      debugPrint("Error deleting plant with documentID $documentId. $e");
    }
  }

  /// <summary>
  /// Should return the list of watering reminders that are stored in the firestore database
  /// </summary>
  Future<List<WateringReminder>> getReminders() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    final userReminderCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('reminders');

    final querySnapshot = await userReminderCollection.get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return WateringReminder(
          documentId: doc.id,
          plantName: data['plantName'],
          reminderTime: (data['reminderTime'] as Timestamp).toDate(),
          plantId: "");
    }).toList();
  }

  /// <summary>
  /// Adds a reminder to the firebase collection using a reminder object passed through
  /// </summary>
  Future<void> addReminder(WateringReminder reminder) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    await _db
        .collection('users')
        .doc(userId)
        .collection('reminders')
        .add(reminder.toMap());
  }

  /// <summary>
  /// Removes a reminder from the collection using a reminderId as reference
  /// </summary>
  Future<void> deleteReminder(String reminderId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    await _db
        .collection('users')
        .doc(userId)
        .collection('reminders')
        .doc(reminderId)
        .delete();
  }

  /// <summary>
  /// Deletes all reminders from the collection
  /// </summary>
  Future<void> deleteAllReminders() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    final userReminderCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('reminders');

    final querySnapshot = await userReminderCollection.get();

    for (final doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }
}
