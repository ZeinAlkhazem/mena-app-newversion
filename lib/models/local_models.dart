import 'package:flutter/material.dart';

class ItemWithTitleAndCallback {
  final String? id;
  final String title;
  final String? thumbnailLink;
    final String? count;
  final Function()? onClickCallback;

  ItemWithTitleAndCallback({
    required this.title,
     this.id,
     this.count,
    required this.thumbnailLink,
    required this.onClickCallback,
  });
}
class ItemWithTitleAndImage {
  final String? id;
  final String title;
  final String? thumbnailLink;
    final String? count;
  final Function()? onClickCallback;

  ItemWithTitleAndImage({
    required this.title,
     this.id,
     this.count,
     this.thumbnailLink,
     this.onClickCallback,
  });
}

class FeedActionItem{
  final String id;
  final String title;
  FeedActionItem ({required this.id, required this.title});
}

class SelectorButtonModel {
  final String title;
  final String? image;
  final Function onClickCallback;
  final bool isSelected;

  final String? thumbnailSvgLink;

  SelectorButtonModel({
    required this.title,
    required this.onClickCallback,
    required this.isSelected,
    this.image,
    this.thumbnailSvgLink,
  });
}

class TimeRange{
  final DateTime from;
  final DateTime to;
  TimeRange({
    required this.from,
    required this.to,
});
}
class BodyItemModel {
  final String title;
  final Widget bodyWidget;

  BodyItemModel({
    required this.title,
    required this.bodyWidget,
  });
}
class AppointmentTypes {
  final String id;
  final String title;
  final String svgPic;
  final String? sub;

  AppointmentTypes({
    required this.id,
    required this.title,
    required this.svgPic,
     this.sub,
  });
}

class MenaSocialItem {
  final String name;
  final String? svgAssetLink;
  final String? jsonLink;
  final String? redirectLink;
  final bool? visible;

  MenaSocialItem({
    required this.name,
    required this.svgAssetLink,
     this.jsonLink,
    this.redirectLink,
    this.visible = true,
  });
}
class AppointmentTypeLocalModel {
  final String id;
  final String name;
  final String? svgAssetLink;
  // final String? redirectLink;
  // final bool? visible;

  AppointmentTypeLocalModel({
    required this.id,
    required this.name,
    required this.svgAssetLink,
    // this.redirectLink,
    // this.visible = true,
  });
}

