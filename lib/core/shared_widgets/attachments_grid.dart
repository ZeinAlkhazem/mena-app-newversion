import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';

import '../../models/api_model/feeds_model.dart';
import '../../modules/home_screen/sections_widgets/sections_widgets.dart';
import '../constants/constants.dart';
import '../functions/main_funcs.dart';
import 'mena_shared_widgets/custom_containers.dart';

class AttachmentsGrid extends StatefulWidget {
  final int maxLength;
  final List<FileElement> files;
  final Function(int) onAttachClicked;
  final Function onExpandClicked;
  final MenaFeed? menaFeed;
  final bool autoplay;

  AttachmentsGrid(
      {required this.files,
      required this.onAttachClicked,
      this.menaFeed,
      this.autoplay = true,
      required this.onExpandClicked,
      this.maxLength = 4,
      Key? key})
      : super(key: key);

  @override
  createState() => _AttachmentsGridState();
}

class _AttachmentsGridState extends State<AttachmentsGrid> {
  @override
  Widget build(BuildContext context) {
    var filesToView = buildAttachedFileToViewInGrid();

    if (widget.files.isEmpty) {
      return SizedBox();}
    else if (widget.files.length == 1 && widget.files[0].type! == 'image') {
      return CachedNetworkImage(imageUrl : widget.files[0].path!,fit: BoxFit.scaleDown,);
    }
    else if (widget.files.length == 1 && widget.files[0].type! != 'image') {
      /// only one file and not image
      return GestureDetector(
        onTap: () => widget.files[0].type == 'audio' ? null : widget.onAttachClicked(0),
        child: widget.files[0].type == 'video'
            ? HomeScreenVideoContainer(
                videoLink: widget.files[0].path!,
                autoplay: widget.autoplay,
                // customFit: BoxFit.cover,
                menaFeed: widget.menaFeed,
                testText: '2',
                comingFromDetails: false,
              )
            : AttachmentHandlerAccordingTypeWidget(
                inGrid: false, menaFeed: widget.menaFeed, file: widget.files[0].path!, type: widget.files[0].type!),
      );
    } else
      return
          // Text('filesToView: ${filesToView}\n file length: ${widget.files.length}');
          // widget.files.length==1?
          //
          // /// only one item so no grid view
          // AttachmentHandlerAccordingTypeWidget(file:
          // widget.files[0].path!
          //     ,type:   widget.files[0].type! ):
          filesToView.length < 3
              ?

              ///2
              GridView.count(
                  padding: EdgeInsets.zero,
                  crossAxisCount: filesToView.length < 2 ? 1 : 2,
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 3,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: filesToView,
                )
              : filesToView.length < 5
                  ?

                  /// 3 , 4
                  Column(
                      children: [
                        // Text(
                        //   'images.length < 5   '
                        //   'filesToView length: ${filesToView.length.toString()}\n'
                        //   'filesUrls: ${widget.filesUrls.length.toString()}\n'
                        //   'images before 2: ${filesToView.getRange(0, 1).toList().length.toString()}'
                        //   'images after 2: ${ filesToView.getRange(2, filesToView.length).toList().length.toString()}'
                        // ),
                        GridView.count(
                          crossAxisCount: 1,
                          crossAxisSpacing: 3,
                          mainAxisSpacing: 3,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: filesToView.getRange(0, 1).toList(),
                        ),
                        heightBox(1),
                        GridView.count(
                          crossAxisCount: filesToView.length == 3 ? 2 : 3,
                          crossAxisSpacing: 3,
                          mainAxisSpacing: 3,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: filesToView.getRange(1, filesToView.length).toList(),
                        )
                      ],
                    )
                  : Column(
                      children: [
                        Text('images.length >=5   '
                            'length: ${filesToView.length.toString()}'),
                        GridView.count(
                          crossAxisCount: 1,
                          crossAxisSpacing: 3,
                          mainAxisSpacing: 3,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: filesToView.getRange(0, 1).toList(),
                        ),
                        heightBox(1),
                        GridView.count(
                          crossAxisCount: 3,
                          crossAxisSpacing: 3,
                          mainAxisSpacing: 3,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: filesToView.getRange(1, filesToView.length).toList(),
                        )
                      ],
                    );
  }

  List<Widget> buildAttachedFileToViewInGrid() {
    int numImages = widget.files.length;
    List<Widget> widgetsToView = [];
    widgetsToView = List<Widget>.generate(min(numImages, widget.maxLength), (index) {
      String fileUrl = widget.files[index].path!;
      String fileType = widget.files[index].type!;

      // If its the last image
      if (index == widget.maxLength - 1) {
        // Check how many more images are left
        int remaining = numImages - widget.maxLength;

        // If no more are remaining return a simple image widget
        if (remaining == 0) {
          return GestureDetector(
            child: AttachmentHandlerAccordingTypeWidget(
              type: fileType,
              menaFeed: widget.menaFeed,
              file: fileUrl,
              autoplay: widget.autoplay,
            ),
            // handleaccordingfiletype
            // DefaultImage(
            //   backGroundImageUrl: fileUrl,
            //   boxFit: BoxFit.cover,
            // ),
            onTap: () => widget.onAttachClicked(index),
          );
        } else {
          // Create the facebook like effect for the last image with number of remaining  images
          return GestureDetector(
            onTap: () => widget.onExpandClicked(),
            child: Stack(
              fit: StackFit.expand,
              children: [
                DefaultImage(
                  backGroundImageUrl: fileUrl,
                  boxFit: BoxFit.cover,
                ),
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(defaultRadiusVal)),
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.black54.withOpacity(0.4),
                      child: Text(
                        '+' + remaining.toString(),
                        textWidthBasis: TextWidthBasis.longestLine,
                        style: mainStyle(context, 33, color: Colors.white.withOpacity(0.7), weight: FontWeight.w800),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      } else {
        return GestureDetector(
          child: AttachmentHandlerAccordingTypeWidget(
            type: fileType,
            file: fileUrl,
            menaFeed: widget.menaFeed,
          ),
          onTap: () => widget.onAttachClicked(index),
        );
      }
    });
    return widgetsToView;
  }
}
