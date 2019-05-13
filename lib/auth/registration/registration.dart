import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sadhana/common.dart';
import 'package:sadhana/model/register.dart';

class RegistrationPage extends StatefulWidget {
  static const String routeName = '/registration';

  @override
  RegistrationPageState createState() => RegistrationPageState();
}

class RegistrationPageState extends State<RegistrationPage> {
  final _register = Register();
  final _formKeyStep1 = GlobalKey<FormState>();
  final _formKeyStep2 = GlobalKey<FormState>();
  DateTime bDate = DateTime.now();
  DateTime gDate = DateTime.now();
  int currantStep = 0;
  List<Step> registrationSteps = [];

  @override
  initState() {
    super.initState();
    _register.mhtId = '123456';
    _register.firstName = 'Milan';
    _register.middleName = 'D';
    _register.lastName = 'Vadher';
    _register.bDate = DateTime.now();
    _register.gDate = DateTime.now();
    _register.email = 'milandv06@gmail.com';
    _register.mobileNos = [1234567890, 1234567890];
    _register.fatherName = 'D';
    _register.center = 'Sim-City';
  }

  @override
  Widget build(BuildContext context) {
    Widget buildStep1() {
      return Form(
        key: _formKeyStep1,
        child: Column(
          children: <Widget>[
            // MhtId
            _FormTextInput(
              keyboardType: TextInputType.text,
              enabled: false,
              labelText: 'Mht Id',
              valueText: _register.mhtId,
            ),
            // FirstName
            _FormTextInput(
              keyboardType: TextInputType.text,
              enabled: false,
              labelText: 'First name',
              valueText: _register.firstName,
            ),
            // MiddleName
            _FormTextInput(
              keyboardType: TextInputType.text,
              enabled: false,
              labelText: 'Middle name',
              valueText: _register.middleName,
            ),
            // LastName
            _FormTextInput(
              keyboardType: TextInputType.text,
              enabled: false,
              labelText: 'Last name',
              valueText: _register.lastName,
            ),
            // DOB
            _DatePicker(
              labelText: 'DOB',
              selectedDate: bDate,
              selectDate: (DateTime date) {
                setState(() {
                  _register.bDate = date;
                });
              },
            ),
            // G_date
            _DatePicker(
              labelText: 'Ganan Date',
              selectedDate: gDate,
              selectDate: (DateTime date) {
                setState(() {
                  _register.gDate = date;
                });
              },
            ),
            // Mobile1
            _FormNumberInput(
              keyboardType: TextInputType.number,
              enabled: false,
              labelText: 'Mobile 1',
              valueText: _register.mobileNos.length > 0 ? _register.mobileNos[0].toString() : "",
            ),
            // Mobile2
            _FormNumberInput(
              keyboardType: TextInputType.number,
              enabled: true,
              labelText: 'Mobile 2',
              valueText: _register.mobileNos.length > 1 ? _register.mobileNos[1].toString() : "",
            ),
            // Email
            _FormTextInput(
              keyboardType: TextInputType.emailAddress,
              enabled: true,
              labelText: 'Email',
              valueText: _register.email,
            ),
            // FatherName
            _FormTextInput(
              keyboardType: TextInputType.text,
              enabled: true,
              labelText: 'Father Name',
              valueText: _register.fatherName,
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
            // Center
            _FormNumberInput(
              keyboardType: TextInputType.text,
              enabled: false,
              labelText: 'Center',
              valueText: _register.center,
            ),
          ],
        ),
      );
    }

    registrationSteps = [
      Step(title: Text('Step : 1'), content: buildStep1(), isActive: true, subtitle: Text('Basic Information')),
      Step(title: Text('Step : 2'), content: buildStep2(), isActive: true, subtitle: Text('MBA Information')),
      Step(title: Text('Step : 3'), content: Text('Other Information'), isActive: true, subtitle: Text('Other Information')),
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
            print('Register Data :: ${_register.mobileNos}');
            setState(() {
              if (currantStep < registrationSteps.length - 1) {
                currantStep += 1;
              } else {
                currantStep = 0;
              }
            });
          },
          steps: registrationSteps,
        ),
      ),
    );

    return home;
  }
}

class _DatePicker extends StatelessWidget {
  const _DatePicker({
    Key key,
    this.labelText,
    this.selectedDate,
    this.selectDate,
  }) : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final ValueChanged<DateTime> selectDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1950, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) selectDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      alignment: Alignment.bottomLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: _InputDate(
              labelText: labelText,
              valueText: DateFormat.yMMMd().format(selectedDate),
              onPressed: () {
                _selectDate(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _InputDate extends StatelessWidget {
  const _InputDate({
    Key key,
    this.child,
    this.labelText,
    this.valueText,
    this.onPressed,
  }) : super(key: key);

  final String labelText;
  final String valueText;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(labelText: labelText, border: OutlineInputBorder()),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(valueText),
            Icon(Icons.today, size: 20),
          ],
        ),
      ),
    );
  }
}

class _FormTextInput extends StatelessWidget {
  const _FormTextInput({
    Key key,
    this.labelText,
    this.valueText,
    this.enabled,
    this.keyboardType,
  }) : super(key: key);

  final String labelText;
  final String valueText;
  final bool enabled;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      alignment: Alignment.bottomLeft,
      child: TextFormField(
        decoration: InputDecoration(labelText: labelText, border: OutlineInputBorder()),
        initialValue: valueText,
        enabled: enabled,
        keyboardType: keyboardType,
        onSaved: (value) {
          return value;
        },
        validator: (value) {
          if (value.isEmpty) {
            return labelText + ' is required';
          }
        },
      ),
    );
  }
}

class _FormNumberInput extends StatelessWidget {
  _FormNumberInput({
    Key key,
    this.labelText,
    this.valueText,
    this.enabled,
    this.keyboardType,
  }) : super(key: key);

  final String labelText;
  String valueText;
  final bool enabled;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      alignment: Alignment.bottomLeft,
      child: TextFormField(
        decoration: InputDecoration(labelText: labelText, border: OutlineInputBorder()),
        initialValue: valueText,
        enabled: enabled,
        keyboardType: keyboardType,
        onSaved: (value) {
          valueText = value;
        },
        validator: (value) {
          if (value.isEmpty) {
            return labelText + ' is required';
          }
        },
      ),
    );
  }
}
