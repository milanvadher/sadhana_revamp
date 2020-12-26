import 'package:sadhana/attendance/model/session.dart';

class DVDInfo {
  String date;
  String group;
  String dvdType;
  int dvdNo;
  int dvdPart;
  String remark;

  DVDInfo.fromSession(Session session) {
    date = session.date;
    group = session.group;
    dvdType = session.dvdType;
    if(dvdType == null)
      dvdType = 'Satsang';
    dvdNo = session.dvdNo;
    dvdPart = session.dvdPart;
    remark = session.remark;
  }

  static setSession(Session session, DVDInfo dvdInfo) {
    session.date = dvdInfo.date;
    session.group = dvdInfo.group;
    session.dvdType = dvdInfo.dvdType;
    session.dvdNo = dvdInfo.dvdNo;
    session.dvdPart = dvdInfo.dvdPart;
    session.remark = dvdInfo.remark;
  }
}