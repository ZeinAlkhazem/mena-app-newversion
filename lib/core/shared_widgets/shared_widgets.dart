import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:mena/core/cache/cache.dart';
import 'package:mena/core/main_cubit/main_cubit.dart';
import 'package:mena/core/responsive/responsive.dart';
import 'package:mena/core/shared_widgets/default_audio_player.dart';
import 'package:mena/core/shared_widgets/pdf_view_layout.dart';
import 'package:mena/models/api_model/feeds_model.dart';
import 'package:mena/modules/auth_screens/sign_in_screen.dart';
import 'package:mena/modules/create_live/create_live_screen.dart';
import 'package:mena/modules/live_screens/live_cubit/live_cubit.dart';
import 'package:mena/modules/platform_provider/cubit/provider_cubit.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/api_model/live_categories.dart';
import '../../models/api_model/lives_model.dart';
import '../../models/local_models.dart';
import '../../modules/appointments/appointments_layouts/my_appointments.dart';
import '../../modules/create_live/widget/radius_20_container.dart';
import '../../modules/feeds_screen/post_a_feed.dart';
import '../../modules/live_screens/start_live_form.dart';
import '../../modules/main_layout/main_layout.dart';
import '../../modules/messenger/messenger_layout.dart';
import '../../modules/messenger/msngr_cubit/messenger_cubit.dart';
import '../constants/constants.dart';
import '../functions/main_funcs.dart';
import 'mena_shared_widgets/custom_containers.dart';

class DefaultContainer extends StatelessWidget {
  const DefaultContainer(
      {Key? key,
      this.width,
      this.height,
      this.backColor,
      this.borderColor,
      this.childWidget,
      this.backGroundImageUrl,
      this.withBoxShadow,
      this.decoration,
      this.radius,
      this.borderWidth,
      this.customConstraints,
      this.withoutBorder = false,
      this.withoutRadius})
      : super(key: key);

  final double? width;
  final double? height;
  final Color? backColor;
  final Color? borderColor;
  final Widget? childWidget;
  final String? backGroundImageUrl;
  final Decoration? decoration;
  final bool? withBoxShadow;
  final double? radius;
  final double? borderWidth;
  final bool? withoutRadius;
  final bool? withoutBorder;
  final BoxConstraints? customConstraints;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      constraints: customConstraints,
      decoration: decoration ??
          BoxDecoration(
            boxShadow: withBoxShadow == null
                ? null
                : withBoxShadow == true
                    ? softBoxShadow
                    : null,
            color: backColor ?? Colors.white,
            image: (backGroundImageUrl != null && backGroundImageUrl != '')
                ? DecorationImage(
                    image: NetworkImage(
                      backGroundImageUrl!,
                    ),
                    fit: BoxFit.fitWidth,
                  )
                : null,
            borderRadius: BorderRadius.circular(withoutRadius != null ? 0.0 : radius ?? defaultRadiusVal),
            border: withoutBorder == true
                ? null
                : Border.all(width: borderWidth ?? 1.0, color: borderColor ?? mainBlueColor),
          ),
      child: childWidget,
    );
  }
}

class NotificationCounterBubble extends StatelessWidget {
  const NotificationCounterBubble({
    Key? key,
    required this.counter,
  }) : super(key: key);
  final String counter;

  @override
  Widget build(BuildContext context) {
    return counter == '0'
            ? SizedBox()
            : Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(33.sp)),
                  // shape: BoxShape.circle
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(
                    constraints: BoxConstraints(
                      minWidth: 15.sp,
                      minHeight: 15.sp,
                      // maxWidth: 15.sp,
                      maxHeight: 15.sp,
                    ),
                    decoration: BoxDecoration(
                      color: alertRedColor,
                      borderRadius: BorderRadius.all(Radius.circular(118.sp)),
                    ),
                    child: FittedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Text(
                          counter,
                          style: mainStyle(
                            context,
                            8,
                            isBold: true,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )

        //   CircleAvatar(
        //   radius: 8,
        //   backgroundColor: alertRedColor,
        //   child: Padding(
        //     padding: EdgeInsets.all(1.0.sp),
        //     child: Center(
        //         child: FittedBox(
        //             child: Text(
        //               counter,
        //               style: mainStyle(
        //                 context,
        //                 8,
        //                 color: Colors.white,
        //                 weight: FontWeight.w800,
        //               ),
        //             ))),
        //   ),
        // )
        ;
  }
}

class DefaultShadowedContainer extends StatelessWidget {
  const DefaultShadowedContainer({
    Key? key,
    this.width,
    this.height,
    this.backColor,
    this.borderColor,
    this.borderWidth,
    this.childWidget,
    this.backGroundImageUrl,
    this.radius,
    this.customOffset,
    this.boxConstraints,
    this.boxShadow,
    this.withoutBorder = false,
    this.withoutRadius,
  }) : super(key: key);

  final List<BoxShadow>? boxShadow;
  final double? width;
  final double? height;
  final Color? backColor;
  final Color? borderColor;
  final double? borderWidth;
  final Widget? childWidget;
  final String? backGroundImageUrl;
  final BoxConstraints? boxConstraints;
  final Offset? customOffset;
  final bool? withoutRadius;
  final bool withoutBorder;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      constraints: boxConstraints,
      decoration: BoxDecoration(
        color: backColor ?? Colors.white,
        borderRadius: withoutRadius != null ? null : BorderRadius.circular(radius ?? defaultRadiusVal),
        border: withoutBorder ? null : Border.all(width: borderWidth ?? 1.0, color: borderColor ?? Colors.transparent),
        boxShadow: boxShadow ??
            [
              BoxShadow(
                color: Color(0x29000000),
                offset: customOffset ?? Offset(0, 2),
                blurRadius: 3,
              ),
            ],
      ),
      child: childWidget,
    );
  }
}

class DefaultImage extends StatelessWidget {
  const DefaultImage(
      {Key? key,
      this.width,
      this.height,
      this.backColor,
      this.borderColor,
      this.borderWidth,
      required this.backGroundImageUrl,
      this.radius,
      this.placeholderScale,
      this.boxFit,
      this.decoration,
      this.customImageCacheHeight,
      this.withoutRadius})
      : super(key: key);
  final double? width;
  final double? height;
  final Color? backColor;
  final Color? borderColor;
  final double? borderWidth;
  final String backGroundImageUrl;
  final bool? withoutRadius;
  final double? radius;
  final double? placeholderScale;
  final BoxFit? boxFit;

  final BoxDecoration? decoration;
  final int? customImageCacheHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        decoration: decoration ??
            BoxDecoration(
              color: backColor,
              borderRadius: BorderRadius.circular(withoutRadius != null ? 0.0 : radius ?? defaultRadiusVal),
              border: Border.all(width: borderWidth ?? 0.0, color: borderColor ?? Colors.transparent),
            ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(withoutRadius != null ? 0.0 : radius ?? defaultRadiusVal),
            child: backGroundImageUrl == ""
                ? SizedBox()
                : backGroundImageUrl.endsWith('.svg')
                    ? SvgPicture.network(backGroundImageUrl)
                    :

                    ///cached
                    CachedNetworkImage(
                        // width: width??double.infinity,
                        width: width,
                        height: height,
                        // memCacheHeight: 800,
                        imageUrl: backGroundImageUrl,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: boxFit ?? BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => DefaultLoaderGrey(),
                        errorWidget: (context, url, error) =>
                            GestureDetector(onTap: () {}, child: Center(child: const ImageLoadingError())),
                      )

            ///
            /// last used commented for now
            ///
            ///NetworkImageWithRetry
            ///
            //     ExtendedImage.network(backGroundImageUrl!,
            //
            //         // width: ScreenUtil.instance.setWidth(400),
            //         // height: ScreenUtil.instance.setWidth(400),
            //         fit: BoxFit.fill,
            //         cache: true,
            //         clearMemoryCacheWhenDispose: true,
            //         loadStateChanged: (ExtendedImageState state) {
            //   switch (state.extendedImageLoadState) {
            //     case LoadState.loading:
            //       // _controller.reset();
            //       // return DefaultLoader();
            //       break;
            //     ///if you don't want override completed widget
            //     ///please return null or state.completedWidget
            //     //return null;
            //     //return state.completedWidget;
            //     case LoadState.completed:
            //       // _controller.forward();
            //       // return DefaultLoader();
            //       break;
            //     case LoadState.failed:
            //       // _controller.reset();
            //       return GestureDetector(
            //         child: Stack(
            //           fit: StackFit.expand,
            //           children: <Widget>[
            //            ImageLoadingError(),
            //             Positioned(
            //               bottom: 0.0,
            //               left: 0.0,
            //               right: 0.0,
            //               child: Text(
            //                 "load image failed, click to reload",
            //                 textAlign: TextAlign.center,
            //               ),
            //             )
            //           ],
            //         ),
            //         onTap: () {
            //           state.reLoadImage();
            //         },
            //       );
            //       break;
            //   }
            // }
            //         // border: Border.all(color: Colors.red, width: 1.0),
            //         // shape: boxShape,
            //         // borderRadius: BorderRadius.all(Radius.circular(30.0)),
            //         //cancelToken: cancellationToken,
            //         )
            // Image(image:
            // NetworkImageWithRetry(backGroundImageUrl!,))
            ///
            ///
            ///
            ///
            ///
            ///
            ///
          ///
            /// FadeInImage
            // FadeInImage.assetNetwork(

            //     placeholder: 'assets/images/public/loader.gif',
            //     image: backGroundImageUrl,
            //     // placeholder: kTransparentImage,
            //     placeholderScale: placeholderScale ?? 8,
            //     placeholderFit: BoxFit.none,
            //     height: height,
            //     width: width,
            //     fit: boxFit ?? BoxFit.cover,
            //     imageErrorBuilder: (context, error, stackTrace) =>
            //         const Center(child: ImageLoadingError()),
            //     placeholderErrorBuilder: (context, error, stackTrace) =>
            //         DefaultLoaderGrey(),
            //   ),
            ));
  }
}

