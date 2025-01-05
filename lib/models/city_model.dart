class City {
  final String name;
  final String country;

  City({
    required this.name,
    required this.country,
  });

  static List<City> fromJson(Map<String, dynamic> json) {
    var results = json['results'] as List;

    return results.map((result) {
      return City(
        name: result['city'] ?? result['name'] ?? 'Unknown City',
        country: result['country'] ?? 'Unknown Country',
      );
    }).toList();
  }
}
