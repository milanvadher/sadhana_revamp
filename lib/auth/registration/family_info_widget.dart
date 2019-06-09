import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sadhana/auth/registration/Inputs/date-input.dart';
import 'package:sadhana/auth/registration/Inputs/dropdown-input.dart';
import 'package:sadhana/auth/registration/Inputs/radio-input.dart';
import 'package:sadhana/auth/registration/Inputs/text-input.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/model/register.dart';

class FamilyInfoWidget extends StatefulWidget {
  final Register register;
  final Function startLoading;
  final Function stopLoading;
  const FamilyInfoWidget({
    Key key,
    @required this.register,
    @required this.startLoading,
    @required this.stopLoading,
  }) : super(key: key);
  @override
  _FamilyInfoWidgetState createState() => _FamilyInfoWidgetState();
}

class _FamilyInfoWidgetState extends State<FamilyInfoWidget> {
  Register _register;
  var dateFormatter = new DateFormat(WSConstant.DATE_FORMAT);
  @override
  Widget build(BuildContext context) {
    _register = widget.register;
    return Column(
      children: <Widget>[
        TextInputField(
          enabled: true,
          labelText: 'Father Name',
          valueText: _register.fatherName,
        ),
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
        DateInput(
          labelText: 'Father Gnan Date',
          enable: _register.fatherGnan == 0 ? false : true,
          selectedDate: _register.fatherGDate == null ? null : DateTime.parse(_register.fatherGDate),
          selectDate: (DateTime date) {
            setState(() {
              _register.fatherGDate = dateFormatter.format(date);
            });
          },
        ),
        TextInputField(
          enabled: true,
          labelText: 'Mother Name',
          valueText: _register.motherName,
        ),
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
        DateInput(
          labelText: 'Mother Gnan Date',
          enable: _register.motherGnan == 0 ? false : true,
          selectedDate: _register.motherGDate == null ? null : DateTime.parse(_register.motherGDate),
          selectDate: (DateTime date) {
            setState(() {
              _register.motherGDate = dateFormatter.format(date);
            });
          },
        ),
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
    );
  }
}
