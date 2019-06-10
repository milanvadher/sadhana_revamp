import 'package:intl/intl.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/model/activity.dart';
import 'package:sadhana/utils/apputils.dart';

class WSSadhanaActivity {
  String name;
  List<WSActivity> data;

  WSSadhanaActivity({this.name, this.data});

  WSSadhanaActivity.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['data'] != null) {
      data = new List<WSActivity>();
      json['data'].forEach((v) {
        data.add(new WSActivity.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }

  WSSadhanaActivity.fromActivity(String sadhanaSName, List<Activity> activities) {
    name = sadhanaSName;
    data = activities.map((activity) => WSActivity.fromActivity(activity)).toList();
  }
}

class WSActivity {
  int value;
  String remark;
  DateTime date;
  DateTime activityTime;

  WSActivity({this.value, this.remark, this.date});

  WSActivity.fromJson(Map<String, dynamic> json) {
    value = (json['value'] != null) ? json['value'] : 0;
    remark = json['remark'];
    date = json['sadhana_date'] != null ? DateFormat(WSConstant.DATE_FORMAT).parse(json['sadhana_date']) : null;
    activityTime = json['activity_datetime'] != null
        ? AppUtils.tryParse(json['activity_datetime'], [WSConstant.DATE_TIME_FORMAT, WSConstant.DATE_TIME_FORMAT2])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['remark'] = this.remark ?? '';
    data['sadhana_date'] = DateFormat(WSConstant.DATE_FORMAT).format(this.date);
    data['activity_datetime'] =
        this.activityTime != null ? DateFormat(WSConstant.DATE_TIME_FORMAT).format(this.activityTime) : null;
    return data;
  }

  WSActivity.fromActivity(Activity activity) {
    value = activity.sadhanaValue;
    remark = activity.remarks;
    date = activity.sadhanaDate;
    activityTime = activity.sadhanaActivityDate;
  }
}
