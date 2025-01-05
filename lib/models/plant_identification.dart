class PlantIdentification {
  final String accessToken;
  final String plantName;
  final double probability;

  PlantIdentification({
    required this.accessToken,
    required this.plantName,
    required this.probability,
  });

  // Factory Constructor
  factory PlantIdentification.fromJson(Map<String, dynamic> json) {
    var suggestions = json['result']['classification']['suggestions'] as List;

    // access the first suggestion
    if (suggestions.isNotEmpty) {
      var firstSuggestion = suggestions[0];

      return PlantIdentification(
        accessToken: json['access_token'],
        plantName: firstSuggestion['name'],
        probability: firstSuggestion['probability']?.toDouble() ?? 0.0,
      );
    } else {
      return PlantIdentification(
        accessToken: "Cant find Plant",
        plantName: "Unknown Plant",
        probability: 0.0,
      );
    }
  }
}
