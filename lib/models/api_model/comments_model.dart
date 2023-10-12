// To parse this JSON data, do
//
//     final commentsModel = commentsModelFromJson(jsonString);

import 'dart:convert';

import 'feeds_model.dart';

CommentsModel? commentsModelFromJson(String str) => CommentsModel.fromJson(json.decode(str));

String commentsModelToJson(CommentsModel? data) => json.encode(data!.toJson());

class CommentsModel {
  CommentsModel({
    this.message,
    this.data,
  });

  String? message;
  Data? data;

  factory CommentsModel.fromJson(Map<String, dynamic> json) => CommentsModel(
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.totalSize,
    this.limit,
    this.offset,
    this.comments,
  });
//video full screen on click
  //video mute
  //image capture
  //video extentions
  // reel video crop
  // video with multiple images
  //
  int? totalSize;
  int? limit;
  int? offset;
  List<MenaFeedComment>? comments;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    totalSize: json["total_size"],
    limit: json["limit"],
    offset: json["offset"],
    comments: json["data"] == null ? [] : List<MenaFeedComment>.from(json["data"]!.map((x) => MenaFeedComment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total_size": totalSize,
    "limit": limit,
    "offset": offset,
    "data": comments == null ? [] : List<dynamic>.from(comments!.map((x) => x.toJson())),
  };
}

