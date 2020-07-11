import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:sadhana/attendance/model/attendance_summary.dart';
import 'package:sadhana/attendance/model/event.dart';
import 'package:sadhana/attendance/model/fill_attendance_data.dart';
import 'package:sadhana/attendance/model/session.dart';
import 'package:sadhana/constant/sharedpref_constant.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/model/center_change_request.dart';
import 'package:sadhana/model/register.dart';
import 'package:sadhana/model/registration_request.dart';
import 'package:sadhana/utils/appsharedpref.dart';
import 'package:sadhana/wsmodel/ws_sadhana_activity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static final _baseServerUrl = 'http://52.140.97.54'; //Test
  //static final _baseServerUrl = 'https://sadhanaapi.dbf.ooo';  //Live
  static final _apiUrl = '$_baseServerUrl/api/method';
  static final _resourceApiUrl = '$_baseServerUrl/api/resource';

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
      {@required String url,
      @required Map<String, dynamic> data,
      bool isResource = false}) async {
    await checkLogin();
    String postUrl = isResource ? _resourceApiUrl + url : _apiUrl + url;
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

  Future<Response> getRegRequest(String mhtId) async {
    Map<String, dynamic> data = {"mht_id" : mhtId};
    Response res = await _postApi(url: '/mba.user.check_mba_registration_status', data: data);
    return res;
  }

  Future<Response> sendRequest(RegistrationRequest registrationRequest) async {
    Map<String, dynamic> data = registrationRequest.toJson();
    Response res =
        await _postApi(url: '/mba.user.req_mba_registration', data: data);
    return res;
  }

  Future<Response> centerChangeRequest(
      CenterChangeRequest centerChangeRequest) async {
    Map<String, dynamic> data = centerChangeRequest.toJson();
    return await _postApi(url: '/mba.user.center_change_request', data: data);
  }

  Future<Response> getCenterChangeRequest() async {
    Map<String, dynamic> data = {};
    return await _postApi(url: '/mba.user.get_center_change_request', data: data);
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

  Map<String, dynamic> addAttendanceCoordinatorData(Map<String, dynamic> data, FillAttendanceData fillAttendanceData) {
    data['group_name'] = fillAttendanceData.groupName;
    data['event_name'] = fillAttendanceData.eventName;
    data['event_type'] = FillAttendanceData.convertEnumToStr(fillAttendanceData.attendanceType);
    return data;
  }

  Future<Response> getUserAccess() async {
    Map<String, dynamic> data = {};
    return await _postApi(url: '/mba.user.get_user_access', data: data);
  }

  Future<Response> getMonthPendingForAttendance(FillAttendanceData fillAttendanceData) async {
    Map<String, dynamic> data = addAttendanceCoordinatorData({}, fillAttendanceData);
    Response res = await _postApi(
        url: '/mba.attendance.get_month_pending_for_attendance', data: data);
    //Response res = http.Response("{\r\n    \"message\": {\r\n        \"data\": {\r\n            \"role\": \"\",\r\n            \"group_name\": \"\"\r\n        }\r\n    }\r\n}", 200);
    return res;
  }

  Future<Response> getSessionDates(FillAttendanceData fillAttendanceData) async {
    Map<String, dynamic> data = addAttendanceCoordinatorData({}, fillAttendanceData);
    return await _postApi(url: '/mba.attendance.get_session_dates', data: data);
  }

  Future<Response> getMBAOfGroup(String date, String group) async {
    Map<String, dynamic> data = {'date': date, 'group_name': group};
    return _postApi(url: '/mba.group_api.get_mba_by_group', data: data);
  }

  Future<Response> getAttendanceSession(FillAttendanceData fillAttendanceData, {String sessionName, String eventName}) async {
    Map<String, dynamic> data = addAttendanceCoordinatorData({'session_name': sessionName}, fillAttendanceData);
    if(eventName != null)
      data['event_name'] = eventName;
    return await _postApi(url: '/mba.attendance.get_attendance', data: data);
  }

  Future<Response> getSessionAttendance(String sessionName, FillAttendanceData fillAttendanceData) async {
    return getAttendanceSession(fillAttendanceData, sessionName: sessionName);
  }
  Future<Response> getEventAttendance(FillAttendanceData fillAttendanceData, String eventName) async {
    return getAttendanceSession(fillAttendanceData, eventName: eventName);
  }

  Future<Response> submitAttendanceSession(Event event) async {
    Map<String, dynamic> data = event.toJson();
    Response res = await _postApi(url: '/mba.attendance.save_attendance', data: data);
    //Response res = http.Response("{\"message\":{\"data\":{}}}", 200);
    return res;
  }

  Future<Response> deleteAttendanceSession(String sessionName,
      DateTime sessionDate, FillAttendanceData fillAttendanceData) async {
    Map<String, dynamic> data = {
      'session_name' : sessionName,
      'session_date': WSConstant.wsDateFormat.format(sessionDate),
      'group_name': fillAttendanceData.groupName,
     "event_name": fillAttendanceData.eventName
    };
    Response res =
        await _postApi(url: '/mba.attendance.delete_session', data: data);
    //Response res = http.Response("{\"message\":{\"data\":{}}}", 200);
    return res;
  }

  Future<Response> getMonthlySummary(String month, FillAttendanceData fillAttendanceData) async {
    Map<String, dynamic> data = {'month': month, 'group_name': fillAttendanceData.groupName, "event_name": fillAttendanceData.eventName};
    Response res =
        await _postApi(url: '/mba.group_api.get_monthly_summary', data: data);
    /*Response res = http.Response(
        "{\"message\":{\"data\":[{\"mht_id\":\"61758\",\"name\":\"Kamlesh Kanazariya\",\"totalattendancedates\":9,\"presentdates\":2,\"lessattendancereason\":\"\"},{\"mht_id\":\"61758\",\"name\":\"Divyang Mistry\",\"totalattendancedates\":9,\"presentdates\":7,\"lessattendancereason\":\"\"},{\"mht_id\":\"61758\",\"name\":\"Milan Vadher\",\"totalattendancedates\":9,\"presentdates\":6,\"lessattendancereason\":\"\"},{\"mht_id\":\"61758\",\"name\":\"Gaurav Suri\",\"totalattendancedates\":9,\"presentdates\":9,\"lessattendancereason\":\"\"},{\"mht_id\":\"61758\",\"name\":\"Parth Gudkha\",\"totalattendancedates\":9,\"presentdates\":8,\"lessattendancereason\":\"\"},{\"mht_id\":\"61758\",\"name\":\"Laxit Patel\",\"totalattendancedates\":9,\"presentdates\":4,\"lessattendancereason\":\"\"},{\"mht_id\":\"61758\",\"name\":\"Vijay Yadav\",\"totalattendancedates\":9,\"presentdates\":3,\"lessattendancereason\":\"\"}]}}",
        200);*/
    return res;
  }

  Future<Response> getAttendanceSummary(FillAttendanceData fillAttendanceData) async {
    Map<String, dynamic> data = addAttendanceCoordinatorData({}, fillAttendanceData);
    Response res = await _postApi(
        url: '/mba.attendance.get_attendance_summary', data: data);
    /*Response res = http.Response(
        "{\"message\":{\"data\":{\"session_start_date\":\"2019-03-01\",\"total_attendance_dates\":3,\"details\":[{\"mht_id\":\"61758\",\"first_name\":\"Kamlesh\",\"last_name\":\"\",\"present_dates\":2,\"total_attendance_dates\":3},{\"mht_id\":\"55354\",\"first_name\":\"Parth\",\"last_name\":\"Gudhka\",\"present_dates\":3,\"total_attendance_dates\":3}]}}}",
        200);*/
    return res;
  }

  Future<Response> getMyAttendanceSummary() async {
    Map<String, dynamic> data = {};
    return await _postApi(url: '/mba.attendance.get_my_attendance_summary', data: data);
  }

  Future<Response> submitMontlyReport(
      String month, List<AttendanceSummary> summary, FillAttendanceData fillAttendanceData) async {
    Map<String, dynamic> data = addAttendanceCoordinatorData({'month': month, 'less_attendance_reasons': AttendanceSummary.toJsonList(summary)}, fillAttendanceData);
    Response res =
        await _postApi(url: '/mba.group_api.submit_monthly_report', data: data);
    //Response res = http.Response("{\"message\":{\"data\":{}}}", 200);
    return res;
  }

  Future<Response> getMBAAttendance(String mhtId, FillAttendanceData fillAttendanceData) async {
    Map<String, dynamic> data = addAttendanceCoordinatorData({'mba_mht_id': mhtId}, fillAttendanceData);
    Response res =
        await _postApi(url: '/mba.attendance.get_mba_attendance', data: data);
    /*Response res = http.Response(
        "{\"message\":{\"data\":[{\"mht_id\":\"61758\",\"name\":\"Kamlesh Kanazariya\",\"totalattendancedates\":9,\"presentdates\":2,\"lessattendancereason\":\"\"},{\"mht_id\":\"61758\",\"name\":\"Divyang Mistry\",\"totalattendancedates\":9,\"presentdates\":7,\"lessattendancereason\":\"\"},{\"mht_id\":\"61758\",\"name\":\"Milan Vadher\",\"totalattendancedates\":9,\"presentdates\":6,\"lessattendancereason\":\"\"},{\"mht_id\":\"61758\",\"name\":\"Gaurav Suri\",\"totalattendancedates\":9,\"presentdates\":9,\"lessattendancereason\":\"\"},{\"mht_id\":\"61758\",\"name\":\"Parth Gudkha\",\"totalattendancedates\":9,\"presentdates\":8,\"lessattendancereason\":\"\"},{\"mht_id\":\"61758\",\"name\":\"Laxit Patel\",\"totalattendancedates\":9,\"presentdates\":4,\"lessattendancereason\":\"\"},{\"mht_id\":\"61758\",\"name\":\"Vijay Yadav\",\"totalattendancedates\":9,\"presentdates\":3,\"lessattendancereason\":\"\"}]}}",
        200);*/
    return res;
  }

  Future<Response> fetchEvents({@required String groupName}) async {
    Map<String, dynamic> data = {'group_name': groupName};
    return await _postApi(url: '/mba.attendance.get_events', data: data);
  }

  Future<Response> getMBAEventsAttendance() async {
    Map<String, dynamic> data = {'event_type': 'Event'};
    return await _postApi(url: '/mba.attendance.get_mba_event_attendance', data: data);
  }

}
