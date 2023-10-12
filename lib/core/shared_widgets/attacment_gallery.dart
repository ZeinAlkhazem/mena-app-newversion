import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';

import '../../models/api_model/feeds_model.dart';
import '../responsive/responsive.dart';


class AttachmentsGallery extends StatefulWidget {
  const AttachmentsGallery({Key? key,required this.files, this.customFileIndex}) : super(key: key);
  final   List<FileElement> files;
  final int? customFileIndex;
  @override
  State<AttachmentsGallery> createState() => _AttachmentsGalleryState();
}

class _AttachmentsGalleryState extends State<AttachmentsGallery> {

  CarouselController carouselController = CarouselController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: newLightTextGreyColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: const DefaultBackTitleAppBar(
          title: '',
        ),
      ),
      body: SizedBox(
        // color: Colors.grey,
        height: double.maxFinite,
        child: CarouselSlider.builder(
          itemCount: widget.files.length,
          carouselController: carouselController,
          itemBuilder: (BuildContext context,
              int itemIndex, int pageViewIndex) =>
              AttachmentHandlerAccordingTypeWidget(
                type:widget.files[itemIndex].type!,
                inGrid: false,
                file:
                widget.files[itemIndex].path!,
                inGallery:true,
                inFeedOrGalleryCarousel: true,
              ),
          options: CarouselOptions(
            autoPlay: false,
            reverse: false,height: double.maxFinite,
            enableInfiniteScroll: false,
            enlargeCenterPage: true,
            viewportFraction:
            Responsive.isMobile(context) ? 1 : 1,
            aspectRatio: 1,
            initialPage: widget.customFileIndex == null
                ? 0
                : widget.customFileIndex!,
            scrollPhysics: ClampingScrollPhysics(),
          ),
        ),
      ),
    );
  }
}
