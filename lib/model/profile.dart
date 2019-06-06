import 'package:sadhana/model/register.dart';

class Profile {
  String mhtId;
  String firstName;
  String lastName;
  String mobileNo1;
  String email;
  String center;
  Profile(
      {this.mhtId, this.firstName, this.lastName, this.mobileNo1, this.email, this.center});

  Profile.fromJson(Map<String, dynamic> json) {
    mhtId = json['mht_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobileNo1 = json['mobile_no_1'];
    email = json['email'];
    center = json['center'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mht_id'] = this.mhtId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['mobile_no_1'] = this.mobileNo1;
    data['email'] = this.email;
    data['center'] = this.center;
    return data;
  }

  Profile.fromRegisterModel(Register register) {
    this.mhtId = register.mhtId;
    this.firstName = register.firstName;
    this.lastName = register.lastName;
    this.mobileNo1 = register.mobileNo1;
    this.email = register.email;
    this.center = register.center;
  }
}
