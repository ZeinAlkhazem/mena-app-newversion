// import 'package:hive_flutter/hive_flutter.dart';
//
// import '../../../../models/api_model/register_model.dart';
// import '../../../../models/api_model/user_info_model.dart';
// import '../../../functions/main_funcs.dart';
// //
// // class UserInfoAdapter extends TypeAdapter<UserInfoModel> {
// //   @override
// //   final typeId = 0;
// //
// //   @override
// //   UserInfoModel read(BinaryReader reader) {
// //     return UserInfoModel=reader.read();
// //   }
// //
// //   @override
// //   void write(BinaryWriter writer, obj) {
// //     // TODO: implement write
// //   }
// // }
//
// class MyHiveService {
//   isExists({required String boxName}) async {
//     final openBox = await Hive.openBox(boxName);
//     int length = openBox.length;
//     return length != 0;
//   }
//
//   addBoxes<T>(List<T> items, String boxName) async {
//     logg("adding boxes");
//     final openBox = await Hive.openBox(boxName);
//
//     for (var item in items) {
//       openBox.add(item);
//     }
//   }
//
//   getBoxes<T>(String boxName) async {
//     List<T> boxList = <T>[];
//
//     final openBox = await Hive.openBox(boxName);
//
//     int length = openBox.length;
//
//     for (int i = 0; i < length; i++) {
//       boxList.add(openBox.getAt(i));
//     }
//
//     return boxList;
//   }
// }
//
//