class DefaultImageFadeInOrSvg extends StatelessWidget {
  const DefaultImageFadeInOrSvg(
      {Key? key,
      this.width,
      this.height,
      this.backColor,
      this.borderColor,
      this.borderWidth,
      required this.backGroundImageUrl,
      this.radius,
      this.placeholderScale,
      this.boxFit,
      this.decoration,
      this.boxConstraints,
      this.customImageCacheHeight,
      this.withoutRadius})
      : super(key: key);
  final double? width;
  final double? height;
  final Color? backColor;
  final Color? borderColor;
  final double? borderWidth;
  final String backGroundImageUrl;
  final bool? withoutRadius;
  final double? radius;
  final double? placeholderScale;
  final BoxConstraints? boxConstraints;
  final BoxFit? boxFit;
  final BoxDecoration? decoration;
  final int? customImageCacheHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        constraints: boxConstraints,
        decoration: decoration ??
            BoxDecoration(
              color: backColor,
              borderRadius: BorderRadius.circular(withoutRadius != null ? 0.0 : radius ?? defaultHorizontalPadding),
              border: Border.all(width: borderWidth ?? 0.0, color: borderColor ?? Colors.transparent),
            ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(withoutRadius != null ? 0.0 : radius ?? defaultHorizontalPadding),
          child: backGroundImageUrl == ""
              ? SizedBox()
              :

              ///cached
              // CachedNetworkImage(
              //     // width: width??double.infinity,
              //     width: width,
              //     height: height,
              //     imageUrl: backGroundImageUrl ?? '',
              //     imageBuilder: (context, imageProvider) => Container(
              //       decoration: BoxDecoration(
              //         image: DecorationImage(
              //           image: imageProvider,
              //           fit: boxFit ?? BoxFit.cover,
              //         ),
              //       ),
              //     ),
              //     placeholder: (context, url) => DefaultLoaderGrey(),
              //
              //     errorWidget: (context, url, error) => GestureDetector(
              //         onTap: () {},
              //         child: Center(child: const ImageLoadingError())),
              //   )

              ///
              /// last used commented for now
              ///
              ///NetworkImageWithRetry
              ///
              //     ExtendedImage.network(backGroundImageUrl!,
              //
              //         // width: ScreenUtil.instance.setWidth(400),
              //         // height: ScreenUtil.instance.setWidth(400),
              //         fit: BoxFit.fill,
              //         cache: true,
              //         clearMemoryCacheWhenDispose: true,
              //         loadStateChanged: (ExtendedImageState state) {
              //   switch (state.extendedImageLoadState) {
              //     case LoadState.loading:
              //       // _controller.reset();
              //       // return DefaultLoader();
              //       break;
              //     ///if you don't want override completed widget
              //     ///please return null or state.completedWidget
              //     //return null;
              //     //return state.completedWidget;
              //     case LoadState.completed:
              //       // _controller.forward();
              //       // return DefaultLoader();
              //       break;
              //     case LoadState.failed:
              //       // _controller.reset();
              //       return GestureDetector(
              //         child: Stack(
              //           fit: StackFit.expand,
              //           children: <Widget>[
              //            ImageLoadingError(),
              //             Positioned(
              //               bottom: 0.0,
              //               left: 0.0,
              //               right: 0.0,
              //               child: Text(
              //                 "load image failed, click to reload",
              //                 textAlign: TextAlign.center,
              //               ),
              //             )
              //           ],
              //         ),
              //         onTap: () {
              //           state.reLoadImage();
              //         },
              //       );
              //       break;
              //   }
              // }
              //         // border: Border.all(color: Colors.red, width: 1.0),
              //         // shape: boxShape,
              //         // borderRadius: BorderRadius.all(Radius.circular(30.0)),
              //         //cancelToken: cancellationToken,
              //         )
              // Image(image:
              // NetworkImageWithRetry(backGroundImageUrl!,))
              ///
              ///
              ///
              ///
              ///
              ///
              ///
              /// Svg supported
              backGroundImageUrl.endsWith('.svg')
                  ? SvgPicture.network(
                      backGroundImageUrl,
                      placeholderBuilder: (c) => DefaultLoaderColor(),
                      height: height ?? 0.1.sh,
                      fit: BoxFit.contain,
                    )
                  :

                  /// FadeInImage
                  FadeInImage.assetNetwork(
                      placeholder: 'assets/images/public/loader.gif',
                      image: backGroundImageUrl,
                      // placeholder: kTransparentImage,
                      placeholderScale: placeholderScale ?? 8,
                      placeholderFit: BoxFit.none,
                      height: height,
                      width: width,
                      fit: boxFit ?? BoxFit.cover,
                      imageErrorBuilder: (context, error, stackTrace) => const Center(child: ImageLoadingError()),
                      placeholderErrorBuilder: (context, error, stackTrace) => DefaultLoaderGrey(),
                    ),
        ));
  }
}

class ImageLoadingError extends StatelessWidget {
  const ImageLoadingError({Key? key, this.customHeight, this.customWidth}) : super(key: key);
  final double? customHeight;
  final double? customWidth;

  /*
  error happened while loading image
   */

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.error);
  }
}

class MainBackground extends StatelessWidget {
  const MainBackground({
    Key? key,
    this.bodyWidget,
    this.hideRainbow = false,
    this.customColor,
  }) : super(key: key);
  final Widget? bodyWidget;
  final bool hideRainbow;
  final Color? customColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Container(
                color: customColor ?? Colors.white,
              ),
            ),
            // hideRainbow ? SizedBox() : const RainbowRow(),
          ],
        ),
        bodyWidget ?? const SizedBox(),
      ],
    );
  }
}

class RainbowRow extends StatelessWidget {
  const RainbowRow({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: rainBowBarHeight,
      child: Row(
        children: const [
          ExpandedColoredContainer(color: Color(0xffD50000)),
          ExpandedColoredContainer(color: Color(0xffFADB3A)),
          ExpandedColoredContainer(color: Color(0xff388E3C)),
          ExpandedColoredContainer(color: Color(0xff003F81)),
          ExpandedColoredContainer(color: Color(0xffB9360C)),
          ExpandedColoredContainer(color: Color(0xff6FD86F)),
          ExpandedColoredContainer(color: Color(0xff5286FF)),
          ExpandedColoredContainer(color: Color(0xff35C1F1)),
          ExpandedColoredContainer(color: Color(0xffD21034)),
          ExpandedColoredContainer(color: Color(0xff003F81)),
        ],
      ),
    );
  }
}

class ExpandedColoredContainer extends StatelessWidget {
  const ExpandedColoredContainer({
    Key? key,
    required this.color,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(color: color));
  }
}

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({Key? key, this.onFieldChanged}) : super(key: key);

  final Function(String)? onFieldChanged;

  @override
  Widget build(BuildContext context) {
    ///
    var localizationStrings = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
              child: DefaultInputField(
            // label: '',
            label: localizationStrings!.search,
            // labelWidget: Text(
            //   localizationStrings!.search,
            //   style: mainStyle(context, 13, color: newDarkGreyColor, weight: FontWeight.w700),
            // ),
            onFieldChanged: onFieldChanged,
            customHintText: 'Search by country name',
            suffixIcon: SvgPicture.asset(
              'assets/svg/search.svg',
              width: 20.w,
            ),
          )),
          // SvgPicture.asset('assets/svg/search.svg'),
        ],
      ),
    );
  }
}

class IconLabelInputWidget extends StatelessWidget {
  const IconLabelInputWidget({
    Key? key,
    this.svgAssetLink,
    // this.customColor,
    required this.labelText,
  }) : super(key: key);

  final String? svgAssetLink;
  final String labelText;

  // final Color? customColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: customColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // svgAssetLink == null ? SizedBox() : widthBox(defaultHorizontalPadding * 1),
            svgAssetLink == null
                ? SizedBox()
                : SizedBox(
                    width: 18.sp,
                    height: 18.sp,
                    child: SvgPicture.asset(
                      svgAssetLink!,
                      width: 18.sp,
                      color: newDarkGreyColor,
                      height: 18.sp,
                    ),
                  ),
            widthBox(5.w),
            Text(
              labelText,
              style: mainStyle(context, 12, color: newDarkGreyColor, weight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class BlurredAndScaledImage extends StatelessWidget {
  final String imageUrl;
  final double blurIntensity;

  BlurredAndScaledImage({
    required this.imageUrl,
    required this.blurIntensity,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Stack(
        children: [
          // Blurred image with BackdropFilter
          CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurIntensity, sigmaY: blurIntensity),
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          // Original image scaled down
          Center(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.scaleDown,
            ),
          ),
        ],
      ),
    );
  }
}

class AttachmentHandlerAccordingTypeWidget extends StatelessWidget {
  const AttachmentHandlerAccordingTypeWidget({
    Key? key,
    required this.type,
    required this.file,
    this.comingFromDetails = false,
    this.inFeedOrGalleryCarousel = false,
    this.inGallery = false,
    this.inGrid = true,
    this.autoplay = true,
    this.menaFeed,
  }) : super(key: key);

  final String type;
  final String file;
  final bool inFeedOrGalleryCarousel;
  final bool inGallery;
  final bool inGrid;
  final bool autoplay;
  final bool comingFromDetails;
  final MenaFeed? menaFeed;

  @override
  Widget build(BuildContext context) {
    return type == 'image'
        ? Center(
            child:
                // inFeedOrGalleryCarousel
                //     ? PhotoViewWithZoomContainer(
                //         picture: file,
                //       )
                //     :

            BlurredAndScaledImage(
              imageUrl: file,
              blurIntensity: 12.0,
            ),
            //     DefaultImage(
            //   backGroundImageUrl: file,
            //   boxFit: inFeedOrGalleryCarousel ? BoxFit.contain : BoxFit.scaleDown,//todo wait client respond cover to scale down
            //   placeholderScale: 99,
            // ),
          )
        : type == 'audio'
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [DefaultAudioPlayer(audioFileLink: file)],
              )
            : type == 'video'
                ? Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: HomeScreenVideoContainer(
                      comingFromDetails: comingFromDetails,
                      videoLink: file,
                      menaFeed: menaFeed,
                      autoplay: autoplay,
                      testText: '4',
                      customFit: BoxFit.contain,
                    ),
                  )
                : type == 'file'
                    ? !inGrid
                        ? Center(
                            child: DefaultShadowedContainer(
                            childWidget: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/svg/icons/attachedfile.svg',
                                    width: 44.w,
                                    // color: Colors.grey,
                                  ),
                                  widthBox(5.w),
                                  Expanded(
                                    child: Text(
                                      '${file.split('/').last}',
                                      style: mainStyle(context, 13),
                                    ),
                                  ),
                                  TextButton(
                                      style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          // minimumSize: Size(50, 30),
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          alignment: Alignment.centerLeft),
                                      onPressed: () async {
                                        logg('launching $file');
                                        if (file.endsWith('.pdf')) {
                                          navigateToWithoutNavBar(context, PdfViewerLayout(pdfLink: file), '');
                                        } else {
                                          if (!await launchUrl(Uri.parse(file))) {
                                            throw 'Could not launch ${file}';
                                          }
                                        }
                                      },
                                      child: Text(
                                        'Open',
                                        style: mainStyle(context, 12, color: mainBlueColor),
                                      ))
                                ],
                              ),
                            ),
                          ))
                        : DefaultShadowedContainer(
                            childWidget: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/svg/icons/attachedfile.svg',
                                    width: 44.w,
                                    // color: Colors.grey,
                                  ),
                                  widthBox(5.w),
                                  Text(
                                    '${file.split('/').last}',
                                    style: mainStyle(context, 13),
                                  ),
                                  TextButton(
                                      style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          // minimumSize: Size(50, 30),
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          alignment: Alignment.centerLeft),
                                      onPressed: () async {
                                        if (!await launchUrl(Uri.parse(file))) {
                                          throw 'Could not launch ${file}';
                                        }
                                      },
                                      child: Text(
                                        'Open',
                                        style: mainStyle(context, 12, color: mainBlueColor),
                                      ))
                                ],
                              ),
                            ),
                          )
                    : SizedBox();
  }
}

