import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:sadhana/auth/registration/Inputs/combobox-input.dart';
import 'package:sadhana/auth/registration/Inputs/date-input.dart';
import 'package:sadhana/auth/registration/Inputs/dropdown-input.dart';
import 'package:sadhana/auth/registration/Inputs/radio-input.dart';
import 'package:sadhana/auth/registration/Inputs/text-input.dart';
import 'package:sadhana/common.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/model/education.dart';
import 'package:sadhana/model/jobinfo.dart';
import 'package:sadhana/model/register.dart';
import 'package:sadhana/model/skill.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/app_response_parser.dart';
import 'package:sadhana/utils/apputils.dart';
import 'package:sadhana/wsmodel/appresponse.dart';

class JobInfoWidget extends StatefulWidget {
  final JobInfo jobInfo;
  final bool viewMode;
  const JobInfoWidget({
    Key key,
    @required this.jobInfo,
    this.viewMode = false,
  }) : super(key: key);

  @override
  _JobInfoWidgetState createState() => _JobInfoWidgetState();
}

class _JobInfoWidgetState extends State<JobInfoWidget> {
  JobInfo _register;
  var dateFormatter = new DateFormat(WSConstant.DATE_FORMAT);
  ApiService api = new ApiService();
  List<String> skills = [];
  List<String> educations = [];
  bool viewMode;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    _register = widget.jobInfo;
    viewMode = widget.viewMode;
    return Column(
      children: <Widget>[
        RadioInput(
          labelText: 'Occupation',
          radioValue: _register.occupation,
          viewMode: viewMode,
          radioData: [
            {'label': 'Job', 'value': 'Job'},
            {'label': 'Business', 'value': 'Business'},
            {'label': 'Seva', 'value': 'Seva'},
            {'label': 'N/A', 'value': 'N/A'},
          ],
          handleRadioValueChange: (value) {
            setState(() {
              _register.occupation = value;
            });
          },
        ),
        DateInput(
          labelText: 'Job/Business Start Date',
          viewMode: viewMode,
          selectedDate: _register.jobStartDate,
          selectDate: (DateTime date) {
            setState(() {
              _register.jobStartDate = date;
            });
          },
        ),
        TextInputField(
          labelText: 'Work City',
          viewMode: viewMode,
          valueText: _register.workCity,
          onSaved: (value) => _register.workCity = value,
          isRequiredValidation: true,
        ),
        TextInputField(
          labelText: 'Company Name',
          viewMode: viewMode,
          valueText: _register.companyName,
          onSaved: (value) => _register.companyName = value,
        ),
      ],
    );
  }
}
