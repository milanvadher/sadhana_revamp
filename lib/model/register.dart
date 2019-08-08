import 'package:sadhana/utils/apputils.dart';

class OtpData {
  int otp;
  Register profile;
  int isLoggedIn;
  OtpData({this.otp, this.profile});

  OtpData.fromJson(Map<String, dynamic> json) {
    otp = json["otp"];
    isLoggedIn = json["is_logged_in"] ?? 0;
    profile =
        json["profile"] != null ? new Register.fromJson(json["profile"]) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["otp"] = this.otp;
    data["is_logged_in"] = this.isLoggedIn;
    if (this.profile != null) {
      data["profile"] = this.profile.toJson();
    }
    return data;
  }
}

class Register {
  String token;
  String mhtId;
  String firstName;
  String middleName;
  String lastName;
  String bDate;
  String gDate;
  String center;
  String group;
  String aptName;
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
  List<dynamic> skills;
  String health;
  String personalNotes;
  String bloodGroup;
  String tshirtSize;
  int registered;
  List<String> holidays;
  Address permanentAddress;
  Address currentAddress;
  bool sameAsPermanentAddress = false;
  SevaProfile sevaProfile;
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
      this.registered,
      this.holidays,
      this.permanentAddress,
      this.currentAddress,
        this.sevaProfile});

  Register.fromJson(Map<String, dynamic> json) {
    mhtId = json["mht_id"];
    firstName = json["first_name"];
    middleName = json["middle_name"];
    lastName = json["last_name"];
    bDate = json["b_date"];
    gDate = json["g_date"];
    center = json["center"];
    group = json['group_title'];
    aptName = json['apt_name'];
    mobileNo1 = json["mobile_no_1"];
    mobileNo2 = json["mobile_no_2"];
    email = json["email"];
    fatherName = json["father_name"];
    fatherGnan = json["father_gnan"];
    fatherGDate = json["father_g_date"];
    fatherMbaApproval = json["father_mba_approval"];
    brotherCount = json["brother_count"];
    motherName = json["mother_name"];
    motherGnan = json["mother_gnan"];
    motherGDate = json["mother_g_date"];
    motherMbaApproval = json["mother_mba_approval"];
    sisterCount = json["sister_count"];
    studyDetail = json["study_detail"];
    occupation = json["occupation"];
    jobStartDate = json["job_start_date"];
    companyName = json["company_name"];
    workCity = json["work_city"];
    skills = json["skills"];
    health = json["health"];
    personalNotes = json["personal_notes"];
    bloodGroup = json["blood_group"];
    tshirtSize = json["tshirt_size"];
    registered = json["registered"];
    sameAsPermanentAddress = AppUtils.convertToIntToBool(json["current_address_same_permanent"]);
    holidays = [];
    List<dynamic> tmpHolidays = json["holidays"];
    if(tmpHolidays != null && tmpHolidays.isNotEmpty)
      holidays = tmpHolidays.map((v) => v.toString()).toList(growable: true);
    permanentAddress = json["permanent_address"] != null ? new Address.fromJson(json["permanent_address"]) : null;
    currentAddress = json["current_address"] != null ? new Address.fromJson(json["current_address"]) : null;
    sevaProfile = json['seva_profile'] != null
        ? new SevaProfile.fromJson(json['seva_profile'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["mht_id"] = this.mhtId;
    data["token"] = this.token;
    data["first_name"] = this.firstName;
    data["middle_name"] = this.middleName;
    data["last_name"] = this.lastName;
    data["b_date"] = this.bDate;
    data["g_date"] = this.gDate;
    data["center"] = this.center;
    data['group_title'] = this.group;
    data['apt_name'] = this.aptName;
    data["mobile_no_1"] = this.mobileNo1;
    data["mobile_no_2"] = this.mobileNo2;
    data["email"] = this.email;
    data["father_name"] = this.fatherName;
    data["father_gnan"] = this.fatherGnan;
    data["father_g_date"] = this.fatherGDate;
    data["father_mba_approval"] = this.fatherMbaApproval;
    data["brother_count"] = this.brotherCount;
    data["mother_name"] = this.motherName;
    data["mother_gnan"] = this.motherGnan;
    data["mother_g_date"] = this.motherGDate;
    data["mother_mba_approval"] = this.motherMbaApproval;
    data["sister_count"] = this.sisterCount;
    data["study_detail"] = this.studyDetail;
    data["occupation"] = this.occupation;
    data["job_start_date"] = this.jobStartDate;
    data["company_name"] = this.companyName;
    data["work_city"] = this.workCity;
    data["health"] = this.health;
    data["personal_notes"] = this.personalNotes;
    data["blood_group"] = this.bloodGroup;
    data["tshirt_size"] = this.tshirtSize;
    data["registered"] = this.registered;
    data['skills'] = this.skills;
    data['holidays'] = this.holidays;
    data['current_address_same_permanent'] = sameAsPermanentAddress ? 1 : 0;
    if (this.permanentAddress != null) {
      this.permanentAddress.addressType = "Permanent";
      data["permanent_address"] = this.permanentAddress.toJson();
    }
    if (this.currentAddress != null) {
      this.currentAddress.addressType = 'Current';
      data["current_address"] = this.currentAddress.toJson();
    }
    if (this.sevaProfile != null) {
      data['seva_profile'] = this.sevaProfile.toJson();
    }
    return data;
  }

  List<dynamic> getFromList(List<dynamic> input) {
    if(input == null || input.isEmpty)
      return [""];
    else
      return input;
  }

  @override
  String toString() {
    return 'Register{mhtId: $mhtId, firstName: $firstName, middleName: $middleName, lastName: $lastName, bDate: $bDate, gDate: $gDate, center: $center, group: $group, aptName: $aptName, mobileNo1: $mobileNo1, mobileNo2: $mobileNo2, email: $email, fatherName: $fatherName, fatherGnan: $fatherGnan, fatherGDate: $fatherGDate, fatherMbaApproval: $fatherMbaApproval, brotherCount: $brotherCount, motherName: $motherName, motherGnan: $motherGnan, motherGDate: $motherGDate, motherMbaApproval: $motherMbaApproval, sisterCount: $sisterCount, studyDetail: $studyDetail, occupation: $occupation, jobStartDate: $jobStartDate, companyName: $companyName, workCity: $workCity, skills: $skills, health: $health, personalNotes: $personalNotes, bloodGroup: $bloodGroup, tshirtSize: $tshirtSize, registered: $registered, holidays: $holidays, permanentAddress: $permanentAddress, currentAddress: $currentAddress, sameAsPermanentAddress: $sameAsPermanentAddress, sevaProfile: $sevaProfile}';
  }

}

class Address {
  String addressType;
  String addressLine1;
  String addressLine2;
  String city;
  String cityDisp;
  String state;
  String country;
  String pincode;
  String emailId;
  String phone;

  Address(
      {this.addressType,
      this.addressLine1,
      this.addressLine2,
      this.city,
      this.cityDisp,
      this.state,
      this.country,
      this.pincode,
      this.emailId,
      this.phone});

  Address.fromJson(Map<String, dynamic> json) {
    addressType = json["address_type"];
    addressLine1 = json["address_line1"];
    addressLine2 = json["address_line2"];
    city = json["city"];
    cityDisp = json["city_disp"];
    state = json["state"];
    country = json["country"];
    pincode = json["pincode"];
    emailId = json["email_id"];
    phone = json["phone"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["address_type"] = this.addressType;
    data["address_line1"] = this.addressLine1;
    data["address_line2"] = this.addressLine2;
    data["city"] = this.city;
    data["city_disp"] = this.cityDisp;
    data["state"] = this.state;
    data["country"] = this.country;
    data["pincode"] = this.pincode;
    data["email_id"] = this.emailId;
    data["phone"] = this.phone;
    return data;
  }

  @override
  String toString() {
    return "Address{addressType: $addressType, addressLine1: $addressLine1, addressLine2: $addressLine2, city: $city, cityDisp: $cityDisp, state: $state, country: $country, pincode: $pincode, emailId: $emailId, phone: $phone}";
  }
}

class SevaProfile {
  String regularSevaDept;
  String eventSevaDept;
  int timeAvailability;
  List<dynamic> daysAvailability;
  String remarks;
  String interest;
  SevaProfile(
      {this.regularSevaDept,
        this.eventSevaDept,
        this.timeAvailability = 0,
        daysAvailability,
        this.remarks,
        this.interest
      }) : this.daysAvailability = daysAvailability ?? List() ;

  SevaProfile.fromJson(Map<String, dynamic> json) {
    regularSevaDept = json['regular_seva_dept'];
    eventSevaDept = json['event_seva_dept'];
    timeAvailability = json['time_availability'] ?? 0;
    daysAvailability = json['days_availability']?? [];
    remarks = json['remarks'];
    interest = json['interest'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['regular_seva_dept'] = this.regularSevaDept;
    data['event_seva_dept'] = this.eventSevaDept;
    data['time_availability'] = this.timeAvailability;
    data['days_availability'] = this.daysAvailability;
    data['remarks'] = this.remarks;
    data['interest'] = this.interest;
    return data;
  }
}