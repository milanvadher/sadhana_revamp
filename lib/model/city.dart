class City {
  String name;

  City({this.name});

  City.fromJson(Map<String, dynamic> json) {
    name = json['city'];
  }
  
  static List<City> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => City.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}