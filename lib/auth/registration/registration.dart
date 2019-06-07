import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:sadhana/auth/registration/Inputs/address_input.dart';
import 'package:sadhana/auth/registration/Inputs/combobox-input.dart';
import 'package:sadhana/auth/registration/Inputs/date-input.dart';
import 'package:sadhana/auth/registration/Inputs/dropdown-input.dart';
import 'package:sadhana/auth/registration/Inputs/number-input.dart';
import 'package:sadhana/auth/registration/Inputs/radio-input.dart';
import 'package:sadhana/auth/registration/Inputs/text-input.dart';
import 'package:sadhana/comman.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/model/city.dart';
import 'package:sadhana/model/country.dart';
import 'package:sadhana/model/register.dart';
import 'package:intl/intl.dart';
import 'package:sadhana/model/skill.dart';
import 'package:sadhana/model/state.dart';
import 'package:sadhana/sadhana/home.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/app_response_parser.dart';
import 'package:sadhana/widgets/base_state.dart';
import 'package:sadhana/wsmodel/appresponse.dart';

class RegistrationPage extends StatefulWidget {
  static const String routeName = '/registration';
  final Register registrationData;

  RegistrationPage({@required this.registrationData});

  @override
  RegistrationPageState createState() => RegistrationPageState();
}

class RegistrationPageState extends BaseState<RegistrationPage> {
  Register _register = new Register();
  ApiService api = new ApiService();
  var dateFormatter = new DateFormat('yyyy-MM-dd');
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();
  final _formKeyStep3 = GlobalKey<FormState>();
  int currentStep = 0;
  bool sameAsPermanentAddress = false;
  List<Step> registrationSteps = [];
  List<String> skills = [];
  List<String> countryList = [];
  List<bool> isExpandedAddress = [true, false];
  bool _autoValidate = false;

  @override
  initState() {
    super.initState();
    _register = widget.registrationData;
    print('***************** Data ');
    print(_register.permanentAddress.toString());
    loadCountries();
    loadSkills();
    //_register.holidays = ['SAT', 'SUN'];
  }

  loadCountries() async {
    try {
      Response res = await api.getAllCountries();
      AppResponse appResponse =
          AppResponseParser.parseResponse(res, context: context);
      if (appResponse.status == WSConstant.SUCCESS_CODE) {
        countryList = [];
        setState(() {
          Country.fromJsonList(appResponse.data).forEach((item) {
            countryList.add(item.name);
          });
        });
      }
    } catch (error, s) {
      print(error);
      print(s);
      CommonFunction.displayErrorDialog(context: context);
    }
  }

  loadSkills() async {
    try {
      Response res = await api.getSkills();
      AppResponse appResponse =
          AppResponseParser.parseResponse(res, context: context);
      if (appResponse.status == WSConstant.SUCCESS_CODE) {
        Skills.fromJsonList(appResponse.data)
            .forEach((item) => skills.add(item.name));
      }
    } catch (error, s) {
      print(error);
      print(s);
      CommonFunction.displayErrorDialog(context: context);
    }
  }

