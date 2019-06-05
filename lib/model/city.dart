class City {
  String name;
  String city;
  City({this.name});

  City.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    city = json['city'];
  }
  
  static List<City> fromJsonList(List<dynamic> jsonList) {
    return jsonList != null ? jsonList.map((json) => City.fromJson(json)).toList() : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['city'] = this.city;
    return data;
  }
}