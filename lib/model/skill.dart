class Skills {
  String name;

  Skills({this.name});

  Skills.fromJson(Map<String, dynamic> json) {
    name = json['skill_name'];
  }
  
  static List<Skills> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Skills.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}