import 'package:flutter/cupertino.dart';
import 'package:mena/core/constants/constants.dart';

import '../../modules/auth_screens/sign_in_screen.dart';
import '../dialogs/dialogs_page.dart';
import '../functions/main_funcs.dart';
bool hasError = false;
String? Function(String?)? emailValidate(BuildContext context) => (String? val) {
  if (val!.isEmpty) {
    hasError = true;
    // logInAlertDialog(context); // Call the logInAlertDialog if the email field is empty
    return 'Account not found. please Check your username, mobile or email and try again';
  } else if (val.contains('.') &&
      val.split('.').last.isNotEmpty &&
      val.contains('@') &&
      val.split('@')[1].isNotEmpty) {
    return null; // null is ok 'valid'
  } else {
    return 'Account not found. please Check your username, mobile or email and try again';
  }
};

String? Function(String?)? passwordValidate(BuildContext context) {
  return (String? val) {
    if (val!.isEmpty) {
      hasError = true;
      // logInAlertDialog(context); // Call the logInAlertDialog if the password field is empty
      return "Invalid password";
    }
    if (val.length < 8) {
      hasError = true;
      return "Invalid password";
    }
    return null;
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

String? normalInputValidate(String? fieldContent) {
  if (fieldContent == null || fieldContent.isEmpty) {
    return "Check your username, mobile or email address  and try again";
  }
  return null;
}

// String? Function(String?)? normalInputValidate(BuildContext context,{String? customText}) {
//   return  (String? val) {
//     if (val!.isEmpty) {
//       hasError =true;
//       return "Check your username, mobile or email address  and try again";
//     }
//     return null;
//   };
// }
String? Function(String?)? yearBeforeCurrentValidate(BuildContext context,{String? customText}) {
  return  (String? val) {
    if (val!.isEmpty) {
      hasError =true;
      return "Check your username, mobile or email address  and try again";
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
      hasError =true;
      return "Check your username, mobile or email address  and try again";
    }
    else if(!isNumeric(val)){
      hasError =true;
      return 'Enter a valid Number';
    }
    // else if((double.parse(val)<1000 || double.parse(val)>DateTime.now().year)){
    //   return 'Enter a valid year';
    // }
    return null;
  }
  ;
}
