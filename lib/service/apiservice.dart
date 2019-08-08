import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:sadhana/attendance/model/attendance_summary.dart';
import 'package:sadhana/attendance/model/session.dart';
import 'package:sadhana/constant/sharedpref_constant.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/model/register.dart';
import 'package:sadhana/model/registration_request.dart';
import 'package:sadhana/utils/appsharedpref.dart';
import 'package:sadhana/wsmodel/ws_sadhana_activity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  //static final _baseServerUrl = 'http://52.140.97.54'; //Test
  static final _baseServerUrl = 'https://sadhanaapi.dbf.ooo';  //Live
  static final _apiUrl = '$_baseServerUrl/api/method';

  Map<String, String> headers = {'content-type': 'application/json'};
  bool enableMock = false;

  checkLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (await AppSharedPrefUtil.isUserLoggedIn()) {
      appendTokenToHeader(await AppSharedPrefUtil.getToken());
    }
  }

  Future<Response> getApi({@required String url}) async {
    await checkLogin();
    String getUrl = _apiUrl + url;
    print('Get Url:' + getUrl);
    Response res = await http.get(getUrl, headers: headers);
    print('Response:' + res.body);
    return res;
  }

  Future<Response> _postApi(
      {@required String url, @required Map<String, dynamic> data}) async {
    await checkLogin();
    String postUrl = _apiUrl + url;
    await appendCommonDataToBody(data);
    String body = json.encode(data);
    print('Post Url:' + postUrl + '\tReq:' + body);
    Response res = await http.post(_apiUrl + url, body: body, headers: headers);
    print(
        'Response: ${res.body} status code: ${res.statusCode} msg: ${res.reasonPhrase}');
    return res;
  }

  appendCommonDataToBody(Map<String, dynamic> data) async {
    if (await AppSharedPrefUtil.isUserRegistered()) {
      data['token'] = await AppSharedPrefUtil.getToken();
      data['mht_id'] = await AppSharedPrefUtil.getMhtId();
    }
  }

  appendTokenToHeader(token) {
    headers['x-access-token'] = token;
    /*if(CacheData.userInfo != null && CacheData.userInfo.mhtId != null)
      headers['mht_id'] = CacheData.userInfo.mhtId.toString();
    print(headers);*/
  }

  Future<Response> getUserProfile(String mht_id) async {
    Map<String, dynamic> data = {'mht_id': mht_id};
    Response res = await _postApi(
      url: '/mba.user.user_profile',
      data: data,
    );
    return res;
  }

  Future<Response> getMBAProfile() async {
    Map<String, dynamic> data = {};
    Response res = await _postApi(
      url: '/mba.user.get_profile_details',
      data: data,
    );
    return res;
  }

  Future<Response> sendOTP(String mht_id, String email, String mobile) async {
    Map<String, dynamic> data = {
      "mht_id": mht_id,
      "email": email,
      "mobile_no_1": mobile
    };
    Response res = await _postApi(url: '/mba.user.send_otp', data: data);
    return res;
  }

  Future<Response> getCenterList() async {
    Map<String, dynamic> data = {};
    Response res = await _postApi(url: '/mba.master.center_list', data: data);
    return res;
  }

  Future<Response> sendRequest(RegistrationRequest registrationRequest) async {
    Map<String, dynamic> data = registrationRequest.toJson();
    Response res = await _postApi(url: '/mba.user.req_mba_registration', data: data);
    return res;
  }


  Future<Response> changeMobile(
      String mht_id, String oldNo, String newNo) async {
    Map<String, dynamic> data = {
      'mht_id': mht_id,
      'old_no': oldNo,
      'new_no': newNo
    };
    Response res =
        await _postApi(url: '/mba.user.change_mobile_no', data: data);
    return res;
  }

  Future<Response> generateToken(String mht_id) async {
    Map<String, dynamic> data = {'mht_id': mht_id};
    Response res = await _postApi(url: '/mba.user.generate_token', data: data);
    return res;
  }

  Future<Response> updateMBAProfile(Register register) async {
    Map<String, dynamic> data = register.toJson();
    Response res =
        await _postApi(url: '/mba.user.update_mba_profile', data: data);
    //Response res = Response("", 200);
    return res;
  }

  Future<Response> validateToken() async {
    Map<String, dynamic> data = {};
    Response res = await _postApi(url: '/mba.user.validate_token', data: data);
    return res;
  }

  Future<Response> updateNotificationToken(
      {@required String mhtId,
      @required String fbToken,
      @required String oneSignalToken}) async {
    Map<String, dynamic> data = {
      'mht_id': mhtId,
      'one_signal_token': oneSignalToken
    };
    Response res =
        await _postApi(url: '/mba.user.save_one_signal_token', data: data);
    return res;
  }

  // Logout
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<Response> getSadhanas() async {
    Response res = await getApi(url: '/mba.sadhana.get_sadhana');
    return res;
  }

  Future<Response> getActivity() async {
    Map<String, dynamic> data = {};
    Response res =
        await _postApi(url: '/mba.sadhana.getsadhana_activity', data: data);
    return res;
  }

  Future<Response> getAllCountries() async {
    return await _postApi(
      url: '/mba.master.country_list',
      data: {},
    );
  }

  Future<Response> getCityByState(String state) async {
    return await _postApi(url: '/mba.master.city_list', data: {'state': state});
  }

  Future<Response> getStateByCountry(String country) async {
    return await _postApi(
      url: '/mba.master.state_list',
      data: {'country': country},
    );
  }

  Future<Response> getSkills() async {
    return await _postApi(
      url: '/mba.master.skill_list',
      data: {},
    );
  }

  Future<Response> getEducations() async {
    return await _postApi(
      url: '/mba.master.education_list',
      data: {},
    );
  }

  Future<Response> syncActivity(
      List<WSSadhanaActivity> wsSadhanaActivity) async {
    Map<String, dynamic> data = {
      'activity': wsSadhanaActivity.map((v) => v.toJson()).toList()
    };
    Response res = await _postApi(url: '/mba.sadhana.sync', data: data);
    return res;
    /*Response res = new http.Response("{\r\n    \"message\": {\r\n        \"data\": [\r\n            {\r\n                \"name\": \"Samayik\",\r\n                \"data\": [\r\n                    {\r\n                        \"value\": \"1\",\r\n                        \"remark\": null,\r\n                        \"date\": \"2019-05-25\"\r\n                    },\r\n                    {\r\n                        \"value\": \"1\",\r\n                        \"remark\": null,\r\n                        \"date\": \"2019-05-24\"\r\n                    },\r\n                    {\r\n                        \"value\": \"1\",\r\n                        \"remark\": null,\r\n                        \"date\": \"2019-05-23\"\r\n                    },\r\n                    {\r\n                        \"value\": \"0\",\r\n                        \"remark\": null,\r\n                        \"date\": \"2019-05-22\"\r\n                    }\r\n                ]\r\n            },\r\n            {\r\n                \"name\": \"Vanchan\",\r\n                \"data\": [\r\n                    {\r\n                        \"value\": \"5\",\r\n                        \"remark\": null,\r\n                        \"date\": \"2019-05-25\"\r\n                    }\r\n                ]\r\n            },\r\n            {\r\n                \"name\": \"Seva\",\r\n                \"data\": [\r\n                    {\r\n                        \"value\": \"5\",\r\n                        \"remark\": null,\r\n                        \"date\": \"2019-05-25\"\r\n                    }\r\n                ]\r\n            },\r\n            {\r\n                \"name\": \"G. Satsang\",\r\n                \"data\": [\r\n                    {\r\n                        \"value\": \"1\",\r\n                        \"remark\": null,\r\n                        \"date\": \"2019-05-25\"\r\n                    }\r\n                ]\r\n            },\r\n            {\r\n                \"name\": \"Vidhi\",\r\n                \"data\": [\r\n                    {\r\n                        \"value\": \"0\",\r\n                        \"remark\": null,\r\n                        \"date\": \"2019-05-25\"\r\n                    }\r\n                ]\r\n            }\r\n        ]\r\n    }\r\n}",
        200);
    return new Future.delayed(const Duration(seconds: 15), () => res);*/
  }

  Future<http.Response> getAppSetting() async {
    http.Response res = await getApi(url: '/mba.sadhana.settings');
    return res;
  }

  Future<http.Response> getMBASchedule(String center, String date) async {
    Map<String, dynamic> data = {'center': center, 'date': date};
    http.Response res =
        await _postApi(url: '/mba.schedule.get_schedule', data: data);
    return res;
  }

  String getMBAScheduleAbsoluteUrl(String relativeUrl) {
    return '$_baseServerUrl/$relativeUrl';
  }

  // Check Login Status
  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(SharedPrefConstant.b_isUserLoggedIn) != null) {
      if (prefs.getBool(SharedPrefConstant.b_isUserLoggedIn)) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }


  //Attendance API
  Future<Response> getUserRole() async {
    Map<String, dynamic> data = {};
    Response res = await _postApi(url: '/mba.user.get_user_role', data: data);
    //Response res = http.Response("{\r\n    \"message\": {\r\n        \"data\": {\r\n            \"role\": \"\",\r\n            \"group_name\": \"\"\r\n        }\r\n    }\r\n}", 200);
    return res;
  }

  Future<Response> getMonthPendingForAttendance(String group) async {
    Map<String, dynamic> data = {'group_name': group};
    Response res = await _postApi(url: '/mba.attendance.get_month_pending_for_attendance', data: data);
    //Response res = http.Response("{\r\n    \"message\": {\r\n        \"data\": {\r\n            \"role\": \"\",\r\n            \"group_name\": \"\"\r\n        }\r\n    }\r\n}", 200);
    return res;
  }

  Future<Response> getSessionDates(String group) async {
    Map<String, dynamic> data = {'group_name': group};
    Response res = await _postApi(url: '/mba.attendance.get_session_dates', data: data);
    //Response res = http.Response("{\"message\":{\"data\":[\"2019-07-05\",\"2019-07-04\"]}}", 200);
    //Response res = http.Response("{\"message\":{\"msg\":\"ProgrammingError(1064, \\\"You have an error in your SQL syntax; check the manual that corresponds to your MariaDB server version for the right syntax to use near ') ORDER BY `first_name`' at line 1\\\")\"}}", 500);
    return res;
  }

  Future<Response> getMBAOfGroup(String date, String group) async {
    Map<String, dynamic> data = {'date': date, 'group_name': group};
    Response res = await _postApi(url: '/mba.group_api.get_mba_by_group', data: data);
    //Response res = http.Response(
    //    "{\"message\":{\"data\":[{\"mht_id\":\"61758\",\"first_name\":\"Kamlesh\",\"last_name\":\"Kanazariya\"},{\"mht_id\":\"111111\",\"first_name\":\"Divyang\",\"last_name\":\"Mistry\"},{\"mht_id\":\"222222\",\"first_name\":\"Milan\",\"last_name\":\"Vadher\"},{\"mht_id\":\"333333\",\"first_name\":\"Gaurav\",\"last_name\":\"Suri\"},{\"mht_id\":\"444444\",\"first_name\":\"Parth\",\"last_name\":\"Gudkha\"},{\"mht_id\":\"555555\",\"first_name\":\"Laxit\",\"last_name\":\"Patel\"},{\"mht_id\":\"666666\",\"first_name\":\"Vijay\",\"last_name\":\"Yadav\"}]}}",
    //    200);
    return res;
  }

  Future<Response> getAttendanceSession(String date, String group) async {
    Map<String, dynamic> data = {'session_date': date, 'group_name': group};
    Response res = await _postApi(url: '/mba.attendance.get_attendance', data: data);
    //Response res = http.Response(
    //    "{\"message\":{\"data\":{\"date\":\"2019-06-15\",\"group\":\"ahmedabad\",\"dvdtype\":\"parayan\/satsang\",\"dvdno\":123,\"dvdpart\":1,\"remark\":\"target zero session\",\"attendance\":[{\"mht_id\":\"61758\",\"isPresent\":1,\"absentreason\":\"job\"},{\"mht_id\":\"111111\",\"isPresent\":0},{\"mht_id\":\"222222\",\"isPresent\":1},{\"mht_id\":\"333333\",\"isPresent\":0},{\"mht_id\":\"444444\",\"isPresent\":1,\"absentreason\":\"job\"}]}}}",
    //    200);
    return res;
  }

  Future<Response> submitAttendanceSession(Session session) async {
    Map<String, dynamic> data = session.toJson();
    Response res = await _postApi(url: '/mba.attendance.save_attendance', data: data);
    //Response res = http.Response("{\"message\":{\"data\":{}}}", 200);
    return res;
  }

  Future<Response> deleteAttendanceSession(DateTime sessionDate) async {
    Map<String, dynamic> data = {'session_date' : WSConstant.wsDateFormat.format(sessionDate)};
    //Response res = await _postApi(url: '/mba.attendance.delete_attendance', data: data);
    Response res = http.Response("{\"message\":{\"data\":{}}}", 200);
    return res;
  }

  Future<Response> getMonthlySummary(String month, String group) async {
    Map<String, dynamic> data = {'month': month, 'group_name': group};
    Response res = await _postApi(url: '/mba.group_api.get_monthly_summary', data: data);
    /*Response res = http.Response(
        "{\"message\":{\"data\":[{\"mht_id\":\"61758\",\"name\":\"Kamlesh Kanazariya\",\"totalattendancedates\":9,\"presentdates\":2,\"lessattendancereason\":\"\"},{\"mht_id\":\"61758\",\"name\":\"Divyang Mistry\",\"totalattendancedates\":9,\"presentdates\":7,\"lessattendancereason\":\"\"},{\"mht_id\":\"61758\",\"name\":\"Milan Vadher\",\"totalattendancedates\":9,\"presentdates\":6,\"lessattendancereason\":\"\"},{\"mht_id\":\"61758\",\"name\":\"Gaurav Suri\",\"totalattendancedates\":9,\"presentdates\":9,\"lessattendancereason\":\"\"},{\"mht_id\":\"61758\",\"name\":\"Parth Gudkha\",\"totalattendancedates\":9,\"presentdates\":8,\"lessattendancereason\":\"\"},{\"mht_id\":\"61758\",\"name\":\"Laxit Patel\",\"totalattendancedates\":9,\"presentdates\":4,\"lessattendancereason\":\"\"},{\"mht_id\":\"61758\",\"name\":\"Vijay Yadav\",\"totalattendancedates\":9,\"presentdates\":3,\"lessattendancereason\":\"\"}]}}",
        200);*/
    return res;
  }

  Future<Response> getAttendanceSummary(String group) async {
    Map<String, dynamic> data = {'group_name': group};
    Response res = await _postApi(url: '/mba.attendance.get_attendance_summary', data: data);
    /*Response res = http.Response(
        "{\"message\":{\"data\":{\"session_start_date\":\"2019-03-01\",\"total_attendance_dates\":3,\"details\":[{\"mht_id\":\"61758\",\"first_name\":\"Kamlesh\",\"last_name\":\"\",\"present_dates\":2,\"total_attendance_dates\":3},{\"mht_id\":\"55354\",\"first_name\":\"Parth\",\"last_name\":\"Gudhka\",\"present_dates\":3,\"total_attendance_dates\":3}]}}}",
        200);*/
    return res;
  }

  Future<Response> submitMontlyReport(String month, String group, List<AttendanceSummary> summary) async {
    Map<String, dynamic> data = {'month' : month, 'group_name': group, 'less_attendance_reasons' : AttendanceSummary.toJsonList(summary)};
    Response res = await _postApi(url: '/mba.group_api.submit_monthly_report', data: data);
    //Response res = http.Response("{\"message\":{\"data\":{}}}", 200);
    return res;
  }

  Future<Response> getMBAAttendance(String mhtId, String group) async {
    Map<String, dynamic> data = {'mba_mht_id': mhtId , 'group_name': group};
    Response res = await _postApi(url: '/mba.attendance.get_mba_attendance', data: data);
    /*Response res = http.Response(
        "{\"message\":{\"data\":[{\"mht_id\":\"61758\",\"name\":\"Kamlesh Kanazariya\",\"totalattendancedates\":9,\"presentdates\":2,\"lessattendancereason\":\"\"},{\"mht_id\":\"61758\",\"name\":\"Divyang Mistry\",\"totalattendancedates\":9,\"presentdates\":7,\"lessattendancereason\":\"\"},{\"mht_id\":\"61758\",\"name\":\"Milan Vadher\",\"totalattendancedates\":9,\"presentdates\":6,\"lessattendancereason\":\"\"},{\"mht_id\":\"61758\",\"name\":\"Gaurav Suri\",\"totalattendancedates\":9,\"presentdates\":9,\"lessattendancereason\":\"\"},{\"mht_id\":\"61758\",\"name\":\"Parth Gudkha\",\"totalattendancedates\":9,\"presentdates\":8,\"lessattendancereason\":\"\"},{\"mht_id\":\"61758\",\"name\":\"Laxit Patel\",\"totalattendancedates\":9,\"presentdates\":4,\"lessattendancereason\":\"\"},{\"mht_id\":\"61758\",\"name\":\"Vijay Yadav\",\"totalattendancedates\":9,\"presentdates\":3,\"lessattendancereason\":\"\"}]}}",
        200);*/
    return res;
  }

}
