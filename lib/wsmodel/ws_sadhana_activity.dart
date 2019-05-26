import 'package:intl/intl.dart';
import 'package:sadhana/constant/wsconstants.dart';

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
}

class WSActivity {
  int value;
  Null remark;
  DateTime date;

  WSActivity({this.value, this.remark, this.date});

  WSActivity.fromJson(Map<String, dynamic> json) {
    value = (json['value'] != null) ? int.parse(json['value']) : 0;
    remark = json['remark'];
    date = json['date'] != null ? DateFormat(WSConstant.DATE_FORMAT).parse(json['date']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    data['remark'] = this.remark;
    data['date'] = DateFormat(WSConstant.DATE_FORMAT).format(this.date);
    return data;
  }
}