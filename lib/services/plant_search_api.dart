import 'dart:convert';

import '../models/plant_search_model.dart';
import 'package:http/http.dart' as http;

Future<PlantSearchModel> plantSearchTokenApiCall(String name) async {
  var headers = {
    'Api-Key': 'KmHJYgdpLWqLkKE8uOE2m1qwZXTx7BmxyNvTkyoUui4UktOJ2u',
    'Content-Type': 'application/json'
  };

  var request = http.Request('GET',
      Uri.parse('https://plant.id/api/v3/kb/plants/name_search?q=$name'));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    String responseBody = await response.stream.bytesToString();
    Map<String, dynamic> json = jsonDecode(responseBody);
    return PlantSearchModel.fromJson(json);
  } else {
    throw Exception("Failed to fetch Data");
  }
}
