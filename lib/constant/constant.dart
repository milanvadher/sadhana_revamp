import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Constant {
  static final DateFormat APP_TIME_FORMAT = DateFormat("hh:mm a");
  static final DateFormat APP_DATE_FORMAT = DateFormat('dd-MMM-yyyy');
  static final DateFormat SYNC_DATE_FORMAT = DateFormat('dd-MM-yy');
  static final String APP_MONTH_FORMAT = 'MMM';
  static final String APP_DATE_TIME_FORMAT = "dd-MM-yy hh:mm a";
  static final String APP_DATE_TIME_FILE_FORMAT = "dd-MM-yy hh-mm-a";
  static final String vanchanName = "Vanchan";
  static final String SEVANAME = "Seva";
  static final int REMARK_MANDATORY_VALUE = 4;
  static final String MBA_MAILID = "mbaapps@googlegroups.com";

  static final String BASE_PLAYSTORE_URL = "https://play.google.com/store/apps/details?id=";
  static final String BASE_APPSTORE_URL = "https://itunes.apple.com/app/id1469199921";
  // Display activity data for no of days
  static int displayDays = 30;

  static final List<DateTime> syncReminder = [
    DateTime(2019, 1, 2, 20),
    DateTime(2019, 1, 3, 16),
    DateTime(2019, 1, 10, 20),
    DateTime(2019, 1, 15, 16),
  ];

  static final DateTime fillReminder = DateTime(2000, 1, 1, 20);

  static final String syncReminderTitle = "Upload Sadhana";
  static final String syncReminderBody = "Please upload your last month sadhana by click on cloud button.";
  // Month names
  static List<String> monthName = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  //  Week days names
  static List<String> weekName = ['MON', 'TUE', 'WED', 'THR', 'FRI', 'SAT', 'SUN'];

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
