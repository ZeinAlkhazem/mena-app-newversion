import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/shared_widgets/mena_shared_widgets/custom_containers.dart';

import '../../core/constants/constants.dart';
import '../../core/functions/main_funcs.dart';
import '../../core/responsive/responsive.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import 'platform_jobs.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: rainBowBarBottomPadding(context)),
      child: Scaffold(
        // key: scaffoldKey,
        backgroundColor: Colors.white,
        // floatingActionButton: const SharedFloatingMsngr(
        //   heroTag: 'CommunityScreen',
        // ),
        drawerScrimColor: Colors.grey.withOpacity(0.2),
        body: MainBackground(
          bodyWidget: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: defaultHorizontalPadding,
                vertical: rainBowBarHeight, //rainbow height
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    heightBox(45),
                    const SplashVideoContainer(
                      videoLink: '',
                    ),
                    heightBox(10),
                    const Text('%Platform community'),
                    heightBox(5),
                    GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: Responsive.isMobile(context) ? 3 : 5,
                      // childAspectRatio: viewType == 'grid' ? ((SizeConfig.screenWidth!>=350)? 7/8:5/7) : 6 / 2,
                      childAspectRatio: 9.sp / 10.7.sp,
                      padding: const EdgeInsets.all(0),
                      shrinkWrap: true,
                      // physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 9.sp,
                      crossAxisSpacing: 10.sp,
                      children: List.generate(
                          9,
                          (index) => GestureDetector(
                                onTap: () {
                                  /// check type :
                                  /// CME                 ...done
                                  /// webinar             ...done
                                  /// video discussion    ...done
                                  /// platform talk       ...done
                                  /// Medical jobs        ...done
                                  ///
                                  ///
                                  /// Q and A,
                                  /// chat,
                                  /// research,
                                  ///
                                  ///

                                  /// clinical cases (? web view)
                                  ///
                                  ///
                                  // navigateToWithoutNavBar(context, CMELayout(),'');
                                  // navigateToWithoutNavBar(context,
                                  //     const PlatformWebinar(), '');
                                  // navigateToWithoutNavBar(context,
                                  //     const VideoDiscussion(), '');
                                  // navigateToWithoutNavBar(context,
                                  //     const DoctorsTalkLayout(), '');
                                  // navigateToWithoutNavBar(context,
                                  //     const PlatformTalkLayout(), '');
                                  navigateToWithoutNavBar(
                                      context, const PlatformJobsLayout(), '');
                                },
                                child: Container(
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.all(3.0.sp),
                                          child: const SmoothBorderContainer(
                                            thumbNail: '',
                                          ),
                                        ),
                                      ),
                                      heightBox(5.h),
                                      const Text('test 5454')
                                    ],
                                  ),
                                ),
                              ) //getProductObjectAsList
                          ),
                    ),
                    heightBox(10),
                    const Text('%Tools for professionals'),
                    heightBox(5),
                    SizedBox(
                      height: 135.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Expanded(
                                child: SmoothBorderContainer(
                                  thumbNail: '',
                                  cornerRadius: 15.sp,
                                  customWidth: 100.sp,
                                ),
                              ),
                              heightBox(5.h),
                              const Text('testcgh')
                            ],
                          ),
                        ),
                        separatorBuilder: (ctx, index) => widthBox(0.w),
                        itemCount: 9,
                      ),
                    ),
                    heightBox(10),
                    const Text('%Platform news'),
                    SmoothBorderContainer(
                      customWidth: double.maxFinite,
                      customHeight: 200.h,
                      cornerRadius: 10.sp,
                      thumbNail: '',
                    ),
                    heightBox(20),
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



//
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class MyMap extends StatefulWidget {
//   @override
//   _MyMapState createState() => _MyMapState();
// }
//
// class _MyMapState extends State<MyMap> {
//   late Future<Map<String, BitmapDescriptor>> _markerIconsFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _markerIconsFuture = loadMarkerIcons();
//   }
//
//   Future<Map<String, BitmapDescriptor>> loadMarkerIcons() async {
//     Map<String, String> markerIconUrls = {
//       'marker1': 'https://www.example.com/marker1.png',
//       'marker2': 'https://www.example.com/marker2.png',
//       // Add additional marker icons and their URLs here
//     };
//
//     Map<String, BitmapDescriptor> markerIcons = {};
//
//     for (String markerId in markerIconUrls.keys) {
//       String markerIconUrl = markerIconUrls[markerId];
//       Uint8List markerIconImageBytes = await loadMarkerIconImageFromNetwork(markerIconUrl);
//       BitmapDescriptor markerIcon = BitmapDescriptor.fromBytes(markerIconImageBytes);
//       markerIcons[markerId] = markerIcon;
//     }
//
//     return markerIcons;
//   }
//
//   Future<Uint8List> loadMarkerIconImageFromNetwork(String url) async {
//     final response = await http.get(Uri.parse(url));
//     final bytes = response.bodyBytes;
//     return bytes.buffer.asUint8List();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<Map<String, BitmapDescriptor>>(
//         future: _markerIconsFuture,
//         builder: (BuildContext context, AsyncSnapshot<Map<String, BitmapDescriptor>> snapshot) {
//       if (snapshot.hasData) {
//         return GoogleMap(
//           initialCameraPosition: CameraPosition(
//             target: LatLng(37.4219999, -122.0840575),
//             zoom: 15,
//           ),
//           markers: {
//             Marker(
//               markerId: MarkerId('marker1'),
//               position: LatLng(37.4219999, -122.0840575),
//               icon: snapshot.data['marker1'].copyWith(
//                 size: Size(50, 50), // Set the icon size
//                 // Set the custom marker shape using a transparent PNG image
//                 // with the same size as the marker
//                 assetName: 'assets/marker_shape.png',
//               ),
//             ),
//             Marker(
//               markerId: MarkerId('marker2'),
//               position: LatLng(37.4219999, -122.0840575),
//               icon: snapshot.data['marker2'].copyWith(
//                 size: Size(50, 50), // Set the icon size
//                 // Set the custom marker shape using a transparent PNG image
//                 // with the same size as the marker
//                 assetName: 'assets/marker_shape.png',
//               ),
//             ),
//             // Add additional markers here with their own custom icon
//           },
//         );
//       } else if (snapshot.hasError) {
//         return Center(child: Text('Error