class PhotoViewWithZoomContainer extends StatefulWidget {
  const PhotoViewWithZoomContainer({
    Key? key,
    required this.picture,
  }) : super(key: key);

  final String picture;

  @override
  State<PhotoViewWithZoomContainer> createState() => _PhotoViewWithZoomContainerState();
}

class _PhotoViewWithZoomContainerState extends State<PhotoViewWithZoomContainer> {
  final keyPhotoView = GlobalKey();

  // late PhotoViewControllerBase photoViewControllerBase;

  late double scaleCopy;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // ProductDetailsCubit.get(context).setupControllerZoom();
    logg('initttttt');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logg('biuisajdkjk');
    // var productDetailsCubit = ProductDetailsCubit.get(context);
    return EasyImageView(
      imageProvider: CachedNetworkImageProvider(
        widget.picture,
      ),
      minScale: 0.5,
      doubleTapZoomable: true,
      maxScale: 10,
    );
    //   PhotoView(
    //   // customSize: Size(246.h, 380.w),
    //   initialScale: PhotoViewComputedScale.covered,
    //   enableRotation: false,
    //   minScale: PhotoViewComputedScale.contained,
    //   loadingBuilder: (ctx, e) => DefaultLoader(
    //     customHeight: 0.2.sh,
    //     customWidth: 0.2.sw,
    //   ),
    //   controller: productDetailsCubit.cont,
    //   backgroundDecoration: const BoxDecoration(color: Colors.transparent),
    //   imageProvider: NetworkImage(
    //     widget.picture,
    //   ),
    // );
  }
}

///
class DefaultInputField extends StatelessWidget {
  const DefaultInputField({
    Key? key,
    this.label,
    // this.labelWidget,
    this.suffixIcon,
    this.obscureText,
    this.controller,
    this.focusNode,
    this.customHintText,
    this.unFocusedBorderColor,
    this.focusedBorderColor,
    this.borderRadius,
    this.maxLength,
    this.maxLines,
    this.onTap,
    this.readOnly = false,
    this.validate,
    this.enabled,
    this.onFieldChanged,
    this.withoutLabelPadding = false,
    this.customTextInputType,
    this.floatingLabelAlignment,
    this.fillColor,
    this.floatingLabelBehavior,
    this.prefixWidget,
    this.autoValidateMode = AutovalidateMode.disabled,
    this.edgeInsetsGeometry,
    this.labelTextStyle,
  }) : super(key: key);

  final String? label;
  final String? customHintText;

  final TextStyle? labelTextStyle;
  // final Widget? labelWidget;
  final bool withoutLabelPadding;
  final FocusNode? focusNode;
  final bool? obscureText;
  final bool? enabled;
  final bool readOnly;
  final Widget? suffixIcon;
  final Widget? prefixWidget;
  final Color? unFocusedBorderColor;
  final Color? focusedBorderColor;
  final Color? fillColor;
  final Function(String)? onFieldChanged;
  final Function()? onTap;
  final TextEditingController? controller;
  final String? Function(String?)? validate;
  final double? borderRadius;
  final int? maxLines;
  final int? maxLength;
  final AutovalidateMode? autoValidateMode;
  final EdgeInsetsGeometry? edgeInsetsGeometry;
  final TextInputType? customTextInputType;

  final FloatingLabelAlignment? floatingLabelAlignment;
  final FloatingLabelBehavior? floatingLabelBehavior;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      onTap: onTap,
      maxLength: maxLength,
      onChanged: onFieldChanged,
      keyboardType: customTextInputType,
      obscureText: obscureText ?? false,
      autovalidateMode: autoValidateMode,
      readOnly: readOnly,
      enabled: enabled,
      decoration: InputDecoration(
        errorMaxLines: 3,
        isDense: true,
        filled: true,
        errorStyle: mainStyle(context, 11, color: Colors.red, weight: FontWeight.w700),
        hintText: customHintText ?? label ?? '...',
        floatingLabelAlignment: floatingLabelAlignment,
        // floatingLabelBehavior: floatingLabelBehavior,
        floatingLabelBehavior: floatingLabelBehavior ?? FloatingLabelBehavior.never,
        hintStyle: mainStyle(context, 12, color: newDarkGreyColor, weight: FontWeight.w700),
        contentPadding: edgeInsetsGeometry ??
            EdgeInsets.symmetric(vertical: Responsive.isMobile(context) ? 15 : 20.0, horizontal: 10.0),
        border: const OutlineInputBorder(),
        suffixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
          child: suffixIcon,
        ),
        prefixIcon: prefixWidget != null
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                child: prefixWidget,
              )
            : null,
        suffixIconConstraints: BoxConstraints(maxHeight: 30.w),
        labelStyle: labelTextStyle ?? mainStyle(context, 13, color: newDarkGreyColor, weight: FontWeight.w700),
        // labelText: label,
        label: Text(label ?? ''),
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: withoutLabelPadding ? 0.0 : 2.0),
        //   child: labelWidget,
        // ),
        fillColor: fillColor ?? newLightGreyColor,
        focusColor: fillColor ?? newLightGreyColor,

        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: unFocusedBorderColor ?? Colors.red, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? defaultRadiusVal))),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: unFocusedBorderColor ?? Colors.red.withOpacity(0.6), width: 1),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? defaultRadiusVal))),

        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: focusedBorderColor ?? mainBlueColor, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? defaultRadiusVal))),

        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: unFocusedBorderColor ?? mainBlueColor.withOpacity(0.7), width: 1),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? defaultRadiusVal))),
        disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: unFocusedBorderColor ?? mainBlueColor.withOpacity(0.7), width: 1),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? defaultRadiusVal))),
      ),
      // decoration: InputDecoration(
      //   contentPadding: EdgeInsets.all(10.h),
      //   // icon: Icon(Icons.send),
      //   // hintText: 'Hint Text',
      //   // helperText: 'Helper Text',
      //   // counterText: '0 characters',
      //
      //   focusedBorder: OutlineInputBorder(
      //       borderSide:
      //       const BorderSide(color: Color(0xffa4c4f4), width: 2.0),
      //       borderRadius: BorderRadius.all(Radius.circular(11.0.sp))),
      //
      //   enabledBorder: OutlineInputBorder(
      //       borderSide:
      //       const BorderSide(color: Color(0xffa4c4f4), width: 1.0),
      //       borderRadius: BorderRadius.all(Radius.circular(11.0.sp))),
      // ),
      validator: validate,
      minLines: 1,
      maxLines: maxLines ?? 1,
      // height: 41.h,
      // decoration: BoxDecoration(
      //   color: const Color(0xffffffff),
      //   borderRadius: BorderRadius.circular(10.0),
      //   border: Border.all(width: 1.0, color: const Color(0xffa4c4f4)),
      // ),
    );
  }
}

class ChatInputField extends StatelessWidget {
  const ChatInputField({
    Key? key,
    this.label,
    this.labelWidget,
    this.suffixIcon,
    this.obscureText,
    this.controller,
    this.focusNode,
    this.customHintText,
    this.unFocusedBorderColor,
    this.focusedBorderColor,
    this.borderRadius,
    this.maxLines,
    this.onTap,
    this.readOnly = false,
    this.validate,
    this.onFieldChanged,
    this.customTextInputType,
    this.autoValidateMode = AutovalidateMode.disabled,
    this.edgeInsetsGeometry,
  }) : super(key: key);

  final String? label;
  final String? customHintText;
  final Widget? labelWidget;
  final FocusNode? focusNode;
  final bool? obscureText;
  final bool readOnly;
  final Widget? suffixIcon;
  final Color? unFocusedBorderColor;
  final Color? focusedBorderColor;
  final Function(String)? onFieldChanged;
  final Function()? onTap;
  final TextEditingController? controller;
  final String? Function(String?)? validate;
  final double? borderRadius;
  final int? maxLines;
  final AutovalidateMode? autoValidateMode;
  final EdgeInsetsGeometry? edgeInsetsGeometry;
  final TextInputType? customTextInputType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      onTap: onTap,
      onChanged: onFieldChanged,
      keyboardType: customTextInputType,
      obscureText: obscureText ?? false,
      autovalidateMode: autoValidateMode,
      readOnly: readOnly,
      decoration: InputDecoration(
        errorMaxLines: 3,
        border: InputBorder.none,
        alignLabelWithHint: true,
        isDense: true,
        labelText: label,
        floatingLabelAlignment: FloatingLabelAlignment.start,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        hintText: customHintText ?? '...',
        hintStyle: mainStyle(context, 12, color: newDarkGreyColor),
        contentPadding: edgeInsetsGeometry ??
            EdgeInsets.symmetric(vertical: Responsive.isMobile(context) ? 18 : 25.0, horizontal: 10.0),
        // border: const OutlineInputBorder(),
        suffixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
          child: suffixIcon,
        ),
        suffixIconConstraints: BoxConstraints(maxHeight: 30.w),
        labelStyle: mainStyle(context, 13, color: softGreyColor),
        // labelText: label,
        label: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: labelWidget,
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: focusedBorderColor ?? mainBlueColor, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 5.0.sp))),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: unFocusedBorderColor ?? mainBlueColor.withOpacity(0.7), width: 1),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 5.0.sp))),
      ),
      // decoration: InputDecoration(
      //   contentPadding: EdgeInsets.all(10.h),
      //   // icon: Icon(Icons.send),
      //   // hintText: 'Hint Text',
      //   // helperText: 'Helper Text',
      //   // counterText: '0 characters',
      //
      //   focusedBorder: OutlineInputBorder(
      //       borderSide:
      //       const BorderSide(color: Color(0xffa4c4f4), width: 2.0),
      //       borderRadius: BorderRadius.all(Radius.circular(11.0.sp))),
      //
      //   enabledBorder: OutlineInputBorder(
      //       borderSide:
      //       const BorderSide(color: Color(0xffa4c4f4), width: 1.0),
      //       borderRadius: BorderRadius.all(Radius.circular(11.0.sp))),
      // ),
      validator: validate,
      minLines: 1,
      maxLines: maxLines ?? 1,
      // height: 41.h,
      // decoration: BoxDecoration(
      //   color: const Color(0xffffffff),
      //   borderRadius: BorderRadius.circular(10.0),
      //   border: Border.all(width: 1.0, color: const Color(0xffa4c4f4)),
      // ),
    );
  }
}

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    required this.text,
    required this.onClick,
    this.height,
    this.width,
    this.radius,
    this.fontSize,
    this.backColor,
    this.borderColor,
    this.customChild,
    this.titleColor,
    this.withoutPadding = false,
    this.isEnabled = true,
  }) : super(key: key);
  final String text;
  final Function() onClick;
  final double? height;
  final double? width;
  final double? radius;
  final bool withoutPadding;
  final double? fontSize;
  final Widget? customChild;
  final Color? backColor;
  final Color? borderColor;
  final Color? titleColor;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onClick : null,
      child: Container(
        width: width,
        height: height ?? null,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(radius ?? defaultRadiusVal),
          ),
          border: Border.all(width: 1.0, color: isEnabled ? borderColor ?? mainBlueColor : disabledGreyColor),
          color: isEnabled ? backColor ?? mainBlueColor : disabledGreyColor,
        ),
        padding: EdgeInsets.symmetric(horizontal: withoutPadding ? 0 : 5, vertical: withoutPadding ? 0 : 10),
        child: customChild ??
            Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: mainStyle(context, isBold: true, fontSize ?? 14, color: titleColor ?? Colors.white),
              ),
            ),
      ),
    );
  }
}

