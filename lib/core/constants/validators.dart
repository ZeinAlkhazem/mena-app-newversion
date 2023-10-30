import 'dart:convert';
import 'dart:developer';

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
String? Function(String?)? emailValidateSignUp(BuildContext context) =>
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
        return getTranslatedStrings(context).invalidEmailSignUp;
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

String? Function(String?) userNameValidateSignUp1(BuildContext context) {
  return (String? val) {
    if (val!.isEmpty) {
      hasError = true;
      return "User Name cannot be empty";
    }
    final bool containsSpecialCharacters = checkSpecialCharacters(val);

    if (containsSpecialCharacters) {
      return 'Username can only include numbers, letters, underscores and periods. Try again.';
    }

    // Check if the length of the username is less than 30
    if (val.length > 30) {
      return 'Choose a username that’s under 30 characters.';
    }

    return null;
  };
}


Future<String> validateCode(String email, String code) async {
  if (code.length < 6) {
    return "The code is too short. Please double-check your entry for accuracy and try again.";
  }

  final apiUrl = Uri.parse("https://menaaii.com/api/v1/users/register/verify-code");
  final body = {"email": email, "code": code};

  try {
    final response = await http.post(apiUrl, body: body);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      bool isValid = responseData["valid"];
      if (isValid) {
        return "Code is valid"; // Code is valid
      } else {
        return "The provided code is not valid. You have the option to request a new one.";
      }
    } else {
      throw Exception('Failed to validate code');
    }
  } catch (e) {
    print("Error in validateCode: $e");
    return "Failed to validate code"; // Return an error message
  }
}

// Future<String?> validateCodeFormat(String code) async {
//   if (code.isEmpty) {
//     return "Code is required";
//   }
//
//   // Check if the code is valid using the validateCode function
//   String validationResult = await validateCode(email, code);
//
//   if (validationResult != "Code is valid") {
//     return validationResult;
//   }
//
//   return null; // Return null if validation passes
// }


Future<bool>   userNameValidateSignUp(String? value) async {

  if (value == null) {
    return false; // No validation errors when the field is empty
  }

  // Check if the username already exists
  final bool usernameExists = await checkUsernameAvailability(value);

  if (usernameExists) {
    // Username already exists, show options in a container
    return false; // Validation failed
  }

  // Check if the username contains special characters
  final bool containsSpecialCharacters = checkSpecialCharacters(value);

  if (containsSpecialCharacters) {
    return false; // Validation failed
  }

  // Check if the length of the username is less than 30
  if (value.length > 30) {
    return false; // Validation failed
  }

  return true; // Validation passed
}
Future<bool> checkUsernameAvailability(String username) async {
  try {
    final apiUrl = Uri.parse("https://menaaii.com/api/v1/checkusername");
    final response = await http.post(apiUrl, body: {"user_name": username});
    log("# response : ${response.statusCode}");
    log("# response : ${response.body}");
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      // Check the response and return true or false based on availability
      return responseData["available"];
    } else {
      // Handle API request errors
      log('Failed to check username availability');
      return false ;
    }
  } catch (e) {
    // Handle the exception, log it, or return an appropriate value
    print("Error in checkUsernameAvailability: $e");
    return false; // Return false to indicate an error occurred
  }
}

bool checkSpecialCharacters(String username) {
  final pattern = RegExp(r'[!@#\$%^&*(),.?":{}|<>]');
  return pattern.hasMatch(username);
}




Future<bool> isEmailTaken(String email) async {
  final apiUrl = Uri.parse("https://menaaii.com/api/v1/users/check_email");
  final response = await http.post(apiUrl, body: {"email": email});

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    return responseData["email_taken"] == true;
  }
  return false; // Handle API request errors
}

bool isValidEmail(String email) {
  final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
  return emailRegExp.hasMatch(email);
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