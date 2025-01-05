class PlantSearchModel {
  final String accessToken;

  PlantSearchModel({
    required this.accessToken,
  });

  // factory constructor
  factory PlantSearchModel.fromJson(Map<String, dynamic> json) {
    // Extract the first result
    var entities = json['entities'] as List;

    if (entities.isNotEmpty) {
      var firstEntity = entities[0];
      String accessToken = firstEntity['access_token'];
      return PlantSearchModel(accessToken: accessToken);
    } else {
      throw Exception("No access Token Found");
    }
  }
}
