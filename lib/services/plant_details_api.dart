import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/plant_details.dart';
import 'package:http/http.dart' as http;

Future<PlantDetails> plantDetailApiCall(String accessToken) async {
  var headers = {
    'Api-Key': 'GBQDg8YAO5mZgSXCs3xdLtVZv33KmohOUNsMOcKW3bjXOoqLFD',
    'Content-Type': 'application/json'
  };

  var request = http.Request(
      'GET',
      Uri.parse(
          'https://plant.id/api/v3/kb/plants/$accessToken?details=common_names,url,description,taxonomy,rank,gbif_id,inaturalist_id,image,synonyms,edible_parts,best_watering,propagation_methods&language=en'));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    String responseBody = await response.stream.bytesToString();
    Map<String, dynamic> json = jsonDecode(responseBody);
    return PlantDetails.fromJson(json);
  } else {
    debugPrint('Error ${response.statusCode}: $response');
    throw Exception("Failed to fetch Data");
  }
}