class DefaultLoaderGrey extends StatelessWidget {
  const DefaultLoaderGrey({Key? key, this.customHeight}) : super(key: key);

  final double? customHeight;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: customHeight ?? 42.h,
        child: Center(
          child: Lottie.asset('assets/video/pre.json'),
        ),
      ),
    );
  }
}

class DefaultLoaderColor extends StatelessWidget {
  const DefaultLoaderColor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 42.h,
        child: Center(
          child: Lottie.asset('assets/video/pre.json'),
        ),
      ),
    );
  }
}

class DefaultButtonOutline extends StatelessWidget {
  const DefaultButtonOutline({
    Key? key,
    required this.text,
    required this.onClick,
  }) : super(key: key);

  final String text;
  final Function() onClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        height: 30.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(defaultRadiusVal),
            topRight: Radius.circular(defaultRadiusVal),
            bottomLeft: Radius.circular(defaultRadiusVal),
            bottomRight: Radius.circular(defaultRadiusVal),
          ),
          border: Border.all(
            color: const Color.fromRGBO(1, 112, 204, 1),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Center(
          child: Text(
            text,
            style: mainStyle(context, 12, color: mainBlueColor),
          ),
        ),
      ),
    );
  }
}

class UserProfileDrawer extends StatelessWidget {
  const UserProfileDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mainCubit = MainCubit.get(context);
    return Container(
      width: 0.72.sw,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            right: BorderSide(
              //                   <--- right side
              color: Colors.grey.withOpacity(0.3),
              width: 1.5,
            ),
          )),
      child: BlocConsumer<MainCubit, MainState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return SafeArea(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                heightBox(30.h),
                const DrawerProfileHeader(),
                Padding(
                  padding: EdgeInsets.only(
                    right: defaultHorizontalPadding * 2,
                  ),
                  child: Divider(
                    height: 20.h,
                    thickness: 1,
                    color: mainBlueColor,
                  ),
                ),
                heightBox(15.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding * 2),
                  child: Column(
                    children: [
                      ProfileDrawerElement(
                          onClick: () {
                            logg('change location');
                          },
                          svgLink: 'assets/svg/icons/location.svg',
                          title: getTranslatedStrings(context).changeAddress),
                      heightBox(5.h),
                      Column(
                        children: [
                          ProfileDrawerElement(
                              svgLink: 'assets/svg/icons/mymedicalreport.svg',
                              onClick: () {
                                mainCubit.medicalRecordExpandedToggle();
                              },
                              suffixSvgLink: !mainCubit.medicalRecordExpanded
                                  ? 'assets/svg/icons/arrow_down_base.svg'
                                  : 'assets/svg/icons/arrow_up_base.svg',
                              title: getTranslatedStrings(context).myMedicalRecord),
                          !mainCubit.medicalRecordExpanded
                              ? const SizedBox()
                              : Padding(
                                  padding: REdgeInsets.symmetric(
                                    horizontal: defaultHorizontalPadding,
                                  ),
                                  child: const MyMedicalRecordDrawerColumn(),
                                )
                        ],
                      ),
                      heightBox(5.h),
                      ProfileDrawerElement(
                          svgLink: 'assets/svg/icons/notification.svg',
                          suffixWidget: CircleAvatar(
                            radius: 9.sp,
                            backgroundColor: alertRedColor,
                            child: FittedBox(
                              child: Padding(
                                padding: EdgeInsets.all(4.0.sp),
                                child: Center(
                                  child: Text('29',
                                      style: mainStyle(context, 18, color: Colors.white, weight: FontWeight.w800)),
                                ),
                              ),
                            ),
                          ),
                          title: getTranslatedStrings(context).notifications),
                      heightBox(5.h),
                      Column(
                        children: [
                          ProfileDrawerElement(
                              svgLink: 'assets/svg/icons/myactivities.svg',
                              onClick: () {
                                mainCubit.myActivitiesExpandedToggle();
                              },
                              suffixSvgLink: !mainCubit.myActivitiesExpanded
                                  ? 'assets/svg/icons/arrow_down_base.svg'
                                  : 'assets/svg/icons/arrow_up_base.svg',
                              title: getTranslatedStrings(context).myActivities),
                          !mainCubit.myActivitiesExpanded
                              ? const SizedBox()
                              : Padding(
                                  padding: REdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                                  child: const MyActivitiesDrawerColumn(),
                                ),
                        ],
                      ),
                      heightBox(15.h),
                    ],
                  ),
                ),
                const SharedDrawerItems()
              ],
            ),
          );
        },
      ),
    );
  }
}

class DrawerProfileHeader extends StatelessWidget {
  const DrawerProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mainCubit = MainCubit.get(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding * 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/svg/icons/profile.svg',
            width: 40.w,
          ),
          SizedBox(
            width: 5.w,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(mainCubit.userInfoModel!.data.user.fullName ?? ''),
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(getTranslatedStrings(context).editProfile,
                          style: mainStyle(context, 12, color: mainBlueColor, weight: FontWeight.w700)),
                    ),
                  ),
                  widthBox(5.w),
                  GestureDetector(
                    onTap: () {
                      removeToken();
                      MainCubit.get(context).removeUserModel();
                      navigateToAndFinishUntil(context, SignInScreen());
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Text('Logout', style: mainStyle(context, 12, color: alertRedColor, weight: FontWeight.w700)),
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}

class GuestDrawer extends StatelessWidget {
  const GuestDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            right: BorderSide(
              //                   <--- right side
              color: Colors.grey.withOpacity(0.3),
              width: 1.5,
            ),
          )),
      width: 0.72.sw,
      height: double.maxFinite,
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(15.0.sp),
      //   color: Colors.white.withOpacity(0.9),
      // ),
      child: BlocConsumer<MainCubit, MainState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  heightBox(40.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding * 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/svg/icons/profile.svg',
                          width: 40.w,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(getTranslatedStrings(context).joinUs),
                            SizedBox(
                              height: 7.h,
                            ),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    navigateToAndFinishUntil(context, SignInScreen());
                                  },
                                  child: Text(
                                    getTranslatedStrings(context).joinUs,
                                    style: mainStyle(context, 12, color: mainBlueColor, weight: FontWeight.w700),
                                  ),
                                ),
                                // widthBox(10.w),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: defaultHorizontalPadding * 2),
                    child: Divider(
                      height: 20.h,
                      thickness: 1,
                      color: mainBlueColor,
                    ),
                  ),
                  heightBox(15.h),
                  const SharedDrawerItems(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class SharedDrawerItems extends StatelessWidget {
  const SharedDrawerItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding * 2),
          child: Column(
            children: [
              ProfileDrawerElement(
                  svgLink: 'assets/svg/icons/setting.svg', title: getTranslatedStrings(context).setting),
              heightBox(5.h),
              Column(
                children: [
                  ProfileDrawerElement(
                      svgLink: 'assets/svg/icons/mena.svg',
                      onClick: () {},
                      title: getTranslatedStrings(context).aboutMenaPlatforms),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: defaultHorizontalPadding,
                    ),
                    child: const AboutMenaDrawerColumn(),
                  )
                ],
              ),
              heightBox(20.h),
              ProfileDrawerElement(
                  svgLink: 'assets/svg/icons/helpcenter.svg', title: getTranslatedStrings(context).helpCenter),
              heightBox(5.h),
              ProfileDrawerElement(
                  svgLink: 'assets/svg/icons/rateAndReview.svg', title: getTranslatedStrings(context).rateAndReview),
              heightBox(5.h),
              ProfileDrawerElement(
                  svgLink: 'assets/svg/icons/tellafriend.svg', title: getTranslatedStrings(context).tellAFriend),
              heightBox(5.h),
              ProfileDrawerElement(
                  svgLink: 'assets/svg/icons/feedback.svg', title: getTranslatedStrings(context).feedback),
              heightBox(5.h),
              ProfileDrawerElement(
                  svgLink: 'assets/svg/icons/follow.svg',
                  title: '${getTranslatedStrings(context).follow} MENA Platforms'),
              heightBox(2.h),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: defaultHorizontalPadding / 2,
                ),
                child: const MenaSocialPlatforms(),
              )
            ],
          ),
        )
      ],
    );
  }
}

