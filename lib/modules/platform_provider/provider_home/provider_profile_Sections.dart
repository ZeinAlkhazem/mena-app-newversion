import 'dart:async';

import 'package:custom_marker/marker_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:mena/core/constants/validators.dart';
import 'package:mena/core/main_cubit/main_cubit.dart';
import 'package:mena/modules/appointments/appointments_layouts/pick_appointment_insurance.dart';
import 'package:mena/modules/my_profile/cubit/profile_cubit.dart';
import 'package:mena/modules/platform_provider/provider_home/provider_profile.dart';
import 'package:mena/modules/platform_provider/provider_home/provider_profile_as_guest.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/constants.dart';
import '../../../core/functions/main_funcs.dart';
import '../../../core/shared_widgets/mena_shared_widgets/custom_containers.dart';
import '../../../core/shared_widgets/shared_widgets.dart';
import '../../../models/api_model/home_section_model.dart';
import '../../../models/api_model/provider_details_model.dart';
import '../../../models/local_models.dart';
import '../../appointments/appointments_layouts/appointments_facilities_result.dart';
import '../../feeds_screen/feeds_screen.dart';
import '../../nearby_screen/nearby_layout.dart';
import '../professionals_layout/professionals_layout.dart';

class ButtonsSection extends StatelessWidget {
  const ButtonsSection({
    Key? key,
    required this.providerId,
    required this.buttons,
  }) : super(key: key);

  final List<Button>? buttons;
  final String providerId;

  @override
  Widget build(BuildContext context) {
    return buttons == null
        ? SizedBox()
        : buttons!.isEmpty
            ? SizedBox()
            : ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => ProfileDynamicButton(
                  providerId: providerId,
                  title: buttons![index].title,
                  subtitle: buttons![index].description,
                  type: buttons![index].type,
                ),
                separatorBuilder: (_, i) => heightBox(10.h),
                itemCount: buttons!.length,
              );
  }
}

// class ContactUsSection extends StatelessWidget {
//   const ContactUsSection({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Title(title: 'Contact us'),
//         heightBox(8.h),
//       ],
//     );
//   }
// }

class OurLocationSection extends StatefulWidget {
  const OurLocationSection({
    Key? key,
    required this.provider,
    required this.providersLocations,
    this.viewTitleInProfileLayout = false,
    // this.viewTitleInProfileLayout=false,
  }) : super(key: key);

  final User? provider;
  final bool viewTitleInProfileLayout;

  // final bool viewTitleInProfileLayout;
  final List<ProviderLocationModel>? providersLocations;

  @override
  State<OurLocationSection> createState() => _OurLocationSectionState();
}

class _OurLocationSectionState extends State<OurLocationSection> {
  Iterable<Marker>? myMarkers;

  Future<Map<String, BitmapDescriptor>>? markerIconsFuture;

  Future<Map<String, BitmapDescriptor>> loadMarkerIcons({required Map<String, String> markerIconUrls}) async {
    Map<String, BitmapDescriptor> markerIcons = {};

    for (String markerId in markerIconUrls.keys) {
      String? markerIconUrl = markerIconUrls[markerId];
      // Uint8List markerIconImageBytes = await loadMarkerIconImageFromNetwork(markerIconUrl!);
      // // BitmapDescriptor markerIcon = BitmapDescriptor.fromBytes(markerIconImageBytes);
      // BitmapDescriptor markerIcon =

      BitmapDescriptor markerIcon = await MarkerIcon.downloadResizePictureCircle(markerIconUrl!,
          size: 80, addBorder: true, borderColor: mainBlueColor, borderSize: 10);
      // BitmapDescriptor.fromBytes(markerIconImageBytes);

      markerIcons[markerId] = markerIcon;
    }

    return markerIcons;
  }

  initialMarkers(List<ProviderLocationModel> providersNearby) async {
    myMarkers = {};
    Map<String, String> _markerIconUrls = {};
    providersNearby.forEach((e) {
      _markerIconUrls[e.id.toString()] = e.image.toString();
    });

    logg('_markerIconUrls: ' + _markerIconUrls.toString());

    // {
    //   'marker1': 'https://www.example.com/marker1.png',
    //   'marker2': 'https://www.example.com/marker2.png',
    //   // Add additional marker icons and their URLs here
    // };
    markerIconsFuture = loadMarkerIcons(markerIconUrls: _markerIconUrls).then((markerIconsFutureData) {
      myMarkers = providersNearby
          .map((e) => Marker(
              markerId: MarkerId(e.id.toString()),
              position: LatLng(double.parse(e.lat), double.parse(e.lng)),
              icon: markerIconsFutureData[e.id.toString()]!
              // infoWindow: InfoWindow(
              //     //popup info
              //     // title: providersNearby.indexOf(e).toString(),
              //     title: e.id.toString(),
              //     snippet: e.name,
              //     onTap: () {
              //       logg('move carousel to card clicked on info window');
              //       logg('animating to ${myMarkers.length}');
              //     }),
              // onTap: () async => await carouselScrollToElement(e),
              // // icon: BitmapDescriptor.defaultMarkerWithHue(23), //Icon for Marker
              // icon: customIcon!, //Icon for Marker
              ))
          .toList();
      return markerIconsFutureData;
    });

//
//     if (customIcon != null) {
//       logg('initializing markers');
//       myMarkers = providersNearby
//           .map((e) => Marker(
//                 markerId: MarkerId(e.id.toString()),
//                 position: LatLng(double.parse(e.lat), double.parse(e.lng)),
//                 // infoWindow: InfoWindow(
//                 //     //popup info
//                 //     // title: providersNearby.indexOf(e).toString(),
//                 //     title: e.id.toString(),
//                 //     snippet: e.name,
//                 //     onTap: () {
//                 //       logg('move carousel to card clicked on info window');
//                 //       logg('animating to ${myMarkers.length}');
//                 //     }),
//                 onTap: () async => await carouselScrollToElement(e),
//                 // icon: BitmapDescriptor.defaultMarkerWithHue(23), //Icon for Marker
//                 icon:
//                 _markerIconsFuture[e.id.toString()]
// ,
//                 // customIcon!, //Icon for Marker
//               ))
//           .toList();
//       logg('my markers result: ' + myMarkers.toString());
//       emit(MarkersReadyState());
//     }
//     else {
//       logg('null icon');
//       logg('null result');
//     }
//     emit(MarkersReadyState());
  }

  @override
  void initState() {
    // TODO: implement initState
    initialMarkers(widget.providersLocations!);

    // myMarkers = widget.providersLocations!
    //     .map((e) =>
    //     Marker(
    //         markerId: MarkerId(e.id.toString()),
    //         position: LatLng(double.parse(e.lat),
    //             double.parse(e.lng)),
    //         icon:
    //       // infoWindow: InfoWindow(
    //       //     //popup info
    //       //     // title: providersNearby.indexOf(e).toString(),
    //       //     title: e.id.toString(),
    //       //     snippet: e.name,
    //       //     onTap: () {
    //       //       logg('move carousel to card clicked on info window');
    //       //       logg('animating to ${myMarkers.length}');
    //       //     }),
    //       // onTap: () async => await carouselScrollToElement(e),
    //       // // icon: BitmapDescriptor.defaultMarkerWithHue(23), //Icon for Marker
    //       // icon: customIcon!, //Icon for Marker
    //     ))
    //     .toList();
    //
    // setState(() {
    //
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.providersLocations == null
        ? SizedBox()
        : widget.providersLocations!.isEmpty
            ? SizedBox()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(0),
                    child: DefaultShadowedContainer(
                      withoutBorder: !widget.viewTitleInProfileLayout,
                      boxShadow: !widget.viewTitleInProfileLayout ? [] : null,
                      childWidget: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: widget.viewTitleInProfileLayout ? defaultHorizontalPadding : 0,
                            vertical: widget.viewTitleInProfileLayout ? defaultHorizontalPadding : 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DefaultShadowedContainer(
                              height: 199.h,
                              childWidget: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(defaultRadiusVal)),
                                child: Stack(
                                  children: [
                                    // myMarkers==null?DefaultLoaderColor():
                                    FutureBuilder<Map<String, BitmapDescriptor>>(
                                      future: markerIconsFuture,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<Map<String, BitmapDescriptor>> snapshot) {
                                        if (snapshot.hasData) {
                                          return DefaultStaticMapView(
                                            myMarkers: myMarkers!,
                                            customZoom: widget.viewTitleInProfileLayout ? 9.5 : null

                                            // {
                                            //   Marker(
                                            //     markerId: MarkerId(provider.id.toString()),
                                            //     position: LatLng(double.parse(provider.lat.toString()),
                                            //         double.parse(provider.lng.toString())),
                                            //     // infoWindow: InfoWindow(
                                            //     //     //popup info
                                            //     //     // title: providersNearby.indexOf(e).toString(),
                                            //     //     title: e.id.toString(),
                                            //     //     snippet: e.name,
                                            //     //     onTap: () {
                                            //     //       logg('move carousel to card clicked on info window');
                                            //     //       logg('animating to ${myMarkers.length}');
                                            //     //     }),
                                            //     // onTap: () async => await carouselScrollToElement(e),
                                            //     // icon: BitmapDescriptor.defaultMarkerWithHue(23), //Icon for Marker
                                            //     // icon: customIcon!, //Icon for Marker
                                            //   )
                                            // }
                                            ,
                                          );
                                        } else {
                                          return DefaultLoaderColor();
                                        }
                                      },
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        logg('our location');
                                        navigateTo(
                                            context,
                                            ProviderLocationsLayout(
                                              title: widget.provider == null ? 'Home' : widget.provider!.fullName!,
                                              providersLocations: widget.providersLocations!,
                                              initialSelectedNearbyProvider: widget.providersLocations![0],
                                            ));
                                      },
                                      child: Container(
                                        color: Colors.white.withOpacity(0.001),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            if (widget.viewTitleInProfileLayout)
                              ProfileFooterTitle(
                                text: 'Our location',
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
  }
}

class ProfileFooterTitle extends StatelessWidget {
  const ProfileFooterTitle({
    super.key,
    required this.text,
    this.tealWidget,
  });

  final String text;

  final Widget? tealWidget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            thickness: 1.2,
          ),
          Row(
            children: [Expanded(child: MyTitle(title: text)), if (tealWidget != null) tealWidget!],
          ),
        ],
      ),
    );
  }
}

class DefaultStaticMapView extends StatefulWidget {
  const DefaultStaticMapView({
    Key? key,
    required this.myMarkers,
    this.customZoom,
  }) : super(key: key);
  final Iterable<Marker> myMarkers;
  final double? customZoom;

  @override
  State<DefaultStaticMapView> createState() => _DefaultStaticMapViewState();
}

class _DefaultStaticMapViewState extends State<DefaultStaticMapView> {
  final Completer<GoogleMapController> googleMapControllerCompleter = Completer();

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      markers: Set<Marker>.of(widget.myMarkers),
      zoomControlsEnabled: false,
      zoomGesturesEnabled: false,
      myLocationButtonEnabled: false,
      mapToolbarEnabled: true,
      buildingsEnabled: true,

      initialCameraPosition: CameraPosition(
        target: LatLng(double.parse(widget.myMarkers.first.position.latitude.toString()),
            double.parse(widget.myMarkers.first.position.longitude.toString())),
        zoom: widget.customZoom ?? 12.48746,
      ),
      onMapCreated: (GoogleMapController controller) {
        googleMapControllerCompleter.complete(controller);
        setState(() {});
      },

      ///
      ///
      myLocationEnabled: true,
      // on below line we have enabled compass
      compassEnabled: true,
      // below line displays google map in our app
    );
  }
}

class FollowUsSection extends StatefulWidget {
  const FollowUsSection({
    Key? key,
    required this.provider,
  }) : super(key: key);

  final User provider;

  @override
  State<FollowUsSection> createState() => _FollowUsSectionState();
}

class _FollowUsSectionState extends State<FollowUsSection> {
  List<MenaSocialItem>? socialItems;

