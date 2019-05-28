import 'package:flutter/material.dart';
import 'package:sadhana/dao/activitydao.dart';
import 'package:sadhana/model/activity.dart';
import 'package:sadhana/model/sadhana.dart';
import 'package:sadhana/utils/apputils.dart';
import 'package:sadhana/widgets/remark_picker.dart';
import 'package:vibration/vibration.dart';

class CheckmarkButton extends StatefulWidget {
  Function onClick;
  Sadhana sadhana;
  Activity activity;

  CheckmarkButton({@required this.sadhana, @required this.activity, this.onClick});

  @override
  _CheckmarkButtonState createState() => _CheckmarkButtonState();
}

class _CheckmarkButtonState extends State<CheckmarkButton> {
  String title;
  Activity activity;
  Sadhana sadhana;
  Brightness theme;
  ActivityDAO activityDAO = ActivityDAO();

  @override
  Widget build(BuildContext context) {
    activity = widget.activity;
    sadhana = widget.sadhana;
    title = sadhana.sadhanaName;
    theme = Theme.of(context).brightness;
    return InkWell(
      onTap: onClicked,
      onLongPress: onLongPress,
      child: Container(
        width: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: (theme == Brightness.light ? widget.sadhana.lColor : widget.sadhana.dColor)
              .withAlpha(widget.activity.sadhanaValue > 0 ? 20 : 0),
          border: Border.all(
            color: theme == Brightness.light ? widget.sadhana.lColor : widget.sadhana.dColor,
            width: 2,
            style: widget.activity.sadhanaValue > 0 ? BorderStyle.solid : BorderStyle.none,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: AnimatedContainer(
            duration: Duration(seconds: 5),
            width: 48,
            child: widget.activity.sadhanaValue > 0
                ? Icon(
                    Icons.done,
                    size: 20.0,
                    color: theme == Brightness.light ? widget.sadhana.lColor : widget.sadhana.dColor,
                  )
                : Icon(
                    Icons.close,
                    size: 20.0,
                    color: Colors.grey,
                  ),
          ),
        ),
      ),
    );
  }

  onClicked() {
    AppUtils.vibratePhone(duration: 10);
    activity.sadhanaValue = activity.sadhanaValue > 0 ? 0 : 1;
    if (widget.onClick != null) widget.onClick(widget.activity);
  }

  onLongPress() {
    showDialog<String>(
        context: context,
        builder: (_) {
          return ReamarkPickerDialog(
            title: Text(title),
            remark: activity.remarks,
          );
        }).then(onRemarkEntered);
  }

  onRemarkEntered(String remark) {
    if (remark != null) {
      AppUtils.vibratePhone(duration: 10);
      if (activity.sadhanaValue == 0) activity.sadhanaValue = 1;
      activity.remarks = remark;
      if (widget.onClick != null) widget.onClick(widget.activity);
    }
  }
}