class MenaSocialPlatforms extends StatelessWidget {
  const MenaSocialPlatforms({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<MenaSocialItem> socialItems = [
      MenaSocialItem(
        name: 'Instagram',
        svgAssetLink: 'assets/svg/icons/intsagram.svg',
      ),
      MenaSocialItem(
        name: 'Facebook',
        svgAssetLink: 'assets/svg/icons/facebook.svg',
      ),
      MenaSocialItem(
        name: 'Pinterest',
        svgAssetLink: 'assets/svg/icons/piterest.svg',
      ),
      MenaSocialItem(
        name: 'Tiktok',
        svgAssetLink: 'assets/svg/icons/tiktok.svg',
      ),
      MenaSocialItem(
        name: 'Youtube',
        svgAssetLink: 'assets/svg/icons/youtube.svg',
      ),
    ];
    return SizedBox(
      height: 27.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => SvgPicture.asset(
          socialItems[index].svgAssetLink!,
          fit: BoxFit.cover,
          width: 30.h,
        ),
        separatorBuilder: (context, index) => widthBox(10.w),
        itemCount: socialItems.length,
      ),
    );
  }
}

class AboutMenaDrawerColumn extends StatelessWidget {
  const AboutMenaDrawerColumn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileDrawerElement(
          svgLink: 'assets/svg/icons/termsOfUse.svg',
          title: getTranslatedStrings(context).termsOfUse,
        ),
        ProfileDrawerElement(
          svgLink: 'assets/svg/icons/privacyPolicy.svg',
          title: getTranslatedStrings(context).privacyPolicy,
        ),
      ],
    );
  }
}

class MyActivitiesDrawerColumn extends StatelessWidget {
  const MyActivitiesDrawerColumn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileDrawerElement(
          svgLink: 'assets/svg/icons/aapointments.svg',
          title: 'Appointments',
          onClick: () => navigateTo(context, MyAppointmentsLayout()),
        ),
        ProfileDrawerElement(
          svgLink: 'assets/svg/icons/mena.svg',
          title: 'test',
        ),
      ],
    );
  }
}

class MyMedicalRecordDrawerColumn extends StatelessWidget {
  const MyMedicalRecordDrawerColumn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        ProfileDrawerElement(
          svgLink: 'assets/svg/icons/mena.svg',
          title: 'test',
        ),
        ProfileDrawerElement(
          svgLink: 'assets/svg/icons/mena.svg',
          title: 'test',
        ),
      ],
    );
  }
}

class ProfileDrawerElement extends StatelessWidget {
  const ProfileDrawerElement({
    Key? key,
    required this.svgLink,
    required this.title,
    this.onClick,
    this.suffixSvgLink,
    this.suffixWidget,
  }) : super(key: key);
  final String svgLink;
  final String title;

  final Function()? onClick;
  final String? suffixSvgLink;
  final Widget? suffixWidget;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        color: Colors.white,
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: defaultHorizontalPadding / 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  svgLink,
                  width: 16.sp,
                ),
                widthBox(7.w),
                Text(
                  title,
                  style: mainStyle(context, 12, weight: FontWeight.w500),
                ),
                widthBox(7.w),
                suffixSvgLink == null
                    ? const SizedBox()
                    : SvgPicture.asset(
                        suffixSvgLink!,
                        width: 16.w,
                        height: 16.w,
                        color: mainBlueColor,
                      ),
                suffixWidget == null
                    ? const SizedBox()
                    : Row(
                        children: [
                          widthBox(7.w),
                          suffixWidget!,
                        ],
                      ),
              ],
            )),
      ),
    );
  }
}

class OldSearchBar extends StatelessWidget {
  const OldSearchBar({
    Key? key,
    required this.scaffoldKey,
  }) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: defaultHorizontalPadding,
        ),
        GestureDetector(
            onTap: () {
              logg('ASdDEEee');
              scaffoldKey.currentState?.openDrawer();
            },
            child: SvgPicture.asset('assets/svg/menu.svg')),
        SizedBox(
          width: defaultHorizontalPadding,
        ),
        const Expanded(child: SearchBar()),
        SizedBox(
          width: defaultHorizontalPadding,
        ),
      ],
    );
  }
}