  @override
  void initState() {
    // TODO: implement initState

    socialItems = [
      MenaSocialItem(
        name: 'Instagram',
        svgAssetLink: 'assets/svg/icons/intsagram.svg',
        jsonLink: 'assets/json/instagram.json',

        /// ToDO: change this == for test purposes
        redirectLink: widget.provider.instagram,
        // visible: widget.provider.instagram != null,
        visible: true,
      ),
      MenaSocialItem(
        name: 'Facebook',
        svgAssetLink: 'assets/svg/icons/facebook.svg',
        jsonLink: 'assets/json/facebook.json',
        redirectLink: widget.provider.facebook,
        // visible: widget.provider.facebook != null,
        visible: true,
      ),
      MenaSocialItem(
        name: 'Pinterest',
        svgAssetLink: 'assets/svg/icons/piterest.svg',
        jsonLink: 'assets/json/pintrest.json',
        redirectLink: widget.provider.pinterest,
        // visible: widget.provider.pinterest != null,
        visible: true,
      ),
      MenaSocialItem(
        name: 'Tiktok',
        svgAssetLink: 'assets/svg/icons/tiktok.svg',
        jsonLink: 'assets/json/tiktok.json',
        redirectLink: widget.provider.tiktok,
        // visible: widget.provider.tiktok != null,
        visible: true,
      ),
      MenaSocialItem(
        name: 'Youtube',
        svgAssetLink: 'assets/svg/icons/youtube.svg',
        jsonLink: 'assets/json/youtube.json',
        redirectLink: widget.provider.youtube,
        // visible: widget.provider.youtube != null,
        visible: true,
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return socialItems!.where((element) => element.visible == true).toList().isEmpty
        ? SizedBox()
        : DefaultShadowedContainer(
            childWidget: Padding(
              padding: EdgeInsets.all(defaultHorizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 55.h,
                    child: Center(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) => GestureDetector(
                            onTap: () async {
                              logg(
                                  'launch url ${socialItems!.where((element) => element.visible == true).toList()[index].redirectLink}');
                              if (!await launchUrl(Uri.parse(socialItems!
                                  .where((element) => element.visible == true)
                                  .toList()[index]
                                  .redirectLink!))) {
                                throw 'Could not launch ${socialItems!.where((element) => element.visible == true).toList()[index].redirectLink}';
                              }
                            },
                            child: socialItems!.where((element) => element.visible == true).toList()[index].jsonLink !=
                                    null
                                ? lottie.Lottie.asset(
                                    socialItems!.where((element) => element.visible == true).toList()[index].jsonLink!)
                                : SvgPicture.asset(
                                    socialItems!
                                        .where((element) => element.visible == true)
                                        .toList()[index]
                                        .svgAssetLink!,
                                    width: 44.w,
                                  )),
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (_, i) => widthBox(11.w),
                        itemCount: socialItems!.where((element) => element.visible == true).toList().length,
                      ),
                    ),
                  ),
                  ProfileFooterTitle(
                    text: 'Follow us',
                  )
                ],
              ),
            ),
          );
  }
}

class ContactUsSection extends StatefulWidget {
  const ContactUsSection({
    Key? key,
    required this.provider,
  }) : super(key: key);

  final User provider;

  @override
  _ContactUsSectionState createState() => _ContactUsSectionState();
}

class _ContactUsSectionState extends State<ContactUsSection> {
  List<MenaSocialItem>? socialItems;

  @override
  void initState() {
    // TODO: implement initState

    socialItems = [
      MenaSocialItem(
        name: 'Web',
        svgAssetLink: 'assets/svg/icons/website.svg',

        jsonLink: 'assets/json/chrome.json',

        /// ToDO: change this == for test purposes
        redirectLink: widget.provider.website,
        // visible: widget.provider.website != null,
        visible: true,
      ),
      MenaSocialItem(
        name: 'Email',
        svgAssetLink: 'assets/svg/icons/openemail.svg',
        jsonLink: 'assets/json/email.json',
        redirectLink: widget.provider.email,
        // visible: widget.provider.email != null,
        visible: true,
      ),
      MenaSocialItem(
        name: 'Phone',
        svgAssetLink: 'assets/svg/icons/landphone.svg',
        jsonLink: 'assets/json/phone.json',
        redirectLink: widget.provider.phone,
        // visible: widget.provider.phone != null,
        visible: true,
      ),
      MenaSocialItem(
        name: 'Whatsapp',
        svgAssetLink: 'assets/svg/icons/whatsapp.svg',
        jsonLink: 'assets/json/whatsapp.json',
        redirectLink: widget.provider.whatsapp,
        // visible: widget.provider.whatsapp != null,
        visible: true,
      ),
      // MenaSocialItem(
      //   name: 'Youtube',
      //   svgAssetLink: 'assets/svg/icons/youtube.svg',
      //   redirectLink: widget.provider.youtube,
      //   visible: widget.provider.youtube != null,
      // ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return socialItems!.where((element) => element.visible == true).toList().isEmpty
        ? SizedBox()
        : DefaultShadowedContainer(
            childWidget: Padding(
              padding: EdgeInsets.all(defaultHorizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // MyTitle(title: 'Contact Us'),
                  // heightBox(8.h),
                  SizedBox(
                    height: 0.6.sw / socialItems!.length,
                    child: Center(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) => GestureDetector(
                            onTap: () async {
                              logg(
                                  'launch url ${socialItems!.where((element) => element.visible == true).toList()[index].redirectLink}');
                              Uri uri = Uri.parse(socialItems!
                                  .where((element) => element.visible == true)
                                  .toList()[index]
                                  .redirectLink!);

                              /// now if tel or email:
                              if (socialItems!
                                  .where((element) => element.visible == true)
                                  .toList()[index]
                                  .redirectLink!
                                  .contains('@')) {
                                uri = Uri(
                                  scheme: 'mailto',
                                  path: socialItems!
                                      .where((element) => element.visible == true)
                                      .toList()[index]
                                      .redirectLink!,
                                  query: encodeQueryParameters(<String, String>{
                                    'subject': 'Subject',
                                  }),
                                );
                              } else if (socialItems!
                                      .where((element) => element.visible == true)
                                      .toList()[index]
                                      .redirectLink!
                                      .startsWith('0') ||
                                  socialItems!
                                      .where((element) => element.visible == true)
                                      .toList()[index]
                                      .redirectLink!
                                      .startsWith('+')) {
                                uri = Uri(
                                    scheme: 'tel',
                                    path: socialItems!
                                        .where((element) => element.visible == true)
                                        .toList()[index]
                                        .redirectLink!);
                              }
                              if (!await launchUrl(uri)) {
                                throw 'Could not launch ${socialItems!.where((element) => element.visible == true).toList()[index].redirectLink}';
                              }
                            },
                            child: socialItems!.where((element) => element.visible == true).toList()[index].jsonLink ==
                                    null
                                ? SvgPicture.asset(
                                    socialItems!
                                        .where((element) => element.visible == true)
                                        .toList()[index]
                                        .svgAssetLink!,
                                    width: 0.6.sw /
                                        socialItems!.where((element) => element.visible == true).toList().length,
                                    height: 0.6.sw /
                                        socialItems!.where((element) => element.visible == true).toList().length,
                                  )
                                : lottie.Lottie.asset(
                                    socialItems!.where((element) => element.visible == true).toList()[index].jsonLink!,

                                    // fit: BoxFit.fill,
                                    width: 0.6.sw /
                                        socialItems!.where((element) => element.visible == true).toList().length,
                                    height: 0.6.sw /
                                        socialItems!.where((element) => element.visible == true).toList().length,
                                    // height: 55.sp,
                                  )),
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (_, i) => widthBox(33.w),
                        itemCount: socialItems!.where((element) => element.visible == true).toList().length,
                      ),
                    ),
                  ),
                  ProfileFooterTitle(
                    text: 'Contact us',
                  )
                ],
              ),
            ),
          );
  }
}

class AwardsSection extends StatelessWidget {
  const AwardsSection({
    Key? key,
    this.rewards,
  }) : super(key: key);

  final List<Awards>? rewards;

  @override
  Widget build(BuildContext context) {
    return rewards == null
        ? SizedBox()
        : rewards!.isEmpty
            ? SizedBox()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyTitle(title: 'Awards'),
                  heightBox(8.h),
                  GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    padding: const EdgeInsets.only(bottom: 15),
                    shrinkWrap: true,
                    mainAxisSpacing: 9.sp,
                    crossAxisSpacing: 10.sp,
                    children: List.generate(
                        rewards!.length,
                        (index) => GestureDetector(
                              onTap: () {},
                              child: DefaultImage(backGroundImageUrl: rewards![index].image),
                            ) //getProductObjectAsList
                        ),
                  ),
                ],
              );
  }
}

class ReviewsSection extends StatelessWidget {
  const ReviewsSection({
    Key? key,
    this.reviews,
  }) : super(key: key);
  final MenaReviews? reviews;

  @override
  Widget build(BuildContext context) {
    return reviews == null
        ? SizedBox()
        : Column(
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     MyTitle(title: 'Reviews'),
              //     Row(
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: [
              //         Icon(
              //           Icons.star,
              //           color: Colors.amber,
              //           size: 20.sp,
              //         ),
              //         Text(
              //           '${reviews!.totalSize.toString()} Reviews',
              //           style: mainStyle(context, 13, color: mainBlueColor, weight: FontWeight.w600, textHeight: 1.5),
              //         ),
              //       ],
              //     )
              //   ],
              // ),
              // heightBox(8.h),
              Expanded(
                child: reviews!.data == null
                    ? SizedBox()
                    : reviews!.data!.isEmpty
                        ? SizedBox()
                        : ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => ReviewItemCard(
                            menaReviewItem: reviews!.data![index],
                          ),
                          separatorBuilder: (_, i) => heightBox(10.h),
                          itemCount: reviews!.data!.length,
                        ),
              ),
              reviews!.totalSize < reviews!.data!.length
                  ? SizedBox()
                  : Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: DefaultButton(
                        text: getTranslatedStrings(context).viewMore,
                        fontSize: 11,
                        backColor: softBlueColor,
                        titleColor: mainBlueColor,
                        onClick: () {
                          viewComingSoonAlertDialog(context);
                        },
                        width: 0.3.sw,
                        // height: 27.sp,
                        radius: 23.r,
                      ),
                    )
            ],
          );
  }
}

class ReviewItemCard extends StatelessWidget {
  const ReviewItemCard({Key? key, required this.menaReviewItem}) : super(key: key);

  final MenaReviewItem menaReviewItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: DefaultShadowedContainer(
        childWidget: Padding(
          padding: EdgeInsets.all(10.0.sp),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ProfileBubble(isOnline: false, pictureUrl: menaReviewItem.image, radius: 22.sp),
                      widthBox(7.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            menaReviewItem.name,
                            style: mainStyle(context, 12, weight: FontWeight.w500),
                          ),
                          heightBox(4.h),
                          Text(
                            menaReviewItem.date,
                            style: mainStyle(context, 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  RatingBarIndicator(
                    rating: menaReviewItem.rate,
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 15.0.sp,
                    direction: Axis.horizontal,
                  ),
                ],
              ),
              heightBox(12.h),
              DescriptionText(title: menaReviewItem.content)
            ],
          ),
        ),
      ),
    );
  }
}

class RewardsSection extends StatelessWidget {
  RewardsSection({
    Key? key,
    this.rewards,
    this.inEditProfile = false,
  }) : super(key: key);
  List<Reward>? rewards;
  final bool inEditProfile;

