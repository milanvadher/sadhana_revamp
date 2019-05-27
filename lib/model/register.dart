class Register {
  String lastName;
  String bloodGroup;
  String gDate;
  String studyDetail;
  String fatherName;
  String owner;
  int motherGnan;
  int sisterCount;
  String jobStartDate;
  String motherName;
  String occupation;
  String firstName;
  String modifiedBy;
  String fatherGDate;
  int motherMbaApproval;
  int fatherGnan;
  String health;
  String companyName;
  String email;
  String motherGDate;
  int registered;
  int fatherMbaApproval;
  String workCity;
  String bDate;
  String middleName;
  String fullName;
  String tshirtSize;
  String mobileNo1;
  String center;
  String name;
  List<String> skills;
  int brotherCount;
  String mhtId;
  String personalNotes;
  Address permanentAddress;
  Address currentAddress;

  Register(
      {this.lastName,
      this.bloodGroup,
      this.gDate,
      this.studyDetail,
      this.fatherName,
      this.owner,
      this.motherGnan,
      this.sisterCount,
      this.jobStartDate,
      this.motherName,
      this.occupation,
      this.firstName,
      this.modifiedBy,
      this.fatherGDate,
      this.motherMbaApproval,
      this.fatherGnan,
      this.health,
      this.companyName,
      this.email,
      this.motherGDate,
      this.registered,
      this.fatherMbaApproval,
      this.workCity,
      this.bDate,
      this.middleName,
      this.fullName,
      this.tshirtSize,
      this.mobileNo1,
      this.center,
      this.name,
      this.skills,
      this.brotherCount,
      this.mhtId,
      this.personalNotes,
      this.permanentAddress,
      this.currentAddress});

  Register.fromJson(Map<String, dynamic> json) {
    lastName = json['last_name'];
    bloodGroup = json['blood_group'];
    gDate = json['g_date'];
    studyDetail = json['study_detail'];
    fatherName = json['father_name'];
    owner = json['owner'];
    motherGnan = json['mother_gnan'];
    sisterCount = json['sister_count'];
    jobStartDate = json['job_start_date'];
    motherName = json['mother_name'];
    occupation = json['occupation'];
    firstName = json['first_name'];
    modifiedBy = json['modified_by'];
    fatherGDate = json['father_g_date'];
    motherMbaApproval = json['mother_mba_approval'];
    fatherGnan = json['father_gnan'];
    health = json['health'];
    companyName = json['company_name'];
    email = json['email'];
    motherGDate = json['mother_g_date'];
    registered = json['registered'];
    fatherMbaApproval = json['father_mba_approval'];
    workCity = json['work_city'];
    bDate = json['b_date'];
    middleName = json['middle_name'];
    tshirtSize = json['tshirt_size'];
    mobileNo1 = json['mobile_no_1'];
    center = json['center'];
    name = json['name'];
    skills = json['skills'].cast<String>();
    brotherCount = json['brother_count'];
    mhtId = json['mht_id'];
    personalNotes = json['personal_notes'];
    permanentAddress = json['permanent_address'] != null
        ? new Address.fromJson(json['permanent_address'])
        : null;
    currentAddress = json['current_address'] != null
        ? new Address.fromJson(json['current_address'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['last_name'] = this.lastName;
    data['blood_group'] = this.bloodGroup;
    data['g_date'] = this.gDate;
    data['study_detail'] = this.studyDetail;
    data['father_name'] = this.fatherName;
    data['owner'] = this.owner;
    data['mother_gnan'] = this.motherGnan;
    data['sister_count'] = this.sisterCount;
    data['job_start_date'] = this.jobStartDate;
    data['mother_name'] = this.motherName;
    data['occupation'] = this.occupation;
    data['first_name'] = this.firstName;
    data['modified_by'] = this.modifiedBy;
    data['father_g_date'] = this.fatherGDate;
    data['mother_mba_approval'] = this.motherMbaApproval;
    data['father_gnan'] = this.fatherGnan;
    data['health'] = this.health;
    data['company_name'] = this.companyName;
    data['email'] = this.email;
    data['mother_g_date'] = this.motherGDate;
    data['registered'] = this.registered;
    data['father_mba_approval'] = this.fatherMbaApproval;
    data['work_city'] = this.workCity;
    data['b_date'] = this.bDate;
    data['middle_name'] = this.middleName;
    data['tshirt_size'] = this.tshirtSize;
    data['mobile_no_1'] = this.mobileNo1;
    data['center'] = this.center;
    data['name'] = this.name;
    data['skills'] = this.skills;
    data['brother_count'] = this.brotherCount;
    data['mht_id'] = this.mhtId;
    data['personal_notes'] = this.personalNotes;
    if (this.permanentAddress != null) {
      data['permanent_address'] = this.permanentAddress.toJson();
    }
    if (this.currentAddress != null) {
      data['current_address'] = this.currentAddress.toJson();
    }
    return data;
  }
}

class Address {
  String pincode;
  Null addressLine2;
  String city;
  String addressLine1;
  String state;
  String country;

  Address(
      {this.pincode,
      this.addressLine2,
      this.city,
      this.addressLine1,
      this.state,
      this.country});

  Address.fromJson(Map<String, dynamic> json) {
    pincode = json['pincode'];
    addressLine2 = json['address_line2'];
    city = json['city'];
    addressLine1 = json['address_line1'];
    state = json['state'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pincode'] = this.pincode;
    data['address_line2'] = this.addressLine2;
    data['city'] = this.city;
    data['address_line1'] = this.addressLine1;
    data['state'] = this.state;
    data['country'] = this.country;
    return data;
  }
}