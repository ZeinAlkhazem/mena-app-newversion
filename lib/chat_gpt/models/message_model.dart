class MessageModel {
  String role;
  String content;

  MessageModel({required this.content, required this.role});

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(content: json["content"], role: json["role"]);
  }

  Map<String, dynamic> toJson() {
    return {"role": role, "content": content};
  }
}