  @override
  Widget build(BuildContext context) {
    var profileCubit = ProfileCubit.get(context);

    return rewards == null
        ? SizedBox()
        : BlocConsumer<MainCubit, MainState>(
            listener: (context, state) {
              // TODO: implement listener

              rewards = MainCubit.get(context).userInfoModel!.data.user.moreData!.rewards;
            },
            builder: (context, state) {
              return DefaultShadowedContainer(
                childWidget: Padding(
                  padding: EdgeInsets.all(defaultHorizontalPadding),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ProfileSectionHeader(
                            svgLink: 'assets/svg/icons/profile/Awards.svg',
                            title: 'Rewards',
                          ),
                          if (inEditProfile)
                            ProfileSectionActions(addAction: () {
                              var _formKey = GlobalKey<FormState>();
                              TextEditingController nameOfUnCertificateCont = TextEditingController();
                              TextEditingController issuingDateCont = TextEditingController();

                              DateTime publishedDate = DateTime.now();
                              viewRewardsModalAddUpdateBottom(context, _formKey, nameOfUnCertificateCont,
                                  issuingDateCont, profileCubit, publishedDate, false);
                            })
                        ],
                      ),
                      heightBox(8.h),
                      rewards!.isEmpty
                          ? SizedBox()
                          : Column(
                              children: [
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) => ProfileSubHeadItem(
                                    title: rewards![index].title,
                                    subTitle: rewards![index].year ?? '-',
                                    svgPicture: 'assets/svg/icons/profile/Awards-1.svg',
                                    actionWidget: Row(
                                      children: [               if(inEditProfile)
                                        GestureDetector(
                                          onTap: () {
                                            var _formKey = GlobalKey<FormState>();
                                            TextEditingController nameOfMemberShipCont = TextEditingController();
                                            TextEditingController nameOfAuthCont = TextEditingController();
                                            DateTime publishedDate = DateTime.now();
                                            nameOfMemberShipCont.text = rewards![index].title;
                                            nameOfAuthCont.text = rewards![index].year.toString();
                                            viewRewardsModalAddUpdateBottom(context, _formKey, nameOfMemberShipCont,
                                                nameOfAuthCont, profileCubit, publishedDate, true,
                                                customId: rewards![index].id.toString());
                                          },
                                          child: SvgPicture.asset(
                                            'assets/svg/icons/edit.svg',
                                            width: 22.w,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  separatorBuilder: (_, i) => heightBox(10.h),
                                  itemCount: rewards!.length,
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}

Future<void> viewRewardsModalAddUpdateBottom(
    BuildContext context,
    GlobalKey<FormState> _formKey,
    TextEditingController nameOfRewardCont,
    TextEditingController nameOfRewardYearCont,
    // TextEditingController publisher,
    // TextEditingController publishedUrl,
    // TextEditingController publishedDateCont,
    ProfileCubit profileCubit,
    DateTime publishedDate,
    bool isUpdateNotAdd,
    {String? customId}) {
  return showMyBottomSheet(
      context: context,
      isDismissible: false,
      title: !isUpdateNotAdd ? 'Add Reward' : 'Edit REward',
      titleActionWidget: customId == null
          ? null
          : GestureDetector(
              onTap: () {
                showMyAlertDialog(context, 'Confirm deletion',
                    alertDialogContent: Text('You are about deleting entry, Are you sure?'),
                    actions: [
                      BlocConsumer<ProfileCubit, ProfileState>(
                        listener: (context, state) {
                          // TODO: implement listener
                        },
                        builder: (context, state) {
                          return state is UpdatingDataState
                              ? DefaultLoaderColor()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('No')),
                                    TextButton(
                                        onPressed: () {
                                          profileCubit
                                              .removeReward(customId.toString())
                                              .then((value) => MainCubit.get(context).getUserInfo().then((value) {
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  }));
                                        },
                                        child: Text('Yes')),
                                  ],
                                );
                        },
                      )
                    ]);
              },
              child: SvgPicture.asset(
                'assets/svg/icons/remove.svg',
                width: 22.w,
              ),
            ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          // DateTime? pickedDate;
          // Future _selectDate() async {
          //   pickedDate = await showDatePicker(
          //       context: context,
          //       initialDate: new DateTime.now(),
          //       firstDate: new DateTime(2020),
          //       lastDate: new DateTime(2030));
          //   if (pickedDate != null) issuingDateCont.text = pickedDate!.toString();
          // }

          return Form(
            key: _formKey,
            child: Column(
              children: [
                DefaultInputField(
                  label: 'Name of Reward',
                  controller: nameOfRewardCont,
                  validate: normalInputValidate(context),
                ),
                heightBox(7.h),
                DefaultInputField(
                  label: 'Year',
                  controller: nameOfRewardYearCont,
                  validate: normalInputValidate(context),
                ),
                // DefaultInputField(
                //   validate: normalInputValidate(context),
                //   label: 'Date of published',
                //   // labelWidget: Text(
                //   //   'Date of birth',
                //   //   style: mainStyle(context, 13, color: mainBlueColor),
                //   // ),
                //   controller: issuingDateCont,
                //   readOnly: true,
                //   onTap: () {
                //     _selectDate();
                //     FocusScope.of(context).requestFocus(new FocusNode());
                //   },
                //   suffixIcon: SvgPicture.asset('assets/svg/icons/calendar.svg'),
                // ),
                // DefaultInputField(
                //   label: 'Date of issuing',
                //   controller: issuingDateCont,
                //   validate: normalInputValidate(context),
                // ),
                // heightBox(7.h),
                // Row(
                //   children: [
                //     Expanded(
                //         child: DefaultInputField(
                //             label: 'Starting year',
                //             controller: startYearCont,
                //             validate: yearBeforeCurrentValidate(context))),
                //     if (!profileCubit.isCurrentlyPursuing) widthBox(7.w),
                //     if (!profileCubit.isCurrentlyPursuing)
                //       Expanded(
                //         child: DefaultInputField(
                //           label: 'Ending  year',
                //           controller: endYearCont,
                //           validate: profileCubit.isCurrentlyPursuing
                //               ? null
                //               : yearBeforeCurrentValidate(context),
                //         ),
                //       ),
                //   ],
                // ),
                // heightBox(7.h),
                // Row(
                //   children: [
                //     Checkbox(
                //         value: profileCubit.isCurrentlyPursuing,
                //         onChanged: (val) {
                //           logg('before: ' + profileCubit.isCurrentlyPursuing.toString());
                //           logg(val.toString());
                //           profileCubit.changeCurrentlyPursuingVal(val!);
                //           logg('after: ' + profileCubit.isCurrentlyPursuing.toString());
                //         }),
                //     Expanded(child: Text('Currently pursuing')),
                //   ],
                // ),
                heightBox(7.h),
                state is UpdatingDataState
                    ? DefaultLoaderColor()
                    : DefaultButton(
                        text: 'Save',
                        onClick: () {
                          if (_formKey.currentState!.validate()) {
                            logg('validate');
                            profileCubit
                                .saveReward(
                                    name: nameOfRewardCont.text,
                                    year: nameOfRewardYearCont.text,
                                    customId: customId,
                                    isUpdateNotAdd: isUpdateNotAdd)
                                .then((value) => MainCubit.get(context).getUserInfo().then((value) {
                                      Navigator.pop(context);
                                    }));
                          }
                        })
              ],
            ),
          );
        },
      ));
}

class EducationSection extends StatelessWidget {
  EducationSection({
    Key? key,
    this.educations,
    this.inEditProfile = false,
  }) : super(key: key);
  List<Education>? educations;

  final bool inEditProfile;

  @override
  Widget build(BuildContext context) {
    var profileCubit = ProfileCubit.get(context);
    return educations == null
        ? SizedBox()
        : BlocConsumer<MainCubit, MainState>(
            listener: (context, state) {
              // TODO: implement listener
              educations = MainCubit.get(context).userInfoModel!.data.user.moreData!.educations;
            },
            builder: (context, mainState) {
              return DefaultShadowedContainer(
                childWidget: Padding(
                  padding: EdgeInsets.all(defaultHorizontalPadding),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ProfileSectionHeader(
                            svgLink: 'assets/svg/icons/profile/education.svg',
                            title: 'Education',
                          ),
                          if (inEditProfile)
                            ProfileSectionActions(addAction: () {
                              var _formKey = GlobalKey<FormState>();
                              TextEditingController nameOfUnCont = TextEditingController();
                              TextEditingController degreeCont = TextEditingController();
                              TextEditingController startYearCont = TextEditingController();
                              TextEditingController endYearCont = TextEditingController();
                              viewEducationModalAddUpdateBottom(context, _formKey, nameOfUnCont, degreeCont,
                                  startYearCont, profileCubit, endYearCont, false);
                            })
                        ],
                      ),
                      educations!.isEmpty
                          ? SizedBox()
                          : Column(
                              children: [
                                heightBox(4.h),
                                Divider(
                                  thickness: 1.2,
                                ),
                                ListView.separated(
                                  shrinkWrap: true,
                                  reverse: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) => ProfileSubHeadItem(
                                    svgPicture: 'assets/svg/icons/profile/education-1.svg',
                                    title: educations![index].universityName.toString(),
                                    subTitle: educations![index].degree.toString(),
                                    subSubTitle:
                                        '${educations![index].startingYear} - ${educations![index].currentlyPursuing == 1 ? 'present' : educations![index].endingYear}',
                                    actionWidget: Row(
                                      children: [
                                        if(inEditProfile)
                                        GestureDetector(
                                          onTap: () {
                                            var _formKey = GlobalKey<FormState>();
                                            TextEditingController nameOfUnCont = TextEditingController();
                                            TextEditingController degreeCont = TextEditingController();
                                            TextEditingController startYearCont = TextEditingController();
                                            TextEditingController endYearCont = TextEditingController();

                                            nameOfUnCont.text = educations![index].universityName;
                                            degreeCont.text = educations![index].degree.toString();
                                            startYearCont.text = educations![index].startingYear.toString();
                                            endYearCont.text = educations![index].endingYear ?? '';
                                            profileCubit
                                                .changeCurrentlyPursuingVal(educations![index].currentlyPursuing == 1);
                                            viewEducationModalAddUpdateBottom(context, _formKey, nameOfUnCont,
                                                degreeCont, startYearCont, profileCubit, endYearCont, true,
                                                customId: educations![index].id.toString());
                                          },
                                          child: SvgPicture.asset(
                                            'assets/svg/icons/edit.svg',
                                            width: 22.w,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  separatorBuilder: (_, i) => heightBox(10.h),
                                  itemCount: educations!.length,
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}

Future<void> viewEducationModalAddUpdateBottom(
    BuildContext context,
    GlobalKey<FormState> _formKey,
    TextEditingController nameOfUnCont,
    TextEditingController degreeCont,
    TextEditingController startYearCont,
    ProfileCubit profileCubit,
    TextEditingController endYearCont,
    bool isUpdateNotAdd,
    {String? customId}) {
  return showMyBottomSheet(
      context: context,
      isDismissible: false,
      title: !isUpdateNotAdd ? 'Add Education' : 'Edit Education',
      titleActionWidget: customId == null
          ? null
          : GestureDetector(
              onTap: () {
                showMyAlertDialog(context, 'Confirm deletion',
                    alertDialogContent: Text('You are about deleting entry, Are you sure?'),
                    actions: [
                      BlocConsumer<ProfileCubit, ProfileState>(
                        listener: (context, state) {
                          // TODO: implement listener
                        },
                        builder: (context, state) {
                          return state is UpdatingDataState
                              ? DefaultLoaderColor()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('No')),
                                    TextButton(
                                        onPressed: () {
                                          profileCubit
                                              .removeEducation(customId.toString())
                                              .then((value) => MainCubit.get(context).getUserInfo().then((value) {
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  }));
                                        },
                                        child: Text('Yes')),
                                  ],
                                );
                        },
                      )
                    ]);
              },
              child: SvgPicture.asset(
                'assets/svg/icons/remove.svg',
                width: 22.w,
              ),
            ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                DefaultInputField(
                  label: 'Name of university',
                  controller: nameOfUnCont,
                  validate: normalInputValidate(context),
                ),
                heightBox(7.h),
                DefaultInputField(
                  label: 'Enter Degree name',
                  controller: degreeCont,
                  validate: normalInputValidate(context),
                ),
                heightBox(7.h),
                Row(
                  children: [
                    Expanded(
                        child: DefaultInputField(
                            label: 'Starting year',
                            controller: startYearCont,
                            validate: yearBeforeCurrentValidate(context))),
                    if (!profileCubit.isCurrentlyPursuing) widthBox(7.w),
                    if (!profileCubit.isCurrentlyPursuing)
                      Expanded(
                        child: DefaultInputField(
                          label: 'Ending  year',
                          controller: endYearCont,
                          validate: profileCubit.isCurrentlyPursuing ? null : yearBeforeCurrentValidate(context),
                        ),
                      ),
                  ],
                ),
                heightBox(7.h),
                Row(
                  children: [
                    Checkbox(
                        value: profileCubit.isCurrentlyPursuing,
                        onChanged: (val) {
                          logg('before: ' + profileCubit.isCurrentlyPursuing.toString());
                          logg(val.toString());
                          profileCubit.changeCurrentlyPursuingVal(val!);
                          logg('after: ' + profileCubit.isCurrentlyPursuing.toString());
                        }),
                    Expanded(child: Text('Currently pursuing')),
                  ],
                ),
                heightBox(7.h),
                state is UpdatingDataState
                    ? DefaultLoaderColor()
                    : DefaultButton(
                        text: 'Save',
                        onClick: () {
                          if (_formKey.currentState!.validate()) {
                            logg('validate');
                            profileCubit
                                .saveEducation(
                                    nameOfUn: nameOfUnCont.text,
                                    degree: degreeCont.text,
                                    startYear: startYearCont.text,
                                    endingYear: endYearCont.text,
                                    customId: customId,
                                    isUpdateNotAdd: isUpdateNotAdd)
                                .then((value) => MainCubit.get(context).getUserInfo().then((value) {
                                      Navigator.pop(context);
                                    }));
                          }
                        })
              ],
            ),
          );
        },
      ));
}

class AboutSection extends StatelessWidget {
  AboutSection({
    Key? key,
    this.about,
    this.inEditProfile = false,
  }) : super(key: key);
  String? about;

  final bool inEditProfile;

  @override
  Widget build(BuildContext context) {
    var profileCubit = ProfileCubit.get(context);
    return about == null
        ? SizedBox()
        : BlocConsumer<MainCubit, MainState>(
            listener: (context, state) {
              // TODO: implement listener
              about = MainCubit.get(context).userInfoModel!.data.user.moreData!.about;
            },
            builder: (context, state) {
              return DefaultShadowedContainer(
                childWidget: Padding(
                  padding: EdgeInsets.all(defaultHorizontalPadding),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ProfileSectionHeader(
                            svgLink: 'assets/svg/icons/profile/About.svg',
                            title: 'About',
                          ),
                          if (inEditProfile)
                            GestureDetector(
                              onTap: () {
                                var _formKey = GlobalKey<FormState>();
                                TextEditingController aboutController = TextEditingController();

                                /// add value of about form api
                                aboutController.text = about ?? '';
                                viewAboutEditBottom(
                                  context,
                                  _formKey,
                                  aboutController,
                                  profileCubit,
                                );
                              },
                              child: SvgPicture.asset(
                                'assets/svg/icons/edit.svg',
                                width: 22.w,
                              ),
                            ),
                          // ProfileSectionActions(
                          //   iOnlyOneItemSoEditWillBeInHeader: true,
                          //   addAction: (){
                          //
                          //   },
                          // )
                        ],
                      ),
                      about!.isEmpty
                          ? SizedBox()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                heightBox(4.h),
                                Divider(
                                  thickness: 1.2,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(defaultHorizontalPadding),
                                  child: Text(
                                    about!,
                                    style: mainStyle(context, 13, color: newDarkGreyColor, weight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  Future<void> viewAboutEditBottom(
      BuildContext context, GlobalKey<FormState> _formKey, TextEditingController aboutCont, ProfileCubit profileCubit,
      {String? customId}) {
    // profileCubit.updateAboutLength(aboutCont.text.length);
    return showMyBottomSheet(
        context: context,
        isDismissible: false,
        title: 'About',
        body: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  DefaultInputField(
                    label: 'About',
                    controller: aboutCont,
                    maxLines: 4,
                    // onFieldChanged: (val){
                    //  profileCubit.updateAboutLength(val.length);
                    // },
                    maxLength: 500,
                    // validate: (String? val) {
                    //   if (val!.length>500) {
                    //     return '';
                    //   }
                    //   return null;
                    // },
                  ),
                  // heightBox(7.h),
                  // Text('${profileCubit.aboutLength}/500',style: mainStyle(context, 13, color: newDarkGreyColor,weight: FontWeight.w700),),
                  heightBox(7.h),
                  state is UpdatingDataState
                      ? DefaultLoaderColor()
                      : DefaultButton(
                          text: 'Save',
                          onClick: () {
                            if (_formKey.currentState!.validate()) {
                              logg('validate');
                              profileCubit
                                  .saveAbout(
                                    aboutCont: aboutCont.text,

                                    customId: customId,
                                    // isUpdateNotAdd: !educations!.isEmpty
                                  )
                                  .then((value) => MainCubit.get(context).getUserInfo().then((value) {
                                        Navigator.pop(context);
                                      }));
                            }
                          })
                ],
              ),
            );
          },
        ));
  }
}

class ProfileCompletionSection extends StatelessWidget {
  ProfileCompletionSection({
    Key? key,
    // this.completionInfo,
    // this.inEditProfile = false,
  }) : super(key: key);

  // DataCompleted? completionInfo;

  // final bool inEditProfile;

  @override
  Widget build(BuildContext context) {
    var mainCubit = MainCubit.get(context);
    return BlocConsumer<MainCubit, MainState>(
      listener: (context, state) {
        // TODO: implement listener
        // mainCubit.calcCompletionPercentage();
      },
      builder: (context, state) {
        return DefaultShadowedContainer(
          childWidget: Padding(
            padding: EdgeInsets.all(defaultHorizontalPadding),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ProfileSectionHeader(
                      svgLink: '',
                      title: 'Profile completion',
                    ),
                    // if (inEditProfile)
                    //   GestureDetector(
                    //     onTap: () {
                    //       var _formKey = GlobalKey<FormState>();
                    //       TextEditingController aboutController = TextEditingController();
                    //
                    //       /// add value of about form api
                    //       aboutController.text = about ?? '';
                    //       viewAboutEditBottom(
                    //         context,
                    //         _formKey,
                    //         aboutController,
                    //         profileCubit,
                    //       );
                    //     },
                    //     child: SvgPicture.asset(
                    //       'assets/svg/icons/edit.svg',
                    //       width: 22.w,
                    //     ),
                    //   ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    heightBox(4.h),
                    Divider(
                      thickness: 1.2,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                height: 50.h,
                                width: 50.h,
                                child: Center(
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: SizedBox(
                                          height: 50.h,
                                          width: 50.h,
                                          child: CircularProgressIndicator(
                                            value: mainCubit.completionPercentage / 100,
                                            color: mainBlueColor,
                                            strokeWidth: 3,
                                          ),
                                        ),
                                      ),
                                      Center(
                                          child: Text(
                                        mainCubit.completionPercentage.round().toString() + ' %',
                                        style: mainStyle(context, 11, color: mainBlueColor, weight: FontWeight.w700),
                                      ))
                                    ],
                                  ),
                                ),
                              ),
                              widthBox(12.w),
                              Expanded(
                                child: Text(
                                  'Did you know that providers over 90% profile completion get most of the views',
                                  style: mainStyle(context, 11, color: newDarkGreyColor, weight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),

                          if (mainCubit.uncompletedSections.isNotEmpty)
                            Column(
                              children: [
                                heightBox(14.h),
                                SizedBox(
                                  height: 0.25.sw,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) => GestureDetector(
                                      // onTap: handleMissedDataBottom(context,mainCubit.uncompletedSections[index].id!),
                                      onTap: () =>
                                          handleMissedDataBottom(context, mainCubit.uncompletedSections[index].id!),
                                      child: DefaultContainer(
                                        // height: double.maxFinite,
                                        borderColor: newDarkGreyColor.withOpacity(0.5),
                                        childWidget: Center(
                                            child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              if (mainCubit.uncompletedSections[index].thumbnailLink != null)
                                                SvgPicture.asset(
                                                  mainCubit.uncompletedSections[index].thumbnailLink!,
                                                  // color: newDarkGreyColor,
                                                  height: 44.h,
                                                ),
                                              heightBox(10.h),
                                              Text(
                                                '${mainCubit.uncompletedSections[index].title}',
                                                style: mainStyle(context, 12,
                                                    color: mainBlueColor, weight: FontWeight.w700),
                                              ),
                                            ],
                                          ),
                                        )),
                                      ),
                                    ),
                                    separatorBuilder: (context, i) => widthBox(7.w),
                                    itemCount: mainCubit.uncompletedSections.length,
                                  ),
                                ),
                              ],
                            ),
                          // DefaultButton(
                          //   text: 'Complete now',
                          //   onClick: () {},
                          //   fontSize: 12,
                          // )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> viewAboutEditBottom(
      BuildContext context, GlobalKey<FormState> _formKey, TextEditingController aboutCont, ProfileCubit profileCubit,
      {String? customId}) {
    return showMyBottomSheet(
        context: context,
        isDismissible: false,
        title: 'About',
        body: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  DefaultInputField(
                    label: 'About',
                    controller: aboutCont,
                    maxLines: 4,
                    validate: normalInputValidate(context),
                  ),
                  heightBox(7.h),
                  state is UpdatingDataState
                      ? DefaultLoaderColor()
                      : DefaultButton(
                          text: 'Save',
                          onClick: () {
                            if (_formKey.currentState!.validate()) {
                              logg('validate');
                              profileCubit
                                  .saveAbout(
                                    aboutCont: aboutCont.text,

                                    customId: customId,
                                    // isUpdateNotAdd: !educations!.isEmpty
                                  )
                                  .then((value) => MainCubit.get(context).getUserInfo().then((value) {
                                        Navigator.pop(context);
                                      }));
                            }
                          })
                ],
              ),
            );
          },
        ));
  }

  handleMissedDataBottom(BuildContext context, String id) {
    var profileCubit = ProfileCubit.get(context);

    logg('handling $id');
    switch (id.toLowerCase()) {
      case 'about':
        var _formKey = GlobalKey<FormState>();
        TextEditingController aboutController = TextEditingController();

        /// add value of about form api
        aboutController.text = '';
        viewAboutEditBottom(
          context,
          _formKey,
          aboutController,
          profileCubit,
        );
        break;
      case 'education':
        var _formKey = GlobalKey<FormState>();
        TextEditingController nameOfUnCont = TextEditingController();
        TextEditingController degreeCont = TextEditingController();
        TextEditingController startYearCont = TextEditingController();
        TextEditingController endYearCont = TextEditingController();
        viewEducationModalAddUpdateBottom(
            context, _formKey, nameOfUnCont, degreeCont, startYearCont, profileCubit, endYearCont, false);
        break;

      case 'experience':
        var _formKey = GlobalKey<FormState>();
        TextEditingController placeOfWork = TextEditingController();
        TextEditingController designation = TextEditingController();
        TextEditingController startYearCont = TextEditingController();
        TextEditingController endYearCont = TextEditingController();
        viewExperiencesModalAddUpdateBottom(
            context, _formKey, placeOfWork, designation, startYearCont, profileCubit, endYearCont, false);
        break;

      case 'publications':
        var _formKey = GlobalKey<FormState>();
        // GlobalKey<FormState> _formKey,
        //     TextEditingController paperTitle,
        // TextEditingController summary,
        // TextEditingController publisher,
        // TextEditingController publishedUrl,
        // ProfileCubit profileCubit,
        // DateTime publishedDate,
        // bool isUpdateNotAdd,

        TextEditingController paperTitle = TextEditingController();
        TextEditingController summary = TextEditingController();
        TextEditingController publisher = TextEditingController();
        TextEditingController publishedUrl = TextEditingController();
        TextEditingController publishedDateCont = TextEditingController();
        DateTime publishedDate = DateTime.now();
        viewPublicationsModalAddUpdateBottom(context, _formKey, paperTitle, summary, publisher, publishedUrl,
            publishedDateCont, profileCubit, publishedDate, false);
        break;

      case 'certifications':
        var _formKey = GlobalKey<FormState>();
        TextEditingController nameOfUnCertificateCont = TextEditingController();
        TextEditingController issuingDateCont = TextEditingController();

        DateTime publishedDate = DateTime.now();
        viewCertificationsModalAddUpdateBottom(
            context, _formKey, nameOfUnCertificateCont, issuingDateCont, profileCubit, publishedDate, false);
        break;

      case 'memberships':
        var _formKey = GlobalKey<FormState>();
        TextEditingController nameOfUnCertificateCont = TextEditingController();
        TextEditingController issuingDateCont = TextEditingController();

        DateTime publishedDate = DateTime.now();
        viewMembershipsModalAddUpdateBottom(
            context, _formKey, nameOfUnCertificateCont, issuingDateCont, profileCubit, publishedDate, false);
        break;

      case 'rewards':
        var _formKey = GlobalKey<FormState>();
        TextEditingController nameOfUnCertificateCont = TextEditingController();
        TextEditingController issuingDateCont = TextEditingController();

        DateTime publishedDate = DateTime.now();
        viewRewardsModalAddUpdateBottom(
            context, _formKey, nameOfUnCertificateCont, issuingDateCont, profileCubit, publishedDate, false);
        break;
    }
  }
}

class ProfileSectionActions extends StatelessWidget {
  const ProfileSectionActions({
    super.key,
    this.iOnlyOneItemSoEditWillBeInHeader = false,
    this.addAction,
  });

  final bool iOnlyOneItemSoEditWillBeInHeader;

  final Function()? addAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (iOnlyOneItemSoEditWillBeInHeader)
          SvgPicture.asset(
            'assets/svg/icons/edit.svg',
            width: 22.w,
          ),
        if (iOnlyOneItemSoEditWillBeInHeader) widthBox(8.w),
        GestureDetector(
          onTap: addAction,
          child: SvgPicture.asset(
            'assets/svg/icons/addcircle.svg',
            width: 22.w,
          ),
        )
      ],
    );
  }
}

