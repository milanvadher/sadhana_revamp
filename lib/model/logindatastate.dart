import 'package:sadhana/model/profile.dart';

class LoginState {

  String mhtId = '';
  int registerMethod = 0;
  String mobileNo = '';
  String newMobile = '';
  String email = '';
  String otp;
  Profile profileData;
  bool mobileChangeRequestStart = false;

  void reset() {
    this.mhtId = '';
    registerMethod = 0;
    mobileNo = '';
    email = '';
    otp = '';
    profileData = null;
    mobileChangeRequestStart = false;
  }
}