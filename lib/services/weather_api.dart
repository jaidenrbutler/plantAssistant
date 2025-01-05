import 'dart:convert';
import '../models/current_weather.dart';
import 'package:http/http.dart' as http;

const weatherApiKey = '18b43e8170888b56a830df0a55f1b318';
const currentWeatherEndpoint =
    'https://api.openweathermap.org/data/2.5/weather';

Future<CurrentWeather> weatherProvider({required String city}) async {
  Uri url = Uri.parse(
      '$currentWeatherEndpoint?units=metric&q=$city&appid=$weatherApiKey');

  final response = await http.get(url);

  if (response.statusCode != 200) {
    throw Exception(
        "There was a problem with the request: Status${response.statusCode} recieved");
  }

  final json = jsonDecode(response.body);

  return CurrentWeather.fromJson(json);
}
