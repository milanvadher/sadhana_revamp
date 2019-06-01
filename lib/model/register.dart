class OtpData {
  int otp;
  Register profile;

  OtpData({this.otp, this.profile});

  OtpData.fromJson(Map<String, dynamic> json) {
    otp = json['otp'];
    profile =
        json['profile'] != null ? new Register.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otp'] = this.otp;
    if (this.profile != null) {
      data['profile'] = this.profile.toJson();
    }
    return data;
  }
}

class Register {
  String mhtId;
  String firstName;
  String middleName;
  String lastName;
  String bDate;
  String gDate;
  String center;
  String mobileNo1;
  String mobileNo2;
  String email;
  String fatherName;
  int fatherGnan;
  String fatherGDate;
  int fatherMbaApproval;
  int brotherCount;
  String motherName;
  int motherGnan;
  String motherGDate;
  int motherMbaApproval;
  int sisterCount;
  String studyDetail;
  String occupation;
  String jobStartDate;
  String companyName;
  String workCity;
  String skills;
  String health;
  String personalNotes;
  String bloodGroup;
  String tshirtSize;
  int registered;

  Register(
      {this.mhtId,
      this.firstName,
      this.middleName,
      this.lastName,
      this.bDate,
      this.gDate,
      this.center,
      this.mobileNo1,
      this.mobileNo2,
      this.email,
      this.fatherName,
      this.fatherGnan,
      this.fatherGDate,
      this.fatherMbaApproval,
      this.brotherCount,
      this.motherName,
      this.motherGnan,
      this.motherGDate,
      this.motherMbaApproval,
      this.sisterCount,
      this.studyDetail,
      this.occupation,
      this.jobStartDate,
      this.companyName,
      this.workCity,
      this.skills,
      this.health,
      this.personalNotes,
      this.bloodGroup,
      this.tshirtSize,
      this.registered});

  Register.fromJson(Map<String, dynamic> json) {
    mhtId = json['mht_id'];
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    bDate = json['b_date'];
    gDate = json['g_date'];
    center = json['center'];
    mobileNo1 = json['mobile_no_1'];
    mobileNo2 = json['mobile_no_2'];
    email = json['email'];
    fatherName = json['father_name'];
    fatherGnan = json['father_gnan'];
    fatherGDate = json['father_g_date'];
    fatherMbaApproval = json['father_mba_approval'];
    brotherCount = json['brother_count'];
    motherName = json['mother_name'];
    motherGnan = json['mother_gnan'];
    motherGDate = json['mother_g_date'];
    motherMbaApproval = json['mother_mba_approval'];
    sisterCount = json['sister_count'];
    studyDetail = json['study_detail'];
    occupation = json['occupation'];
    jobStartDate = json['job_start_date'];
    companyName = json['company_name'];
    workCity = json['work_city'];
    skills = json['skills'];
    health = json['health'];
    personalNotes = json['personal_notes'];
    bloodGroup = json['blood_group'];
    tshirtSize = json['tshirt_size'];
    registered = json['registered'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mht_id'] = this.mhtId;
    data['first_name'] = this.firstName;
    data['middle_name'] = this.middleName;
    data['last_name'] = this.lastName;
    data['b_date'] = this.bDate;
    data['g_date'] = this.gDate;
    data['center'] = this.center;
    data['mobile_no_1'] = this.mobileNo1;
    data['mobile_no_2'] = this.mobileNo2;
    data['email'] = this.email;
    data['father_name'] = this.fatherName;
    data['father_gnan'] = this.fatherGnan;
    data['father_g_date'] = this.fatherGDate;
    data['father_mba_approval'] = this.fatherMbaApproval;
    data['brother_count'] = this.brotherCount;
    data['mother_name'] = this.motherName;
    data['mother_gnan'] = this.motherGnan;
    data['mother_g_date'] = this.motherGDate;
    data['mother_mba_approval'] = this.motherMbaApproval;
    data['sister_count'] = this.sisterCount;
    data['study_detail'] = this.studyDetail;
    data['occupation'] = this.occupation;
    data['job_start_date'] = this.jobStartDate;
    data['company_name'] = this.companyName;
    data['work_city'] = this.workCity;
    data['skills'] = this.skills;
    data['health'] = this.health;
    data['personal_notes'] = this.personalNotes;
    data['blood_group'] = this.bloodGroup;
    data['tshirt_size'] = this.tshirtSize;
    data['registered'] = this.registered;
    return data;
  }
}
