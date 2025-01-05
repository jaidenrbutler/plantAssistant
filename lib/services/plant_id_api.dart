import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:plant_id_project/models/plant_identification.dart';

Future<PlantIdentification> apiCall(String image) async {
  var headers = {
    'Api-Key': 'GBQDg8YAO5mZgSXCs3xdLtVZv33KmohOUNsMOcKW3bjXOoqLFD',
    // GBQDg8YAO5mZgSXCs3xdLtVZv33KmohOUNsMOcKW3bjXOoqLFD New Key
    // KmHJYgdpLWqLkKE8uOE2m1qwZXTx7BmxyNvTkyoUui4UktOJ2u
    'Content-Type': 'application/json'
  };

  var request = http.Request('POST',
      Uri.parse('https://plant.id/api/v3/identification?details=common_names'));
  request.body = json.encode({
    "images": [image],
    // TODO: Geolocation?
    "latitude": 49.207,
    "longitude": 16.608,
  });
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 201) {
    String responseBody = await response.stream.bytesToString();
    Map<String, dynamic> json = jsonDecode(responseBody);
    return PlantIdentification.fromJson(json);
  } else {
    throw Exception("Failed to fetch data: ${response.statusCode}");
  }
}
