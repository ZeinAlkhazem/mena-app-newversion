import 'dart:async';

// import 'dart:ui' as ui;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart' as mapLauncher;

// import 'package:map_launcher/map_launcher.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/responsive/responsive.dart';
import 'package:mena/core/shared_widgets/mena_shared_widgets/custom_containers.dart';
import 'package:mena/core/shared_widgets/shared_widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

import '../../core/functions/main_funcs.dart';
import '../../models/api_model/home_section_model.dart';
import 'cubit/nearby_cubit.dart';

class ProviderLocationsLayout extends StatefulWidget {
  const ProviderLocationsLayout(
      {Key? key, required this.providersLocations, required this.initialSelectedNearbyProvider, required this.title})
      : super(key: key);

  final String title;
  final List<ProviderLocationModel> providersLocations;
  final ProviderLocationModel initialSelectedNearbyProvider;

  @override
  State<ProviderLocationsLayout> createState() => _ProviderLocationsLayoutState();
}

class _ProviderLocationsLayoutState extends State<ProviderLocationsLayout> {
  final Completer<GoogleMapController> googleMapControllerCompleter = Completer();

  // late GoogleMapController googleMapController;
  CarouselController carouselController = CarouselController();
  late CameraPosition initialPosition;

  // late Future<Map<String, BitmapDescriptor>> _markerIconsFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /// get marker icons from network
    // _markerIconsFuture = loadMarkerIcons();

