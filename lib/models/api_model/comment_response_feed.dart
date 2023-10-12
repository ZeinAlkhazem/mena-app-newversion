// To parse this JSON data, do
//
//     final commentResponseModel = commentResponseModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

import 'feeds_model.dart';

CommentResponseModel commentResponseModelFromJson(String str) => CommentResponseModel.fromJson(json.decode(str));

String commentResponseModelToJson(CommentResponseModel data) => json.encode(data.toJson());

class CommentResponseModel {
  CommentResponseModel({
    required this.message,
  required   this.menaFeed,
  });

  String message;
  MenaFeed menaFeed;

  factory CommentResponseModel.fromJson(Map<String, dynamic> json) => CommentResponseModel(
    message: json["message"],
    menaFeed: MenaFeed.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": menaFeed.toJson(),
  };
}




