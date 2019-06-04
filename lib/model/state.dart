class StateList {
  String name;

  StateList({this.name});

  StateList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }
  
  static List<StateList> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => StateList.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}