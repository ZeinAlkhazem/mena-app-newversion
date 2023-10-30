import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../responsive/responsive.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

var myScaffoldKey = GlobalKey<ScaffoldState>();

///agora
String appId = 'f422aaa81a81434d856d7824e49616a7';
String channelName = 'test';
String token =
    '007eJxTYHiw711elO45fmaDHZkpkzf7CW3SOOE0J3fTzTiFtsn7zt1UYEgzMTJKTEy0MAQiE2OTFAtTsxRzCyOTVBNLM0OzRHOj+beTGwIZGX68F2NlZIBAEJ+FoSS1uISBAQBr/yAk';
int uid = 0; //

///dimensions
double defaultRadiusVal = 7.r;
double defaultHorizontalPadding = 12.w;
double homeScreeHorizontalPadding = defaultHorizontalPadding / 5;

///
// double defaultVerticalPaddings = 15.h;
// double defaultAllSidesPadding = 15.sp;
///
///
double rainBowBarHeight = 3;

///
/// 3 pixels
///
///
///
String databaseName = 'mayya_db.db';

/// database name not used 'json_store.db' used by json store package
///

int databaseVersion = 1;

String databaseStoredJsonTableName = 'json_table';

double rainBowBarBottomPadding(BuildContext context) => 0;

double topScreenPadding = 1.h;

/// colors
Color blackColor = const Color.fromRGBO(0, 0, 0, 1);
Color alertRedColor = const Color(0xffE30000);
Color mainBlueColor = const Color(0xff2688EB);
Color secBlueColor = const Color(0xff1287DD);
Color nesWecBlueColor = const Color(0xff5d82d0);
Color mainGreenColor = const Color(0xff01BC62);
Color chatBlueColor = const Color(0xffcce4ff);
Color chatGreyColor = const Color(0xffeeedf1);
Color feedsWhiteColor = const Color(0xffffffff);
Color auxBlueColor = const Color(0xff8dcef8);
Color softBlueColor = const Color(0xffD4EEFF);
Color softGreyColor = const Color.fromRGBO(111, 111, 111, 1);
Color disabledGreyColor = const Color(0xffa9a9a9);
Color newLightGreyColor = const Color(0xffF2F3F5);
Color drawerColor = const Color(0xffdce0e5);
Color newDarkGreyColor = const Color(0xff818C99);
Color newLightTextGreyColor = const Color(0xff818C99);

/// shadow
List<BoxShadow>? mainBoxShadow = [
  const BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.30000001192092896),
    offset: Offset(0, 3),
    blurRadius: 5,
  ),
];

List<BoxShadow>? softBoxShadow = const [
  BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.30000001192092896), offset: Offset(0, 1), blurRadius: 3)
];

AppLocalizations getTranslatedStrings(BuildContext context) {
  return AppLocalizations.of(context)!;
}

String privacyAudienceTranslatedText(BuildContext context, String textInEnglish) {
  if (textInEnglish.toLowerCase() == 'everyone') {
    return getTranslatedStrings(context).everyOne;
  } else if (textInEnglish.toLowerCase() == 'providers') {
    return getTranslatedStrings(context).providers;
  } else if (textInEnglish.toLowerCase() == 'only me') {
    return getTranslatedStrings(context).onlyMe;
  }
  return textInEnglish;
}
