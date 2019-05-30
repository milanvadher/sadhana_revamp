import 'dart:io';

class AppSetting {
  String appVersionAndroid;
  String appVersionIos;
  String editableDays;
  String serverDate;
  String get version => Platform.isIOS ? appVersionIos : appVersionAndroid;

  AppSetting(
      {this.appVersionAndroid,
        this.appVersionIos,
        this.editableDays,
        this.serverDate});

  AppSetting.fromJson(Map<String, dynamic> json) {
    appVersionAndroid = json['app_version_android'];
    appVersionIos = json['app_version_ios'];
    editableDays = json['editable_days'];
    serverDate = json['server_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_version_android'] = this.appVersionAndroid;
    data['app_version_ios'] = this.appVersionIos;
    data['editable_days'] = this.editableDays;
    data['server_date'] = this.serverDate;
    return data;
  }
}