import 'package:flutter/material.dart';
import 'package:sadhana/comman.dart';

class RadioInput extends StatelessWidget {
  RadioInput({
    this.radioValue,
    this.handleRadioValueChange,
    @required this.labelText,
    this.radioData,
    this.viewMode = false,
    this.viewModeTitleWidth,
  });

  final radioValue;
  final Function handleRadioValueChange;
  final String labelText;
  final List<Map<String, dynamic>> radioData;
  final bool viewMode;
  final double viewModeTitleWidth;
  BuildContext context;
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Container(
      padding: EdgeInsets.symmetric(vertical: !viewMode ? 10.0 : 5),
      alignment: Alignment.bottomLeft,
      child: viewMode ? viewModeWidget() : editModeWidget(),
    );
  }

  Widget viewModeWidget() {
    double screenWidth = MediaQuery.of(context).size.width;
    String value = radioValue.toString();
    if(radioData != null) {
      for(Map<String,dynamic> labelValue in radioData) {
        if(labelValue['value'] == radioValue) {
          value = labelValue['label'];
          break;
        }
      }
    }
    return CommonFunction.getTitleAndNameForProfilePage(screenWidth: screenWidth, title: labelText, value: value, titleWidth: viewModeTitleWidth);
  }

  Widget editModeWidget() {
    return Column(
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
