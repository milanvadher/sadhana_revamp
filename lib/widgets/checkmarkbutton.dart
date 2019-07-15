import 'package:flutter/material.dart';
import 'package:sadhana/dao/activitydao.dart';
import 'package:sadhana/model/activity.dart';
import 'package:sadhana/model/sadhana.dart';
import 'package:sadhana/utils/apputils.dart';
import 'package:sadhana/widgets/remark_picker.dart';

class CheckmarkButton extends StatefulWidget {
  Function onClick;
  Sadhana sadhana;
  Activity activity;
  bool isDisabled;

  CheckmarkButton({@required this.sadhana, @required this.activity, this.onClick, this.isDisabled = false});

  @override
  _CheckmarkButtonState createState() => _CheckmarkButtonState();
}

class _CheckmarkButtonState extends State<CheckmarkButton> {
  String title;
  Activity activity;
  Sadhana sadhana;
  Brightness theme;
  ActivityDAO activityDAO = ActivityDAO();
  Color color;

  @override
  Widget build(BuildContext context) {
    activity = widget.activity;
    sadhana = widget.sadhana;
    title = sadhana.sadhanaName;
    theme = Theme.of(context).brightness;
    color = theme == Brightness.light ? widget.sadhana.lColor : widget.sadhana.dColor;
    return Container(
      color:
          widget.isDisabled ? (theme == Brightness.light ? Colors.grey.shade300 : Colors.grey.shade800) : Theme.of(context).cardColor,
      height: 50,
      child: InkWell(
        onTap: widget.isDisabled ? null : onClicked,
        onLongPress: widget.isDisabled ? null : onLongPress,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Container(
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (color).withAlpha(widget.activity.sadhanaValue > 0 ? 20 : 0),
              border: Border.all(
                color: color,
                width: 2,
                style: widget.activity.sadhanaValue > 0 ? BorderStyle.solid : BorderStyle.none,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: AnimatedContainer(
                duration: Duration(seconds: 5),
                width: 40,
                child: widget.activity.sadhanaValue > 0
                    ? Icon(
                        Icons.done,
                        size: 20.0,
                        color: color,
                      )
                    : Icon(
                        Icons.close,
                        size: 20.0,
                        color: Colors.grey,
                      ),
              ),
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
          return RemarkPickerDialog(
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