// class AddEditEducation extends StatelessWidget {
//   const AddEditEducation({
//     super.key,
//     this.education,
//   });
//
//   final Education? education;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//         onTap: () {
//         },
//         child: );
//   }
// }

class ExperienceSection extends StatelessWidget {
  ExperienceSection({
    Key? key,
    this.experiences,
    this.inEditProfile = false,
  }) : super(key: key);
  List<Experience>? experiences;
  final bool inEditProfile;

  @override
  Widget build(BuildContext context) {
    var profileCubit = ProfileCubit.get(context);
    return experiences == null
        ? SizedBox()
        : BlocConsumer<MainCubit, MainState>(
            listener: (context, state) {
              // TODO: implement listener
              experiences = MainCubit.get(context).userInfoModel!.data.user.moreData!.experiences;
            },
            builder: (context, state) {
              return DefaultShadowedContainer(
                childWidget: Padding(
                  padding: EdgeInsets.all(defaultHorizontalPadding),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ProfileSectionHeader(
                            svgLink: 'assets/svg/icons/profile/Experiences.svg',
                            title: 'Experience',
                          ),
                          if (inEditProfile)
                            ProfileSectionActions(addAction: () {
                              var _formKey = GlobalKey<FormState>();
                              TextEditingController placeOfWork = TextEditingController();
                              TextEditingController designation = TextEditingController();
                              TextEditingController startYearCont = TextEditingController();
                              TextEditingController endYearCont = TextEditingController();
                              viewExperiencesModalAddUpdateBottom(context, _formKey, placeOfWork, designation,
                                  startYearCont, profileCubit, endYearCont, false);
                            })
                        ],
                      ),
                      heightBox(8.h),
                      experiences!.isEmpty
                          ? SizedBox()
                          : Column(
                              children: [
                                ListView.separated(
                                  shrinkWrap: true,
                                  reverse: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) => ProfileSubHeadItem(
                                    svgPicture: 'assets/svg/icons/profile/Experiences-1.svg',
                                    title: experiences![index].placeOfWork.toString(),
                                    subTitle: experiences![index].designation.toString(),
                                    subSubTitle:
                                        '${experiences![index].startingYear} - ${experiences![index].currentlyWorking == 1 ? 'present' : experiences![index].endingYear}',
                                    actionWidget: Row(
                                      children: [               if(inEditProfile)
                                        GestureDetector(
                                          onTap: () {
                                            var _formKey = GlobalKey<FormState>();
                                            TextEditingController placeOfWork = TextEditingController();
                                            TextEditingController designation = TextEditingController();
                                            TextEditingController startYearCont = TextEditingController();
                                            TextEditingController endYearCont = TextEditingController();

                                            placeOfWork.text = experiences![index].placeOfWork;
                                            designation.text = experiences![index].designation.toString();
                                            startYearCont.text = experiences![index].startingYear.toString();
                                            endYearCont.text = experiences![index].endingYear ?? '';
                                            profileCubit
                                                .changeCurrentlyPursuingVal(experiences![index].currentlyWorking == 1);
                                            viewExperiencesModalAddUpdateBottom(context, _formKey, placeOfWork,
                                                designation, startYearCont, profileCubit, endYearCont, true,
                                                customId: experiences![index].id.toString());
                                          },
                                          child: SvgPicture.asset(
                                            'assets/svg/icons/edit.svg',
                                            width: 22.w,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  separatorBuilder: (_, i) => heightBox(10.h),
                                  itemCount: experiences!.length,
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}

Future<void> viewExperiencesModalAddUpdateBottom(
    BuildContext context,
    GlobalKey<FormState> _formKey,
    TextEditingController designation,
    TextEditingController placeOfWork,
    TextEditingController startYearCont,
    ProfileCubit profileCubit,
    TextEditingController endYearCont,
    bool isUpdateNotAdd,
    {String? customId}) {
  return showMyBottomSheet(
      context: context,
      isDismissible: false,
      title: !isUpdateNotAdd ? 'Add Experience' : 'Edit Experience',
      titleActionWidget: customId == null
          ? null
          : GestureDetector(
              onTap: () {
                showMyAlertDialog(context, 'Confirm deletion',
                    alertDialogContent: Text('You are about deleting entry, Are you sure?'),
                    actions: [
                      BlocConsumer<ProfileCubit, ProfileState>(
                        listener: (context, state) {
                          // TODO: implement listener
                        },
                        builder: (context, state) {
                          return state is UpdatingDataState
                              ? DefaultLoaderColor()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('No')),
                                    TextButton(
                                        onPressed: () {
                                          profileCubit
                                              .removeExperience(customId.toString())
                                              .then((value) => MainCubit.get(context).getUserInfo().then((value) {
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  }));
                                        },
                                        child: Text('Yes')),
                                  ],
                                );
                        },
                      )
                    ]);
              },
              child: SvgPicture.asset(
                'assets/svg/icons/remove.svg',
                width: 22.w,
              ),
            ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                DefaultInputField(
                  label: 'Designation',
                  controller: designation,
                  validate: normalInputValidate(context),
                ),
                heightBox(7.h),
                DefaultInputField(
                  label: 'Place Of Work',
                  controller: placeOfWork,
                  validate: normalInputValidate(context),
                ),
                heightBox(7.h),
                Row(
                  children: [
                    Expanded(
                        child: DefaultInputField(
                            label: 'Starting year',
                            controller: startYearCont,
                            validate: yearBeforeCurrentValidate(context))),
                    if (!profileCubit.isCurrentlyPursuing) widthBox(7.w),
                    if (!profileCubit.isCurrentlyPursuing)
                      Expanded(
                        child: DefaultInputField(
                          label: 'Ending  year',
                          controller: endYearCont,
                          validate: profileCubit.isCurrentlyPursuing ? null : yearBeforeCurrentValidate(context),
                        ),
                      ),
                  ],
                ),
                heightBox(7.h),
                Row(
                  children: [
                    Checkbox(
                        value: profileCubit.isCurrentlyPursuing,
                        onChanged: (val) {
                          logg('before: ' + profileCubit.isCurrentlyPursuing.toString());
                          logg(val.toString());
                          profileCubit.changeCurrentlyPursuingVal(val!);
                          logg('after: ' + profileCubit.isCurrentlyPursuing.toString());
                        }),
                    Expanded(child: Text('Currently working')),
                  ],
                ),
                heightBox(7.h),
                state is UpdatingDataState
                    ? DefaultLoaderColor()
                    : DefaultButton(
                        text: 'Save',
                        onClick: () {
                          if (_formKey.currentState!.validate()) {
                            logg('validate');
                            profileCubit
                                .saveExperience(
                                    position: designation.text,
                                    company: placeOfWork.text,
                                    startYear: startYearCont.text,
                                    endingYear: endYearCont.text,
                                    customId: customId,
                                    isUpdateNotAdd: isUpdateNotAdd)
                                .then((value) => MainCubit.get(context).getUserInfo().then((value) {
                                      Navigator.pop(context);
                                    }));
                          }
                        })
              ],
            ),
          );
        },
      ));
}

class MembershipSection extends StatelessWidget {
  MembershipSection({
    Key? key,
    this.memberships,
    this.inEditProfile = false,
  }) : super(key: key);
  List<Membership>? memberships;
  final bool inEditProfile;

  @override
  Widget build(BuildContext context) {
    var profileCubit = ProfileCubit.get(context);
    return memberships == null
        ? SizedBox()
        : BlocConsumer<MainCubit, MainState>(
            listener: (context, state) {
              // TODO: implement listener
              memberships = MainCubit.get(context).userInfoModel!.data.user.moreData!.memberships;
            },
            builder: (context, state) {
              return DefaultShadowedContainer(
                childWidget: Padding(
                  padding: EdgeInsets.all(defaultHorizontalPadding),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ProfileSectionHeader(
                            svgLink: 'assets/svg/icons/profile/Memberships.svg',
                            title: 'Membership',
                          ),
                          if (inEditProfile)
                            ProfileSectionActions(addAction: () {
                              var _formKey = GlobalKey<FormState>();
                              TextEditingController nameOfUnCertificateCont = TextEditingController();
                              TextEditingController issuingDateCont = TextEditingController();

                              DateTime publishedDate = DateTime.now();
                              viewMembershipsModalAddUpdateBottom(context, _formKey, nameOfUnCertificateCont,
                                  issuingDateCont, profileCubit, publishedDate, false);
                            })
                        ],
                      ),
                      heightBox(8.h),
                      memberships!.isEmpty
                          ? SizedBox()
                          : Column(
                              children: [
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) => ProfileSubHeadItem(
                                    title: memberships![index].name,
                                    subTitle: memberships![index].authName ?? '-',
                                    svgPicture: 'assets/svg/icons/profile/Memberships-1.svg',
                                    actionWidget: Row(
                                      children: [               if(inEditProfile)
                                        GestureDetector(
                                          onTap: () {
                                            var _formKey = GlobalKey<FormState>();
                                            TextEditingController nameOfMemberShipCont = TextEditingController();
                                            TextEditingController nameOfAuthCont = TextEditingController();
                                            DateTime publishedDate = DateTime.now();
                                            nameOfMemberShipCont.text = memberships![index].name;
                                            nameOfAuthCont.text = memberships![index].authName.toString();
                                            viewMembershipsModalAddUpdateBottom(context, _formKey, nameOfMemberShipCont,
                                                nameOfAuthCont, profileCubit, publishedDate, true,
                                                customId: memberships![index].id.toString());
                                          },
                                          child: SvgPicture.asset(
                                            'assets/svg/icons/edit.svg',
                                            width: 22.w,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  separatorBuilder: (_, i) => heightBox(10.h),
                                  itemCount: memberships!.length,
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}

Future<void> viewMembershipsModalAddUpdateBottom(
    BuildContext context,
    GlobalKey<FormState> _formKey,
    TextEditingController nameOfMembershipCont,
    TextEditingController nameOfMembershipAuthCont,
    // TextEditingController publisher,
    // TextEditingController publishedUrl,
    // TextEditingController publishedDateCont,
    ProfileCubit profileCubit,
    DateTime publishedDate,
    bool isUpdateNotAdd,
    {String? customId}) {
  return showMyBottomSheet(
      context: context,
      isDismissible: false,
      title: !isUpdateNotAdd ? 'Add Membership' : 'Edit Membership',
      titleActionWidget: customId == null
          ? null
          : GestureDetector(
              onTap: () {
                showMyAlertDialog(context, 'Confirm deletion',
                    alertDialogContent: Text('You are about deleting entry, Are you sure?'),
                    actions: [
                      BlocConsumer<ProfileCubit, ProfileState>(
                        listener: (context, state) {
                          // TODO: implement listener
                        },
                        builder: (context, state) {
                          return state is UpdatingDataState
                              ? DefaultLoaderColor()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('No')),
                                    TextButton(
                                        onPressed: () {
                                          profileCubit
                                              .removeMembership(customId.toString())
                                              .then((value) => MainCubit.get(context).getUserInfo().then((value) {
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  }));
                                        },
                                        child: Text('Yes')),
                                  ],
                                );
                        },
                      )
                    ]);
              },
              child: SvgPicture.asset(
                'assets/svg/icons/remove.svg',
                width: 22.w,
              ),
            ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          // DateTime? pickedDate;
          // Future _selectDate() async {
          //   pickedDate = await showDatePicker(
          //       context: context,
          //       initialDate: new DateTime.now(),
          //       firstDate: new DateTime(2020),
          //       lastDate: new DateTime(2030));
          //   if (pickedDate != null) issuingDateCont.text = pickedDate!.toString();
          // }

          return Form(
            key: _formKey,
            child: Column(
              children: [
                DefaultInputField(
                  label: 'Name of Membership',
                  controller: nameOfMembershipCont,
                  validate: normalInputValidate(context),
                ),
                heightBox(7.h),
                DefaultInputField(
                  label: 'Name of Authority',
                  controller: nameOfMembershipAuthCont,
                  validate: normalInputValidate(context),
                ),
                // DefaultInputField(
                //   validate: normalInputValidate(context),
                //   label: 'Date of published',
                //   // labelWidget: Text(
                //   //   'Date of birth',
                //   //   style: mainStyle(context, 13, color: mainBlueColor),
                //   // ),
                //   controller: issuingDateCont,
                //   readOnly: true,
                //   onTap: () {
                //     _selectDate();
                //     FocusScope.of(context).requestFocus(new FocusNode());
                //   },
                //   suffixIcon: SvgPicture.asset('assets/svg/icons/calendar.svg'),
                // ),
                // DefaultInputField(
                //   label: 'Date of issuing',
                //   controller: issuingDateCont,
                //   validate: normalInputValidate(context),
                // ),
                // heightBox(7.h),
                // Row(
                //   children: [
                //     Expanded(
                //         child: DefaultInputField(
                //             label: 'Starting year',
                //             controller: startYearCont,
                //             validate: yearBeforeCurrentValidate(context))),
                //     if (!profileCubit.isCurrentlyPursuing) widthBox(7.w),
                //     if (!profileCubit.isCurrentlyPursuing)
                //       Expanded(
                //         child: DefaultInputField(
                //           label: 'Ending  year',
                //           controller: endYearCont,
                //           validate: profileCubit.isCurrentlyPursuing
                //               ? null
                //               : yearBeforeCurrentValidate(context),
                //         ),
                //       ),
                //   ],
                // ),
                // heightBox(7.h),
                // Row(
                //   children: [
                //     Checkbox(
                //         value: profileCubit.isCurrentlyPursuing,
                //         onChanged: (val) {
                //           logg('before: ' + profileCubit.isCurrentlyPursuing.toString());
                //           logg(val.toString());
                //           profileCubit.changeCurrentlyPursuingVal(val!);
                //           logg('after: ' + profileCubit.isCurrentlyPursuing.toString());
                //         }),
                //     Expanded(child: Text('Currently pursuing')),
                //   ],
                // ),
                heightBox(7.h),
                state is UpdatingDataState
                    ? DefaultLoaderColor()
                    : DefaultButton(
                        text: 'Save',
                        onClick: () {
                          if (_formKey.currentState!.validate()) {
                            logg('validate');
                            profileCubit
                                .saveMembership(
                                    name: nameOfMembershipCont.text,
                                    authName: nameOfMembershipAuthCont.text,
                                    customId: customId,
                                    isUpdateNotAdd: isUpdateNotAdd)
                                .then((value) => MainCubit.get(context).getUserInfo().then((value) {
                                      Navigator.pop(context);
                                    }));
                          }
                        })
              ],
            ),
          );
        },
      ));
}

class PublicationSection extends StatelessWidget {
  PublicationSection({
    Key? key,
    this.publications,
    this.inEditProfile = false,
  }) : super(key: key);
  List<Publication>? publications;

  final bool inEditProfile;

  @override
  Widget build(BuildContext context) {
    var profileCubit = ProfileCubit.get(context);
    return publications == null
        ? SizedBox()
        : BlocConsumer<MainCubit, MainState>(
            listener: (context, state) {
              // TODO: implement listener
              publications = MainCubit.get(context).userInfoModel!.data.user.moreData!.publications;
            },
            builder: (context, state) {
              return DefaultShadowedContainer(
                childWidget: Padding(
                  padding: EdgeInsets.all(defaultHorizontalPadding),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ProfileSectionHeader(
                            svgLink: 'assets/svg/icons/profile/Publications.svg',
                            title: 'Publications',
                          ),
                          if (inEditProfile)
                            ProfileSectionActions(addAction: () {
                              var _formKey = GlobalKey<FormState>();
                              // GlobalKey<FormState> _formKey,
                              //     TextEditingController paperTitle,
                              // TextEditingController summary,
                              // TextEditingController publisher,
                              // TextEditingController publishedUrl,
                              // ProfileCubit profileCubit,
                              // DateTime publishedDate,
                              // bool isUpdateNotAdd,

                              TextEditingController paperTitle = TextEditingController();
                              TextEditingController summary = TextEditingController();
                              TextEditingController publisher = TextEditingController();
                              TextEditingController publishedUrl = TextEditingController();
                              TextEditingController publishedDateCont = TextEditingController();
                              DateTime publishedDate = DateTime.now();
                              viewPublicationsModalAddUpdateBottom(context, _formKey, paperTitle, summary, publisher,
                                  publishedUrl, publishedDateCont, profileCubit, publishedDate, false);
                            })
                        ],
                      ),
                      heightBox(8.h),
                      publications!.isEmpty
                          ? SizedBox()
                          : Column(
                              children: [
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) => PublicationSubHeadItem(
                                    publication: publications![index],
                                    actionWidget: Row(
                                      children: [               if(inEditProfile)
                                        GestureDetector(
                                          onTap: () {
                                            var _formKey = GlobalKey<FormState>();

                                            TextEditingController paperTitle = TextEditingController();
                                            TextEditingController summary = TextEditingController();
                                            TextEditingController publisher = TextEditingController();
                                            TextEditingController publishedUrl = TextEditingController();
                                            TextEditingController publishedDateCont = TextEditingController();
                                            // DateTime publishedDate = DateTime.now();

                                            paperTitle.text = publications![index].paperTitle;
                                            summary.text = publications![index].summary;
                                            publisher.text = publications![index].publisher;
                                            publishedUrl.text = publications![index].publishedUrl;
                                            publishedDateCont.text = publications![index].publishedDate.toString();
                                            DateTime publishedDate = DateTime.now();
                                            // viewPublicationsModalAddUpdateBottom(context, _formKey, paperTitle, summary, publisher,
                                            //     publishedUrl, publishedDateCont, profileCubit, publishedDate, true);

                                            viewPublicationsModalAddUpdateBottom(
                                                context,
                                                _formKey,
                                                paperTitle,
                                                summary,
                                                publisher,
                                                publishedUrl,
                                                publishedDateCont,
                                                profileCubit,
                                                publishedDate,
                                                true,
                                                customId: publications![index].id.toString());
                                            // TextEditingController placeOfWork = TextEditingController();
                                            // TextEditingController designation = TextEditingController();
                                            // TextEditingController startYearCont = TextEditingController();
                                            // TextEditingController endYearCont = TextEditingController();

                                            // placeOfWork.text = publications![index].placeOfWork;
                                            // designation.text = publications![index].designation.toString();
                                            // startYearCont.text = publications![index].startingYear.toString();
                                            // endYearCont.text = publications![index].endingYear ?? '';
                                            // profileCubit
                                            //     .changeCurrentlyPursuingVal(experiences![index].currentlyWorking == 1);
                                            // viewExperiencesModalAddUpdateBottom(context, _formKey, placeOfWork,
                                            //     designation, startYearCont, profileCubit, endYearCont, true,
                                            //     customId: experiences![index].id.toString());
                                          },
                                          child: SvgPicture.asset(
                                            'assets/svg/icons/edit.svg',
                                            width: 22.w,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  separatorBuilder: (_, i) => heightBox(10.h),
                                  itemCount: publications!.length,
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}

Future<void> viewPublicationsModalAddUpdateBottom(
    BuildContext context,
    GlobalKey<FormState> _formKey,
    TextEditingController paperTitle,
    TextEditingController summary,
    TextEditingController publisher,
    TextEditingController publishedUrl,
    TextEditingController publishedDateCont,
    ProfileCubit profileCubit,
    DateTime publishedDate,
    bool isUpdateNotAdd,
    {String? customId}) {
  return showMyBottomSheet(
      context: context,
      isDismissible: false,
      title: !isUpdateNotAdd ? 'Add Publication' : 'Edit Publication',
      titleActionWidget: customId == null
          ? null
          : GestureDetector(
              onTap: () {
                showMyAlertDialog(context, 'Confirm deletion',
                    alertDialogContent: Text('You are about deleting entry, Are you sure?'),
                    actions: [
                      BlocConsumer<ProfileCubit, ProfileState>(
                        listener: (context, state) {
                          // TODO: implement listener
                        },
                        builder: (context, state) {
                          return state is UpdatingDataState
                              ? DefaultLoaderColor()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('No')),
                                    TextButton(
                                        onPressed: () {
                                          profileCubit
                                              .removePublication(customId.toString())
                                              .then((value) => MainCubit.get(context).getUserInfo().then((value) {
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  }));
                                        },
                                        child: Text('Yes')),
                                  ],
                                );
                        },
                      )
                    ]);
              },
              child: SvgPicture.asset(
                'assets/svg/icons/remove.svg',
                width: 22.w,
              ),
            ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          DateTime? pickedDate;
          Future _selectDate() async {
            pickedDate = await showDatePicker(
                context: context,
                initialDate: new DateTime.now(),
                firstDate: new DateTime(2020),
                lastDate: new DateTime(2030));
            if (pickedDate != null) publishedDateCont.text = pickedDate.toString();
          }

          return Form(
            key: _formKey,
            child: Column(
              children: [
                DefaultInputField(
                  label: 'Paper Title',
                  controller: paperTitle,
                  validate: normalInputValidate(context),
                ),
                heightBox(7.h),
                DefaultInputField(
                  label: 'Summary',
                  controller: summary,
                  maxLines: 4,
                  validate: normalInputValidate(context),
                ),
                heightBox(7.h),
                DefaultInputField(
                  label: 'Publisher',
                  controller: publisher,
                  validate: normalInputValidate(context),
                ),
                heightBox(7.h),
                DefaultInputField(
                  label: 'Published Url',
                  controller: publishedUrl,
                  validate: normalInputValidate(context),
                ),
                // Row(
                //         children: [
                //           Expanded(
                //               child: DefaultInputField(
                //                   label: 'Publisher',
                //                   controller: publisher,
                //                   validate: yearBeforeCurrentValidate(context))),
                //           // if (!profileCubit.isCurrentlyPursuing) widthBox(7.w),
                //           // if (!profileCubit.isCurrentlyPursuing)
                //             Expanded(
                //               child: DefaultInputField(
                //                 label: 'Ending  year',
                //                 controller: endYearCont,
                //                 validate: profileCubit.isCurrentlyPursuing ? null : yearBeforeCurrentValidate(context),
                //               ),
                //             ),
                //         ],
                //       ),
                // heightBox(7.h),
                // Row(
                // children: [
                // Checkbox(
                // value: profileCubit.isCurrentlyPursuing,
                // onChanged: (val) {
                // logg('before: ' + profileCubit.isCurrentlyPursuing.toString());
                // logg(val.toString());
                // profileCubit.changeCurrentlyPursuingVal(val!);
                // logg('after: ' + profileCubit.isCurrentlyPursuing.toString());
                // }),
                // Expanded(child: Text('Currently working')),
                // ],
                // ),
                heightBox(7.h),
                DefaultInputField(
                  validate: normalInputValidate(context),
                  label: 'Date of published',
                  // labelWidget: Text(
                  //   'Date of birth',
                  //   style: mainStyle(context, 13, color: mainBlueColor),
                  // ),
                  controller: publishedDateCont,
                  readOnly: true,
                  onTap: () {
                    _selectDate();
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  suffixIcon: SvgPicture.asset('assets/svg/icons/calendar.svg'),
                ),
                heightBox(7.h),

                state is UpdatingDataState
                    ? DefaultLoaderColor()
                    : DefaultButton(
                        text: 'Save',
                        onClick: () {
                          if (_formKey.currentState!.validate()) {
                            logg('validate');
                            profileCubit
                                .savePublication(
                                    paperTitle: paperTitle.text,
                                    summary: summary.text,
                                    publisher: publisher.text,
                                    publishedUrl: publishedUrl.text,
                                    publishedDate: publishedDateCont.text,
                                    customId: customId,
                                    isUpdateNotAdd: isUpdateNotAdd)
                                .then((value) => MainCubit.get(context).getUserInfo().then((value) {
                                      Navigator.pop(context);
                                    }));
                          }
                        })
              ],
            ),
          );
        },
      ));
}

class CertificationsSection extends StatelessWidget {
  CertificationsSection({
    Key? key,
    this.certifications,
    this.inEditProfile = false,
  }) : super(key: key);
  List<Certificate>? certifications;

  final bool inEditProfile;

  @override
  Widget build(BuildContext context) {
    var profileCubit = ProfileCubit.get(context);

    return certifications == null
        ? SizedBox()
        : BlocConsumer<MainCubit, MainState>(
            listener: (context, state) {
              // TODO: implement listener
              certifications = MainCubit.get(context).userInfoModel!.data.user.moreData!.certifications;
            },
            builder: (context, state) {
              return DefaultShadowedContainer(
                childWidget: Padding(
                  padding: EdgeInsets.all(defaultHorizontalPadding),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ProfileSectionHeader(
                            svgLink: 'assets/svg/icons/profile/Certifications.svg',
                            title: 'Certifications',
                          ),
                          if (inEditProfile)
                            ProfileSectionActions(addAction: () {
                              var _formKey = GlobalKey<FormState>();
                              TextEditingController nameOfUnCertificateCont = TextEditingController();
                              TextEditingController issuingDateCont = TextEditingController();

                              DateTime publishedDate = DateTime.now();
                              viewCertificationsModalAddUpdateBottom(context, _formKey, nameOfUnCertificateCont,
                                  issuingDateCont, profileCubit, publishedDate, false);

                              // showMyBottomSheet(
                              //     context: context,
                              //     title: certifications!.isEmpty ? 'Add Certificate' : 'Edit Certificate',
                              //     body: BlocConsumer<ProfileCubit, ProfileState>(
                              //       listener: (context, state) {
                              //         // TODO: implement listener
                              //       },
                              //       builder: (context, state) {
                              //         DateTime? pickedDate;
                              //         Future _selectDate() async {
                              //           pickedDate = await showDatePicker(
                              //               context: context,
                              //               initialDate: new DateTime.now(),
                              //               firstDate: new DateTime(2020),
                              //               lastDate: new DateTime(2030));
                              //           if (pickedDate != null)
                              //             issuingDateCont.text = getFormattedDateOnlyDate(pickedDate!).toString();
                              //         }
                              //
                              //         return Form(
                              //           key: _formKey,
                              //           child: Column(
                              //             children: [
                              //               DefaultInputField(
                              //                 label: 'Name of certificate',
                              //                 controller: nameOfUnCertificateCont,
                              //                 validate: normalInputValidate(context),
                              //               ),
                              //               heightBox(7.h),
                              //               DefaultInputField(
                              //                 validate: normalInputValidate(context),
                              //                 label: 'Date of published',
                              //                 // labelWidget: Text(
                              //                 //   'Date of birth',
                              //                 //   style: mainStyle(context, 13, color: mainBlueColor),
                              //                 // ),
                              //                 controller: issuingDateCont,
                              //                 readOnly: true,
                              //                 onTap: () {
                              //                   _selectDate();
                              //                   FocusScope.of(context).requestFocus(new FocusNode());
                              //                 },
                              //                 suffixIcon: SvgPicture.asset('assets/svg/icons/calendar.svg'),
                              //               ),
                              //               // DefaultInputField(
                              //               //   label: 'Date of issuing',
                              //               //   controller: issuingDateCont,
                              //               //   validate: normalInputValidate(context),
                              //               // ),
                              //               // heightBox(7.h),
                              //               // Row(
                              //               //   children: [
                              //               //     Expanded(
                              //               //         child: DefaultInputField(
                              //               //             label: 'Starting year',
                              //               //             controller: startYearCont,
                              //               //             validate: yearBeforeCurrentValidate(context))),
                              //               //     if (!profileCubit.isCurrentlyPursuing) widthBox(7.w),
                              //               //     if (!profileCubit.isCurrentlyPursuing)
                              //               //       Expanded(
                              //               //         child: DefaultInputField(
                              //               //           label: 'Ending  year',
                              //               //           controller: endYearCont,
                              //               //           validate: profileCubit.isCurrentlyPursuing
                              //               //               ? null
                              //               //               : yearBeforeCurrentValidate(context),
                              //               //         ),
                              //               //       ),
                              //               //   ],
                              //               // ),
                              //               // heightBox(7.h),
                              //               // Row(
                              //               //   children: [
                              //               //     Checkbox(
                              //               //         value: profileCubit.isCurrentlyPursuing,
                              //               //         onChanged: (val) {
                              //               //           logg('before: ' + profileCubit.isCurrentlyPursuing.toString());
                              //               //           logg(val.toString());
                              //               //           profileCubit.changeCurrentlyPursuingVal(val!);
                              //               //           logg('after: ' + profileCubit.isCurrentlyPursuing.toString());
                              //               //         }),
                              //               //     Expanded(child: Text('Currently pursuing')),
                              //               //   ],
                              //               // ),
                              //               heightBox(7.h),
                              //               state is UpdatingDataState
                              //                   ? DefaultLoaderColor()
                              //                   : DefaultButton(
                              //                       text: 'Save',
                              //                       onClick: () {
                              //                         if (_formKey.currentState!.validate()) {
                              //                           logg('validate');
                              //                           profileCubit.saveCertificate(
                              //                             name: nameOfUnCertificateCont.text,
                              //                             issueDate: issuingDateCont.text,
                              //                           );
                              //                         }
                              //                       })
                              //             ],
                              //           ),
                              //         );
                              //       },
                              //     ));
                            })
                        ],
                      ),
                      heightBox(8.h),
                      certifications!.isEmpty
                          ? SizedBox()
                          : Column(
                              children: [
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) => ProfileSubHeadItem(
                                    title: certifications![index].certificateName,
                                    svgPicture: 'assets/svg/icons/profile/Certifications-1.svg',
                                    subTitle: certifications![index].issueDate.year.toString(),
                                    actionWidget: Row(
                                      children: [               if(inEditProfile)
                                        GestureDetector(
                                          onTap: () {
                                            var _formKey = GlobalKey<FormState>();
                                            TextEditingController nameOfUnCertificateCont = TextEditingController();
                                            TextEditingController issuingDateCont = TextEditingController();
                                            DateTime publishedDate = DateTime.now();
                                            nameOfUnCertificateCont.text = certifications![index].certificateName;
                                            issuingDateCont.text = certifications![index].issueDate.toString();
                                            viewCertificationsModalAddUpdateBottom(
                                                context,
                                                _formKey,
                                                nameOfUnCertificateCont,
                                                issuingDateCont,
                                                profileCubit,
                                                publishedDate,
                                                true,
                                                customId: certifications![index].id.toString());
                                          },
                                          child: SvgPicture.asset(
                                            'assets/svg/icons/edit.svg',
                                            width: 22.w,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  separatorBuilder: (_, i) => heightBox(10.h),
                                  itemCount: certifications!.length,
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}

Future<void> viewCertificationsModalAddUpdateBottom(
    BuildContext context,
    GlobalKey<FormState> _formKey,
    TextEditingController nameOfUnCertificateCont,
    TextEditingController issuingDateCont,
    // TextEditingController publisher,
    // TextEditingController publishedUrl,
    // TextEditingController publishedDateCont,
    ProfileCubit profileCubit,
    DateTime publishedDate,
    bool isUpdateNotAdd,
    {String? customId}) {
  return showMyBottomSheet(
      context: context,
      isDismissible: false,
      title: !isUpdateNotAdd ? 'Add Certificate' : 'Edit Certificate',
      titleActionWidget: customId == null
          ? null
          : GestureDetector(
              onTap: () {
                showMyAlertDialog(context, 'Confirm deletion',
                    alertDialogContent: Text('You are about deleting entry, Are you sure?'),
                    actions: [
                      BlocConsumer<ProfileCubit, ProfileState>(
                        listener: (context, state) {
                          // TODO: implement listener
                        },
                        builder: (context, state) {
                          return state is UpdatingDataState
                              ? DefaultLoaderColor()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('No')),
                                    TextButton(
                                        onPressed: () {
                                          profileCubit
                                              .removeCertificate(customId.toString())
                                              .then((value) => MainCubit.get(context).getUserInfo().then((value) {
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  }));
                                        },
                                        child: Text('Yes')),
                                  ],
                                );
                        },
                      )
                    ]);
              },
              child: SvgPicture.asset(
                'assets/svg/icons/remove.svg',
                width: 22.w,
              ),
            ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          DateTime? pickedDate;
          Future _selectDate() async {
            pickedDate = await showDatePicker(
                context: context,
                initialDate: new DateTime.now(),
                firstDate: new DateTime(2020),
                lastDate: new DateTime(2030));
            if (pickedDate != null) issuingDateCont.text = pickedDate!.toString();
          }

          return Form(
            key: _formKey,
            child: Column(
              children: [
                DefaultInputField(
                  label: 'Name of certificate',
                  controller: nameOfUnCertificateCont,
                  validate: normalInputValidate(context),
                ),
                heightBox(7.h),
                DefaultInputField(
                  validate: normalInputValidate(context),
                  label: 'Date of published',
                  // labelWidget: Text(
                  //   'Date of birth',
                  //   style: mainStyle(context, 13, color: mainBlueColor),
                  // ),
                  controller: issuingDateCont,
                  readOnly: true,
                  onTap: () {
                    _selectDate();
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  suffixIcon: SvgPicture.asset('assets/svg/icons/calendar.svg'),
                ),
                // DefaultInputField(
                //   label: 'Date of issuing',
                //   controller: issuingDateCont,
                //   validate: normalInputValidate(context),
                // ),
                // heightBox(7.h),
                // Row(
                //   children: [
                //     Expanded(
                //         child: DefaultInputField(
                //             label: 'Starting year',
                //             controller: startYearCont,
                //             validate: yearBeforeCurrentValidate(context))),
                //     if (!profileCubit.isCurrentlyPursuing) widthBox(7.w),
                //     if (!profileCubit.isCurrentlyPursuing)
                //       Expanded(
                //         child: DefaultInputField(
                //           label: 'Ending  year',
                //           controller: endYearCont,
                //           validate: profileCubit.isCurrentlyPursuing
                //               ? null
                //               : yearBeforeCurrentValidate(context),
                //         ),
                //       ),
                //   ],
                // ),
                // heightBox(7.h),
                // Row(
                //   children: [
                //     Checkbox(
                //         value: profileCubit.isCurrentlyPursuing,
                //         onChanged: (val) {
                //           logg('before: ' + profileCubit.isCurrentlyPursuing.toString());
                //           logg(val.toString());
                //           profileCubit.changeCurrentlyPursuingVal(val!);
                //           logg('after: ' + profileCubit.isCurrentlyPursuing.toString());
                //         }),
                //     Expanded(child: Text('Currently pursuing')),
                //   ],
                // ),
                heightBox(7.h),
                state is UpdatingDataState
                    ? DefaultLoaderColor()
                    : DefaultButton(
                        text: 'Save',
                        onClick: () {
                          if (_formKey.currentState!.validate()) {
                            logg('validate');
                            profileCubit
                                .saveCertificate(
                                    name: nameOfUnCertificateCont.text,
                                    issueDate: issuingDateCont.text,
                                    customId: customId,
                                    isUpdateNotAdd: isUpdateNotAdd)
                                .then((value) => MainCubit.get(context).getUserInfo().then((value) {
                                      Navigator.pop(context);
                                    }));
                          }
                        })
              ],
            ),
          );
        },
      ));
}

class OurProfileSection extends StatelessWidget {
  const OurProfileSection({
    Key? key,
    this.expertise,
    this.summary,
  }) : super(key: key);

  final String? expertise;
  final String? summary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (summary != null || expertise != null)
          MyTitle(
            title: 'Our profile',
          ),
        if (expertise != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SubTitle(
                  title: 'Our Expertise',
                ),
                heightBox(5.h),
                DescriptionText(title: expertise!),
              ],
            ),
          ),
        if (summary != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SubTitle(
                  title: 'Summary',
                ),
                heightBox(5.h),
                DescriptionText(title: summary!),
              ],
            ),
          ),
      ],
    );
  }
}

class MyTitle extends StatelessWidget {
  const MyTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: mainStyle(context, 14, isBold: true, color: newDarkGreyColor, textHeight: 1),
    );
  }
}

class SubTitle extends StatelessWidget {
  const SubTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: mainStyle(context, 14, weight: FontWeight.normal, textHeight: 1.5),
    );
  }
}

class DescriptionText extends StatelessWidget {
  const DescriptionText({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: mainStyle(context, 12, weight: FontWeight.normal, textHeight: 1.5),
    );
  }
}

class ProfileDynamicButton extends StatelessWidget {
  const ProfileDynamicButton({
    Key? key,
    required this.providerId,
    this.title,
    this.subtitle,
    this.type,
  }) : super(key: key);

  final String providerId;
  final String? title;
  final String? subtitle;
  final String? type;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        handleNavigate(context, type, providerId);
      },
      child: Container(
        width: double.maxFinite,
        height: 68.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x29000000),
              offset: Offset(3, 3),
              blurRadius: 3,
            ),
          ],
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color.fromRGBO(0, 129, 236, 1), Color.fromRGBO(0, 98, 179, 1)]),
        ),
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Container(
                height: 68.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [
                    Color.fromRGBO(68, 198, 160, 1),
                    Color.fromRGBO(44, 107, 209, 1),
                  ]),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      title ?? '',
                      textAlign: TextAlign.center,
                      style: mainStyle(context, 14, color: Colors.white, weight: FontWeight.w900, textHeight: 0.6),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      subtitle ?? '',
                      style: mainStyle(context, 10, color: Colors.white, weight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 5),
            Container(
                width: 0.1.sw,
                height: 67.h,
                decoration: BoxDecoration(),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    // size: 25.sp,
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void handleNavigate(BuildContext context, String? type, String? providerId) {
    logg('handling navigate type: $type');
    switch (type) {
      case 'professionals':
        navigateTo(context, ProviderProfessionalLayout(providerId: providerId!));

        /// do something
        break;
      case 'appointments':
        // logg('temppppppppppp because no appointment added');
        navigateTo(
            context,
            AppointmentFacilitiesResults(
              selectedProfessionalId: providerId!,
              searchKey: '',
              searchingBy: SearchingBy.search,
            ));

        /// do something
        break;
      case 'events':
        logg('temppppppppppp because no appointment added');
        // navigateTo(
        //     context, AppointmentFacilitiesResults(selectedProfessionalId: providerId!, searchKey: '', searchingBy: SearchingBy.search,));
        /// do something
        break;
      case 'courses':

        /// do something
        break;
      case 'marketplace':

        /// do something
        break;
      case 'e_services':

        /// do something
        break;
      case 'departments':

        /// do something
        break;
      case 'videos':

        /// do something
        break;
      case 'articles':

        /// do something
        break;
      case '':

        /// do something
        break;
      case 'join_our_team':

        /// do something
        break;

      default:
        logg('default case not handled');

        /// do something
        break;
    }
  }
}

class ProviderProfileMainActions extends StatelessWidget {
  const ProviderProfileMainActions({Key? key, required this.provider}) : super(key: key);

  final User provider;

  @override
  Widget build(BuildContext context) {
    List<Widget> itemActions = [
      ActionItem(
        title: 'Profile',
        customHeight: 58.sp,
        actionItemHead: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/svg/icons/profile/edit profile.svg',
              height: 26.sp,
              // color: mainBlueColor,
            ),
          ],
        ),
        onClick: () {

           navigateTo(
              context,
             ProviderProfileAsAGuest(user:provider));
        },
      ),
      ActionItem(
        title: 'FEEDS',
        customHeight: 58.sp,
        actionItemHead: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/svg/icons/feeds.svg',
              height: 26.sp,
              color: mainBlueColor,
            ),
          ],
        ),
        onClick: () {
          bool isMyFeed = false;
          var mainCubit = MainCubit.get(context);
          if (mainCubit.userInfoModel != null) {
            if (mainCubit.userInfoModel!.data.user.id == provider.id) {
              isMyFeed = true;
            }
          }
          return navigateTo(
              context,
              FeedsScreen(
                user: provider,
                providerId: provider.id.toString(),
                isMyFeeds: isMyFeed,
              ));
        },
      ),
      // const HorizontalSeparator(),
      ActionItem(
        title: 'DEALS',
        customHeight: 58.sp,
        actionItemHead: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/svg/icons/promotion.svg',
              color: mainBlueColor,
              height: 26.sp,
            ),
          ],
        ),
        onClick: () => logg('DEALS'),
      ),
      // const HorizontalSeparator(),
      // ActionItem(
      //     title: 'CHAT',
      //     customHeight: 58.sp,
      //     actionItemHead: Row(
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         SvgPicture.asset(
      //           'assets/svg/icons/messages.svg',
      //           color: mainBlueColor,
      //           height: 26.sp,
      //         ),
      //       ],
      //     ),)
      //     // onClick: () {
      //     //   logg('chat');
      //     //   getCachedToken() == null
      //     //       ? viewMessengerLoginAlertDialog(context)
      //     //       : navigateTo(
      //     //           context,
      //     //           ChatLayout(
      //     //             user: provider,
      //     //           ));
      //     // }),
      // // const HorizontalSeparator(),
      // ,
      ActionItem(
        title: 'Video call',
        customHeight: 58.sp,
        actionItemHead: SvgPicture.asset(
          'assets/svg/icons/video camera 24.svg',
          height: 26.sp,
          // color: mainBlueColor,
        ),
        onClick: () => logg('SUPPORT GROUPS'),
      ),
    ];
    return DefaultShadowedContainer(
      childWidget: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: itemActions.map((e) => Expanded(child: e)).toList(),
      ),
    );
  }
}