class FloatingPickPlatformsDrawer extends StatelessWidget {
  const FloatingPickPlatformsDrawer({
    Key? key,
    required this.buttons,
  }) : super(key: key);
  final List<SelectorButtonModel> buttons;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      width: 0.50.sw,
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 88.0),
        child: DefaultContainer(
          width: 0.33.sw,
          backColor: drawerColor.withOpacity(0.7),
          withoutBorder: true,
          withBoxShadow: false,
          radius: 28.sp,
          childWidget: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(28.sp)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 13, sigmaY: 13),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 14),
                child:
                    // SizedBox()
                    Column(
                  children: [
                    heightBox(17.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/svg/icons/categories_outline_28.svg',
                          color: mainBlueColor,
                        ),
                        widthBox(5.w),
                        Expanded(
                          child: Text(
                            'Select Platform',
                            style: mainStyle(
                              context,
                              11, isBold: true,
                              // color: newDarkGreyColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    heightBox(12.h),
                    Expanded(
                      child: ListView.separated(
                        itemCount: buttons.length,
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return PlatformPickItem(
                            button: buttons[index],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) => Divider(
                          thickness: 0.3,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PlatformPickItem extends StatelessWidget {
  const PlatformPickItem({
    super.key,
    required this.button,
  });

  final SelectorButtonModel button;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        button.onClickCallback();
      },
      child: Column(
        children: [
          DefaultImageFadeInOrSvg(
            backGroundImageUrl: button.image!,
            height: 0.07.sh,
            // borderColor: button.isSelected?Colors.green:Colors.transparent,
            // borderWidth: 0,
            boxConstraints: BoxConstraints(minHeight: 0.08.sh),
          ),
          heightBox(7.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  button.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: mainStyle(context, 11, isBold: true, color: button.isSelected ? mainBlueColor : null),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: button.isSelected ? mainBlueColor : null,
                size: 16.sp,
              )
            ],
          ),
        ],
      ),
    );
  }
}

class OptionsMenu extends StatelessWidget {
  const OptionsMenu({
    Key? key,
    this.hide = true,
    required this.chatId,
  }) : super(key: key);
  final bool hide;
  final String? chatId;

  @override
  Widget build(BuildContext context) {
    var messengerCubit = MessengerCubit.get(context);

    return hide
        ? SizedBox()
        : PullDownButton(
            itemBuilder: (context) => [
              PullDownMenuItem(
                title: getTranslatedStrings(context).reportToMena,
                textStyle: mainStyle(context, 13, weight: FontWeight.w600, color: Colors.black),
                onTap: () {
                  showAlertConfirmDialog(context,
                      customTitle: getTranslatedStrings(context).reportToMena,
                      customSubTitle: getTranslatedStrings(context).areYouSureReportChat, confirmCallBack: () {
                    messengerCubit
                        .reportToMENA(
                      chatId: chatId.toString(),
                    )
                        .then((value) {
                      // messengerCubit
                      //   .fetchMyMessages();
                      Navigator.pop(context);
                    });
                  });
                },
              ),
              const PullDownMenuDivider(),
              PullDownMenuItem(
                title: getTranslatedStrings(context).block,
                textStyle: mainStyle(context, 13, weight: FontWeight.w600, color: Colors.black),
                onTap: () {
                  showAlertConfirmDialog(context,
                      customTitle: getTranslatedStrings(context).blockUser,
                      customSubTitle: getTranslatedStrings(context).areYouSureBlockUser, confirmCallBack: () {
                    messengerCubit
                        .blockUserChat(
                      chatId: chatId.toString(),
                    )
                        .then((value) {
                      messengerCubit.fetchMyMessages();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    });
                  });
                },
              ),
              const PullDownMenuDivider(),
              PullDownMenuItem(
                title: getTranslatedStrings(context).clearChat,
                textStyle: mainStyle(context, 13, weight: FontWeight.w600, color: Colors.black),
                onTap: () {
                  showAlertConfirmDialog(context,
                      customTitle: getTranslatedStrings(context).clearChat,
                      customSubTitle: getTranslatedStrings(context).areYouSureClearChat, confirmCallBack: () {
                    messengerCubit
                        .clearChat(
                      chatId: chatId.toString(),
                    )
                        .then((value) {
                      messengerCubit.fetchChatMessagesByChatId(chatId: chatId!);
                      // messengerCubit
                      //     .fetchMyMessages();
                      // Navigator.pop(context);
                      Navigator.pop(context);
                    });
                  });
                },
              ),
            ],
            position: PullDownMenuPosition.over,
            backgroundColor: Colors.white.withOpacity(0.8),
            offset: const Offset(-10, 10),
            applyOpacity: false,
            widthConfiguration: PullDownMenuWidthConfiguration(0.45.sw),
            buttonBuilder: (context, showMenu) => CupertinoButton(
              onPressed: showMenu,
              padding: EdgeInsets.zero,
              child: SvgPicture.asset(
                'assets/svg/icons/setting.svg',
                width: 22.sp,
              ),
            ),
          );
  }
}

class LivesList extends StatelessWidget {
  const LivesList({
    Key? key,
    required this.categories,
    required this.livesByCategoryItems,
    required this.isNow,
  }) : super(key: key);

  final List<LiveCategory> categories;
  final List<LiveByCategoryItem> livesByCategoryItems;
  final bool isNow;

  /// this class will get lives model or list

  @override
  Widget build(BuildContext context) {
    var liveCubit = LiveCubit.get(context);
    return Container(
      color: newLightGreyColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: categories.isEmpty
                  ? SizedBox()
                  : Padding(
                      padding: EdgeInsets.only(
                          top: 7.0.h, bottom: 5.h, left: defaultHorizontalPadding, right: defaultHorizontalPadding),
                      child: Row(
                        children: [
                          NewSelectorButton(
                              title: 'ALL',
                              customHeight: 31.sp - 4,
                              customFontSize: 10,
                              isSelected: isNow
                                  ? liveCubit.selectedNowLiveCat == '-1'
                                  : liveCubit.selectedUpcomingLiveCat == '-1',
                              onClick: () {
                                /// unselected current items in the row and remove the below rows
                                isNow
                                    ? liveCubit.changeSelectedNowLiveCat('-1')
                                    : liveCubit.changeSelectedUpcomingLiveCat('-1');
                              }),
                          // Container(width: 4,color: Colors.red,height: 10,),
                          Expanded(
                            child: NewHorizontalSelectorScrollable(
                              buttons: categories
                                  .map((e) => SelectorButtonModel(
                                      title: e.name,
                                      onClickCallback: () {
                                        isNow
                                            ? liveCubit.changeSelectedNowLiveCat(e.id.toString())
                                            : liveCubit.changeSelectedUpcomingLiveCat(e.id.toString());
                                      },
                                      isSelected: isNow
                                          ? liveCubit.selectedNowLiveCat == e.id.toString()
                                          : liveCubit.selectedUpcomingLiveCat == e.id.toString()))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            heightBox(7.h),
            if (isNow)
              DefaultShadowedContainer(
                backColor: Colors.white,
                childWidget: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      getCachedToken() == null
                          ? widthBox(defaultHorizontalPadding)
                          : !MainCubit.get(context).isUserProvider()
                              ? widthBox(defaultHorizontalPadding)
                              : Row(
                                  children: [
                                    widthBox(
                                      defaultHorizontalPadding,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        navigateToWithoutNavBar(context, CreateLivePage(), 'routeName');
                                        logg('go live');

                                        // await Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             ZegoUIKitPrebuiltLiveStreaming(
                                        //               appID: zegoAppId,
                                        //               appSign: zegoAppSign,
                                        //               userID: generateRandUserID,
                                        //               userName: generateRandUserID,
                                        //               liveID: 'widget.liveID',
                                        //               config:
                                        //                   ZegoUIKitPrebuiltLiveStreamingConfig
                                        //                       .host(),
                                        //             ))).then((value) async {
                                        //   logg('zego live pop');
                                        //   // await Future.delayed(Duration(seconds: 3));
                                        //   await ScreenUtil.init(
                                        //           context,
                                        //           designSize: const Size(360, 770),
                                        //           splitScreenMode: true)
                                        //       .then((value) => logg('screen init '));
                                        //   setState(() {
                                        //
                                        //   });
                                        // });
                                        // viewLiveModalBottomSheet(context, formKey, liveCubit, titleController,
                                        //     goalController, topicController);
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Lottie.asset('assets/json/livecircle_live_now.json',
                                              width: 60.sp, fit: BoxFit.fill),
                                          SizedBox(height: 8.h),
                                          Text(
                                            'Go live',
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: mainStyle(context, 9, weight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                    ),
                                    widthBox(
                                      defaultHorizontalPadding / 2,
                                    ),
                                  ],
                                ),
                      Expanded(
                        child: liveCubit.nowLivesModel == null
                            ? DefaultLoaderColor()
                            : liveCubit.nowLivesModel!.data.lives.isEmpty
                                ? SizedBox(
                                    height: 82.sp,
                                    // child:
                                        // Text('empty')
                                    //     ListView.separated(
                                    //   itemBuilder: (context, index) {
                                    //     return LiveProfileBubble(
                                    //       requiredWidth: 60.sp,
                                    //       name: '...',
                                    //       thumbnailUrl: '',
                                    //       liveTitle: '',
                                    //       liveGoal: '',
                                    //       liveTopic: '',
                                    //       liveId: null,
                                    //     );
                                    //   },
                                    //   separatorBuilder: (_, i) => widthBox(2.w),
                                    //   scrollDirection: Axis.horizontal,
                                    //   shrinkWrap: true,
                                    //   physics: BouncingScrollPhysics(),
                                    //   itemCount: 4,
                                    // ),
                                  )
                                : SizedBox(
                                    height: 82.sp,
                                    child: ListView.separated(
                                      itemBuilder: (context, index) {
                                        return LiveProfileBubble(
                                          requiredWidth: 60.sp,
                                          liveId: liveCubit.nowLivesModel!.data.lives[index].roomId,
                                          name: liveCubit.nowLivesModel!.data.lives[index].name,
                                          liveTitle: liveCubit.goLiveModel?.data.title ?? '',
                                          liveGoal: liveCubit.goLiveModel?.data.goal ?? '',
                                          liveTopic: liveCubit.goLiveModel?.data.topic ?? '',
                                          thumbnailUrl: liveCubit.nowLivesModel!.data.lives[index].image,
                                        );
                                      },
                                      separatorBuilder: (_, i) => widthBox(2.w),
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      physics: BouncingScrollPhysics(),
                                      itemCount: liveCubit.nowLivesModel!.data.lives.length,
                                    ),
                                  ),
                      ),
                    ],
                  ),
                ),
              ),
            if (isNow) heightBox(12.h),
            ListView.separated(
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: livesByCategoryItems[index].dateTime == null
                      ? LiveContainerLiveNow(
                          liveItem: livesByCategoryItems[index],
                        )
                      : LiveContainerUpcoming(
                          liveItem: livesByCategoryItems[index],
                        ),
                );
              },
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (_, i) => heightBox(11.h),
              itemCount: livesByCategoryItems.length,
            ),
            heightBox(7.h),
          ],
        ),
      ),
    );
  }

  Future<void> viewLiveModalBottomSheet(
    BuildContext context,
    GlobalKey<FormState> formKey,
    LiveCubit liveCubit,
    TextEditingController titleController,
    TextEditingController goalController,
    TextEditingController topicController,
  ) {
    return buildShowModalBottomSheet(context,
        body: BlocConsumer<LiveCubit, LiveState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (modalBottomContext, state) {
            return SizedBox();
          },
        ));
  }
}

class HorizontalSelectorScrollable extends StatefulWidget {
  const HorizontalSelectorScrollable({
    Key? key,
    required this.buttons,
    this.customFontSize,
  }) : super(key: key);

  final List<SelectorButtonModel> buttons;
  final double? customFontSize;

  @override
  State<HorizontalSelectorScrollable> createState() => _HorizontalSelectorScrollableState();
}

class _HorizontalSelectorScrollableState extends State<HorizontalSelectorScrollable> {
  // final horizontalScrollController = ScrollController();
  final unSubCategoriesScrollController = ItemScrollController();

  // final unSubCategoriesScrollListener = ItemPositionsListener.create();
  // final horizontalScrollListener = ItemPositionsListener.create();

  Future jumpToCategory(int index) async {
    // logg('jumpToCategory:' +
    // unSubCategoriesScrollListener.itemPositions.value.toString());

    if (unSubCategoriesScrollController.isAttached)
      try {
        unSubCategoriesScrollController.scrollTo(
            index: index, duration: const Duration(milliseconds: 130), curve: Curves.linear);
      } on Exception catch (_) {
        logg('never reached');
      }
  }

  @override
  void initState() {
    // TODO: implement initState
    ProviderCubit.get(context).changeIsExpanded(true);
    super.initState();
    logg('init scroll');
    jumpToCategory(0);
  }

  @override
  Widget build(BuildContext context) {
    return widget.buttons.isEmpty
        ? const SizedBox()
        : Stack(
            children: [
              /// sub sub
              ShaderMask(
                shaderCallback: (Rect rect) {
                  return LinearGradient(
                    begin: getTranslatedStrings(context).currentLanguageDirection == 'ltr'
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    end: Alignment.bottomCenter,
                    colors: [mainBlueColor, Colors.transparent, Colors.transparent, Colors.transparent],
                    stops: widget.buttons.length <= 2
                        ? const [0.0, 0.0, 0.0, 0.0]
                        : const [0.15, 0.4, 0.14, 0.051], // 10% purple, 80% transparent, 10% purple
                  ).createShader(rect);
                },
                blendMode: BlendMode.dstOut,
                child: SizedBox(
                  height: 35.sp,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1.5),
                    child: Center(
                      child: Row(
                        children: [
                          // widthBox(widget.buttons.length <= 3
                          //     ? 0
                          //     : getTranslatedStrings(context).currentLanguageDirection == 'ltr'
                          //         ? 0
                          //         : defaultHorizontalPadding* 2),
                          Expanded(
                            child: Center(
                                child: ScrollablePositionedList.builder(
                                    // padding: EdgeInsets.only(
                                    //   left: widget.buttons.length <= 3
                                    //       ? 0
                                    //       : getTranslatedStrings(context).currentLanguageDirection == 'ltr'
                                    //           ? defaultHorizontalPadding
                                    //           : defaultHorizontalPadding * 2,
                                    //   right: widget.buttons.length <= 3
                                    //       ? 0
                                    //       : getTranslatedStrings(context).currentLanguageDirection == 'ltr'
                                    //           ? defaultHorizontalPadding * 2
                                    //           : defaultHorizontalPadding,
                                    // ),
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: widget.buttons.length,
                                    itemScrollController: unSubCategoriesScrollController,
                                    // itemPositionsListener:
                                    //     unSubCategoriesScrollListener,
                                    physics: const ClampingScrollPhysics(),
                                    itemBuilder: (BuildContext context, int index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                        child: SelectorButton(
                                          title: widget.buttons[index].title,
                                          isSelected: widget.buttons[index].isSelected,
                                          customFontSize: widget.customFontSize,
                                          onClick: () {
                                            jumpToCategory(index);
                                            logg('title: ${widget.buttons[index].title} index: $index clicked uujh');
                                            widget.buttons[index].onClickCallback();
                                          },
                                        ),
                                      );
                                    })),
                          ),
                          widthBox(widget.buttons.length <= 2
                              ? 0
                              : getTranslatedStrings(context).currentLanguageDirection == 'ltr'
                                  ? defaultHorizontalPadding
                                  : 0)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              widget.buttons.length <= 2
                  ? const SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          color: Colors.transparent,
                          width: 33.sp,
                          child: PullDownButton(
                            itemBuilder: (context) => widget.buttons
                                .map((e) => PullDownMenuItem(
                                      onTap: () {
                                        jumpToCategory(widget.buttons.indexOf(e));
                                        e.onClickCallback();
                                      },
                                      title: e.title,
                                      textStyle: mainStyle(context, 13,
                                          weight: e.isSelected ? FontWeight.w900 : FontWeight.w600,
                                          color: e.isSelected ? mainBlueColor : Colors.black),
                                    ))
                                .toList(),
                            position: PullDownMenuPosition.over,
                            backgroundColor: Colors.white.withOpacity(0.75),
                            offset: const Offset(-2, 1),
                            applyOpacity: true,
                            widthConfiguration: PullDownMenuWidthConfiguration(0.77.sw),
                            buttonBuilder: (context, showMenu) => CupertinoButton(
                              onPressed: showMenu,
                              padding: EdgeInsets.zero,
                              child: Icon(
                                Icons.keyboard_arrow_down_outlined,
                                size: 28.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          );
  }
}

///
///
///

class NewHorizontalSelectorScrollable extends StatefulWidget {
  const NewHorizontalSelectorScrollable({
    Key? key,
    required this.buttons,
    this.customFontSize,
  }) : super(key: key);

  final List<SelectorButtonModel> buttons;
  final double? customFontSize;

  @override
  State<NewHorizontalSelectorScrollable> createState() => _NewHorizontalSelectorScrollableState();
}

class _NewHorizontalSelectorScrollableState extends State<NewHorizontalSelectorScrollable> {
  // final horizontalScrollController = ScrollController();
  final unSubCategoriesScrollController = ItemScrollController();

  // final unSubCategoriesScrollListener = ItemPositionsListener.create();
  // final horizontalScrollListener = ItemPositionsListener.create();

  Future jumpToCategory(int index) async {
    // logg('jumpToCategory:' +
    // unSubCategoriesScrollListener.itemPositions.value.toString());

    if (unSubCategoriesScrollController.isAttached)
      try {
        unSubCategoriesScrollController.scrollTo(
            index: index, duration: const Duration(milliseconds: 130), curve: Curves.linear);
      } on Exception catch (_) {
        logg('never reached');
      }
  }

  @override
  void initState() {
    // TODO: implement initState
    ProviderCubit.get(context).changeIsExpanded(true);
    super.initState();
    logg('init scroll');
    jumpToCategory(0);
  }

  @override
  Widget build(BuildContext context) {
    return widget.buttons.isEmpty
        ? const SizedBox()
        : Stack(
            children: [
              /// sub sub
              ShaderMask(
                shaderCallback: (Rect rect) {
                  return LinearGradient(
                    begin: getTranslatedStrings(context).currentLanguageDirection == 'ltr'
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    end: Alignment.bottomCenter,
                    colors: [mainBlueColor, Colors.transparent, Colors.transparent, Colors.transparent],
                    stops: widget.buttons.length <= 2
                        ? const [0.0, 0.0, 0.0, 0.0]
                        : const [0.15, 0.4, 0.14, 0.051], // 10% purple, 80% transparent, 10% purple
                  ).createShader(rect);
                },
                blendMode: BlendMode.dstOut,
                child: SizedBox(
                  height: 35.sp,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1.5),
                    child: Row(
                      children: [
                        // widthBox(widget.buttons.length <= 3
                        //     ? 0
                        //     : getTranslatedStrings(context).currentLanguageDirection == 'ltr'
                        //         ? 0
                        //         : defaultHorizontalPadding* 2),
                        Expanded(
                          child: ScrollablePositionedList.builder(
                              // padding: EdgeInsets.only(
                              //   left: widget.buttons.length <= 3
                              //       ? 0
                              //       : getTranslatedStrings(context).currentLanguageDirection == 'ltr'
                              //           ? defaultHorizontalPadding
                              //           : defaultHorizontalPadding * 2,
                              //   right: widget.buttons.length <= 3
                              //       ? 0
                              //       : getTranslatedStrings(context).currentLanguageDirection == 'ltr'
                              //           ? defaultHorizontalPadding * 2
                              //           : defaultHorizontalPadding,
                              // ),
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: widget.buttons.length,
                              itemScrollController: unSubCategoriesScrollController,
                              // itemPositionsListener:
                              //     unSubCategoriesScrollListener,
                              physics: const ClampingScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                                  child: NewSelectorButton(
                                    title: widget.buttons[index].title,
                                    isSelected: widget.buttons[index].isSelected,
                                    customFontSize: widget.customFontSize,
                                    onClick: () {
                                      jumpToCategory(index);
                                      logg('title: ${widget.buttons[index].title} index: $index clicked uujh');
                                      widget.buttons[index].onClickCallback();
                                    },
                                  ),
                                );
                              }),
                        ),
                        widthBox(widget.buttons.length <= 2
                            ? 0
                            : getTranslatedStrings(context).currentLanguageDirection == 'ltr'
                                ? defaultHorizontalPadding
                                : 0)
                      ],
                    ),
                  ),
                ),
              ),
              widget.buttons.length <= 2
                  ? const SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          color: Colors.transparent,
                          width: 33.sp,
                          child: PullDownButton(
                            itemBuilder: (context) => widget.buttons
                                .map((e) => PullDownMenuItem(
                                      onTap: () {
                                        jumpToCategory(widget.buttons.indexOf(e));
                                        e.onClickCallback();
                                      },
                                      title: e.title,
                                      textStyle: mainStyle(context, 13,
                                          weight: e.isSelected ? FontWeight.w900 : FontWeight.w600,
                                          color: e.isSelected ? mainBlueColor : Colors.black),
                                    ))
                                .toList(),
                            position: PullDownMenuPosition.over,
                            backgroundColor: Colors.white.withOpacity(0.75),
                            offset: const Offset(-2, 1),
                            applyOpacity: true,
                            widthConfiguration: PullDownMenuWidthConfiguration(0.77.sw),
                            buttonBuilder: (context, showMenu) => CupertinoButton(
                              onPressed: showMenu,
                              padding: EdgeInsets.zero,
                              child: Icon(
                                Icons.keyboard_arrow_down_outlined,
                                size: 28.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          );
  }
}

///
///
///
///
///
class JobTypesSelectorScrollable extends StatelessWidget {
  const JobTypesSelectorScrollable({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Jobs'),
        Row(
          children: [
            PullDownButton(
              itemBuilder: (context) => [
                PullDownMenuItem(
                  title: 'Platform 1',
                  textStyle: mainStyle(context, 13, color: mainBlueColor, weight: FontWeight.w800),
                  onTap: () => {},
                ),
                const PullDownMenuDivider(),
                PullDownMenuItem(
                  title: 'Platform 2',
                  textStyle: mainStyle(context, 13, color: mainBlueColor, weight: FontWeight.w800),
                  onTap: () {},
                ),
              ],
              position: PullDownMenuPosition.over,
              backgroundColor: Colors.white.withOpacity(0.8),
              offset: const Offset(-10, 10),
              applyOpacity: false,
              widthConfiguration: PullDownMenuWidthConfiguration(0.45.sw),
              buttonBuilder: (context, showMenu) => CupertinoButton(
                onPressed: showMenu,
                padding: EdgeInsets.zero,
                child: const Icon(Icons.keyboard_arrow_down_outlined),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class EmptyListLayout extends StatelessWidget {
  const EmptyListLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Lottie.asset('assets/json/51382-astronaut-light-theme.json'),
          Text(
            'Empty list'
            '\n'
            'Will add a design for empty lists',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class FeedsEmptyLayout extends StatelessWidget {
  const FeedsEmptyLayout({Key? key, this.isMyFeed = false}) : super(key: key);
  final bool isMyFeed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Lottie.asset('assets/json/51382-astronaut-light-theme.json'),
          isMyFeed ? MyFeedsEmpty() : OthersFeedsEmpty(),
        ],
      ),
    );
  }
}

class OthersFeedsEmpty extends StatelessWidget {
  const OthersFeedsEmpty({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // color:Colors.white
      child: Column(
        children: [
          Lottie.asset('assets/json/no feeds.json', height: 0.33.sh),
          Text(
            'There are no posts here yet.',
            style: mainStyle(context, 14, isBold: true, color: newDarkGreyColor),
            textAlign: TextAlign.center,
          ),
          Container(
            constraints: BoxConstraints(maxWidth: 0.7.sw),
            child: Text(
              '\n'
              'The provider has not yet published any content on their MENA feeds.',
              style: mainStyle(context, 14, isBold: false, color: newLightTextGreyColor, weight: FontWeight.normal),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class MyFeedsEmpty extends StatelessWidget {
  const MyFeedsEmpty({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Lottie.asset('assets/json/no feeds.json', height: 0.33.sh),
        Text(
          ' There are no posts here yet.',
          style: mainStyle(context, 14, isBold: true, color: newDarkGreyColor),
          textAlign: TextAlign.center,
        ),
        Container(
          constraints: BoxConstraints(maxWidth: 0.7.sw),
          child: Text(
            '\n'
            'now\'s the perfect time to start!',
            style: mainStyle(context, 14, isBold: false, color: newDarkGreyColor),
            textAlign: TextAlign.center,
          ),
        ),
        heightBox(20.h),
        DefaultButton(
            text: 'Post Now',
            width: 0.37.sw,
            onClick: () {
              navigateTo(context, PostAFeedLayout());
            })
      ],
    );
  }
}

class DefaultBackTitleAppBar extends StatelessWidget {
  const DefaultBackTitleAppBar({
    Key? key,
    this.title,
    this.customTitleWidget,
    this.suffix,
  }) : super(key: key);

  final String? title;
  final Widget? customTitleWidget;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widthBox(0.02.sw),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                height: 30.h,
                width: 30.w,
                color: Colors.transparent,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/svg/icons/back.svg',
                    color: mainBlueColor,
                  ),
                ),
              ),
            ),
            widthBox(0.02.sw),
            Expanded(
              child: customTitleWidget ??
                  Text(
                    title ?? '',
                    style: mainStyle(context, 11, weight: FontWeight.w400, color: Colors.black, isBold: true),
                  ),
            ),
            suffix ?? SizedBox()
          ],
        ),
      ),
    );
  }
}

class DefaultOnlyLogoAppbar extends StatelessWidget {
  const DefaultOnlyLogoAppbar({
    Key? key,
    this.withBack = false,
    this.title,
    this.suffix,
    this.logo,
  }) : super(key: key);


  final String? logo;
  final String? title;
  final bool withBack;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widthBox(defaultHorizontalPadding),
            if (withBack)
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 30.h,
                  width: 30.w,
                  color: Colors.transparent,
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/svg/icons/back.svg',
                      color: mainBlueColor,
                    ),
                  ),
                ),
              ),
            widthBox(0.02.sw),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                // height: 30.h,
                // width: 30.w,
                color: Colors.transparent,
                child: Center(
                  child: SvgPicture.asset(
                  logo ??  'assets/svg/mena8.svg',
                    height: 20.h,
                    // color: mainBlueColor,
                  ),
                ),
              ),
            ),
            widthBox(0.02.sw),
            Expanded(
              child: Text(
                title ?? '',
                style: mainStyle(context, 11, weight: FontWeight.w400, color: Colors.black, isBold: true),
              ),
            ),
            suffix ?? SizedBox()
          ],
        ),
      ),
    );
  }
}

