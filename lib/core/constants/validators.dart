import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:mena/core/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:mena/modules/create_new_user/username_page.dart';
import '../functions/main_funcs.dart';

bool hasError = false;
String? Function(String?)? emailValidate(BuildContext context) =>
        (String? val) {
      if (val!.isEmpty) {
        return getTranslatedStrings(context).thisFieldIsRequired;
      } else if (val.contains('.') &&
          val.split('.').last.isNotEmpty &&
          val.contains('@') &&
          val.split('@')[1].isNotEmpty) {
        hasError = false;
        return null; // null is ok 'valid'
      } else {
        hasError = true;
        return getTranslatedStrings(context).invalidEmail;
      }
    };
String? Function(String?)? passwordValidate(BuildContext context) {
  return (String? val) {
    if (val!.isEmpty) {
      hasError = true;
      return getTranslatedStrings(context).pleaseEnterPassword;
    } else if (val.length < 8) {
      hasError = true;
      return getTranslatedStrings(context).invalidPassword;
    } else {
      hasError = false;
      // return getTranslatedStrings(context).invalidPassword;
      return null;
    }
  };
}
String? passwordMatchValidator(String newPassword, String confirmPassword) {
  if (newPassword != confirmPassword) {
    return "Passwords do not match";
  }
  return null; // No validation errors
}
String? Function(String?) passwordValidateSignUp(BuildContext context) {
  return (String? val) {
    if (val!.isEmpty) {
      hasError = true;
      return "Password cannot be empty";
    }else if (val.length < 8) {
      hasError = true;
      return "This password is too short. Create a longer password with at least 8 letters and numbers";
    }else if (val == "12345678" || val == "87654321") {
      hasError = true;
      return "This password is too easy to guess. Please create a new one";
    }else {
      hasError = false;
      return null;
    }
  };
}
// Future<String?> userNameValidateSignUp(BuildContext context, String value) async {
//   // Check if the username already exists
//   final bool usernameExists = await checkUsernameAvailability(value);
//
//   if (usernameExists) {
//     // Username already exists, show options in a container
//     return 'The username $userName is Not available';
//   }
//
//   // Check if the username contains special characters
//   final bool containsSpecialCharacters = checkSpecialCharacters(value);
//
//   if (containsSpecialCharacters) {
//     return 'Username contains special characters. Remove them.';
//   }
//
//   // Check if the length of the username is less than 30
//   if (value.length > 30) {
//     return 'Username must be less than 30 characters.';
//   }
//
//   return null; // No validation errors
// }

Future<String?> userNameValidateSignUp(String? value) async {
  if (value == null) {
    return null; // No validation errors when the field is empty
  }

  // Check if the username already exists
  final bool usernameExists = await checkUsernameAvailability(value);

  if (usernameExists) {
    // Username already exists, show options in a container
    return 'The username $value is Not available';
  }

  // Check if the username contains special characters
  final bool containsSpecialCharacters = checkSpecialCharacters(value);

  if (containsSpecialCharacters) {
    return 'Username contains special characters. Remove them.';
  }

  // Check if the length of the username is less than 30
  if (value.length > 30) {
    return 'Username must be less than 30 characters.';
  }

  return null; // No validation errors
}

Future<bool> checkUsernameAvailability(String username) async {
  final apiUrl = Uri.parse("http://menaaii.com/api/v1/checkusername");
  final response = await http.post(apiUrl, body: {"username": username});

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    // Check the response and return true or false based on availability
    return responseData["available"];
  } else {
    // Handle API request errors
    throw Exception('Failed to check username availability');
  }
}

bool checkSpecialCharacters(String username) {
  final pattern = RegExp(r'[!@#\$%^&*(),.?":{}|<>]');
  return pattern.hasMatch(username);
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
String? normalInputValidate1(String? fieldContent) {
  if (fieldContent == null || fieldContent.isEmpty) {
    hasError = true;
    return "Check your username, mobile or email address  and try again";
  }
  hasError = false;
  return null;
}

String? emptyValueValidate(String? fieldContent) {
  if (fieldContent == null || fieldContent.isEmpty) {
    return "Please fill this field";
  }
  return null;
}
String? Function(String?)? normalInputValidate(BuildContext context,{String? customText}) {
  return  (String? val) {
    if (val!.isEmpty) {
      return customText??getTranslatedStrings(context).thisFieldIsRequired;
    }
    return null;
  };
}
String? normalInputValidate2(String? fieldContent) {
  if (fieldContent == null || fieldContent.isEmpty) {
    return "Check your username, mobile or email address  and try again";
  }
  return null;
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

// String? Function(String?)? userNameValidateSignUp(BuildContext context) {
//   return (String? val) {
//
//     if (val!.isEmpty) {
//       hasError = true;
//       return "UserName cannot be empty";
//     }
//     if (!RegExp(r'^[A-Za-z0-9_.]+$').hasMatch(val)) {
//       hasError = true;
//       return "Username can only include numbers, letters, underscores and periods. Try again";
//     }
//     if (val.length > 30 ) {
//       hasError = true;
//       return "Choose a username that’s under 30 characters.";
//     }
//     return null;
//   };
// }

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