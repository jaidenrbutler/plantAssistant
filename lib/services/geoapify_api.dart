import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/city_model.dart';

Future<List<City>> fetchCities(String query) async {
  const apiKey = '96ed1f1731de416aaff7bdd3bf034d88';
  final url =
      'https://api.geoapify.com/v1/geocode/autocomplete?text=$query&type=city&format=json&apiKey=$apiKey';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);

      return City.fromJson(json);
    } else {
      debugPrint('Error ${response.statusCode}: ${response.body}');
      throw Exception('Failed to fetch cities');
    }
  } catch (e) {
    debugPrint('Exception caught: $e');
    throw Exception('Failed to fetch cities due to an exception');
  }
}
