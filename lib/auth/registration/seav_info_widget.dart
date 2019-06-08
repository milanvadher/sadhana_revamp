import 'package:flutter/material.dart';
import 'package:sadhana/auth/registration/Inputs/combobox-input.dart';
import 'package:sadhana/auth/registration/Inputs/text-input.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/model/register.dart';
import 'package:sadhana/setup/numberpicker.dart';

import 'Inputs/dropdown-input.dart';

class SevaInfoWidget extends StatefulWidget {
  final Register register;
  final Function startLoading;
  final Function stopLoading;

  const SevaInfoWidget(
      {Key key, this.register, this.startLoading, this.stopLoading})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SevaInfoWidgetState();
  }
}

class SevaInfoWidgetState extends State<SevaInfoWidget> {
  Register _register = new Register();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Container(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Text('Regular Seva Department:'),
              TextInputField(
                labelText: 'Regular Seva Dept.',
                valueText: _register.personalNotes,
                onSaved: (value) => _register.personalNotes = value,
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.all(0),
                subtitle: Text(
                  'Note: Please Enter the Departments were you currently give seva or have given in past.',
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
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Text('Event Based Seva Department:'),
              TextInputField(
                labelText: 'Event Seva Dept.',
                valueText: _register.personalNotes,
                onSaved: (value) => _register.personalNotes = value,
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
          child: Row(
            children: <Widget>[
              Text('Seva Alailability'),
              Container(
                child: DropDownInput(
                  labelText: 'Hours',
                  valueText: 1,
                  items: [1, 2, 3, 4, 5, 6, 7, 8, 9],
                  onChange: (value) {
                    setState(() {
                      print(value);
                    });
                  },
                ),
              ),
              // Container(
              //   child: Wrap(
              //       children:
              //           List.generate(Constant.weekName.length, (int index) {
              //     return Column(
              //       children: <Widget>[
              //         Text(Constant.weekName[index]),
              //         Checkbox(
              //           onChanged: (value) {
              //             setState(() {
              //               if (value) {
              //                 _register.holidays.add(Constant.weekName[index]);
              //               } else {
              //                 _register.holidays
              //                     .remove(Constant.weekName[index]);
              //               }
              //             });
              //           },
              //           value: true,
              //           // value: _register.holidays
              //           //     .contains(Constant.weekName[index]),
              //         )
              //       ],
              //     );
              //   })),
              // )
            ],
          ),
        ),
      ],
    );
  }

  // sevaAvailTime() {
  //   return
  // }

  // sevaRemarkField() {
  //   return Container(
  //     child: Column(
  //       children: <Widget>[
  //         Text('Remark'),
  //         TextInputField(
  //           labelText: 'Remarks',
  //           valueText: _register.personalNotes,
  //           onSaved: (value) => _register.personalNotes = value,
  //         )
  //       ],
  //     ),
  //   );
  // }
}
