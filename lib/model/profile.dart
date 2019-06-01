class Profile {
  String mhtId;
  String firstName;
  String lastName;
  String mobileNo1;
  String email;

  Profile(
      {this.mhtId, this.firstName, this.lastName, this.mobileNo1, this.email});

  Profile.fromJson(Map<String, dynamic> json) {
    mhtId = json['mht_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobileNo1 = json['mobile_no_1'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mht_id'] = this.mhtId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['mobile_no_1'] = this.mobileNo1;
    data['email'] = this.email;
    return data;
  }
}
