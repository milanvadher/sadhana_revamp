import 'package:flutter/material.dart';
import 'package:sadhana/constant/sadhanatype.dart';
import 'package:sadhana/dao/activitydao.dart';
import 'package:sadhana/model/activity.dart';
import 'package:sadhana/model/sadhana.dart';
import 'package:sadhana/utils/app_setting_util.dart';
import 'package:sadhana/widgets/checkmarkbutton.dart';
import 'package:sadhana/widgets/nameheading.dart';
import 'package:sadhana/widgets/numberbutton.dart';

class SadhanaHorizontalPanel extends StatefulWidget {
  final List<DateTime> daysToDisplay;
  final Sadhana sadhana;
  final double buttonWidth;
  SadhanaHorizontalPanel({this.daysToDisplay, this.sadhana, this.buttonWidth = 40});

  @override
  _SadhanaHorizontalPanelState createState() => _SadhanaHorizontalPanelState();
}

class _SadhanaHorizontalPanelState extends State<SadhanaHorizontalPanel> {
  Sadhana sadhana;
  ActivityDAO activityDAO = ActivityDAO();
  int editableDays = 4;
  DateTime today = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppSettingUtil.getServerAppSetting().then((appSetting) {
      setState(() {
        editableDays = appSetting.editableDays;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> daysToDisplay = widget.daysToDisplay;
    sadhana = widget.sadhana;
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      margin: EdgeInsets.fromLTRB(0, 4, 4, 4),
      child: Container(
        height: 45,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              daysToDisplay.length,
              (int index) {
                Activity activity = sadhana.activitiesByDate[widget.daysToDisplay[index].millisecondsSinceEpoch];
                if (activity == null)
                  activity = Activity(sadhanaId: sadhana.id, sadhanaDate: daysToDisplay[index], sadhanaValue: 0, remarks: "");
                bool isDisabled = false;
                if(sadhana.isPreloaded) {
                    isDisabled = index >= editableDays ? true : false;
                }
                return sadhana.type == SadhanaType.BOOLEAN
                    ? CheckmarkButton(
                        sadhana: sadhana,
                        activity: activity,
                        onClick: onClick,
                        isDisabled: isDisabled,
                        width: widget.buttonWidth,
                      )
                    : NumberButton(
                        sadhana: sadhana,
                        activity: activity,
                        onClick: onClick,
                        isDisabled: isDisabled,
                        width: widget.buttonWidth,
                      );
              },
            ),
          ),
        ),
      ),
    );
  }

  onClick(Activity activity) {
    if (sadhana.isPreloaded)
      activity.isSynced = false;
    else
      activity.isSynced = true;
    /*if(activity.sadhanaValue <= 0)
      activity.remarks = '';*/
    setState(() {
      sadhana.activitiesByDate[activity.sadhanaDate.millisecondsSinceEpoch] = activity;
    });
    activityDAO.insertOrUpdate(activity).then((dbActivity) {
      setState(() {
        sadhana.activitiesByDate[activity.sadhanaDate.millisecondsSinceEpoch] = dbActivity;
      });
    });
    var namingState = listOfNamingState[sadhana.sadhanaName];
    if(namingState != null)
      namingState.setState(() {});
    /*setState(() {
      widget.sadhana.sadhanaData[activity.sadhanaDate] = activity;
    });*/
  }
}