class ProfileSubHeadItem extends StatelessWidget {
  const ProfileSubHeadItem({
    Key? key,
    required this.title,
    required this.subTitle,
    this.subSubTitle,
    this.svgPicture,
    this.actionWidget,
  }) : super(key: key);

  final String title;

  final String subTitle;
  final String? subSubTitle;
  final String? svgPicture;
  final Widget? actionWidget;

  @override
  Widget build(BuildContext context) {
    return DefaultShadowedContainer(
      childWidget: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          children: [
            if (svgPicture != null)
              SvgPicture.asset(
                svgPicture!,
                width: 35.w,
              ),
            if (svgPicture != null) widthBox(11.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: mainStyle(context, 13, color: newDarkGreyColor, isBold: true),
                  ),
                  heightBox(5.h),
                  Text(
                    subTitle,
                    style: mainStyle(context, 12, color: newDarkGreyColor, weight: FontWeight.w700),
                  ),
                  if (subSubTitle != null) heightBox(8.h),
                  if (subSubTitle != null)
                    Text(
                      subSubTitle!,
                      style: mainStyle(context, 12, color: newDarkGreyColor, weight: FontWeight.w700),
                    ),
                ],
              ),
            ),
            if (actionWidget != null) actionWidget!,
          ],
        ),
      ),
    );
  }
}

