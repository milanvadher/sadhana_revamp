import 'package:flutter/material.dart';

class Constant {

  static final String APP_TIME_FORMAT = "hh:mm a";
  static final String APP_DATE_FORMAT = 'dd-MM-yyyy';
  static final String APP_MONTH_FORMAT = 'MMM';
  static final String APP_DATE_TIME_FORMAT = "dd-MM-yyyy hh:mm a";
  static final String APP_DATE_TIME_FILE_FORMAT = "dd-MM-yyyy hh-mm-a";
  static final String vanchanName = "Vanchan";
  static final String SEVANAME = "Seva";
  static final int REMARK_MANDATORY_VALUE = 4;
  static final String MBA_MAILID = "mbaapps@googlegroups.com";

  static final String BASE_PLAYSTORE_URL = "https://play.google.com/store/apps/details?id=";
  static final String BASE_APPSTORE_URL = "https://itunes.apple.com/app/id1457589389";
  // Display activity data for no of days
  static int displayDays = 15;

  // Month names
  static List<String> monthName = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'June',
    'July',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  //  Week days names
  static List<String> weekName = ['MON', 'TUE', 'WED', 'THR', 'FRI', 'SAT', 'SUN'];

  // List of colors when create any sadhana
  static List<Color> color = [
    const Color(0xFFD32F2F),
    const Color(0xFFE64A19),
    const Color(0xFFF57C00),
    const Color(0xFFFF8F00),
    const Color(0xFFF9A825),
    const Color(0xFFAFB42B),
    const Color(0xFF7CB342),
    const Color(0xFF388E3C),
    const Color(0xFF00897B),
    const Color(0xFF00ACC1),
    const Color(0xFF039BE5),
    const Color(0xFF1976D2),
    const Color(0xFF303F9F),
    const Color(0xFF5E35B1),
    const Color(0xFF8E24AA),
    const Color(0xFF5D4037),
    const Color(0xFF303030),
    const Color(0xFF757575),
    const Color(0xFFaaaaaa),
  ];

  // List of colors when create any sadhana
  static List<List<Color>> colors = [
    [Colors.red[700], Colors.red[200]],
    [Colors.deepOrange[700], Colors.deepOrange[200]],
    [Colors.orange[700], Colors.orange[200]],
    [Colors.amber[800], Colors.amber[100]],
    [Colors.yellow[800], Colors.yellow[200]],
    [Colors.lime[800], Colors.lime[200]],
    [Colors.lightGreen[600], Colors.lightGreen[200]],
    [Colors.green[700], Colors.green[200]],
    [Colors.teal[600], Colors.teal[200]],
    [Colors.cyan[600], Colors.cyan[200]],
    [Colors.lightBlue[600], Colors.lightBlue[200]],
    [Colors.blue[700], Colors.blue[200]],
    [Colors.indigo[700], Colors.indigo[200]],
    [Colors.deepPurple[600], Colors.deepPurple[200]],
    [Colors.purple[600], Colors.purple[200]],
    [Colors.pink[600], Colors.pink[200]],
    [Colors.brown[700], Colors.brown[200]],
    [Colors.grey[800], Colors.grey[100]],
    [Colors.grey[600], Colors.grey[300]],
    [Colors.grey[500], Colors.grey[500]],
  ];

}