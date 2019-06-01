class Geo {
  String name;

  Geo({this.name});

  Geo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }
  
  static List<Geo> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Geo.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}