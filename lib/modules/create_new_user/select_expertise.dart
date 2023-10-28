import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mena/core/network/network_constants.dart';
import 'package:mena/models/api_model/register_model.dart';
import 'package:mena/models/my_models/user_type_info_model.dart';
import 'package:mena/modules/create_new_user/your_name.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/constants.dart';
import '../../core/functions/main_funcs.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import '../../models/api_model/config_model.dart';
import '../../models/my_models/create_user_model.dart';
import '../auth_screens/cubit/auth_cubit.dart';
import '../auth_screens/cubit/auth_state.dart';

class SelectExpertise extends StatefulWidget {
  final RadioData selectedPlatform;
  final UserTypeInfoModel selectedUserTyp;

  const SelectExpertise(
      {super.key,
      required this.selectedPlatform,
      required this.selectedUserTyp});

  @override
  State<SelectExpertise> createState() => _SelectExpertiseState();
}

class _SelectExpertiseState extends State<SelectExpertise> {
  final cateController = TextEditingController();
  final subCateController = TextEditingController();
  final specialtyController = TextEditingController();

  RadioData? cateSelection;
  RadioData? subCateSelection;
  RadioData? specialtySelection;

  CreateUserModel? newUserModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log("# user type id :${widget.selectedUserTyp.id}");
    log("# platform id :${widget.selectedPlatform.id}");
  }

  @override
  Widget build(BuildContext context) {
    String categoriesUrl =
        '$baseUrl/categories/${widget.selectedUserTyp.id}/${widget.selectedPlatform.id}';
    ///api/v1/sub-categories/{id}
    log("# Main url :$categoriesUrl");
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0.h),
        child: const DefaultOnlyLogoAppbar1(
          withBack: true,
          // title: 'Back',
        ),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 25, top: 5, right: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    heightBox(15.h),
                    Text(
                      'Select Your Expertise',
                      style: TextStyle(
                        fontSize: 23.0,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'PNfont',
                        color: Color(0xff303840),
                      ),
                      // textAlign: TextAlign.center,
                    ),
                    heightBox(25.h),
                    Text(
                      textAlign: TextAlign.start,
                      "Choose your primary area of expertise to customize your experience. Start by selecting your main category, followed by a sub-category, and, if applicable, your specialty. This helps us tailor content and features to your User type",
                      style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'PNfont',
                          color: Color(0xff303840),
                          fontWeight: FontWeight.w500),
                    ),
                    heightBox(30.h),
                    DefaultInputField(
                      fillColor: Color(0xffF2F2F2),
                      focusedBorderColor: Color(0xff0077FF),
                      unFocusedBorderColor: Color(0xffC9CBCD),
                      label: 'Select Main Category',
                      controller: cateController,
                      suffixIcon: IconButton(
                        iconSize: 80,
                        icon: Transform.rotate(
                          angle: 3.141592, // 180 degrees in radians
                          child: SvgPicture.asset(
                            'assets/menue.svg',
                            fit: BoxFit.contain,
                            color: Color(0xff999B9D),
                            theme: SvgTheme(
                              // currentColor: Color(0xff999B9D),
                              fontSize: 13,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainSelectionPage(
                                  paramName: 'categories', url: categoriesUrl),
                            ),
                          ).then((value) {
                            RadioData cate = value[0] as RadioData;
                            setState(() {
                              cateController.text = cate.name;
                              cateSelection = value[0];
                            });
                          });
                        },
                      ),
                      labelTextStyle: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'PNfont',
                          color: Color(0xff999B9D)),
                    ),
                    heightBox(15.h),
                    DefaultInputField(
                      fillColor: Color(0xffF2F2F2),
                      focusedBorderColor: Color(0xff0077FF),
                      unFocusedBorderColor: Color(0xffC9CBCD),
                      label: 'Select Sub-Category',
                      controller: subCateController,
                      suffixIcon: IconButton(
                        iconSize: 80,
                        icon: Transform.rotate(
                          angle: 3.141592, // 180 degrees in radians
                          child: SvgPicture.asset(
                            'assets/menue.svg',
                            fit: BoxFit.contain,
                            color: Color(0xff999B9D),
                            theme: SvgTheme(
                              // currentColor: Color(0xff999B9D),
                              fontSize: 13,
                            ),
                          ),
                        ),
                        onPressed: () {
                          String subCateUrl =
                              '$baseUrl/getSubCategories/${cateSelection!.id}';
                          log("# sub cate url : $subCateUrl");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainSelectionPage(
                                  paramName: 'platformSubCategories',
                                  url: subCateUrl),
                            ),
                          ).then((value) {
                            RadioData cate = value[0] as RadioData;
                            setState(() {
                              subCateController.text = cate.name;
                              subCateSelection = value[0];
                            });
                          });
                        },
                      ),
                      labelTextStyle: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'PNfont',
                          color: Color(0xff999B9D)),
                    ),
                    heightBox(15.h),
                    DefaultInputField(
                      fillColor: Color(0xffF2F2F2),
                      focusedBorderColor: Color(0xff0077FF),
                      unFocusedBorderColor: Color(0xffC9CBCD),
                      label: 'Select Specialty',
                      controller: specialtyController,
                      suffixIcon: IconButton(
                        iconSize: 80,
                        icon: Transform.rotate(
                          angle: 3.141592, // 180 degrees in radians
                          child: SvgPicture.asset(
                            'assets/menue.svg',
                            fit: BoxFit.contain,
                            color: Color(0xff999B9D),
                            theme: SvgTheme(
                              // currentColor: Color(0xff999B9D),
                              fontSize: 13,
                            ),
                          ),
                        ),
                        onPressed: () {
                          String subCateUrl =
                              '$baseUrl/getSpecialty/${subCateSelection!.id}';
                          log("# sub cate url : $subCateUrl");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainSelectionPage(
                                  paramName: 'speciality', url: subCateUrl),
                            ),
                          ).then((value) {
                            RadioData cate = value[0] as RadioData;
                            setState(() {
                              specialtyController.text = cate.name;
                              specialtySelection = value[0];
                            });
                          });
                        },
                      ),
                      labelTextStyle: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'PNfont',
                          color: Color(0xff999B9D)),
                    ),
                    heightBox(300.h),
                    DefaultButton(
                        text: "Next",
                        onClick: () {
                          newUserModel = CreateUserModel(
                              platformId: widget.selectedPlatform.id,
                              specialitList: [specialtySelection!.id],
                              );
                          navigateTo(
                              context,
                              YourName(
                                userInfo: newUserModel!,
                              ));
                        }),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MainSelectionPage extends StatefulWidget {
  final String url;
  final String paramName;

  const MainSelectionPage(
      {super.key, required this.url, required this.paramName});

  @override
  State<MainSelectionPage> createState() => _MainSelectionPageState();
}

