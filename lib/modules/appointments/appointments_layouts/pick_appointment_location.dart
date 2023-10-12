import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:mena/modules/appointments/appointments_layouts/pick_appointment_type.dart';

import '../../../core/shared_widgets/shared_widgets.dart';

class PickAppointmentLocation extends StatelessWidget {
  const PickAppointmentLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: const DefaultBackTitleAppBar(
          title: 'Book an appointment',
        ),
      ),
      body: SafeArea(
        child: PlacePicker(
          apiKey: "AIzaSyC9AEfwxO9TCxGzZgugExbTuW2xWzTqv_o",
          selectedPlaceWidgetBuilder:
              (context, result, state, isSearchBarFocused) {
            return Align(
              alignment: Alignment.bottomCenter,
              child:

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  state ==SearchingState.Searching?
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DefaultLoaderColor(

                    ),
                  ):
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: DefaultShadowedContainer(
                      borderColor: mainBlueColor,
                      childWidget:

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:result==null?SizedBox(): Text(

                          result.formattedAddress.toString(),textAlign: TextAlign.center,),
                      ),
                    ),
                  ),
                  state ==SearchingState.Searching?
                      SizedBox():
                  Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: DefaultButton(text: 'Next', onClick: (){

                      navigateToWithNavBar(context, PickAppointmentType(), '');
                      /// save picked location and navigate
                    }),
                  )
                ],
              ),
            );
          },

          /// onPlacePicked not working when we use selectedPlaceWidgetBuilder

          ///
          // onPlacePicked: (result) {
          //   print(result.url);
          //   Navigator.of(context).pop();
          // },
          initialPosition: LatLng(13, 13),
          useCurrentLocation: true,
          initialMapType: MapType.hybrid,
         automaticallyImplyAppBarLeading: false,
          resizeToAvoidBottomInset:
              true, // only works in page mode, less flickery, remove if wrong offsets
        ),
      ),
    );
  }
}
