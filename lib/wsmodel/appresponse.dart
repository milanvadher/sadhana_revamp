class ServerResponse {
  AppResponse appResponse;

  ServerResponse({this.appResponse});

  ServerResponse.fromJson(Map<String, dynamic> json) {
    appResponse = json['message'] != null ? new AppResponse.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.appResponse != null) {
      data['message'] = this.appResponse.toJson();
    }
    return data;
  }
}

class AppResponse {
  String msg;
  int status;
  dynamic data;

  AppResponse({this.msg, this.data, this.status});

  AppResponse.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    data = json['data'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['data'] = this.data;
    data['status'] = this.status;
    return data;
  }
}
