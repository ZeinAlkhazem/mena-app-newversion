import 'package:flutter/cupertino.dart';
import 'package:mena/core/constants/constants.dart';

import '../functions/main_funcs.dart';
bool hasError = false;
String? Function(String?)? emailValidate(BuildContext context) => (String? val) {
  if (val!.isEmpty) {
    return getTranslatedStrings(context).thisFieldIsRequired;
  } else if (val.contains('.') &&
      val.split('.').last.isNotEmpty &&
      val.contains('@') &&
      val.split('@')[1].isNotEmpty) {
    hasError = false;
    return null; // null is ok 'valid'
  } else {
    hasError = false;
    return getTranslatedStrings(context).invalidEmail;
  }
};
String? Function(String?)? passwordValidate(BuildContext context) {
  return (String? val) {
  if (val!.isEmpty) {
    hasError = true;
    return getTranslatedStrings(context).pleaseEnterPassword;
  } else
  if (val.length < 8) {
    hasError = true;
    return getTranslatedStrings(context).passwordShouldBeMoreThan8Characters;
  } else{
    hasError = false;
  return null;
  }
};
}
// String? Function(String?)? retypePasswordValidate(BuildContext context,String passwordEntered) {
//   return (String? val) {
//   if (val!.isEmpty) {
//     return 'Please reType Password';
//   }
//   if (val != passwordEntered) {
//     return 'password not match';
//   }
//   return null;
// };
// }


String? Function(String?)? normalInputValidate(BuildContext context,{String? customText}) {
  return  (String? val) {
    if (val!.isEmpty) {
      return customText??getTranslatedStrings(context).thisFieldIsRequired;
    }
    return null;
  };
}
String? Function(String?)? yearBeforeCurrentValidate(BuildContext context,{String? customText}) {
  return  (String? val) {
    if (val!.isEmpty) {
      return getTranslatedStrings(context).thisFieldIsRequired;
    }
    else if(!isNumeric(val)){
      return 'Enter a valid year';
    }
    else if((double.parse(val)<1000 || double.parse(val)>DateTime.now().year)){
      return 'Enter a valid year';
    }
    return null;
  }
  ;
}
String? Function(String?)? isNumberValidate(BuildContext context,{String? customText}) {
  return  (String? val) {
    if (val!.isEmpty) {
      return getTranslatedStrings(context).thisFieldIsRequired;
    }
    else if(!isNumeric(val)){
      return 'Enter a valid Number';
    }
    // else if((double.parse(val)<1000 || double.parse(val)>DateTime.now().year)){
    //   return 'Enter a valid year';
    // }
    return null;
  }
  ;
}
