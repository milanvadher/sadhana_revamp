import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:sadhana/auth/registration/Inputs/combobox-input.dart';
import 'package:sadhana/auth/registration/Inputs/date-input.dart';
import 'package:sadhana/auth/registration/Inputs/dropdown-input.dart';
import 'package:sadhana/auth/registration/Inputs/number-input.dart';
import 'package:sadhana/auth/registration/Inputs/radio-input.dart';
import 'package:sadhana/auth/registration/Inputs/text-input.dart';
import 'package:sadhana/comman.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/model/country.dart';
import 'package:sadhana/model/register.dart';
import 'package:intl/intl.dart';
import 'package:sadhana/model/skill.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/app_response_parser.dart';
import 'package:sadhana/wsmodel/appresponse.dart';

class RegistrationPage extends StatefulWidget {
  static const String routeName = '/registration';
  final Register registrationData;

  RegistrationPage({@required this.registrationData});

  @override
  RegistrationPageState createState() => RegistrationPageState();
}

class RegistrationPageState extends State<RegistrationPage> {
  Register _register = new Register();
  ApiService api = new ApiService();
  var dateFormatter = new DateFormat('yyyy-MM-dd');
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();
  final _formKeyStep3 = GlobalKey<FormState>();
  int currantStep = 0;
  bool sameAsPermenentAddress = false;
  List<Step> registrationSteps = [];
  List<String> skills = [];
  List<Geo> countryList = [];
  List<Geo> stateList = [];
  List<Geo> cityList = [];
  List<bool> isExpandedAddress = [false, false];

  loadCountries() async {
    try {
      Response res = await api.postApi(
        url: '/mba.master.country_list',
        data: {},
      );
      AppResponse appResponse =
          AppResponseParser.parseResponse(res, context: context);
      if (appResponse.status == WSConstant.SUCCESS_CODE) {
        countryList = Geo.fromJsonList(appResponse.data);
      }
    } catch (error) {
      print(error);
      CommonFunction.displayErrorDialog(context: context);
    }
  }

  getStateByCountry({@required String country}) async {
    try {
      Response res = await api.postApi(
        url: '/mba.master.state_list',
        data: {'country': country},
      );
      AppResponse appResponse =
          AppResponseParser.parseResponse(res, context: context);
      if (appResponse.status == WSConstant.SUCCESS_CODE) {
        stateList = Geo.fromJsonList(appResponse.data);
      }
    } catch (error) {
      print(error);
      CommonFunction.displayErrorDialog(context: context);
    }
  }

  getCityByState({@required String state}) async {
    try {
      Response res = await api.postApi(
        url: '/mba.master.city_list',
        data: {'state': state},
      );
      AppResponse appResponse =
          AppResponseParser.parseResponse(res, context: context);
      if (appResponse.status == WSConstant.SUCCESS_CODE) {
        stateList = Geo.fromJsonList(appResponse.data);
      }
    } catch (error) {
      print(error);
      CommonFunction.displayErrorDialog(context: context);
    }
  }

  loadSkills() async {
    try {
      Response res = await api.postApi(
        url: '/mba.master.skill_list',
        data: {},
      );
      AppResponse appResponse =
          AppResponseParser.parseResponse(res, context: context);
      if (appResponse.status == WSConstant.SUCCESS_CODE) {
        Skills.fromJsonList(appResponse.data).forEach((item) {
          skills.add(item.name);
        });
      }
    } catch (error) {
      print(error);
      CommonFunction.displayErrorDialog(context: context);
    }
  }

