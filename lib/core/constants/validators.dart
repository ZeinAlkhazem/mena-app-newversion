import 'package:flutter/cupertino.dart';
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
      return "Password cannot be empty";
    }
    if (val.length < 8) {
      hasError = true;
      return "This password is too short.";
    }
    return null;
  };
}

String? Function(String?)? codeValidate(BuildContext context) {
  return (String? val) {
    if (val!.isEmpty) {
      hasError = true;
      return "Code cannot be empty";
    }
    if (val.length < 6) {
      hasError = true;
      return "The code is too short. Please double-check your entry for accuracy and try again";
    }
    return null;
  };
}

String? Function(String?)? passwordValidateSignUp(BuildContext context) {
  return (String? val) {
    if (val!.isEmpty) {
      hasError = true;
      return "Password cannot be empty";
    }
    if (val.length < 8) {
      hasError = true;
      return "This password is too short. Create a longer password with at least 8 letters and numbers";
    }
    if (val == "12345678" || val == "87654321") {
      hasError = true;
      return "This password is too easy to guess. Please create a new one";
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

String? emptyValueValidate(String? fieldContent) {
  if (fieldContent == null || fieldContent.isEmpty) {
    return "Please fill this field";
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
  };

}


String? Function(String?)? userNameValidateSignUp(BuildContext context) {
  return (String? val) {

    if (val!.isEmpty) {
      hasError = true;
      return "UserName cannot be empty";
    }
    if (!RegExp(r'^[A-Za-z0-9_.]+$').hasMatch(val)) {
      hasError = true;
      return "Username can only include numbers, letters, underscores and periods. Try again";
    }
    if (val.length > 30 ) {
      hasError = true;
      return "Choose a username that’s under 30 characters.";
    }
    return null;
  };
}