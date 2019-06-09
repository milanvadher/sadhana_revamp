class Education {
  String education;

  Education({this.education});

  Education.fromJson(Map<String, dynamic> json) {
    education = json['education'];
  }
  
  static List<Education> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Education.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['education'] = this.education;
    return data;
  }
}