  @override
  Widget pageToDisplay() {
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
          currentStep: currentStep,
          onStepContinue: () {
            setState(() {
              if (currentStep < registrationSteps.length - 1) {
                switch (currentStep) {
                  case 0:
                    if (!_formKeyStep1.currentState.validate()) {
                      return;
                    }
                    _formKeyStep1.currentState.save();
                    if (sameAsPermanentAddress)
                      _register.currentAddress = _register.permanentAddress;
                    break;
                  case 1:
                    if (!_formKeyStep2.currentState.validate()) {
                      return;
                    }
                    _formKeyStep2.currentState.save();
                }
                currentStep += 1;
              } else {
                if (_formKeyStep3.currentState.validate()) {
                  _formKeyStep3.currentState.save();
                  register();
                }

                //currantStep = 0;
              }
              print(_register);
            });
          },
          onStepTapped: (value) {
            setState(() {
              currentStep = value;
            });
          },
          steps: registrationSteps,
        ),
      ),
    );

    return home;
  }

  Widget buildStep1() {
    return Form(
      key: _formKeyStep1,
      autovalidate: _autoValidate,
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
                '${_register.firstName} ${_register.middleName ?? ""} ${_register.lastName}',
          ),
          // Mobile
          NumberInput(
            enabled: false,
            labelText: 'Mobile',
            valueText: _register.mobileNo1,
          ),
          NumberInput(
            labelText: 'Alternate Mobile',
            valueText: _register.mobileNo2,
          ),
          // Email
          TextInputField(
            enabled: true,
            labelText: 'Email',
            valueText: _register.email,
            onSaved: (value) => _register.email = value,
          ),
          // Center
          TextInputField(
            enabled: false,
            labelText: 'Center',
            valueText: _register.center,
          ),
          // B_date
          DateInput(
            labelText: 'Birth Date',
            selectedDate: _register.bDate == null
                ? null
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
                ? null
                : DateTime.parse(_register.gDate),
            selectDate: (DateTime date) {
              setState(() {
                _register.gDate = dateFormatter.format(date);
              });
            },
          ),
          // Blood Group
          DropDownInput(
            items: ['A-', 'A+', 'B-', 'B+', 'AB-', 'AB+', 'O-', 'O+'],
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
            items: ['S', 'M', 'L', 'XL', 'XXL', 'XXXL'],
            labelText: 'T-shirt Size',
            valueText: _register.tshirtSize,
            onChange: (value) {
              setState(() {
                _register.tshirtSize = value;
              });
            },
          ),
          // Permanent Address
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
                  return ListTile(title: Text('Permanent Address'));
                },
                isExpanded: isExpandedAddress[0],
                body: AddressInput(
                  address: _register.permanentAddress,
                  countryList: countryList,
                  startLoading: startLoading,
                  stopLoading: stopLoading,
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
                  value: sameAsPermanentAddress,
                  onChanged: (value) {
                    setState(() {
                      sameAsPermanentAddress = value;
                      isExpandedAddress[1] = false;
                    });
                  },
                ),
              ],
            ),
          ),
          // Current Address
          new ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              if (!sameAsPermanentAddress) {
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
                body: isExpandedAddress[1] ? AddressInput(
                  address: _register.currentAddress,
                  countryList: countryList,
                  startLoading: startLoading,
                  stopLoading: stopLoading,
                ) : Container(),
              ),
            ],
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
            radioValue: _register.fatherGnan,
            radioData: [
              {'lable': 'Yes', 'value': 1},
              {'lable': 'No', 'value': 0},
            ],
            handleRadioValueChange: (value) {
              setState(() {
                _register.fatherGnan = value;
                if (_register.fatherGnan == 0) _register.fatherGDate = null;
              });
            },
          ),
          // Father gnan date
          DateInput(
            labelText: 'Father Gnan Date',
            enable: _register.fatherGnan == 0 ? false : true,
            selectedDate: _register.fatherGDate == null
                ? null
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
            radioValue: _register.fatherMbaApproval,
            radioData: [
              {'lable': 'Yes', 'value': 1},
              {'lable': 'No', 'value': 0},
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
            radioValue: _register.motherGnan,
            radioData: [
              {'lable': 'Yes', 'value': 1},
              {'lable': 'No', 'value': 0},
            ],
            handleRadioValueChange: (value) {
              setState(() {
                _register.motherGnan = value;
                if (_register.motherGnan == 0) _register.motherGDate = null;
              });
            },
          ),
          // Mother gnan date
          DateInput(
            labelText: 'Mother Gnan Date',
            enable: _register.motherGnan == 0 ? false : true,
            selectedDate: _register.motherGDate == null
                ? null
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
            radioValue: _register.motherMbaApproval,
            radioData: [
              {'lable': 'Yes', 'value': 1},
              {'lable': 'No', 'value': 0},
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
          /*DropDownInput(
            items: ["Bachelor"],
            labelText: 'Education Qualification',
            valueText: _register.studyDetail,
            onChange: (value) {
              setState(() {
                _register.studyDetail = value;
              });
            },
          ),*/
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
                ? null
                : DateTime.parse(_register.jobStartDate),
            selectDate: (DateTime date) {
              setState(() {
                _register.jobStartDate = dateFormatter.format(date);
              });
            },
          ),
          // No of Holidays
          Container(  
            child: ListTile(
              title: Text('Weekly off in your Job/Occupation/Business'),
              contentPadding: EdgeInsets.only(left: 5),
            ),
          ),
          // No of holiday
          Container(
            child: Wrap(
                children: List.generate(Constant.weekName.length, (int index) {
              return Column(
                children: <Widget>[
                  Text(Constant.weekName[index]),
                  Checkbox(
                    onChanged: (value) {
                      setState(() {
                        if (value) {
                          _register.holidays.add(Constant.weekName[index]);
                        } else {
                          _register.holidays.remove(Constant.weekName[index]);
                        }
                      });
                    },
                    value:
                        _register.holidays.contains(Constant.weekName[index]),
                  )
                ],
              );
            })),
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
          // Comapny Name
          TextInputField(
            labelText: 'Comapny Name',
            valueText: _register.companyName,
            onSaved: (value) => _register.companyName = value,
          ),
          // Health Name
          TextInputField(
            labelText: 'Health',
            valueText: _register.health,
            onSaved: (value) => _register.health = value,
          ),
          // Remarks Name
          TextInputField(
            labelText: 'Remarks',
            valueText: _register.personalNotes,
            onSaved: (value) => _register.personalNotes = value,
          ),
        ],
      ),
    );
  }

  void register() async {
    startLoading();
    try {
      print(_register.toJson());
      Response res = await api.generateToken(_register.mhtId);
      AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
      if (appResponse.status == WSConstant.SUCCESS_CODE) {
        if (appResponse.data != null &&
            appResponse.data.toString().isNotEmpty) {
          _register.token = appResponse.data;
          res = await api.register(_register);
          appResponse = AppResponseParser.parseResponse(res, context: context);
          if (appResponse.status == WSConstant.SUCCESS_CODE) {
            CommonFunction.registerUser(register: _register);
            Navigator.pushReplacementNamed(context, HomePage.routeName);
          }
        }
      }
    } catch (e, s) {
      print(e);
      print(s);
      CommonFunction.displayErrorDialog(context: context);
    }
    stopLoading();
    //}
  }
}
