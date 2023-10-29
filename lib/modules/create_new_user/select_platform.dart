import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mena/models/my_models/platform_model.dart';
import 'package:mena/models/my_models/user_type_info_model.dart';
import 'package:mena/modules/create_new_user/select_expertise.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/constants.dart';
import '../../core/functions/main_funcs.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import '../../models/api_model/config_model.dart';
import '../auth_screens/cubit/auth_cubit.dart';
import '../auth_screens/cubit/auth_state.dart';
import '../auth_screens/pick_user_type_layout.dart';
import '../auth_screens/sign_in_screen.dart';
import 'package:http/http.dart' as http;

class SelectPlatform extends StatefulWidget {
  final UserTypeInfoModel userTypeInfoModel;


  const SelectPlatform(
      {super.key, required this.userTypeInfoModel});

  @override
  State<SelectPlatform> createState() => _SelectPlatformState();
}

class _SelectPlatformState extends State<SelectPlatform> {
  final selectedPlatformController = TextEditingController();
  RadioData? platformSelected;

  @override
  Widget build(BuildContext context) {
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
                      'Select Platform',
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
                      "Please choose the platform that best represents your primary affiliation or area of expertise. Selecting the right platform ensures access to features and content relevant to your industry and facilitates account acceptance and authentication.",
                      style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'PNfont',
                          color: Color(0xff303840),
                          fontWeight: FontWeight.w500),
                    ),
                    heightBox(30.h),
                    DefaultInputField(
                      focusedBorderColor: Color(0xff0077FF),
                      unFocusedBorderColor: Color(0xffC9CBCD),
                      label: 'Select Platform',
                      controller: selectedPlatformController,
                      suffixIcon: IconButton(
                        icon: Transform.rotate(
                          angle: 3.141592, // 180 degrees in radians
                          child: SvgPicture.asset(
                            'assets/new_icons/new_menu.svg',
                            fit: BoxFit.contain,
                            width: 50.w,
                            height: 50.h,
                            color: Color(0xff999B9D),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlatformSelectionPage(),
                            ),
                          ).then((value) {
                            log("# selected platform  : $value");
                            RadioData data = value[0] as RadioData;
                            setState(() {
                              selectedPlatformController.text = data.name;
                              platformSelected = data;
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
                    DefaultButton(
                        text: "Next",
                        onClick: () {
                          navigateTo(
                              context,
                              SelectExpertise(
                                selectedPlatform: platformSelected!,
                                selectedUserTyp: widget.userTypeInfoModel,
                              ));
                        }),
                    heightBox(380.h),
                    Padding(
                      padding: const EdgeInsets.only(left: 80.0),
                      child: TextButton(
                        onPressed: () {
                          navigateTo(context, SignInScreen());
                        },
                        child: Text(
                          textAlign: TextAlign.start,
                          "Already have an account?",
                          style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'PNfont',
                              color: Color(0xff0077FF),
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                    )
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

class PlatformSelectionPage extends StatefulWidget {
  const PlatformSelectionPage({Key? key}) : super(key: key);

  @override
  _PlatformSelectionPageState createState() => _PlatformSelectionPageState();
}

class _PlatformSelectionPageState extends State<PlatformSelectionPage> {
  bool isLoading = false;
  List<PlatformModel> platformList = [];

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
        Uri.parse('https://menaaii.com/api/v1/platformsList'),
      );
      log("# response : ${response.body}");
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> platformsData = responseData['data'];

        setState(() {
          platformList = platformsData.map((data) {
            return PlatformModel.fromJson(data);
          }).toList();
        });
      }
    } catch (error) {
      // Handle errors, e.g., show a snackbar or an error message
      print("Error fetching platform data : $error");
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
                        "Platform",
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
                            width: 70.w,
                            height: 70.h,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                isLoading
                    ? SizedBox(height: 500, child: const DefaultLoaderGrey())
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
                                        icon: SvgPicture.asset(
                                          "assets/close.svg",
                                          width: 40.w,
                                          height: 40.h,
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
                                        "Select platform",
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
                                  child: RadioGroup1(),
                                  // Row(
                                  //   // mainAxisAlignment: MainAxisAlignment.start,
                                  //   crossAxisAlignment: CrossAxisAlignment.start,
                                  //   children: [
                                  //     Text("English (US)",
                                  //       style: TextStyle(
                                  //           fontSize: 16.0,
                                  //           fontWeight: FontWeight.w600,
                                  //           fontFamily: 'PNfont',
                                  //           color: Color(0xff303840)),),
                                  //     widthBox(0.45.sw),
                                  //     Icon(Icons.circle_outlined, size: 18,)
                                  //   ],
                                  // ),
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
        Uri.parse('https://menaaii.com/api/v1/platformsList'),
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
        print("Error fetching platform data 2 : ${response.statusCode}");
      }
    } catch (error) {
      // Handle errors, e.g., show a snackbar or an error message
      print("Error fetching platform data 3 : $error");
    } finally {
      setState(() {
        isLoading = false; // Set loading state to false when done
      });
    }
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
                    _updateLanguage(selectedOption!, radioData.code);
                    Navigator.pop(context, [radioData]);
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

                          _updateLanguage(selectedOption!, radioData.code);
                          Navigator.pop(context, [radioData]);
                        });
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          );
  }

  Future<void> _updateLanguage(String selectedPlatform, String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedPlatform', selectedPlatform);
  }
}
