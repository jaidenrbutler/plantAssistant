class PlantDetails {
  final String documentID;
  final String commonNames;
  final String plantClass;
  final String plantGenus;
  final String wikiUrl;
  final String imageUrl;
  final String wateringTips;

  PlantDetails({
    required this.documentID,
    required this.commonNames,
    required this.plantClass,
    required this.plantGenus,
    required this.wikiUrl,
    required this.imageUrl,
    required this.wateringTips,
  });

  // Factory Constructor
  factory PlantDetails.fromJson(Map<String, dynamic> json) {
    // Extract the first common name if available
    var jsonCommonNames = json['common_names'] as List;
    String commonNames =
        jsonCommonNames.isNotEmpty ? jsonCommonNames[0] : "Unknown";

    String plantClass = json['taxonomy']?['class'] ?? "Unknown Class";
    String plantGenus = json['taxonomy']?['genus'] ?? "Unknown Genus";

    // Access the Wikipedia URL
    String wikiUrl = json['url'] ?? "No URL";
    String imageUrl = json['image']?['value'] ?? "No Image";

    String wateringTips = json['best_watering'] ?? 'Unknown';

    // Return a new PlantDetails instance
    return PlantDetails(
      documentID: "",
      commonNames: commonNames,
      plantClass: plantClass,
      plantGenus: plantGenus,
      wikiUrl: wikiUrl,
      imageUrl: imageUrl,
      wateringTips: wateringTips,
    );
  }
}
