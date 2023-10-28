class PlatformModel {
  int id;
  String name;
  String description;
  int ranking;
  String image;
  DateTime? createdAt;

  PlatformModel(
      {required this.id,
      required this.name,
      required this.description,
      required this.image,
      required this.ranking,
      this.createdAt});

  factory PlatformModel.fromJson(Map<String, dynamic> json) {
    return PlatformModel(
      id: json.containsKey('id') ? json['id'] : "",
      name: json.containsKey('name') ? json['name'] : "",
      description: json.containsKey('description') ? json['description'] : "",
      image: json.containsKey('image') ? json['image'] : "",
      ranking: json.containsKey('ranking') ? json['ranking'] : 0,
      createdAt: json.containsKey('created_at') ? DateTime.tryParse(json['created_at']) : null,
    );
  }
}
