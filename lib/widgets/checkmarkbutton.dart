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
  final double width;

  CheckmarkButton({@required this.sadhana, @required this.activity, this.onClick, this.isDisabled = false, this.width = 40});

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
      width: widget.width,
      child: InkWell(
        onTap: onClicked,
        onLongPress: onLongPress,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 7, horizontal: 4),
          child: Container(
            //width: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (color).withAlpha(widget.activity.sadhanaValue > 0 ? 20 : 0),
              border: Border.all(
                color: color,
                width: 2,
                style: widget.activity.sadhanaValue > 0 ? BorderStyle.solid : BorderStyle.none,
              ),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              AnimatedContainer(
                duration: Duration(seconds: 5),
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
              CircleAvatar(
                maxRadius: activity.remarks != null && activity.remarks.isNotEmpty ? 2 : 0,
                backgroundColor: color,
              ),
            ]),
          ),
        ),
      ),
    );
  }

  onClicked() {
    if(widget.isDisabled) {
      if(activity.remarks != null && activity.remarks.isNotEmpty) {
        showReadOnlyDialog();
        return;
      }
      return;
    }
    AppUtils.vibratePhone(duration: 10);
    activity.sadhanaValue = activity.sadhanaValue > 0 ? 0 : 1;
    if (widget.onClick != null) widget.onClick(widget.activity);
  }

  void showReadOnlyDialog() {
    showDialog<String>(
        context: context,
        builder: (_) {
          return RemarkPickerDialog(
            title: Text(title),
            remark: activity.remarks,
            isEnabled: false,
          );
        });
  }

  onLongPress() {
    if(widget.isDisabled) {
      if(activity.remarks != null && activity.remarks.isNotEmpty) {
        showReadOnlyDialog();
        return;
      }
      return;
    }
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
