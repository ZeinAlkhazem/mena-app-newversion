import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:custom_marker/marker_icon.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:meta/meta.dart';

import '../../../core/functions/main_funcs.dart';
import '../../../models/api_model/home_section_model.dart';

part 'nearby_state.dart';

class NearbyCubit extends Cubit<NearbyState> {
  NearbyCubit() : super(NearbyInitial());

  static NearbyCubit get(context) => BlocProvider.of(context);

  BitmapDescriptor? customIcon;
  late Iterable<Marker> myMarkers = {};

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  initialMapMarker() async {
    // await
    // BitmapDescriptor.fromAssetImage(
    //         ImageConfiguration(size: Size(2.sp, 2.sp),),
    //         'assets/svg/icons/marker.png',)
    final Uint8List markerIcon = await getBytesFromAsset('assets/svg/icons/marker.png', 66);
    customIcon = BitmapDescriptor.fromBytes(markerIcon);
    //     .then((d) {
    //   customIcon = d;
    //   logg('      customIcon = d;');
    //   // emit(MarkersReadyState());
    //
    //   // providersNearby.forEach((e) {
    //   //   // final Uint8List markIcons = await getImage('assets/svg/icons/marker.png', 100);
    //   //   logg('adding marker ${providersNearby.indexOf(e)}');
    //   //   myMarkers.add(Marker(
    //   //     markerId: MarkerId(e.id.toString()),
    //   //     position: LatLng(double.parse(e.lat), double.parse(e.lng)),
    //   //     infoWindow: InfoWindow(
    //   //       //popup info
    //   //         title: providersNearby.indexOf(e).toString(),
    //   //         snippet: e.distance,
    //   //         onTap: () {
    //   //           logg('move carousel to card clicked on info window');
    //   //         }),
    //   //     onTap: () {
    //   //       logg('move carousel to card clicked on marker');
    //   //     },
    //   //     // icon: BitmapDescriptor.defaultMarkerWithHue(23), //Icon for Marker
    //   //     icon: customIcon!, //Icon for Marker
    //   //   ));
    //   // });
    // });
  }

// make sure to initialize before map loading
  ///
  ///

  Future<ui.Image> loadImage(Uint8List img) async {
    final Completer<ui.Image> completer = new Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      // isImageloaded = true;
      return completer.complete(img);
    });
    return completer.future;
  }

  // Future<Uint8List> loadMarkerIconImageFromNetwork(String url) async {
  //   // int width=55;
  //   // int height=55;
  //   // final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  //   // final Canvas canvas = Canvas(pictureRecorder);
  //   //
  //   //
  //   // ///
  //   // final ByteData datai = await rootBundle.load(url);
  //   // var imaged = await loadImage(new Uint8List.view(datai.buffer));
  //   // canvas.drawImageRect(
  //   //   imaged,
  //   //   Rect.fromLTRB(
  //   //       0.0, 0.0, imaged.width.toDouble(), imaged.height.toDouble()),
  //   //   Rect.fromLTRB(0.0, 0.0, width.toDouble(), height.toDouble()),
  //   //   new Paint(),
  //   // );
  //   //
  //   // final img = await pictureRecorder.endRecording().toImage(width, height);
  //   // final data = await img.toByteData(format: ui.ImageByteFormat.png);
  //   // return data!.buffer.asUint8List();
  //   ///
  //   final response = await http.get(Uri.parse(url));
  //   final bytes = response.bodyBytes;
  //
  //   ui.Codec codec = await ui.instantiateImageCodec(
  //     bytes.buffer.asUint8List(),
  //     targetWidth: 66,
  //   );
  //   ui.FrameInfo fi = await codec.getNextFrame();
  //
  //   // return bytes.buffer.asUint8List();
  //   return (await fi.image.toByteData(
  //     format: ui.ImageByteFormat.png,
  //   ))!
  //       .buffer
  //       .asUint8List();
  // }

  ///
  ///
  ///
  Future<Map<String, BitmapDescriptor>> loadMarkerIcons({required Map<String, String> markerIconUrls}) async {


    Map<String, BitmapDescriptor> markerIcons = {};

    for (String markerId in markerIconUrls.keys) {
      String? markerIconUrl = markerIconUrls[markerId];
      // Uint8List markerIconImageBytes = await loadMarkerIconImageFromNetwork(markerIconUrl!);
      // // BitmapDescriptor markerIcon = BitmapDescriptor.fromBytes(markerIconImageBytes);
      // BitmapDescriptor markerIcon =

      BitmapDescriptor markerIcon=   await MarkerIcon.downloadResizePictureCircle(markerIconUrl!,
          size: 120,
          addBorder: true,
          borderColor: mainBlueColor,
          borderSize: 10)
      ;
      // BitmapDescriptor.fromBytes(markerIconImageBytes);


      markerIcons[markerId] = markerIcon;
    }

    return markerIcons;
  }

  Future<Map<String, BitmapDescriptor>>? markerIconsFuture;

  ///
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
                // infoWindow: InfoWindow(
                //     //popup info
                //     // title: providersNearby.indexOf(e).toString(),
                //     title: e.id.toString(),
                //     snippet: e.name,
                //     onTap: () {
                //       logg('move carousel to card clicked on info window');
                //       logg('animating to ${myMarkers.length}');
                //     }),
                onTap: () async => await carouselScrollToElement(e),
                // icon: BitmapDescriptor.defaultMarkerWithHue(23), //Icon for Marker
                icon: markerIconsFutureData[e.id.toString()]!,
                // icon: await MarkerIcon.downloadResizePictureCircle(
                //    e.image,
                //     size: 150,
                //     addBorder: true,
                //     borderColor: Colors.white,
                //     borderSize: 15),
                // customIcon!, //Icon for Marker
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
    emit(MarkersReadyState());
  }

  carouselScrollToElement(ProviderLocationModel e) {
    logg('move carousel slider to');
    logg(e.id.toString());
    emit(CarouselControllerScrollTo(e.id));
  }
}
