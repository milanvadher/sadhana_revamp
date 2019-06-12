import 'package:flutter/material.dart';
import 'package:sadhana/auth/registration/Inputs/combobox-input.dart';
import 'package:sadhana/auth/registration/Inputs/text-input.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/model/register.dart';

import 'Inputs/dropdown-input.dart';

class SevaInfoWidget extends StatefulWidget {
  final Register register;
  final Function startLoading;
  final Function stopLoading;

  const SevaInfoWidget(
      {Key key, @required this.register, this.startLoading, this.stopLoading})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return SevaInfoWidgetState();
  }
}

class SevaInfoWidgetState extends State<SevaInfoWidget> {
  Register _register;

  @override
  Widget build(BuildContext context) {
    _register = widget.register;
    return Column(
      children: <Widget>[
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Regular Seva Department:'),
              TextInputField(
                labelText: 'Regular Seva Dept.',
                valueText: _register.sevaProfile.regularSevaDept,
                onSaved: (value) => _register.sevaProfile.regularSevaDept = value,
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.all(0),
                subtitle: Text(
                  'Note: Please Enter the Departments where you are currently giving seva.',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Event Based Seva Department:'),
              TextInputField(
                labelText: 'Event Seva Dept.',
                valueText: _register.sevaProfile.eventSevaDept,
                onSaved: (value) => _register.sevaProfile.eventSevaDept = value,
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.all(0),
                subtitle: Text(
                  'Note: In Which Department you give seva as preferred sevarthi.',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Seva Availability'),
              Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 4,
                    child: DropDownInput(
                      labelText: 'Hours',
                      valueText: _register.sevaProfile.timeAvailability,
                      items: List.generate(24, (index) => index),
                      onChange: (value) {
                        setState(() {
                          _register.sevaProfile.timeAvailability = value;
                        });
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width / 2,
                    child: Wrap(
                      children: List.generate(
                        Constant.weekName.length,
                        (int index) {
                          return Column(
                            children: <Widget>[
                              Text(
                                Constant.weekName[index],
                                style: TextStyle(fontSize: 10),
                              ),
                              Checkbox(
                                onChanged: (value) {
                                  setState(() {
                                    if (value) {
                                      _register.sevaProfile.daysAvailability.add(Constant.weekName[index]);
                                    } else {
                                      _register.sevaProfile.daysAvailability.remove(Constant.weekName[index]);
                                    }
                                  });
                                },
                                value: _register.sevaProfile.daysAvailability.contains(Constant.weekName[index]),
                                // value: _register.holidays
                                //     .contains(Constant.weekName[index]),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ),

                ],
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.all(0),
                subtitle: Text(
                  'How much time(days/hours) you can be available for seva?',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Text('Seva Availability more details'),
              TextInputField(
                labelText: 'Seva Availability more details',
                valueText: _register.sevaProfile.remarks,
                onSaved: (value) => _register.sevaProfile.remarks = value,
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.all(0),
                subtitle: Text(
                  'Note: Please give seva availability more details. eg., Can give 1 hrs seva in weekdays and 4 hrs seva on weekends.',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Interest in Dept/Skill\'s'),
                TextInputField(
                  labelText: 'Interest in Dept/Skill\'s',
                  valueText: _register.sevaProfile.interest,
                  onSaved: (value) => _register.sevaProfile.interest = value,
                  isRequiredValidation: true,
                ),
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.all(0),
                  subtitle: Text(
                    'Note: Please write name of department/skills where you want to give seva in future.',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                )
              ],
            ))
      ],
    );
  }
}
