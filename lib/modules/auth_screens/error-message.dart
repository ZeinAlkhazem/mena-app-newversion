// import 'package:flutter/material.dart';
//
//
// class ErrorPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey, // Gray background
//       body: Center(
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             // Gray background container
//             Container(
//               width: double.infinity,
//               height: double.infinity,
//               color: Color(0xff999B9D),
//             ),
//             // Dialog with title "Error"
//             Dialog(
//               elevation: 5.0,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20.0),
//               ),
//               child: Container(
//                 color: Colors.white,
//                 width: 50.0, // Adjust the width as needed
//                 padding: EdgeInsets.all(16.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       'Error',
//                       style: TextStyle(
//                           fontSize: 22.0,
//                           fontWeight: FontWeight.w600,
//                           fontFamily: 'PNfont',
//                           color: Color(0xff152026)),
//                     ),
//                     SizedBox(height: 16.0),
//                     Text(
//                       'This link is no longer valid. Please request a new one',
//                       style: TextStyle(
//                           fontSize: 13.0,
//                           fontWeight: FontWeight.w500,
//                           fontFamily: 'PNfont',
//                           color: Color(0xff999B9D)),
//                       textAlign: TextAlign.center,
//                     ),
//                     SizedBox(height: 16.0),
//                     Divider(),
//                     ElevatedButton(
//                       style: ButtonStyle(
//                       ),
//                       onPressed: () {
//                         // Close the dialog or navigate away
//                         Navigator.pop(context);
//                       },
//                       child: Text('Close',
//                       style: TextStyle(
//                           fontSize: 13.0,
//                           fontWeight: FontWeight.w500,
//                           fontFamily: 'PNfont',
//                           color: Color(0xff0077FF)),),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/functions/main_funcs.dart';


class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff999B9D), // Gray background
      body: Center(
        child: Container(
          width: 280.0, // Adjust the width as needed
          padding: EdgeInsets.only(left: 16.0,top: 8,bottom: 8, right: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(35.0), // Rounded corners
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              heightBox(20.h),
              Text(
                'Error',
                style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'PNfont',
                          color: Color(0xff152026)),
              ),
              heightBox(20.h),
              Text(
                'This link is no longer valid. Please request a new one',
                style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'PNfont',
                          color: Color(0xff999B9D)),
                textAlign: TextAlign.center,
              ),

              Divider(),
              TextButton(
                onPressed: () {
                  // Add your action here
                },
                child: Text('Close',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'PNfont',
                    color: Color(0xff0077FF)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
