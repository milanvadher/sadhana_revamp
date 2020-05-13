import 'package:intl/intl.dart';

class WSConstant {
  static final int SUCCESS_CODE = 200;
  static final int CODE_ENTITY_NOT_FOUND = 221;
  static final String MONTH_FORMAT = 'yyyy-MM';
  static final String DATE_FORMAT = 'yyyy-MM-dd';
  static final String DATE_TIME_FORMAT = 'yyyy-MM-dd HH:mm:ss.SSS';
  static final String DATE_TIME_FORMAT2 = 'yyyy-MM-dd HH:mm:ss';

  static final String ROLE_ATTENDANCECOORD = "AttendanceCoord";

  static final DateFormat wsDateFormat = DateFormat(DATE_FORMAT);
  static final DateFormat wsTimeFormat = DateFormat(DATE_TIME_FORMAT);

  static final String sessionType_GD = "GD";
  static final String sessionType_General = "General";

  static final String center_Simcity = 'Simandhar City';


  static final String attendanceType_Center = 'Center';
  static final String attendanceType_GD = 'GD';
  static final String attendanceType_Event = 'Event';

  static final String JOB_CHANGE = "Job Change";
}
