// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:lottie/lottie.dart';
// import 'package:mena/core/functions/main_funcs.dart';
// import 'package:mena/core/main_cubit/main_cubit.dart';
// import 'package:mena/core/shared_widgets/shared_widgets.dart';
// import 'package:mena/l10n/l10n.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//
// import '../../core/constants/constants.dart';
// import 'initial_choose_country.dart';
//
// ///
// /// ghadeer mayya
// ///
// /// get languages and countries from config
// /// Select language and country and set location permission and send to db
// /// change first run cached value
//
// class InitialChooseLang extends StatelessWidget {
//   const InitialChooseLang({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     var mainCubit = MainCubit.get(context);
//     var localizationStrings = AppLocalizations.of(context);
//     return Scaffold(
//
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(56.0.h),
//         child: const DefaultOnlyLogoAppbar(
//           // title: 'Back',
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding ),
//         child: SafeArea(
//           child: BlocConsumer<MainCubit, MainState>(
//             listener: (context, state) {
//               // TODO: implement listener
//             },
//             builder: (context, state) {
//               return Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Center(
//                     child: Column(
//                       children: [
//                         Lottie.asset('assets/json/pick-language.json',height: 75.sp),
//                         heightBox(12.h),
//
//                         Text(
//                           'Select Application Language',
//                           style: mainStyle(context, 14, weight: FontWeight.w700),
//                         ),
//                         heightBox(12.h),
//                         Text(
//                           'Select app language now,\nchange later if needed from within."',
//                           textAlign: TextAlign.center,
//                           style: mainStyle(context, 13,
//                               color: newDarkGreyColor, weight: FontWeight.w700),
//                         ),
//                       ],
//                     ),
//                   ),
//                   heightBox(35.h),
//                   Expanded(
//                     flex: 4,
//                     child:
//                     mainCubit.configModel == null
//                         ? DefaultLoaderGrey()
//                         : ListView.separated(
//                             physics: const BouncingScrollPhysics(),
//                             padding: EdgeInsets.symmetric(horizontal: defaultHorizontalPadding*3),
//                             shrinkWrap: true,
//                             itemBuilder: (context, index) {
//                               logg('selectedLocalesInDashboard : ${mainCubit.selectedLocalesInDashboard}');
//                               return GestureDetector(
//                                 onTap: () {
//                                   logg('setting locale');
//                                   mainCubit.setLocale(
//                                       mainCubit.selectedLocalesInDashboard[index], context, false);
//                                 },
//                                 child: DefaultContainer(
//                                   height: 35.h,
//                                   radius: 5.sp,
//                                   borderColor: L10n.all[index].languageCode ==
//                                           mainCubit.appLocale!.languageCode
//                                       ? mainBlueColor
//                                       : softGreyColor.withOpacity(0.5),
//                                   childWidget: Center(
//                                     child: Text(
//                                       mainCubit.selectedLocalesInDashboard[index].languageCode == 'ar'
//                                           ? 'العربية'
//                                           : mainCubit.selectedLocalesInDashboard[index].languageCode == 'en'
//                                               ? 'English'
//                                               : mainCubit.selectedLocalesInDashboard[index].languageCode == 'hi'
//                                                   ? 'हिन्दी'
//                                                   : mainCubit.selectedLocalesInDashboard[index].languageCode ==
//                                                           'fil'
//                                                       ? 'Filipino'
//                                                       : mainCubit.selectedLocalesInDashboard[index]
//                                                                   .languageCode ==
//                                                               'ru'
//                                                           ? 'русский'
//                                                           : mainCubit.selectedLocalesInDashboard[index]
//                                                                       .languageCode ==
//                                                                   'zh'
//                                                               ? '中國人'
//                                                               : mainCubit.selectedLocalesInDashboard[index]
//                                                                           .languageCode ==
//                                                                       'tr'
//                                                                   ? 'Türkçe'
//                                                                   : mainCubit.selectedLocalesInDashboard[index]
//                                                                               .languageCode ==
//                                                                           'es'
//                                                                       ? 'española'
//                                                                       :mainCubit.selectedLocalesInDashboard[index]
//                                           .languageCode ==
//                                           'fr'
//                                           ? 'Français'
//                                           : 'ْunknown lang',
//                                       style: mainStyle(context, 13,
//                                           weight: FontWeight.w400,
//                                           fontFamily:
//                                           mainCubit.selectedLocalesInDashboard[index].languageCode == 'ar'
//                                                   ? 'Tajawal'
//                                                   : null),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                             separatorBuilder: (context, index) => SizedBox(
//                               height: 20.h,
//                             ),
//                             itemCount: mainCubit.selectedLocalesInDashboard.length,
//                           ),
//                   ),
//                   heightBox(35.h),
//                   SizedBox(
//                     child: Center(
//                       child: DefaultButton(
//                           text: localizationStrings!.next,
//                           onClick: () {
//                             navigateTo(context, const InitialChooseCountry());
//                           }),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mena/core/functions/main_funcs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/constants.dart';
import '../../models/api_model/config_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

