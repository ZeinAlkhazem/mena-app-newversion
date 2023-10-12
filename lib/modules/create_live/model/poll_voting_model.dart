class MenaPlatform {
  MenaPlatform({
    required this.id,
    required this.name,
    required this.image,
  });

  String? id;
  String? name;
  String? image;

  factory MenaPlatform.fromJson(Map<String, dynamic> json) => MenaPlatform(
        id: json["id"].toString(),
        name: json["name"].toString(),
        image: json["image"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
