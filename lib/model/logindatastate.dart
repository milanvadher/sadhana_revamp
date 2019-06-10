import 'package:sadhana/model/profile.dart';

class LoginState {

  String mhtId = '';
  int registerMethod = 0;
  String mobileNo = '';
  String email = '';
  String otp;
  Profile profileData;
  bool mobileChangeRequestStart = false;
}