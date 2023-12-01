import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';

import '../models/item_model.dart';

class RoundedExpansionPanel extends StatefulWidget {
  final Map<String, String> items;

  const RoundedExpansionPanel({super.key, required this.items});

  @override
  _RoundedExpansionPanelState createState() => _RoundedExpansionPanelState();
}

class _RoundedExpansionPanelState extends State<RoundedExpansionPanel> {
  @override
  Widget build(BuildContext context) {
    List<DisclaimItem> _items = generateItems(context, widget.items);

    return ListView(
      children: _items.map<Widget>((DisclaimItem item) {
        return IgnorePointer(
          ignoring: item.expandedValue.isEmpty,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.symmetric(vertical: 5.h),
            child: Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                onExpansionChanged: (expand) {
                  setState(() {
                    item.isExpanded = expand;
                  });
                },
                expandedAlignment: Alignment.topLeft,
                childrenPadding:
                    EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                title: Text(
                  item.headerValue,
                ),
                trailing: item.expandedValue.isEmpty
                    ? SizedBox()
                    : Icon(
                        item.isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: mainBlueColor,
                      ),
                children: item.expandedValue.isEmpty
                    ? []
                    : [Text(item.expandedValue)],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

List<DisclaimItem> generateItems(
    BuildContext context, Map<String, String> disclaimers) {
  return List<DisclaimItem>.generate(disclaimers.length, (int index) {
    return DisclaimItem(
      headerValue: disclaimers.keys.elementAt(index),
      expandedValue: disclaimers.values.elementAt(index),
    );
  });
}
