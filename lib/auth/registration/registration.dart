import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sadhana/auth/registration/Inputs/combobox-input.dart';
import 'package:sadhana/auth/registration/Inputs/date-input.dart';
import 'package:sadhana/auth/registration/Inputs/dropdown-input.dart';
import 'package:sadhana/auth/registration/Inputs/number-input.dart';
import 'package:sadhana/auth/registration/Inputs/radio-input.dart';
import 'package:sadhana/auth/registration/Inputs/text-input.dart';
import 'package:sadhana/model/register.dart';
import 'package:intl/intl.dart';

class RegistrationPage extends StatefulWidget {
  static const String routeName = '/registration';

  @override
  RegistrationPageState createState() => RegistrationPageState();
}

class RegistrationPageState extends State<RegistrationPage> {
  final _register = Register();
  var dateFormatter = new DateFormat('yyyy-MM-dd');
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();
  final _formKeyStep3 = GlobalKey<FormState>();
  List<String> skills = [];
  int currantStep = 0;
  List<Step> registrationSteps = [];

  @override
  initState() {
    super.initState();
    _register.mhtId = '123456';
    _register.fullName = '${_register.firstName} ${_register.middleName} ${_register.lastName}';
    _register.bDate = '2018-05-20';
    _register.gDate = '2018-05-20';
    _register.email = 'milandv06@gmail.com';
    _register.mobileNo1 = "1234567890";
    _register.fatherName = 'D';
    _register.center = 'Sim-City';
    _register.fatherMbaApproval = 0;
    _register.motherMbaApproval = 1;
    _register.skills = [];
    skills.add('Skill 1');
    skills.add('Skill 2');
    skills.add('Skill 3');
    skills.add('Skill 4');
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
              valueText: '${_register.firstName} ${_register.middleName} ${_register.lastName}',
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
              selectedDate:
                  _register.bDate == null ? DateTime.now() : dateFormatter.parse(_register.bDate),
              selectDate: (DateTime date) {
                setState(() {
                  _register.bDate = dateFormatter.format(date);
                });
              },
            ),
            // G_date
            DateInput(
              labelText: 'Gnan Date',
              selectedDate:
                  _register.gDate == null ? DateTime.now() : _register.gDate,
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
            Text('Address Come here'),
            // TODO : address (P/T)
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
              enable:
                  _register.fatherGnan == null ? false : _register.fatherGnan,
              selectedDate: _register.fatherGDate == null
                  ? DateTime.now()
                  : _register.fatherGDate,
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
              radioValue: _register.motherGnan,
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
              enable:
                  _register.motherGnan == null ? false : _register.motherGnan,
              selectedDate: _register.motherGDate == null
                  ? DateTime.now()
                  : _register.motherGDate,
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
                  : _register.jobStartDate,
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
            _formKeyStep1.currentState.save();
            _formKeyStep2.currentState.save();
            _formKeyStep3.currentState.save();
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
