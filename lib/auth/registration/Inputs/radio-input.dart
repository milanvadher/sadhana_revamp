import 'package:flutter/material.dart';

class RadioInput extends StatelessWidget {
  RadioInput({
    this.radioValue,
    this.handleRadioValueChange,
    @required this.labelText,
    this.radioData,
  });

  final radioValue;
  final Function handleRadioValueChange;
  final String labelText;
  final List<Map<String, dynamic>> radioData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      alignment: Alignment.bottomLeft,
      child: Column(
        children: <Widget>[
          Container(
            child: Text(labelText),
            width: double.infinity,
          ),
          Container(
            width: double.infinity,
            child: RadioInputItem(
              radioData: radioData,
              handleRadioValueChange: handleRadioValueChange,
              radioValue: radioValue,
            ),
          ),
        ],
      ),
    );
  }
}

class RadioInputItem extends StatelessWidget {
  RadioInputItem({
    this.radioValue,
    this.handleRadioValueChange,
    this.radioData,
  });

  final radioValue;
  final Function handleRadioValueChange;
  final List<Map<String, dynamic>> radioData;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      children: radioData
          .map((item) => Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Radio(
                      value: item['value'],
                      groupValue: radioValue,
                      onChanged: handleRadioValueChange,
                    ),
                    new Text(item['label'])
                  ],
                ),
              ))
          .toList(),
    );
  }
}
