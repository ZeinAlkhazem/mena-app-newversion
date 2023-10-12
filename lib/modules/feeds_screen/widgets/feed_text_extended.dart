import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';

class FeedTextExtended extends StatefulWidget {
  const FeedTextExtended({
    Key? key,
    required this.text,
    required this.maxLines,
  }) : super(key: key);

  final String text;
  final int maxLines;

  @override
  State<FeedTextExtended> createState() => _FeedTextExtendedState();
}

class _FeedTextExtendedState extends State<FeedTextExtended> {
  int? maxLines = 4;

  @override
  void initState() {
    // TODO: implement initState

    setState(() {
      maxLines = widget.maxLines;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (maxLines != null) {
            maxLines = null;
          } else {
            maxLines = 4;
          }
        });
      },
      child: SizedBox(
        width: double.maxFinite,
        child:
            // Text(widget.text),
            ExtendedText(
          '${widget.text}',
          maxLines: maxLines,
          style: mainStyle(context, 14,
              weight: FontWeight.w400, color: Color(0xff252525)),
          textAlign: TextAlign.justify,
          overflowWidget: TextOverflowWidget(
            position: TextOverflowPosition.end,
            align: TextOverflowAlign.center,
            child: Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('\u2026 '),
                  InkWell(
                    child: Text(
                      getTranslatedStrings(context).viewMore,
                      style: mainStyle(
                        context,
                        15,
                          color: mainBlueColor,
                        weight: FontWeight.w700
                      ),
                    ),
                    onTap: () {
                      logg('view more');
                      setState(() {
                        if (maxLines != null) maxLines = null;
                      });
                      // launch(
                      // 'https://github.com/fluttercandies/extended_text');
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
