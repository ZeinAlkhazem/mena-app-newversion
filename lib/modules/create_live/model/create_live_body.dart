class CreateLiveBody {
  String? title;
  String? target;
  String? goal;
  String? liveNowCategoryId;

  CreateLiveBody();

  Map<String, dynamic> toJson() {
    return {
      "live_now_category_id": "1",
      "title" : title,
      "target" : target,
      "goal" : goal,
    };
  }
}
