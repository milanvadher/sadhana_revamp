import 'package:flutter/material.dart';
import 'package:sadhana/auth/registration/Inputs/combobox-input.dart';
import 'package:sadhana/auth/registration/Inputs/text-input.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/model/register.dart';
import 'package:sadhana/setup/numberpicker.dart';

class SevaDetails extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SevaDetailsState();
  }
}

class SevaDetailsState extends State<SevaDetails> {
  Register _register = new Register();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: _body(),
    );
  }

  _body() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            sevaMSBFormField('Regular Seva Department :', ''),
            sevaMSBFormField('Event based seva Department :', ''),
            sevaAvailTime(),
            sevaRemarkField(),
          ],
        ),
      ),
    );
  }

  sevaMSBFormField(String label, String noteText) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(label),
          ComboboxInput(
            lableText: 'Skills',
            // listData: skills,
            // selectedData: _register.skills,
            handleValueSelect: (value) {
              print('onselect : $value');
              setState(() {
                // _register.skills.add(value);
                // skills.remove(value);
              });
            },
            onDelete: (value) {
              setState(() {
                // _register.skills.remove(value);
                // skills.add(value);
              });
            },
          ),
          Text(noteText),
        ],
      ),
    );
  }

  sevaAvailTime() {
    return Container(
      child: Column(
        children: <Widget>[
          Text('Seva Alailability'),
          Row(
            children: <Widget>[
              NumberPickerDialog.integer(
                initialIntegerValue: 1,
                maxValue: 24,
                minValue: 1,
              ),
              Container(
                child: Wrap(
                    children:
                        List.generate(Constant.weekName.length, (int index) {
                  return Column(
                    children: <Widget>[
                      Text(Constant.weekName[index]),
                      Checkbox(
                        onChanged: (value) {
                          setState(() {
                            if (value) {
                              _register.holidays.add(Constant.weekName[index]);
                            } else {
                              _register.holidays
                                  .remove(Constant.weekName[index]);
                            }
                          });
                        },
                        value: _register.holidays
                            .contains(Constant.weekName[index]),
                      )
                    ],
                  );
                })),
              )
            ],
          )
        ],
      ),
    );
  }

  sevaRemarkField() {
    return Container(
      child: Column(
        children: <Widget>[
          Text('Remark'),
          TextInputField(
            labelText: 'Remarks',
            valueText: _register.personalNotes,
            onSaved: (value) => _register.personalNotes = value,
          )
        ],
      ),
    );
  }

  
}
