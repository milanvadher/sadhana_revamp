class StateList {
  String name;
  String state;
  StateList({this.name});

  StateList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    state = json['state'];
  }
  
  static List<StateList> fromJsonList(List<dynamic> jsonList) {
    return jsonList != null ? jsonList.map((json) => StateList.fromJson(json)).toList() : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['state'] = this.state;
    return data;
  }
}