  @override
  initState() {
    super.initState();
    _register = widget.registrationData;
    print('***************** Data ');
    print(_register.permanentAddress.toString());
    loadCountries();
    loadSkills();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildStep1() {
      return Form(
        key: _formKeyStep1,
        child: Column(
          children: <Widget>[
            // MhtId
            TextInputField(
              enabled: false,
              labelText: 'Mht Id',
              valueText: _register.mhtId,
            ),
            // FullName
            TextInputField(
              enabled: false,
              labelText: 'Full Name',
              valueText:
                  '${_register.firstName} ${_register.middleName} ${_register.lastName}',
            ),
            // Mobile
            NumberInput(
              enabled: false,
              labelText: 'Mobile',
              valueText: _register.mobileNo1,
            ),
            // Email
            TextInputField(
              enabled: true,
              labelText: 'Email',
              valueText: _register.email,
            ),
            // Center
            NumberInput(
              enabled: false,
              labelText: 'Center',
              valueText: _register.center,
            ),
            // B_date
            DateInput(
              labelText: 'Birth Date',
              selectedDate: _register.bDate == null
                  ? DateTime.now()
                  : DateTime.parse(_register.bDate),
              selectDate: (DateTime date) {
                setState(() {
                  _register.bDate = dateFormatter.format(date);
                });
              },
            ),
            // G_date
            DateInput(
              labelText: 'Gnan Date',
              selectedDate: _register.gDate == null
                  ? DateTime.now()
                  : DateTime.parse(_register.gDate),
              selectDate: (DateTime date) {
                setState(() {
                  _register.gDate = dateFormatter.format(date);
                });
              },
            ),
            // Blood Group
            DropDownInput(
              items: ['A', 'A+', 'B', 'B+', 'AB', 'AB+', 'O', 'O+'],
              labelText: 'Blood Group',
              valueText: _register.bloodGroup,
              onChange: (value) {
                setState(() {
                  _register.bloodGroup = value;
                });
              },
            ),
            // T-shirt Size
            DropDownInput(
              items: ['S', 'M', 'XL', 'XXL', 'XXXL'],
              labelText: 'T-shirt Size',
              valueText: _register.tshirtSize,
              onChange: (value) {
                setState(() {
                  _register.tshirtSize = value;
                });
              },
            ),
            // Permenent Address
            new ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  isExpandedAddress[0] = !isExpandedAddress[0];
                });
              },
              children: [
                ExpansionPanel(
                  canTapOnHeader: true,
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Text('Permenent Address'),
                    );
                  },
                  isExpanded: isExpandedAddress[0],
                  body: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: <Widget>[
                        // Address Line 1
                        TextInputField(
                          enabled: false,
                          labelText: 'Address Line 1',
                          valueText: _register?.permanentAddress?.addressLine1,
                        ),
                        // Address Line 2
                        TextInputField(
                          enabled: false,
                          labelText: 'Address Line 2',
                          valueText: _register?.permanentAddress?.addressLine2,
                        ),
                        // City
                        TextInputField(
                          enabled: false,
                          labelText: 'City',
                          valueText: _register?.permanentAddress?.cityDisp,
                        ),
                        // State
                        TextInputField(
                          enabled: false,
                          labelText: 'State',
                          valueText: _register?.permanentAddress?.state,
                        ),
                        // Country
                        TextInputField(
                          enabled: false,
                          labelText: 'Country',
                          valueText: _register?.permanentAddress?.country,
                        ),
                        // Pincode
                        TextInputField(
                          enabled: false,
                          labelText: 'Pincode',
                          valueText: _register?.permanentAddress?.pincode,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Copy checkbox
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: <Widget>[
                  Text('Same as Permenent Address'),
                  Checkbox(
                    value: sameAsPermenentAddress,
                    onChanged: (value) {
                      setState(() {
                        sameAsPermenentAddress = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            // Current Address
            new ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                if (!sameAsPermenentAddress) {
                  setState(() {
                    isExpandedAddress[1] = !isExpandedAddress[1];
                  });
                }
              },
              children: [
                ExpansionPanel(
                  canTapOnHeader: true,
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Text('Current Address'),
                    );
                  },
                  isExpanded: isExpandedAddress[1],
                  body: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: <Widget>[
                        // Address Line 1
                        TextInputField(
                          enabled: !sameAsPermenentAddress,
                          labelText: 'Address Line 1',
                          valueText: sameAsPermenentAddress
                              ? _register?.permanentAddress?.addressLine1
                              : _register?.currentAddress?.addressLine1,
                        ),
                        // Address Line 2
                        TextInputField(
                          enabled: !sameAsPermenentAddress,
                          labelText: 'Address Line 2',
                          valueText: sameAsPermenentAddress
                              ? _register?.permanentAddress?.addressLine2
                              : _register?.currentAddress?.addressLine2,
                        ),
                        // City
                        TextInputField(
                          enabled: !sameAsPermenentAddress,
                          labelText: 'City',
                          valueText: sameAsPermenentAddress
                              ? _register?.permanentAddress?.cityDisp
                              : _register?.currentAddress?.cityDisp,
                        ),
                        // State
                        TextInputField(
                          enabled: !sameAsPermenentAddress,
                          labelText: 'State',
                          valueText: sameAsPermenentAddress
                              ? _register?.permanentAddress?.state
                              : _register?.currentAddress?.state,
                        ),
                        // Country
                        TextInputField(
                          enabled: !sameAsPermenentAddress,
                          labelText: 'Country',
                          valueText: sameAsPermenentAddress
                              ? _register?.permanentAddress?.country
                              : _register?.currentAddress?.country,
                        ),
                        // Pincode
                        TextInputField(
                          enabled: !sameAsPermenentAddress,
                          labelText: 'Pincode',
                          valueText: sameAsPermenentAddress
                              ? _register?.permanentAddress?.pincode
                              : _register?.currentAddress?.pincode,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Current Address
            Padding(
              padding: EdgeInsets.all(10),
              child: Text('Current Address'),
            ),
          ],
        ),
      );
    }

    Widget buildStep2() {
      return Form(
        key: _formKeyStep2,
        child: Column(
          children: <Widget>[
            // Father Name
            TextInputField(
              enabled: false,
              labelText: 'Father Name',
              valueText: _register.fatherName,
            ),
            // Father Gnan
            RadioInput(
              lableText: 'Is your Father taken gnan ? ',
              radioValue: _register.fatherGnan == 1,
              radioData: [
                {'lable': 'Yes', 'value': true},
                {'lable': 'No', 'value': false},
              ],
              handleRadioValueChange: (value) {
                setState(() {
                  _register.fatherGnan = value;
                });
              },
            ),
            // Father gnan date
            DateInput(
              labelText: 'Father Gnan Date',
              enable: _register.fatherGnan == 0 ? false : _register.fatherGnan,
              selectedDate: _register.fatherGDate == null
                  ? DateTime.now()
                  : DateTime.parse(_register.fatherGDate),
              selectDate: (DateTime date) {
                setState(() {
                  _register.fatherGDate = dateFormatter.format(date);
                });
              },
            ),
            // Father MBA approval
            RadioInput(
              lableText: 'Father MBA Approval',
              radioValue: _register.fatherMbaApproval == 1,
              radioData: [
                {'lable': 'Yes', 'value': true},
                {'lable': 'No', 'value': false},
              ],
              handleRadioValueChange: (value) {
                setState(() {
                  _register.fatherMbaApproval = value;
                });
              },
            ),
            // Mother Name
            TextInputField(
              enabled: false,
              labelText: 'Mother Name',
              valueText: _register.motherName,
            ),
            // Mother Gnan
            RadioInput(
              lableText: 'Is your Mother taken gnan ? ',
              radioValue: _register.motherGnan == 1,
              radioData: [
                {'lable': 'Yes', 'value': true},
                {'lable': 'No', 'value': false},
              ],
              handleRadioValueChange: (value) {
                setState(() {
                  _register.motherGnan = value;
                });
              },
            ),
            // Mother gnan date
            DateInput(
              labelText: 'Mother Gnan Date',
              enable: _register.motherGnan == 0 ? false : _register.motherGnan,
              selectedDate: _register.motherGDate == null
                  ? DateTime.now()
                  : DateTime.parse(_register.motherGDate),
              selectDate: (DateTime date) {
                setState(() {
                  _register.motherGDate = dateFormatter.format(date);
                });
              },
            ),
            // Mother MBA approval
            RadioInput(
              lableText: 'Mother MBA Approval',
              radioValue: _register.motherMbaApproval == 1,
              radioData: [
                {'lable': 'Yes', 'value': true},
                {'lable': 'No', 'value': false},
              ],
              handleRadioValueChange: (value) {
                setState(() {
                  _register.motherMbaApproval = value;
                });
              },
            ),
            // Brother Count
            DropDownInput(
              items: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
              labelText: 'No. of Brother(s)',
              valueText: _register.brotherCount,
              onChange: (value) {
                setState(() {
                  _register.brotherCount = value;
                });
              },
            ),
            // Sister Count
            DropDownInput(
              items: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
              labelText: 'No. of Sister(s)',
              valueText: _register.sisterCount,
              onChange: (value) {
                setState(() {
                  _register.sisterCount = value;
                });
              },
            ),
          ],
        ),
      );
    }

    Widget buildStep3() {
      return Form(
        key: _formKeyStep3,
        child: Column(
          children: <Widget>[
            // Education Qualification
            DropDownInput(
              items: ['Test1', 'Test2'],
              labelText: 'Education Qualification',
              valueText: _register.studyDetail,
              onChange: (value) {
                setState(() {
                  _register.studyDetail = value;
                });
              },
            ),
            // Occupation
            RadioInput(
              lableText: 'Occupation',
              radioValue: _register.occupation,
              radioData: [
                {'lable': 'Job', 'value': 'Job'},
                {'lable': 'Business', 'value': 'Business'},
                {'lable': 'Seva', 'value': 'Seva'},
                {'lable': 'N/A', 'value': 'N/A'},
              ],
              handleRadioValueChange: (value) {
                setState(() {
                  _register.occupation = value;
                });
              },
            ),
            // Job/Business Start Date
            DateInput(
              labelText: 'Job/Business Start Date',
              selectedDate: _register.jobStartDate == null
                  ? DateTime.now()
                  : DateTime.parse(_register.jobStartDate),
              selectDate: (DateTime date) {
                setState(() {
                  _register.jobStartDate = dateFormatter.format(date);
                });
              },
            ),
            // Skills
            ComboboxInput(
              lableText: 'Skills',
              listData: skills,
              selectedData: _register.skills,
              handleValueSelect: (value) {
                print('onselect : $value');
                setState(() {
                  _register.skills.add(value);
                  skills.remove(value);
                });
              },
              onDelete: (value) {
                setState(() {
                  _register.skills.remove(value);
                  skills.add(value);
                });
              },
            ),
            // Work City
            DropDownInput(
              items: ['Ahmedabad', 'Gandhinagar'],
              labelText: 'Work city',
              valueText: _register.workCity,
              onChange: (value) {
                setState(() {
                  _register.workCity = value;
                });
              },
            ),
            // Comapny Name
            TextInputField(
              labelText: 'Comapny Name',
              valueText: _register.companyName,
            ),
            // Health Name
            TextInputField(
              labelText: 'Health',
              valueText: _register.health,
            ),
            // Remarks Name
            TextInputField(
              labelText: 'Remarks',
              valueText: _register.personalNotes,
            ),
          ],
        ),
      );
    }

    registrationSteps = [
      Step(
        title: Text('Step : 1'),
        content: buildStep1(),
        isActive: true,
        subtitle: Text('Personal Information'),
      ),
      Step(
        title: Text('Step : 2'),
        content: buildStep2(),
        isActive: true,
        subtitle: Text('Family Information'),
      ),
      Step(
        title: Text('Step : 3'),
        content: buildStep3(),
        isActive: true,
        subtitle: Text('Professional Information'),
      ),
    ];

    Widget home = Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: SafeArea(
        child: Stepper(
          currentStep: currantStep,
          onStepContinue: () {
            setState(() {
              if (currantStep < registrationSteps.length - 1) {
                currantStep += 1;
              } else {
                currantStep = 0;
              }
            });
          },
          onStepTapped: (value) {
            setState(() {
              currantStep = value;
            });
          },
          steps: registrationSteps,
        ),
      ),
    );

    return home;
  }
}