PreferredSize defaultSearchMessengerAppBar(BuildContext context, {String? title}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(56.0.h),
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
        child: Container(
          // color: Colors.red,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 30.h,
                      width: 30.w,
                      color: Colors.transparent,
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/svg/icons/back.svg',
                          color: mainBlueColor,
                        ),
                      ),
                    ),
                  ),
                  widthBox(12.w),
                  Text(
                    title ?? getTranslatedStrings(context).back,
                    style: mainStyle(context, 11, weight: FontWeight.w700),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SvgPicture.asset(
                    'assets/svg/icons/searchFilled.svg',
                    height: Responsive.isMobile(context) ? 28.w : 12.w,
                  ),
                  widthBox(10.w),
                  MessengerIconBubble(),
                  widthBox(10.w),
                  // GestureDetector(
                  //   onTap: () {
                  //     logg('opening drawer');
                  //     comingSoonAlertDialog(context);
                  //     // scaffoldKey.currentState?.openDrawer();
                  //   },
                  //   child: SvgPicture.asset(
                  //     'assets/svg/icons/profile.svg',
                  //     height: Responsive.isMobile(context) ? 22.w : 12.w,
                  //   ),
                  // ),
                  // widthBox(10.w),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
  //   AppBar(
  //   // backgroundColor: Colors.white,
  //   leading: GestureDetector(
  //     onTap: () => Navigator.pop(context),
  //     child: Container(
  //       color: Colors.transparent,
  //       child: Row(
  //         children: [
  //           widthBox(5.w),
  //           SizedBox(
  //             width: 5.w,
  //             child: Icon(
  //               Icons.arrow_back_ios_new_rounded,
  //               color: Colors.black,
  //               size: 22.w,
  //             ),
  //           ),
  //           widthBox(7.w),
  //           // widthBox(5.w),
  //           // Text(
  //           //   title??  'back',
  //           //   style: mainStyle(context, 12, color: Colors.blue),
  //           // )
  //         ],
  //       ),
  //     ),
  //   ),
  //   title: Text(
  //     title ?? 'back',
  //     style: mainStyle(context, 11, weight: FontWeight.w200),
  //   ),
  //   centerTitle: false,
  //   actions: [
  //     Row(
  //       children: [
  //         SvgPicture.asset(
  //           'assets/svg/icons/search.svg',
  //           height: Responsive.isMobile(context) ? 22.w : 12.w,
  //         ),
  //         widthBox(10.w),
  //         GestureDetector(
  //           onTap: () {
  //             // viewComingSoonAlertDialog(context);
  //             getCachedToken() == null
  //                 ? viewLoginAlertDialog(context)
  //                 : navigateToWithoutNavBar(context, const MessengerLayout(), '');
  //           },
  //           child: SvgPicture.asset(
  //             'assets/svg/icons/messages.svg',
  //             height: Responsive.isMobile(context) ? 22.w : 12.w,
  //           ),
  //         ),
  //         widthBox(10.w),
  //         // GestureDetector(
  //         //   onTap: () {
  //         //     logg('opening drawer');
  //         //     comingSoonAlertDialog(context);
  //         //     // scaffoldKey.currentState?.openDrawer();
  //         //   },
  //         //   child: SvgPicture.asset(
  //         //     'assets/svg/icons/profile.svg',
  //         //     height: Responsive.isMobile(context) ? 22.w : 12.w,
  //         //   ),
  //         // ),
  //         // widthBox(10.w),
  //       ],
  //     ),
  //   ],
  //   leadingWidth: 35.w,
  //   elevation: 0,
  // );
}

