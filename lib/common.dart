enum SadhanaType { BOOLEAN, NUMBER }

class CommonValidation {

  // mhtId Validation
  static String mhtIdValidation(value) {
    if (value.isEmpty) {
      return 'Mht ID is required';
    }
    return null;
  }

  // password Validation
  static String passwordValidation(String value) {
//    Pattern pattern =
//        r'(?=^.{6,}$)((?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$';
//    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 4) {
      return 'Passwords must contain at least 4 characters';
    }
//    else if (!regex.hasMatch(value)) {
//      return 'Passwords must contain uppercase, lowercase letters and numbers';
//    }
    return null;
  }

  // otp Validation
  static String otpValidation(String value) {
    if (value.isEmpty) {
      return 'OTP is required';
    } else if (value.length != 6) {
      return 'OTP must have 6 digit';
    }
    return null;
  }

  // mobile Validation
  static String mobileValidation(String value) {
    if (value.isEmpty) {
      return 'Mobile no. is required';
    } else if (value.length != 10) {
      return 'Enter valid Mobile no.';
    }
    return null;
  }

  // email Validation
  static String emailValidation(String value) {
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) {
      return 'Email-Id is required';
    } else if (!regex.hasMatch(value)) {
      return 'Enter valid Email-Id';
    }
    return null;
  }

  // Feedback contact validation
  static String contactValidation(String value) {
    if (value.isEmpty) {
      return 'Contact is required';
    }
    return null;
  }

}