class InitialChooseLang extends StatefulWidget {
  const InitialChooseLang({Key? key}) : super(key: key);
  static String routeName = 'signInScreen';

  @override
  State<InitialChooseLang> createState() => _InitialChooseLangState();
}

class _InitialChooseLangState extends State<InitialChooseLang> {
  bool showContainer = false;
  late double height, width;

  String selectedLanguage = "";

  void saveData(Map<String, dynamic> jsonData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String jsonString = json.encode(jsonData);

    await prefs.setString('myDataKey', jsonString);
  }

  Future<Map<String, dynamic>> loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('myDataKey');

    if (jsonString != null) {
      final jsonData = json.decode(jsonString);
      return jsonData;
    } else {
      // If data is not found, return an empty map or handle the absence of data accordingly.
      return {};
    }
  }


 void  getSelectedLanguage() async{
   final prefs = await SharedPreferences.getInstance();

   String lastLanguage  = prefs.getString(Keys.keyLanguage)??"";

   setState(() {
     selectedLanguage = lastLanguage;
   });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSelectedLanguage();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    getSelectedLanguage();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

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
                  // constraints: BoxConstraints(maxHeight: 0.7.sh),
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            // Toggle the state to show/hide the container
                            showContainer = !showContainer;
                          });
                        },
                        child: Text(
                          // "English (US)",
                            selectedLanguage,
                          style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'PNfont',
                              color: Color(0xff999B9D)),
                        ),
                      ),

                      heightBox(0.09.sh),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/test.png',
                            scale: 2,
                          ),
                        ],
                      ),
                      // heightBox(33.h),
                      // heightBox(22.h),
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 20),
                  margin: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10
                  ),
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
                        padding:
                            EdgeInsets.only(right: 25, top: 22, bottom: 22),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                              "   Select Your language",
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
                          padding:
                              EdgeInsets.only(left: 20, right: 20, top: 40,bottom: 40),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.white,
                          ),
                          child: RadioGroup()
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
          ),
        ),
      ),
    );
  }
}

class RadioGroup extends StatefulWidget {
  @override
  _RadioGroupState createState() => _RadioGroupState();
}

class _RadioGroupState extends State<RadioGroup> {
  String? selectedOption; // Stores the selected radio button value
  List<RadioData> radioDataList = []; // List to store data from the API

  bool isLoading = false;


  // Fetch data from the API
  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    final response =
        await http.get(Uri.parse('http://menaaii.com/api/v1/languages'));

    if (response.statusCode == 200) {

      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic>? languagesData = responseData['data']['languages'];


      if (languagesData != null) {
        setState(() {
          radioDataList =
              languagesData.map((data) => RadioData.fromJson(data)).toList();
        });
      } else {
        throw Exception('No "languages" data found in the API response');
      }
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load data from the API');
    }
  }

  void getLastLanguage() async{
    final prefs = await SharedPreferences.getInstance();

    String lastLanguage  = prefs.getString('selectedLanguage')??"";
    String currentLanguage =   Localizations.localeOf(context).languageCode;
    log("# current language : $currentLanguage");
    log("# last language : $lastLanguage");

    if(currentLanguage == "en"){
      currentLanguage = "English";
    }


    if(lastLanguage.isNotEmpty){
      setState(() {
        selectedOption = lastLanguage;
      });
    }else{
      setState(() {
        selectedOption = currentLanguage;
      });
    }

  }

  @override
  void initState() {
    super.initState();
    getLastLanguage();
    fetchData();// Fetch data when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Column(
            children: radioDataList.map((RadioData radioData) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedOption = radioData.name;
                    _updateLanguage(selectedOption!,radioData.code);
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
                          log("# selected language :$selectedOption");
                          _updateLanguage(selectedOption!,radioData.code);
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

  Future<void> _updateLanguage(String selectedLanguage,String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', selectedLanguage);
    setState(() {
      Locale(langCode,langCode.toUpperCase());
    });
  }
}


