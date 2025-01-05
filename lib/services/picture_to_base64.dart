import 'dart:convert';
import 'package:flutter/services.dart';

Future<String> convertImageToBase64(String imagePath) async {
  try {
    final byteData = await rootBundle.load(imagePath);
    final bytes = byteData.buffer.asUint8List();

    return base64Encode(bytes);
  } catch (e) {
    throw Exception('Error converting image to Base64 $e');
  }
}
