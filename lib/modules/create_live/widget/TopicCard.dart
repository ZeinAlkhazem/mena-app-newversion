import 'package:flutter/material.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/modules/create_live/widget/avatar_for_live.dart';

class TopicCard extends StatefulWidget {
  TopicCard({super.key,required this.title,required this.id,required this.selected});
  final String title;
  final int id;
  bool selected = false;

  @override
  State<TopicCard> createState() => _TopicCardState();
}

class _TopicCardState extends State<TopicCard> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(bottom:10.0),
      child: Column(
        children: [
          Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AvatarForLive(isOnline: true,pictureUrl:"https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80"),
          widthBox(12),
          Text(
            widget.title.capitalize(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color:widget.selected ? Colors.red :Colors.black,fontSize: 14,
            ),
          ),
        ],
      )
        ],
      ),
    );
  }
}
extension StringExtension on String {
    String capitalize() {
      return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
    }
}