import 'package:get/get.dart';

import 'const_utils.dart';

/// REGULAR EXPRESSION
class RegularExpression {
  /// TextField Enter Pattern Expression
  static String leadingZero = r'^[1-9][0-9]*$';
  static String emailPattern = r"([a-zA-Z0-9_@.])";
  static String passwordPattern = r"[a-zA-Z0-9#!_@$%^&*-]";
  static String alphabetPattern = r"[a-zA-Z]";
  static String alphabetSpacePattern = r"[a-zA-Z. ]";
  static String alphabetDigitSpacePattern = r"[a-zA-Z0-9#&$%_@.'?+ ]";
  static String alphabetDigitsPattern = r"[a-zA-Z0-9 ]";
  static String alphabetDigitsWithoutSpacePattern = r"[a-z0-9_]";
  static String alphabetDigitsSpacePlusPattern = r"[a-zA-Z0-9+ ]";
  static String alphabetDigitsSpecialSymbolPattern = r"[a-zA-Z0-9#&$%_@.]";
  static String alphabetDigitsDashPattern = r"[a-zA-Z0-9- ]";
  static String addressValidationPattern = r"[a-zA-Z0-9-@#&* ]";
  static String digitsPattern = r"[0-9]";
  static String pricePattern = r'^\d+\.?\d*';

  /// Validation Expression Pattern
  static String emailValidationPattern =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  static String passwordValidPattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
}

/// VALIDATION MESSAGE WITH
class ValidationMsg {
  static String isRequired = "is required";
  static String somethingWentToWrong = "Something went Wrong";
  static String pleaseEnterValidEmail = "Please Enter Valid Email";
  static String passwordLength = 'Must BeMore Than 6 Char';
  static String mobileNoLength = 'Mobile No Must Be 10 Digit';
  static String passwordInValid = 'Password Invalid';
}

/// VALIDATION METHOD
class ValidationMethod {
  /// EMAIL VALIDATION METHOD
  static String? validateUserName(value) {
    bool regex =
        RegExp(RegularExpression.emailValidationPattern).hasMatch(value);
    if (value == null) {
      return ValidationMsg.isRequired.tr;
    } else if (regex == false) {
      return ValidationMsg.pleaseEnterValidEmail.tr;
    }
    return null;
  }

  /// PASSWORD VALIDATION METHOD
  static String? validatePassword(value) {
    if (value == null) {
      return ValidationMsg.isRequired.tr;
    } else if (value.length < ConstUtils.kPasswordLength) {
      return ValidationMsg.passwordLength;
    }
    return null;
  }

  /// MOBILE VALIDATION METHOD
  static String? validatePhoneNo(value) {
    if (value == null) {
      return ValidationMsg.isRequired.tr;
    } else if (value.length < ConstUtils.kPhoneNumberLength) {
      return ValidationMsg.mobileNoLength;
    }
    return null;
  }

  /// IS REQUIRED VALIDATION METHOD  (COMMON METHOD)
  static String? validateIsRequired(value) {
    if (value == null) {
      return ValidationMsg.isRequired.tr;
    }
    return null;
  }
}