    /// initial location (selected nearby)
    initialPosition = CameraPosition(
      target: LatLng(double.parse(widget.initialSelectedNearbyProvider.lat),
          double.parse(widget.initialSelectedNearbyProvider.lng)),
      zoom: 12.4746,
    );
    Future.delayed(const Duration(seconds: 1)).then((value) => carouselController.animateToPage(
        widget.providersLocations.indexOf(
          widget.providersLocations.firstWhere((element) => element == widget.initialSelectedNearbyProvider),
        ),
        duration: const Duration(milliseconds: 1000)));
    logg('selected marker: ${widget.initialSelectedNearbyProvider.id}');
    logg('nearby markers: ${widget.providersLocations.toString()}');
  }

  // Future<Uint8List> loadMarkerIconImageFromNetwork(String url) async {
  //   final response = await http.get(Uri.parse(url));
  //   final bytes = response.bodyBytes;
  //   return bytes.buffer.asUint8List();
  // }
  //
  //
  // ///
  // ///
  // ///
  // Future<Map<String, BitmapDescriptor>> loadMarkerIcons() async {
  //   Map<String, String> markerIconUrls = {
  //     'marker1': 'https://www.example.com/marker1.png',
  //     'marker2': 'https://www.example.com/marker2.png',
  //     // Add additional marker icons and their URLs here
  //   };
  //
  //   Map<String, BitmapDescriptor> markerIcons = {};
  //
  //   for (String markerId in markerIconUrls.keys) {
  //     String markerIconUrl = markerIconUrls[markerId];
  //     Uint8List markerIconImageBytes = await loadMarkerIconImageFromNetwork(markerIconUrl);
  //     BitmapDescriptor markerIcon = BitmapDescriptor.fromBytes(markerIconImageBytes);
  //     markerIcons[markerId] = markerIcon;
  //   }
  //
  //   return markerIcons;
  // }

  ///

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  ///
  ///
  @override
  Widget build(BuildContext context) {
    var nearbyCubit = NearbyCubit.get(context)..initialMarkers(widget.providersLocations);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: newDarkGreyColor.withOpacity(0.2),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20.sp),
          ),
        ),
        elevation: 0,
        centerTitle: false,
        leadingWidth: 44.w,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Row(
            children: [
              SizedBox(
                width: 7.w,
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Transform(
                  alignment: Alignment.center,
                  transform: getTranslatedStrings(context).currentLanguageDirection == 'ltr'
                      ? Matrix4.rotationY(0)
                      : Matrix4.rotationY(math.pi),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SvgPicture.asset(
                      'assets/svg/icons/back.svg',
                      width: 35.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: CircleAvatar(backgroundColor: Colors.white, child: SvgPicture.asset('assets/svg/icons/search.svg')),
          )
        ],
        title: Text(
          widget.title,
          style: mainStyle(context, 14, color: Colors.white, weight: FontWeight.w700),
        ),
      ),
      body: BlocConsumer<NearbyCubit, NearbyState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is CarouselControllerScrollTo) {
            logg('latch state scroll to in build then scroll');
            carouselController.animateToPage(
                widget.providersLocations
                    .indexOf(widget.providersLocations.firstWhere((element) => element.id == state.id)),
                duration: const Duration(milliseconds: 1000));
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              FutureBuilder<Map<String, BitmapDescriptor>>(
                future: nearbyCubit.markerIconsFuture,
                builder: (BuildContext context, AsyncSnapshot<Map<String, BitmapDescriptor>> snapshot) {
                  if (snapshot.hasData) {
                    return GoogleMap(
                      mapType: MapType.normal,

                      ///
                      markers: Set<Marker>.of(nearbyCubit.myMarkers),
                      myLocationButtonEnabled: false,
                      mapToolbarEnabled: true,
                      buildingsEnabled: true,
                      // onTap: (latLng) {
                      //   nearbyCubit.myMarkers.forEach((element) {if(element.position==latLng){
                      //   logg('its marker');
                      //   }else{
                      //     logg('not a marker');
                      //   }
                      //   });
                      //   },
                      initialCameraPosition: initialPosition,
                      onMapCreated: (GoogleMapController controller) {
                        googleMapControllerCompleter.complete(controller);

                        ///
                        ///
                      },

                      ///
                      ///
                      myLocationEnabled: true,
                      // on below line we have enabled compass
                      compassEnabled: true,
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
              Positioned(
                bottom: 50.h,
                right: 0,
                child: Container(
                  height: 170.h,
                  width: 1.sw,
                  child: CarouselSlider.builder(
                    itemCount: widget.providersLocations.length,
                    carouselController: carouselController,
                    itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) => GestureDetector(
                      onTap: () {
                        // _goCameraToPosition(
                        //     newPosition: LatLng(37.43296265331129, -122.08832357078792));
                      },
                      child: CustomMapInfoCard(
                        nearbyProvider: widget.providersLocations[itemIndex],
                        fn: () {
                          nearbyCubit.carouselScrollToElement(widget.providersLocations[itemIndex]);
                          _goToCameraPosition(
                              newPosition: LatLng(
                            double.parse(widget.providersLocations[itemIndex].lat),
                            double.parse(widget.providersLocations[itemIndex].lng),
                          ));
                        },
                      ),
                    ),
                    options: CarouselOptions(
                      autoPlay: false,
                      reverse: false,
                      enableInfiniteScroll: false,
                      enlargeCenterPage: true,
                      viewportFraction: Responsive.isMobile(context) ? 0.8 : 0.5,
                      aspectRatio: 2.0,
                      initialPage: 2,
                      scrollPhysics: ClampingScrollPhysics(),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _goToCameraPosition({required LatLng newPosition}) async {
    CameraPosition cameraPosition = CameraPosition(
        bearing: 0.0,

        /// north top 0.0
        target: newPosition,
        tilt: 33.440717697143555,

        /// 3d angle
        zoom: 15.751926040649414);
    final GoogleMapController controller = await googleMapControllerCompleter.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );
  }
}

class CustomMapInfoCard extends StatelessWidget {
  const CustomMapInfoCard({
    Key? key,
    required this.nearbyProvider,
    required this.fn,
  }) : super(key: key);

  final ProviderLocationModel nearbyProvider;
  final Function()? fn;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: fn,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: DefaultShadowedContainer(
                backColor: Colors.white,
                height: 135.h,
                width: 0.8.sw,
                radius: 30.sp,
                childWidget: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    heightBox(20.h),
                    Text(
                      nearbyProvider.name.toString(),
                      style: mainStyle(context, 13, color: newDarkGreyColor, weight: FontWeight.w700),
                      // +
                      // 'id ${nearbyProvider.id}'
                    ),
                    // heightBox(5.h),
                    // RichText(
                    //   text: TextSpan(
                    //     text: 'Call: ',
                    //     style: mainStyle(
                    //       context,
                    //       11.0,
                    //       textHeight: 1.5,
                    //     ),
                    //     children: <TextSpan>[
                    //       TextSpan(
                    //         text: nearbyProvider.phone,
                    //         style: mainStyle(context, 12.0, weight: FontWeight.w800, textHeight: 1.5),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    heightBox(5.h),
                    RichText(
                      text: TextSpan(
                        text: 'Distance: ',
                        style:
                            mainStyle(context, 11.0, textHeight: 1.5, color: newDarkGreyColor, weight: FontWeight.w700),
                        children: <TextSpan>[
                          TextSpan(
                            text: nearbyProvider.distance,
                            style: mainStyle(context, 12.0, weight: FontWeight.w800, textHeight: 1.5),
                          ),
                        ],
                      ),
                    ),
                    heightBox(10.h),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          Expanded(
                              child: DefaultButton(
                            text: 'Direction',
                            withoutPadding: true,
                            customChild: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.directions,
                                      color: Colors.white,
                                      size: 13.sp,
                                    ),
                                    widthBox(4.w),
                                    Text(
                                      'Directions',
                                      style: mainStyle(context, 12, weight: FontWeight.w700, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onClick: () async {
                              final availableMaps = await mapLauncher.MapLauncher.installedMaps;
                              logg(availableMaps
                                  .toString()); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]

                              showMyBottomSheet(
                                  context: context,
                                  title: 'Available Map apps',
                                  body: SafeArea(
                                    child: Column(
                                      children: availableMaps
                                          .map((e) => Row(
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                          e.icon,
                                                          height: 18.h,
                                                        ),
                                                        widthBox(7.w),
                                                        Text(e.mapName),
                                                      ],
                                                    ),
                                                  ),
                                                  DefaultButton(
                                                      text: 'Open',
                                                      titleColor: newDarkGreyColor,
                                                      radius: 33.sp,
                                                      backColor: Colors.white,
                                                      borderColor: newDarkGreyColor.withOpacity(0.5),
                                                      onClick: () async {
                                                        // if (await mapLauncher.MapLauncher.isMapAvailable(MapType.google)){
                                                        //
                                                        // };

                                                        // e.showDirections(destination: mapLauncher.Coords(double.parse(nearbyProvider.lat), double.parse(nearbyProvider.lng)));
                                                        e.showMarker(
                                                            coords: mapLauncher.Coords(double.parse(nearbyProvider.lat),
                                                                double.parse(nearbyProvider.lng)),
                                                            title: 'title');
                                                      })
                                                ],
                                              ))
                                          .toList(),
                                    ),
                                  ));
                              //
                              // MapsLauncher.launchCoordinates(double.parse(nearbyProvider.lat), double.parse(nearbyProvider.lng),);
                              // String googleUrl = 'https://www.google.com/maps/search/?api=1&query=${nearbyProvider.lat},${nearbyProvider.lng}';
                              //
                              //
                              // Uri uri = Uri.parse(googleUrl);
                              // logg(
                              //     'launch url: ${nearbyProvider.lat}');
                              // if (!await launchUrl(uri)) {
                              // throw 'Could not launch ${nearbyProvider.lat}';
                              // }
                            },
                            radius: 44.sp,
                          )),
                          widthBox(7.w),
                          DefaultButton(
                            text: 'Start',
                            withoutPadding: true,
                            backColor: Colors.white,
                            borderColor: newDarkGreyColor.withOpacity(0.6),
                            customChild: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 13.sp,
                                    color: mainBlueColor,
                                  ),
                                  widthBox(6.w),
                                  Text(
                                    'Start',
                                    style: mainStyle(context, 12, weight: FontWeight.w700, color: mainBlueColor),
                                  ),
                                ],
                              ),
                            ),
                            onClick: () async {
                              final availableMaps = await mapLauncher.MapLauncher.installedMaps;
                              logg(availableMaps
                                  .toString()); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]

                              showMyBottomSheet(
                                  context: context,
                                  title: 'Available Map apps',
                                  body: SafeArea(
                                    child: Column(
                                      children: availableMaps
                                          .map((e) => Row(
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                          e.icon,
                                                          height: 18.h,
                                                        ),
                                                        widthBox(7.w),
                                                        Text(e.mapName),
                                                      ],
                                                    ),
                                                  ),
                                                  DefaultButton(
                                                      text: 'Open',
                                                      titleColor: newDarkGreyColor,
                                                      radius: 33.sp,
                                                      backColor: Colors.white,
                                                      borderColor: newDarkGreyColor.withOpacity(0.5),
                                                      onClick: () async {
                                                        // if (await mapLauncher.MapLauncher.isMapAvailable(MapType.google)){
                                                        //
                                                        // };

                                                        e.showDirections(
                                                            destination: mapLauncher.Coords(
                                                                double.parse(nearbyProvider.lat),
                                                                double.parse(nearbyProvider.lng)));
                                                        // e.showMarker(coords: mapLauncher.Coords(double.parse(nearbyProvider.lat), double.parse(nearbyProvider.lng)), title: 'title');
                                                      })
                                                ],
                                              ))
                                          .toList(),
                                    ),
                                  ));
                              //
                              // MapsLauncher.launchCoordinates(double.parse(nearbyProvider.lat), double.parse(nearbyProvider.lng),);
                              // String googleUrl = 'https://www.google.com/maps/search/?api=1&query=${nearbyProvider.lat},${nearbyProvider.lng}';
                              //
                              //
                              // Uri uri = Uri.parse(googleUrl);
                              // logg(
                              //     'launch url: ${nearbyProvider.lat}');
                              // if (!await launchUrl(uri)) {
                              // throw 'Could not launch ${nearbyProvider.lat}';
                              // }
                            },
                            radius: 44.sp,
                          ),
                          widthBox(7.w),
                          DefaultButton(
                            text: 'Call',
                            withoutPadding: true,
                            backColor: Colors.white,
                            borderColor: newDarkGreyColor.withOpacity(0.6),
                            customChild: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
                              child: Row(
                                children: [
                                  SvgPicture.asset('assets/svg/icons/phone call.svg'),
                                  widthBox(6.w),
                                  Text(
                                    'Call',
                                    style: mainStyle(context, 12, weight: FontWeight.w700, color: mainBlueColor),
                                  ),
                                ],
                              ),
                            ),
                            onClick: () async {
                              Uri uri = Uri(scheme: 'tel', path: nearbyProvider.phone);
                              logg('launch url: ${nearbyProvider.phone}');
                              if (!await launchUrl(uri)) {
                                throw 'Could not launch ${nearbyProvider.phone}';
                              }
                            },
                            radius: 44.sp,
                          ),
                        ],
                      ),
                    )
                  ],
                )),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30.h,
                child: ProfileBubble(
                  isOnline: false,
                  pictureUrl: nearbyProvider.image,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// events nearby
class NearbyEventsLayout extends StatefulWidget {
  const NearbyEventsLayout({Key? key, required this.nearbyProviders, required this.initialSelectedNearbyProvider})
      : super(key: key);

  final List<EventsNearby> nearbyProviders;
  final EventsNearby initialSelectedNearbyProvider;

  @override
  State<NearbyEventsLayout> createState() => _NearbyEventsLayoutState();
}

class _NearbyEventsLayoutState extends State<NearbyEventsLayout> {
  final Completer<GoogleMapController> _controller = Completer();

  static CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  //list of markers
  late final Set<Marker> myMarkers = Set();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    /// initial location (selected nearby)
    _kGooglePlex = CameraPosition(
      target: LatLng(double.parse(widget.initialSelectedNearbyProvider.lat),
          double.parse(widget.initialSelectedNearbyProvider.lng)),
      zoom: 14.4746,
    );

    myMarkers.add(
      Marker(
        //add first marker
        markerId: const MarkerId('saj fg hb'),
        position: const LatLng(37.43296265331129, -122.08832357078792),
        //position of marker
        infoWindow: const InfoWindow(
          //popup info
          title: 'My Custom Title as sad ',
          snippet: 'My Custom Subtitle sd',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(23), //Icon for Marker
      ),
    );

    myMarkers.add(const Marker(
      //add second marker
      markerId: MarkerId('qw er ty qk wd mx nc'),
      zIndex: 20,
      position: LatLng(37.43296265331129, -122.09962357078792),
      //position of marker
      infoWindow: InfoWindow(
        //popup info
        title: 'My Custom Title ',
        snippet: 'My Custom Subtitle',
      ),
      icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: GoogleMap(
          mapType: MapType.normal,
          markers: myMarkers,
          // mapToolbarEnabled: false,
          // myLocationButtonEnabled: false,
          buildingsEnabled: true,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