class _MainSelectionPageState extends State<MainSelectionPage> {
  bool isLoading = false;

  List<RadioData> expertiseList = [];
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    _fetchPlatformData();
  }

  Future<void> _fetchPlatformData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(widget.url),
      );
      log("# response : ${response.body}");
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> expertisesData =
            responseData['data'];

        setState(() {
          expertiseList =
              expertisesData.map((data) => RadioData.fromJson(data)).toList();
        });
      }
    } catch (error) {
      // Handle errors, e.g., show a snackbar or an error message
      print("Error fetching platform data: $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 18),
                  child: Column(
                    children: [
                      Text(
                        "Main Category",
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'PNfont',
                          color: Color(0xff999B9D),
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/menalogoblack.png',
                            scale: 2,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                isLoading
                    ? Center(child: const DefaultLoaderGrey())
                    : Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, top: 5, bottom: 20),
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Color(0xffF2F2F2),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: 50,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Color(0xff5B5C5E),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      right: 25, top: 22, bottom: 22),
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    // mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          weight: 22,
                                        ),
                                        color: Color(0xff303840),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),

                                      // Image.asset("assets/close.png",scale: 4,),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        "   Select Main Category",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w800,
                                            fontFamily: 'PNfont',
                                            color: Color(0xff303840)),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, top: 40, bottom: 40),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    children: expertiseList
                                        .map((RadioData radioData) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            Navigator.pop(context, [radioData]);
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                radioData.name,
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'PNfont',
                                                    color: Color(0xff303840)),
                                              ),
                                            ),
                                            // widthBox(0.50.sw),
                                            Radio(
                                              value: radioData.name,
                                              groupValue: selectedOption,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedOption =
                                                      value as String?;
                                                  log("# selected platform :$selectedOption");
                                                  Navigator.pop(
                                                      context, [radioData]);
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class SubSelectionPage extends StatefulWidget {
//   const SubSelectionPage({super.key});
//
//   @override
//   State<SubSelectionPage> createState() => _SubSelectionPageState();
// }
// class _SubSelectionPageState extends State<SubSelectionPage> {
//   bool isLoading = false;
//   List<Expertise> expertiseList = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchPlatformData();
//   }
//
//   Future<void> _fetchPlatformData() async {
//     setState(() {
//       isLoading = true;
//     });
//
//     try {
//       final response = await http.get(
//         Uri.parse('http://menaaii.com/api/v1/getSubCategories/{category_id}'),
//       );
//
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = json.decode(response.body);
//         final List<dynamic> expertisesData = responseData['data']['platforms'];
//
//         // setState(() {
//         //   expertiseList = expertisesData
//         //       .map((data) => Platform.fromJson(data))
//         //       .toList();
//         // });
//       }
//     } catch (error) {
//       // Handle errors, e.g., show a snackbar or an error message
//       print("Error fetching platform data: $error");
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       resizeToAvoidBottomInset: false,
//       body: SafeArea(
//         child: Container(
//           child: SingleChildScrollView(
//             physics: ClampingScrollPhysics(),
//             child: Column(
//               children: [
//                 Container(
//                   padding: EdgeInsets.only(top: 18),
//                   child: Column(
//                     children: [
//                       Text(
//                         "ٍSub Category",
//                         style: TextStyle(
//                           fontSize: 13.0,
//                           fontWeight: FontWeight.w500,
//                           fontFamily: 'PNfont',
//                           color: Color(0xff999B9D),
//                         ),
//                       ),
//                       SizedBox(height: 16),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Image.asset(
//                             'assets/test.png',
//                             scale: 2,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 isLoading
//                     ? Center(child: const DefaultLoaderGrey())
//                     : Column(
//                   children: [
//                     Container(
//                       padding:
//                       EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 20),
//                       margin: EdgeInsets.symmetric(
//                           horizontal: 10,
//                           vertical: 10
//                       ),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(25),
//                         color: Color(0xffF2F2F2),
//                       ),
//                       child: Column(
//                         children: [
//                           Container(
//                             alignment: Alignment.center,
//                             width: 50,
//                             height: 5,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(50),
//                               color: Color(0xff5B5C5E),
//                             ),
//                           ),
//                           Container(
//                             padding:
//                             EdgeInsets.only(right: 25, top: 22, bottom: 22),
//                             width: MediaQuery.of(context).size.width,
//                             child: Column(
//                               // mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 IconButton(
//                                   icon: Icon(
//                                     Icons.close,
//                                     weight: 22,
//                                   ),
//                                   color: Color(0xff303840),
//                                   onPressed: () {
//                                     Navigator.pop(context);
//                                   },
//                                 ),
//
//                                 // Image.asset("assets/close.png",scale: 4,),
//                                 SizedBox(
//                                   height: 8,
//                                 ),
//                                 Text(
//                                   "   Select Sub Category",
//                                   style: TextStyle(
//                                       fontSize: 20.0,
//                                       fontWeight: FontWeight.w800,
//                                       fontFamily: 'PNfont',
//                                       color: Color(0xff303840)),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Container(
//                             padding:
//                             EdgeInsets.only(left: 20, right: 20, top: 40,bottom: 40),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(25),
//                               color: Colors.white,
//                             ),
//                             child: RadioGroup1(),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
// class SpecialtySelectionPage extends StatefulWidget {
//   const SpecialtySelectionPage({super.key});
//
//   @override
//   State<SpecialtySelectionPage> createState() => _SpecialtySelectionPageState();
// }
// class _SpecialtySelectionPageState extends State<SpecialtySelectionPage> {
//   bool isLoading = false;
//   List<Expertise> expertiseList = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchPlatformData();
//   }
//
//   Future<void> _fetchPlatformData() async {
//     setState(() {
//       isLoading = true;
//     });
//
//     try {
//       final response = await http.get(
//         Uri.parse('http://menaaii.com/api/v1/getSpecialty/{subCategory_id}'),
//       );
//
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = json.decode(response.body);
//         final List<dynamic> expertisesData = responseData['data']['platforms'];
//
//         // setState(() {
//         //   expertiseList = expertisesData
//         //       .map((data) => Platform.fromJson(data))
//         //       .toList();
//         // });
//       }
//     } catch (error) {
//       // Handle errors, e.g., show a snackbar or an error message
//       print("Error fetching platform data: $error");
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       resizeToAvoidBottomInset: false,
//       body: SafeArea(
//         child: Container(
//           child: SingleChildScrollView(
//             physics: ClampingScrollPhysics(),
//             child: Column(
//               children: [
//                 Container(
//                   padding: EdgeInsets.only(top: 18),
//                   child: Column(
//                     children: [
//                       Text(
//                         "Specialty",
//                         style: TextStyle(
//                           fontSize: 13.0,
//                           fontWeight: FontWeight.w500,
//                           fontFamily: 'PNfont',
//                           color: Color(0xff999B9D),
//                         ),
//                       ),
//                       SizedBox(height: 16),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Image.asset(
//                             'assets/test.png',
//                             scale: 2,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 isLoading
//                     ? Center(child: const DefaultLoaderGrey())
//                     : Column(
//                   children: [
//                     Container(
//                       padding:
//                       EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 20),
//                       margin: EdgeInsets.symmetric(
//                           horizontal: 10,
//                           vertical: 10
//                       ),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(25),
//                         color: Color(0xffF2F2F2),
//                       ),
//                       child: Column(
//                         children: [
//                           Container(
//                             alignment: Alignment.center,
//                             width: 50,
//                             height: 5,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(50),
//                               color: Color(0xff5B5C5E),
//                             ),
//                           ),
//                           Container(
//                             padding:
//                             EdgeInsets.only(right: 25, top: 22, bottom: 22),
//                             width: MediaQuery.of(context).size.width,
//                             child: Column(
//                               // mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 IconButton(
//                                   icon: Icon(
//                                     Icons.close,
//                                     weight: 22,
//                                   ),
//                                   color: Color(0xff303840),
//                                   onPressed: () {
//                                     Navigator.pop(context);
//                                   },
//                                 ),
//
//                                 // Image.asset("assets/close.png",scale: 4,),
//                                 SizedBox(
//                                   height: 8,
//                                 ),
//                                 Text(
//                                   "   Select Specialty",
//                                   style: TextStyle(
//                                       fontSize: 20.0,
//                                       fontWeight: FontWeight.w800,
//                                       fontFamily: 'PNfont',
//                                       color: Color(0xff303840)),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Container(
//                             padding:
//                             EdgeInsets.only(left: 20, right: 20, top: 40,bottom: 40),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(25),
//                               color: Colors.white,
//                             ),
//                             child: RadioGroup1(),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class RadioGroup1 extends StatefulWidget {
  @override
  _RadioGroup1State createState() => _RadioGroup1State();
}

class _RadioGroup1State extends State<RadioGroup1> {
  String? selectedOption;
  bool isLoading = true;
  List<RadioData> platformList = [];

  // Fetch data from the API
  Future<void> _fetchPlatformData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
            'http://menaaii.com/api/v1/specialities/{subcatid}/{provider_types_id}'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> platformsData = responseData['data'];

        setState(() {
          platformList =
              platformsData.map((data) => RadioData.fromJson(data)).toList();
        });
      } else {
        // Handle errors, e.g., show a snackbar or an error message
        print("Error fetching platform data: ${response.statusCode}");
      }
    } catch (error) {
      // Handle errors, e.g., show a snackbar or an error message
      print("Error fetching platform data: $error");
    } finally {
      setState(() {
        isLoading = false; // Set loading state to false when done
      });
    }

    // try {
    //   final response = await http.get(
    //     Uri.parse('http://menaaii.com/api/v1/platformsList'),
    //   );
    //
    //   if (response.statusCode == 200) {
    //     final Map<String, dynamic> responseData = json.decode(response.body);
    //     final List<dynamic> platformsData = responseData['data']['platforms'];
    //
    //     setState(() {
    //       platformList = platformsData
    //           .map((data) => Platform.fromJson(data)).cast<RadioData>()
    //           .toList();
    //     });
    //   }
    // } catch (error) {
    //   // Handle errors, e.g., show a snackbar or an error message
    //   print("Error fetching platform data: $error");
    // } finally {
    //   setState(() {
    //     isLoading = false;
    //   });
    // }
  }

  @override
  void initState() {
    super.initState();
    _fetchPlatformData(); // Fetch data when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: const DefaultLoaderGrey())
        : Column(
            children: platformList.map((RadioData radioData) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedOption = radioData.name;
                    Navigator.pop(context);
                  });
                },
                child: Row(
                  children: [
                    Text(
                      radioData.name,
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'PNfont',
                          color: Color(0xff303840)),
                    ),
                    // widthBox(0.50.sw),
                    Spacer(
                      flex: 2,
                    ),
                    Radio(
                      value: radioData.name,
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value as String?;
                          log("# selected platform :$selectedOption");
                          Navigator.pop(context);
                        });
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          );
  }
}
