import 'package:flutter/material.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/dao/activitydao.dart';
import 'package:sadhana/model/activity.dart';
import 'package:sadhana/model/sadhana.dart';
import 'package:sadhana/setup/numberpicker.dart';
import 'package:sadhana/utils/apputils.dart';

class NumberButton extends StatefulWidget {
  Function onClick;
  Sadhana sadhana;
  Activity activity;
  bool isDisabled;
  NumberButton({this.onClick, @required this.sadhana, @required this.activity, this.isDisabled = false});

  @override
  _NumberButtonState createState() => _NumberButtonState();
}

class _NumberButtonState extends State<NumberButton> {
  String title;
  Activity activity;
  Sadhana sadhana;
  Brightness theme;
  Color color;
  @override
  Widget build(BuildContext context) {
    activity = widget.activity;
    sadhana = widget.sadhana;
    title = sadhana.sadhanaName;
    theme = Theme.of(context).brightness;
    color = widget.isDisabled ? Colors.grey : theme == Brightness.light ? sadhana.lColor : sadhana.dColor;
    return Container(
      width: 34,
      margin: EdgeInsets.all(7),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: (color).withAlpha(isActivityDone() ? 20 : 0),
        border: Border.all(
          color: color,
          width: 2,
          style: isActivityDone() ? BorderStyle.solid : BorderStyle.none,
        ),
      ),
      child: Container(
        width: 48,
        child: Center(
          child: FlatButton(
            padding: EdgeInsets.all(0),
            onPressed: widget.isDisabled ? null : onPressed,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  activity.sadhanaValue.toString(),
                  style: TextStyle(
                      color: isActivityDone() ? color : Colors.grey),
                ),
                CircleAvatar(
                  maxRadius: activity.remarks != null && activity.remarks.isNotEmpty ? 2 : 0,
                  backgroundColor: color,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isActivityDone() {
    return activity.sadhanaValue >= sadhana.targetValue;
  }

  onPressed() {
    showDialog<List>(
        context: context,
        builder: (_) {
          return new NumberPickerDialog.integer(
            title: Text(title),
            color: theme == Brightness.light ? sadhana.lColor : sadhana.dColor,
            initialIntegerValue: activity.sadhanaValue,
            minValue: 0,
            isForSevaSadhana: AppUtils.equalsIgnoreCase(sadhana.sadhanaName, Constant.SEVANAME),
            maxValue: AppUtils.equalsIgnoreCase(sadhana.sadhanaName, Constant.SEVANAME) ? 24 : 100,
            remark: activity.remarks,
          );
        }).then(
      (List onValue) {
        onValueSelected(onValue);
      },
    );
  }

  onValueSelected(List onValue) {
    if (onValue != null && onValue[0] != null) {
      AppUtils.vibratePhone(duration: 10);
      activity.sadhanaValue = onValue[0];
      activity.remarks = onValue[1];
      if (widget.onClick != null) widget.onClick(widget.activity);
    }
  }

}
