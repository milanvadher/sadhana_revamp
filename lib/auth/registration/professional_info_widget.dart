import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:sadhana/auth/registration/Inputs/combobox-input.dart';
import 'package:sadhana/auth/registration/Inputs/date-input.dart';
import 'package:sadhana/auth/registration/Inputs/dropdown-input.dart';
import 'package:sadhana/auth/registration/Inputs/radio-input.dart';
import 'package:sadhana/auth/registration/Inputs/text-input.dart';
import 'package:sadhana/comman.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/model/education.dart';
import 'package:sadhana/model/register.dart';
import 'package:sadhana/model/skill.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/app_response_parser.dart';
import 'package:sadhana/wsmodel/appresponse.dart';

class ProfessionalInfoWidget extends StatefulWidget {
  final Register register;
  final Function startLoading;
  final Function stopLoading;

  const ProfessionalInfoWidget({
    Key key,
    @required this.register,
    @required this.startLoading,
    @required this.stopLoading,
  }) : super(key: key);

  @override
  _ProfessionalInfoWidgetState createState() => _ProfessionalInfoWidgetState();
}

class _ProfessionalInfoWidgetState extends State<ProfessionalInfoWidget> {
  Register _register;
  var dateFormatter = new DateFormat(WSConstant.DATE_FORMAT);
  ApiService api = new ApiService();
  List<String> skills = [];
  List<String> educations = [];
  @override
  void initState() {
    super.initState();
    loadSkills();
    loadEducation();
  }

  loadSkills() async {
    try {
      Response res = await api.getSkills();
      AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
      if (appResponse.status == WSConstant.SUCCESS_CODE) {
        setState(() {
          Skills.fromJsonList(appResponse.data).forEach((item) => skills.add(item.name));
        });

      }
    } catch (error, s) {
      print(error);
      print(s);
      CommonFunction.displayErrorDialog(context: context);
    }
  }

  loadEducation() async {
    try {
      Response res = await api.getEducations();
      AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
      if (appResponse.status == WSConstant.SUCCESS_CODE) {
        setState(() {
          Education.fromJsonList(appResponse.data).forEach((item) => educations.add(item.education));
        });
      }
    } catch (error, s) {
      print(error);
      print(s);
      CommonFunction.displayErrorDialog(context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    _register = widget.register;
    return Column(
      children: <Widget>[
        // Education Qualification
        DropDownInput(
            items: educations,
            labelText: 'Education Qualification',
            valueText: _register.studyDetail ?? null,
            onChange: (value) {
              setState(() {
                _register.studyDetail = value;
              });
            },
          ),
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
        DateInput(
          labelText: 'Job/Business Start Date',
          selectedDate: _register.jobStartDate == null ? null : DateTime.parse(_register.jobStartDate),
          selectDate: (DateTime date) {
            setState(() {
              _register.jobStartDate = dateFormatter.format(date);
            });
          },
        ),
        TextInputField(
          labelText: 'Work City',
          valueText: _register.workCity,
          onSaved: (value) => _register.workCity = value,
          isRequiredValidation: true,
        ),
        Container(
          child: ListTile(
            title: Text('Weekly off in your Job/Occupation/Business'),
            contentPadding: EdgeInsets.only(left: 5),
          ),
        ),
        Container(
          child: Wrap(
              children: List.generate(Constant.weekName.length, (int index) {
            return Column(
              children: <Widget>[
                Text(
                  Constant.weekName[index],
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).copyWith().textTheme.caption.color,
                  ),
                ),
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
                  value: _register.holidays.contains(Constant.weekName[index]),
                )
              ],
            );
          })),
        ),
        ComboboxInput(
          labelText: 'Skills',
          listData: skills,
          selectedData: _register.skills,
          isRequiredValidation: true,
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
        TextInputField(
          labelText: 'Company Name',
          valueText: _register.companyName,
          onSaved: (value) => _register.companyName = value,
        ),
        /*TextInputField(
          labelText: 'Health',
          valueText: _register.health,
          onSaved: (value) => _register.health = value,
        ),*/
        TextInputField(
          labelText: 'Remarks',
          valueText: _register.personalNotes,
          onSaved: (value) => _register.personalNotes = value,
        ),
      ],
    );
  }
}
