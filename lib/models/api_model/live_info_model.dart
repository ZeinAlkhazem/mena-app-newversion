import 'dart:convert';


LiveInfoModel userInfoModelFromJson(String str) => LiveInfoModel.fromJson(json.decode(str));

String userInfoModelToJson(LiveInfoModel data) => json.encode(data.toJson());


class LiveInfoModel {
  LiveInfoModel({
    required this.message,
    required this.data,
  });

  String message;

  LiveData data;

  factory LiveInfoModel.fromJson(Map<String, dynamic> json) => LiveInfoModel(
    message: json["message"],
    data: LiveData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data.toJson(),
  };
}

class LiveData {
  LiveData({
    required this.topics,
  });

  List<Topic> topics;

  factory LiveData.fromJson(Map<String, dynamic> json) => LiveData(
    topics: List<Topic>.from(json["topics"].map((x) => Topic.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "topics": List<Topic>.from(topics.map((x) => x.toJson())),
  };
}


class Topic {
  Topic({
    required this.id,
    required this.title,
    this.platform_id,
  });

  int id;
  String title;
  String? platform_id;

  factory Topic.fromJson(Map<String, dynamic> json) => Topic(
    id: json["id"],
    title: json["title"], 
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
  };
}
