class EventResponse {
  List<Event> message;

  EventResponse({this.message});

  EventResponse.fromJson(Map<String, dynamic> json) {
    if (json['message'] != null) {
      message = new List<Event>();
      json['message'].forEach((v) {
        message.add(new Event.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.message != null) {
      data['message'] = this.message.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Event {
  String eventPk;
  String eventName;
  String startDate;
  String endDate;
  bool isEditable;
  bool isAttendanceTaken;

  Event({
    this.eventPk,
    this.eventName,
    this.startDate,
    this.endDate,
    this.isEditable,
    this.isAttendanceTaken,
  });

  Event.fromJson(Map<String, dynamic> json) {
    eventPk = json['event_pk'];
    eventName = json['event_name'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    isEditable = json['is_editable'];
    isAttendanceTaken = json['is_attendance_taken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_pk'] = this.eventPk;
    data['event_name'] = this.eventName;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['is_editable'] = this.isEditable;
    data['is_attendance_taken'] = this.isAttendanceTaken;
    return data;
  }
}
