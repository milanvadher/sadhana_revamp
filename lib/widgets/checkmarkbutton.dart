import 'package:flutter/material.dart';
import 'package:sadhana/model/activity.dart';
import 'package:sadhana/model/sadhana.dart';

class CheckmarkButton extends StatelessWidget {
  Function onClick;
  Sadhana sadhana;
  Activity activity;
  String title;
  @override
  Widget build(BuildContext context) {
    Brightness theme = Theme.of(context).brightness;
    return InkWell(
      onTap: () {
        activity.sadhanaValue = activity.sadhanaValue > 0 ? 0 : 1;
        onClick(activity);
      },
      child: Container(
        width: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: (theme == Brightness.light ? sadhana.lColor : sadhana.dColor).withAlpha(activity.sadhanaValue > 0 ? 20 : 0),
          border: Border.all(
            color: theme == Brightness.light ? sadhana.lColor : sadhana.dColor,
            width: 2,
            style: activity.sadhanaValue > 0 ? BorderStyle.solid : BorderStyle.none,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: AnimatedContainer(
            duration: Duration(seconds: 5),
            width: 48,
            child: activity.sadhanaValue > 0
                ? Icon(
                    Icons.done,
                    size: 20.0,
                    color: theme == Brightness.light ? sadhana.lColor : sadhana.dColor,
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
}
