import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/shared_widgets/attachments_grid.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
import '../../../models/api_model/feeds_model.dart';
import '../feed_details.dart';
import '../feed_image_viewer.dart';
import '../feeds_screen.dart';
import 'feed_text_extended.dart';

class FeedItemBody extends StatefulWidget {
  const FeedItemBody({
    Key? key,
    required this.menaFeed,
  }) : super(key: key);

  final MenaFeed menaFeed;

  @override
  State<FeedItemBody> createState() => _FeedItemBodyState();
}

class _FeedItemBodyState extends State<FeedItemBody> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if(menaFeed.files!=null){
    //   menaFeed.files!.add(menaFeed.files![0]);
    // }
    return DefaultContainer(
      width: double.maxFinite,
      borderColor: Colors.transparent,
      backColor: feedsWhiteColor,
      childWidget: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.menaFeed.text == null
                ? SizedBox()
                : widget.menaFeed.text!.isEmpty
                    ? SizedBox()
                    : Padding(
                        padding: EdgeInsets.only(bottom: 6.0),
                        child: FeedTextExtended(
                          text: widget.menaFeed.text!,
                          maxLines: (widget.menaFeed.files != null &&
                                  widget.menaFeed.files!.isNotEmpty)
                              ? 3
                              : 10,
                        )),

            /// files
            widget.menaFeed.files == null
                ? SizedBox()
                : AttachmentsGrid(
                    menaFeed: widget.menaFeed,
                    files: widget.menaFeed.files!,
                    onAttachClicked: (i) {
                      logg('current file index: $i');
                      //todo correct
                      if (widget.menaFeed.files![i].type == 'image')
                        navigateToWithoutNavBar(
                            context,
                            FeedImageViewer(
                              /// item index - length of all non images indexes before this element
                              customIndex: i -
                                  widget.menaFeed.files!
                                      .getRange(0, i)
                                      .where((element) =>
                                  element.type != 'image')
                                      .toList()
                                      .length,

                              menaFeed: widget.menaFeed,
                              fromDetails: false,
                            ),
                            '');
                      else
                      navigateToWithoutNavBar(
                          context,
                          FeedDetailsLayout(
                            menaFeed: widget.menaFeed,
                            customFileIndex: i,
                          ),
                          '');
                    },
                    onExpandClicked: () {
                      logg('expand clicked');
                      navigateToWithoutNavBar(
                          context,
                          FeedDetailsLayout(
                            menaFeed: widget.menaFeed,
                            customFileIndex: 3,
                          ),
                          '');
                    },
                    maxLength: 4,
                  )
          ],
        ),
      ),
    );
  }
}
