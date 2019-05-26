class Register {
  String mhtId;
  String fullName;
  DateTime bDate;
  DateTime gDate;
  String center;
  int mobileNo;
  String email;
  String fatherName;
  bool fatherGnan;
  DateTime fatherGDate;
  bool fatherMbaApproval;
  String motherName;
  bool motherGnan;
  DateTime motherGDate;
  bool motherMbaApproval;
  int brotherCount;
  int sisterCount;
  String studyDetails;
  String occupation;
  int workExp;
  DateTime jobStartDate;
  String companyName;
  String workCity;
  List<String> skills;
  String health;
  String personalNotes;
  String bloodGroup;
  String tshirtSize;
  Address permanentAddress;
  Address tempAddress;

  Register(
      {this.mhtId,
        this.fullName,
        this.bDate,
        this.gDate,
        this.center,
        this.mobileNo,
        this.email,
        this.fatherName,
        this.fatherGnan,
        this.fatherGDate,
        this.fatherMbaApproval,
        this.motherName,
        this.motherGnan,
        this.motherGDate,
        this.motherMbaApproval,
        this.brotherCount,
        this.sisterCount,
        this.studyDetails,
        this.occupation,
        this.workExp,
        this.jobStartDate,
        this.companyName,
        this.workCity,
        this.skills,
        this.health,
        this.personalNotes,
        this.bloodGroup,
        this.tshirtSize,
        this.permanentAddress,
        this.tempAddress});

  Register.fromJson(Map<String, dynamic> json) {
    mhtId = json['mht_id'];
    fullName = json['full_name'];
    bDate = json['b_date'];
    gDate = json['g_date'];
    center = json['center'];
    mobileNo = json['mobile_no'].cast<int>();
    email = json['email'];
    fatherName = json['father_name'];
    fatherGnan = json['father_gnan'];
    fatherGDate = json['father_g_date'];
    fatherMbaApproval = json['father_mba_approval'];
    motherName = json['mother_name'];
    motherGnan = json['mother_gnan'];
    motherGDate = json['mother_g_date'];
    motherMbaApproval = json['mother_mba_approval'];
    brotherCount = json['brother_count'];
    sisterCount = json['sister_count'];
    studyDetails = json['study_details'];
    occupation = json['occupation'];
    workExp = json['work_exp'];
    jobStartDate = json['job_start_date'];
    companyName = json['company_name'];
    workCity = json['work_city'];
    skills = json['skills'].cast<String>();
    health = json['health'];
    personalNotes = json['personal_notes'];
    bloodGroup = json['blood_group'];
    tshirtSize = json['tshirt_size'];
    permanentAddress = json['permanent_address'] != null
        ? new Address.fromJson(json['permanent_address'])
        : null;
    tempAddress = json['temp_address'] != null
        ? new Address.fromJson(json['temp_address'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mht_id'] = this.mhtId;
    data['full_name'] = this.fullName;
    data['b_date'] = this.bDate;
    data['g_date'] = this.gDate;
    data['center'] = this.center;
    data['mobile_nos'] = this.mobileNo;
    data['email'] = this.email;
    data['father_name'] = this.fatherName;
    data['father_gnan'] = this.fatherGnan;
    data['father_g_date'] = this.fatherGDate;
    data['father_mba_approval'] = this.fatherMbaApproval;
    data['mother_name'] = this.motherName;
    data['mother_gnan'] = this.motherGnan;
    data['mother_g_date'] = this.motherGDate;
    data['mother_mba_approval'] = this.motherMbaApproval;
    data['brother_count'] = this.brotherCount;
    data['sister_count'] = this.sisterCount;
    data['study_details'] = this.studyDetails;
    data['occupation'] = this.occupation;
    data['work_exp'] = this.workExp;
    data['job_start_date'] = this.jobStartDate;
    data['company_name'] = this.companyName;
    data['work_city'] = this.workCity;
    data['skills'] = this.skills;
    data['health'] = this.health;
    data['personal_notes'] = this.personalNotes;
    data['blood_group'] = this.bloodGroup;
    data['tshirt_size'] = this.tshirtSize;
    if (this.permanentAddress != null) {
      data['permanent_address'] = this.permanentAddress.toJson();
    }
    if (this.tempAddress != null) {
      data['temp_address'] = this.tempAddress.toJson();
    }
    return data;
  }
}

class Address {
  int id;
  String country;
  String address1;
  String address2;
  String city;
  String state;
  int zipCode;
  String raw;

  Address(
      {this.id,
        this.country,
        this.address1,
        this.address2,
        this.city,
        this.state,
        this.zipCode,
        this.raw});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    country = json['country'];
    address1 = json['address_1'];
    address2 = json['address_2'];
    city = json['city'];
    state = json['state'];
    zipCode = json['zip_code'];
    raw = json['raw'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['country'] = this.country;
    data['address_1'] = this.address1;
    data['address_2'] = this.address2;
    data['city'] = this.city;
    data['state'] = this.state;
    data['zip_code'] = this.zipCode;
    data['raw'] = this.raw;
    return data;
  }
}
