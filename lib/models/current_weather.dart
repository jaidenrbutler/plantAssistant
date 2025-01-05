class CurrentWeather {
  final String city;
  final String description;
  final double currentTemp;

  CurrentWeather(
      {required this.city,
      required this.description,
      required this.currentTemp});

  // Factory Constructor
  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    if (json.isNotEmpty) {
      return CurrentWeather(
          city: json['name'],
          description: json['weather'][0]['description'],
          currentTemp: json['main']['temp']?.toDouble() ?? 0.0);
    } else {
      return CurrentWeather(
          city: "Unknown City",
          description: "Unknown Conditions",
          currentTemp: 0.0);
    }
  }
}
