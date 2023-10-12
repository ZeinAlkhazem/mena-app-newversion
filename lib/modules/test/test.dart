// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// class FloatingIsland extends StatefulWidget {
//   @override
//   _FloatingIslandState createState() => _FloatingIslandState();
// }
//
// class _FloatingIslandState extends State<FloatingIsland> {
//   bool _islandFloating = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: <Widget>[
//           AnimatedPositioned(
//             duration: Duration(seconds: 2),
//             bottom: _islandFloating ? 300 : 0,
//             child: Transform.scale(
//               scale: _islandFloating ? 1.5 : 1,
//               child: SvgPicture.asset(
//                 'assets/island.svg',
//                 height: 300,
//                 width: 300,
//               ),
//             ),
//           ),
//           Positioned(
//             top: 80,
//             left: 40,
//             child: Icon(
//               Icons.favorite,
//               color: Colors.red,
//               size: 30,
//             ),
//           ),
//           Positioned(
//             top: 80,
//             right: 40,
//             child: Icon(
//               Icons.star,
//               color: Colors.yellow,
//               size: 30,
//             ),
//           ),
//           Positioned(
//             top: 240,
//             left: 120,
//             child: Text(
//               'Flutter Island',
//               style: TextStyle(
//                 color: Colors.grey[800],
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           Positioned(
//             top: 270,
//             left: 135,
//             child: Text(
//               'Created with Flutter',
//               style: TextStyle(
//                 color: Colors.grey[800],
//                 fontSize: 16,
//               ),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           setState(() {
//             _islandFloating = !_islandFloating;
//           });
//         },
//         child: Icon(Icons.arrow_upward),
//       ),
//     );
//   }
// }