// class ExperienceSubHeadItem extends StatelessWidget {
//   const ExperienceSubHeadItem({Key? key, required this.experience}) : super(key: key);
//
//   final Experience experience;
//
//   @override
//   Widget build(BuildContext context) {
//     var profileCubit=ProfileCubit.get(context);
//     return ,;
//   }
// }

class PublicationSubHeadItem extends StatelessWidget {
  const PublicationSubHeadItem({Key? key, required this.publication, required this.actionWidget}) : super(key: key);

  final Publication publication;
  final Widget actionWidget;

  @override
  Widget build(BuildContext context) {
    return DefaultShadowedContainer(
      childWidget: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/svg/icons/profile/Publications-1.svg',
                width: 35.w,
              ),
              widthBox(11.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      publication.paperTitle,
                      style: mainStyle(context, 13, color: newDarkGreyColor, isBold: true),
                    ),
                    heightBox(5.h),
                    Text(
                      publication.summary,
                      style: mainStyle(
                        context,
                        11,
                        color: newDarkGreyColor,
                        weight: FontWeight.w700,
                      ),
                    ),
                    heightBox(5.h),
                    Text(
                      publication.publisher,
                      style: mainStyle(
                        context,
                        11,
                        color: newDarkGreyColor,
                      ),
                    ),
                    heightBox(5.h),
                    Text(
                      '${publication.publishedDate.year.toString()}',
                      style: mainStyle(
                        context,
                        11,
                        color: newDarkGreyColor,
                      ),
                    ),
                    heightBox(5.h),
                    GestureDetector(
                      onTap: () async {
                        if (!await launchUrl(Uri.parse(publication.publishedUrl))) {
                          throw 'Could not launch ${publication.publishedUrl}';
                        }
                      },
                      child: Text(
                        publication.publishedUrl,
                        style: mainStyle(context, 11, decoration: TextDecoration.underline, color: mainBlueColor),
                      ),
                    ),
                  ],
                ),
              ),
              actionWidget
            ],
          )),
    );
  }
}

class ProfileSectionHeader extends StatelessWidget {
  const ProfileSectionHeader({
    Key? key,
    required this.title,
    required this.svgLink,
  }) : super(key: key);

  final String title;
  final String svgLink;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (svgLink.isNotEmpty)
              SvgPicture.asset(
                svgLink,
                width: 28.w,
              ),
            widthBox(5.w),
            MyTitle(
              title: title,
            ),
          ],
        ),
      ],
    );
  }
}
