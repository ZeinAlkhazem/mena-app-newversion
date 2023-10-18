import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/modules/create_new_user/select_expertise.dart';
import 'package:mena/modules/create_new_user/select_platform.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/functions/main_funcs.dart';
import '../../core/shared_widgets/shared_widgets.dart';
import '../../models/api_model/config_model.dart';
import '../../models/my_models/platform_model.dart';
import '../../models/my_models/user_type_info_model.dart';
import '../auth_screens/cubit/auth_cubit.dart';
import '../auth_screens/cubit/auth_state.dart';
import '../auth_screens/sign_in_screen.dart';
import 'package:http/http.dart' as http;

class CountryPage extends StatefulWidget {
  final UserTypeInfoModel userTypeInfoModel;

  const CountryPage({super.key, required this.userTypeInfoModel});

  @override
  State<CountryPage> createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  final selectedCountryController = TextEditingController();
  RadioData? countrySelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Image.asset(
            'assets/back.png', // Replace with your image path
            scale: 3,
            alignment: Alignment.centerRight, // Adjust the height as needed
          ),
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
                      'Select Country',
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
                      "Please choose your country.",
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
                      label: 'Select Country',
                      controller: selectedCountryController,
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.arrow_circle_down_rounded,
                          color: Color(0xff999B9D),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CountrySelectionPage(),
                            ),
                          ).then((value) {
                            log("# selected platform  : $value");
                            RadioData data = value[0] as RadioData;
                            setState(() {
                              selectedCountryController.text = data.name;
                              countrySelected = data;
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
                            SelectPlatform(
                              userTypeInfoModel: widget.userTypeInfoModel,
                              countryId: countrySelected!.id,
                            ),
                          );
                        }),
                    heightBox(420.h),
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

class CountrySelectionPage extends StatefulWidget {
  const CountrySelectionPage({super.key});

  @override
  State<CountrySelectionPage> createState() => _CountrySelectionPageState();
}

class _CountrySelectionPageState extends State<CountrySelectionPage> {
  bool isLoading = false;

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
                        "Country",
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
                            'assets/test.png',
                            scale: 2,
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
                                        "Select Country",
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
  List<RadioData> countryList = [];

  // Fetch data from the API
  Future<void> _fetchPlatformData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('http://menaaii.com/api/v1/countries'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> platformsData = responseData['data'];

        setState(() {
          countryList =
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
            children: countryList.map((RadioData radioData) {
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
                    Expanded(
                      child: Text(
                        radioData.name,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'PNfont',
                          color: Color(0xff303840),
                        ),
                      ),
                    ),
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

  Future<void> _updateLanguage(String selectedCountry, String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedCountry', selectedCountry);
  }
}