PreferredSize defaultVideoOnlyBackAppBar(BuildContext context, {String? title, Color? customColor}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(56.0.h),
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
        child: Container(
          // color: Colors.red,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 30.h,
                      width: 30.w,
                      color: Colors.transparent,
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/svg/icons/back.svg',
                          color: customColor ?? mainBlueColor,
                        ),
                      ),
                    ),
                  ),
                  widthBox(12.w),
                  Text(
                    title ?? '',
                    style: mainStyle(context, 11, weight: FontWeight.w700, color: customColor),
                  ),
                ],
              ),
              // Text('data'),
              ///
              ///
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.end,
              //   children: [
              //     SvgPicture.asset(
              //       'assets/svg/icons/search.svg',
              //       height: Responsive.isMobile(context) ? 22.w : 12.w,
              //     ),
              //     widthBox(10.w),
              //     MessengerIconPubble(),
              //     widthBox(10.w),
              //     // GestureDetector(
              //     //   onTap: () {
              //     //     logg('opening drawer');
              //     //     comingSoonAlertDialog(context);
              //     //     // scaffoldKey.currentState?.openDrawer();
              //     //   },
              //     //   child: SvgPicture.asset(
              //     //     'assets/svg/icons/profile.svg',
              //     //     height: Responsive.isMobile(context) ? 22.w : 12.w,
              //     //   ),
              //     // ),
              //     // widthBox(10.w),
              //   ],
              // ),
              ///
              ///
            ],
          ),
        ),
      ),
    ),
  );
  //   AppBar(
  //   // backgroundColor: Colors.white,
  //   leading: GestureDetector(
  //     onTap: () => Navigator.pop(context),
  //     child: Container(
  //       color: Colors.transparent,
  //       child: Row(
  //         children: [
  //           widthBox(5.w),
  //           SizedBox(
  //             width: 5.w,
  //             child: Icon(
  //               Icons.arrow_back_ios_new_rounded,
  //               color: Colors.black,
  //               size: 22.w,
  //             ),
  //           ),
  //           widthBox(7.w),
  //           // widthBox(5.w),
  //           // Text(
  //           //   title??  'back',
  //           //   style: mainStyle(context, 12, color: Colors.blue),
  //           // )
  //         ],
  //       ),
  //     ),
  //   ),
  //   title: Text(
  //     title ?? 'back',
  //     style: mainStyle(context, 11, weight: FontWeight.w200),
  //   ),
  //   centerTitle: false,
  //   actions: [
  //     Row(
  //       children: [
  //         SvgPicture.asset(
  //           'assets/svg/icons/search.svg',
  //           height: Responsive.isMobile(context) ? 22.w : 12.w,
  //         ),
  //         widthBox(10.w),
  //         GestureDetector(
  //           onTap: () {
  //             // viewComingSoonAlertDialog(context);
  //             getCachedToken() == null
  //                 ? viewLoginAlertDialog(context)
  //                 : navigateToWithoutNavBar(context, const MessengerLayout(), '');
  //           },
  //           child: SvgPicture.asset(
  //             'assets/svg/icons/messages.svg',
  //             height: Responsive.isMobile(context) ? 22.w : 12.w,
  //           ),
  //         ),
  //         widthBox(10.w),
  //         // GestureDetector(
  //         //   onTap: () {
  //         //     logg('opening drawer');
  //         //     comingSoonAlertDialog(context);
  //         //     // scaffoldKey.currentState?.openDrawer();
  //         //   },
  //         //   child: SvgPicture.asset(
  //         //     'assets/svg/icons/profile.svg',
  //         //     height: Responsive.isMobile(context) ? 22.w : 12.w,
  //         //   ),
  //         // ),
  //         // widthBox(10.w),
  //       ],
  //     ),
  //   ],
  //   leadingWidth: 35.w,
  //   elevation: 0,
  // );
}

class ActionItem extends StatelessWidget {
  const ActionItem({
    Key? key,
    required this.actionItemHead,
    this.subTitle,
    required this.title,
    this.customHeight,
    this.onClick,
  }) : super(key: key);

  final Widget actionItemHead;
  final String title;
  final String? subTitle;
  final double? customHeight;
  final Function()? onClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        height: customHeight ?? 44.sp,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            actionItemHead,
            heightBox(4.h),
            if (title.isNotEmpty)
              Container(
                constraints: BoxConstraints(minWidth: 0.22.sw, maxWidth: 0.24.sw),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: mainStyle(context, 9, color: newDarkGreyColor, isBold: true, textHeight: 1.3),
                ),
              ),
            if (subTitle != null && subTitle!.isNotEmpty) heightBox(4.h),
            if (subTitle != null && subTitle!.isNotEmpty)
              Container(
                constraints: BoxConstraints(minWidth: 0.22.sw, maxWidth: 0.24.sw),
                child: Text(
                  subTitle!,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: mainStyle(context, 10, color: newDarkGreyColor, isBold: true, textHeight: 1.3),
                ),
              )
          ],
        ),
      ),
    );
  }
}

class ComingSoonWidget extends StatelessWidget {
  const ComingSoonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/json/coming soon.json'),
            Text(
              'Coming SOON',
              style: mainStyle(context, 13, color: mainBlueColor),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginWidget extends StatelessWidget {
  const LoginWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset('assets/json/coming soon.json'),
          Text(
            'Login To Proceed...',
            style: mainStyle(context, 13, color: mainBlueColor),
          ),
        ],
      ),
    );
  }
}

class BottomSheetSimple extends StatelessWidget {
  const BottomSheetSimple(
      {super.key,
        this.onClickCancel,
        this.onClickConfirm,
        this.backColorConfirm,
        this.txetConfirm});

  final VoidCallback? onClickCancel;

  final VoidCallback? onClickConfirm;

  final Color? backColorConfirm;

  final String? txetConfirm;

  @override
  Widget build(BuildContext context) {
    return Radius20Container(
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultButton(
              width: 100.w,
              borderColor: chatGreyColor,
              titleColor: const Color(0xff6d7885),
              backColor: chatGreyColor,
              text: "Cancel",
              onClick: onClickCancel!,
            ),
            DefaultButton(
              width: 100.w,
              text: txetConfirm ?? "Confirm",
              onClick: onClickConfirm!,
              backColor: backColorConfirm,
              borderColor: backColorConfirm,
            ),
          ],
        ),
      ),
    );
  }
}

//
// class CustomGradient extends CustomPainter {
//   CustomGradient({ this.gradient,required this.sWidth});
//
//   final Gradient? gradient;
//   final double sWidth;
//   final Paint p = Paint();
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     Rect innerRect = Rect.fromLTRB(sWidth, sWidth, size.width - sWidth, size.height - sWidth);
//     Rect outerRect = Offset.zero & size;
//
//     p.shader = gradient?.createShader(outerRect);
//     Path borderPath = _calculateBorderPath(outerRect, innerRect);
//     canvas.drawPath(borderPath, p);
//   }
//
//   Path _calculateBorderPath(Rect outerRect, Rect innerRect) {
//     Path outerRectPath = Path()..addRect(outerRect);
//     Path innerRectPath = Path()..addRect(innerRect);
//     return Path.combine(PathOperation.difference, outerRectPath, innerRectPath);
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => true;
// }
//
// class CustomGradientContainer extends StatelessWidget {
//   CustomGradientContainer({
//     required gradient,
//     required this.child,
//     this.strokeWidth = 3, required this.onPressed,
//   }) : this.painter = CustomGradient(
//       gradient: gradient, sWidth: strokeWidth
//   );
//
//   final CustomGradient? painter;
//   final Widget child;
//   final VoidCallback onPressed;
//   final double strokeWidth;
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//         painter: painter,
//         child: child
//     );
//   }
// }
//
