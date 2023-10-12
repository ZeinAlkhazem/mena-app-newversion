// To parse this JSON data, do
//
//     final likeCommentsModel = likeCommentsModelFromJson(jsonString);

import 'dart:convert';

import 'package:mena/models/api_model/feeds_model.dart';

LikeCommentsModel? likeCommentsModelFromJson(String str) => LikeCommentsModel.fromJson(json.decode(str));

String likeCommentsModelToJson(LikeCommentsModel? data) => json.encode(data!.toJson());

class LikeCommentsModel {
  LikeCommentsModel({
    this.message,
    this.comment,
  });

  String? message;
  MenaFeedComment? comment;

  factory LikeCommentsModel.fromJson(Map<String, dynamic> json) => LikeCommentsModel(
    message: json["message"],
    comment: MenaFeedComment.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": comment!.toJson(),
  };
}
