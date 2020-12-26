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
  final bool viewMode;
  final bool profileEdit;
  const FamilyInfoWidget({
    Key key,
    @required this.register,
    @required this.startLoading,
    @required this.stopLoading,
    this.viewMode = false,
    this.profileEdit = false,
  }) : super(key: key);
  @override
  _FamilyInfoWidgetState createState() => _FamilyInfoWidgetState();
}

class _FamilyInfoWidgetState extends State<FamilyInfoWidget> {
  Register _register;
  var dateFormatter = new DateFormat(WSConstant.DATE_FORMAT);
  bool viewMode;
  double viewModeTitleWidth = 120;
  @override
  Widget build(BuildContext context) {
    _register = widget.register;
    viewMode = widget.viewMode;
    return Column(
      children: <Widget>[
        widget.profileEdit ? Container() : TextInputField(
          enabled: true,
          labelText: 'Father Name',
          isRequiredValidation: true,
          valueText: _register.fatherName,
          onSaved: (value) => _register.fatherName = value,
          viewMode: viewMode,
          viewModeTitleWidth: viewModeTitleWidth,
        ),
        RadioInput(
          labelText: 'Father MBA Approval',
          radioValue: _register.fatherMbaApproval,
          viewMode: viewMode,
          viewModeTitleWidth: viewModeTitleWidth,
          radioData: [
            {'label': 'Yes', 'value': 1},
            {'label': 'No', 'value': 0},
          ],
          handleRadioValueChange: (value) {
            setState(() {
              _register.fatherMbaApproval = value;
            });
          },
        ),
        RadioInput(
          labelText: 'Has your Father taken gnan ? ',
          radioValue: _register.fatherGnan,
          viewMode: viewMode,
          viewModeTitleWidth: viewModeTitleWidth,
          radioData: [
            {'label': 'Yes', 'value': 1},
            {'label': 'No', 'value': 0},
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
          viewMode: viewMode,
          viewModeTitleWidth: viewModeTitleWidth,
          isRequiredValidation: _register.fatherGnan == 0 ? false : true,
          enable: _register.fatherGnan == 0 ? false : true,
          selectedDate: _register.fatherGDate == null ? null : DateTime.parse(_register.fatherGDate),
          selectDate: (DateTime date) {
            setState(() {
              _register.fatherGDate = dateFormatter.format(date);
            });
          },
        ),
        widget.profileEdit ? Container() : TextInputField(
          enabled: true,
          labelText: 'Mother Name',
          viewMode: viewMode,
          viewModeTitleWidth: viewModeTitleWidth,
          isRequiredValidation: true,
          valueText: _register.motherName,
          onSaved: (value) => _register.motherName = value,
        ),
        RadioInput(
          labelText: 'Mother MBA Approval',
          radioValue: _register.motherMbaApproval,
          viewMode: viewMode,
          viewModeTitleWidth: viewModeTitleWidth,
          radioData: [
            {'label': 'Yes', 'value': 1},
            {'label': 'No', 'value': 0},
          ],
          handleRadioValueChange: (value) {
            setState(() {
              _register.motherMbaApproval = value;
            });
          },
        ),
        RadioInput(
          labelText: 'Has your Mother taken gnan ? ',
          radioValue: _register.motherGnan,
          viewMode: viewMode,
          viewModeTitleWidth: viewModeTitleWidth,
          radioData: [
            {'label': 'Yes', 'value': 1},
            {'label': 'No', 'value': 0},
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
          viewMode: viewMode,
          viewModeTitleWidth: viewModeTitleWidth,
          isRequiredValidation: _register.motherGnan == 0 ? false : true,
          enable: _register.motherGnan == 0 ? false : true,
          selectedDate: _register.motherGDate == null ? null : DateTime.parse(_register.motherGDate),
          selectDate: (DateTime date) {
            setState(() {
              _register.motherGDate = dateFormatter.format(date);
            });
          },
        ),
        widget.profileEdit ? Container() : DropDownInput(
          items: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
          labelText: 'No. of Brother(s)',
          valueText: _register.brotherCount,
          viewMode: viewMode,
          viewModeTitleWidth: viewModeTitleWidth,
          onChange: (value) {
            setState(() {
              _register.brotherCount = value;
            });
          },
        ),
        // Sister Count
        widget.profileEdit ? Container() : DropDownInput(
          items: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
          labelText: 'No. of Sister(s)',
          valueText: _register.sisterCount,
          viewMode: viewMode,
          viewModeTitleWidth: viewModeTitleWidth,
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
