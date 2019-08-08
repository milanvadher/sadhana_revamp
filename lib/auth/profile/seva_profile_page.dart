import 'package:flutter/material.dart';
import 'package:sadhana/auth/profile/profile_page.dart';
import 'package:sadhana/model/register.dart';
import 'package:sadhana/utils/apputils.dart';

class SevaProfilePage extends StatelessWidget {
  final Register register;

  const SevaProfilePage({Key key, this.register}) : super(key: key);
  final double titleWidth = 110;
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      buildProfileRow(
          title: 'Regular Seva Department',
          value: register.sevaProfile.regularSevaDept,
          context: context,
          viewModeTitleWidth: titleWidth),
      buildProfileRow(
          title: 'Event Based Seva Department',
          value: register.sevaProfile.eventSevaDept,
          context: context,
          viewModeTitleWidth: titleWidth),
      buildProfileRow(
          title: 'Seva Availability',
          value: getSevaAvailability(),
          context: context,
          viewModeTitleWidth: titleWidth),
      buildProfileRow(
          title: 'Seva Availability more details',
          value: register.sevaProfile.remarks,
          context: context,
          viewModeTitleWidth: titleWidth),
      buildProfileRow(
          title: 'Interest in Dept/Skill\'s',
          value: register.sevaProfile.interest,
          context: context,
          viewModeTitleWidth: titleWidth),
    ]);
  }

  String getSevaAvailability() {
    String value = '${register.sevaProfile.timeAvailability?.toString()} hours';
    value = '$value ${AppUtils.listToString(register.sevaProfile.daysAvailability)}';
    return value;
  }
}
