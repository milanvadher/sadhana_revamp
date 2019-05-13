import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sadhana/common.dart';

class RegistrationPage extends StatefulWidget {
  static const String routeName = '/registration';

  @override
  RegistrationPageState createState() => RegistrationPageState();
}

class RegistrationPageState extends State<RegistrationPage> {
  final _formKeyStep1 = GlobalKey<FormState>();
  DateTime bDate = DateTime.now();
  DateTime gDate = DateTime.now();
  int currantStep = 0;
  List<Step> registrationSteps = [];

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildStep1() {
      return Form(
        key: _formKeyStep1,
        child: Column(
          children: <Widget>[
            // MhtId
            _FormInput(
              keyboardType: TextInputType.text,
              enabled: false,
              labelText: 'Mht Id',
              valueText: '129719',
            ),
            // FirstName
            _FormInput(
              keyboardType: TextInputType.text,
              enabled: false,
              labelText: 'First name',
              valueText: 'Milan',
            ),
            // MiddleName
            _FormInput(
              keyboardType: TextInputType.text,
              enabled: false,
              labelText: 'Middle name',
              valueText: 'D',
            ),
            // LastName
            _FormInput(
              keyboardType: TextInputType.text,
              enabled: false,
              labelText: 'Last name',
              valueText: 'Vadher',
            ),
            // DOB
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              alignment: Alignment.bottomLeft,
              child: _DatePicker(
                labelText: 'DOB',
                selectedDate: bDate,
                selectDate: (DateTime date) {
                  setState(() {
                    bDate = date;
                  });
                },
              ),
            ),
            // G_date
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              alignment: Alignment.bottomLeft,
              child: _DatePicker(
                labelText: 'Ganan Date',
                selectedDate: gDate,
                selectDate: (DateTime date) {
                  setState(() {
                    gDate = date;
                  });
                },
              ),
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
          subtitle: Text('Basic Information')),
      Step(
          title: Text('Step : 2'),
          content: Text('MBA Information'),
          isActive: true,
          subtitle: Text('MBA Information')),
      Step(
          title: Text('Step : 3'),
          content: Text('Other Information'),
          isActive: true,
          subtitle: Text('Other Information')),
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
    return Row(
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
        decoration:
            InputDecoration(labelText: labelText, border: OutlineInputBorder()),
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

class _FormInput extends StatelessWidget {
  const _FormInput({
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
          decoration: InputDecoration(
              labelText: labelText, border: OutlineInputBorder()),
          initialValue: valueText,
          enabled: enabled,
          keyboardType: keyboardType),
    );
  }
}
