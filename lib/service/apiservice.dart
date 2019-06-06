import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:sadhana/constant/sharedpref_constant.dart';
import 'package:sadhana/model/cachedata.dart';
import 'package:sadhana/model/register.dart';
import 'package:sadhana/utils/appsharedpref.dart';
import 'package:sadhana/wsmodel/ws_sadhana_activity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static final _baseServerUrl = 'http://52.140.97.54';
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

  Future<Response> postApi({@required String url, @required Map<String, dynamic> data}) async {
    await checkLogin();
    String postUrl = _apiUrl + url;
    await appendCommonDataToBody(data);
    String body = json.encode(data);
    print('Post Url:' + postUrl + '\tReq:' + body);
    Response res = await http.post(_apiUrl + url, body: body, headers: headers);
    print('Response: ${res.body} status code: ${res.statusCode} msg: ${res.reasonPhrase}');
    return res;
  }

  appendCommonDataToBody(Map<String, dynamic> data) async {
    if(await AppSharedPrefUtil.isUserRegistered()) {
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
    Response res = await postApi(url: '/mba.sadhana.getsadhana_activity', data: data);
    return res;
  }

  Future<Response> getAllCountries() async {
    return await postApi(
      url: '/mba.master.country_list',
      data: {},
    );
  }

  Future<Response> getCityByState(String state) async {
    return await postApi(
        url: '/mba.master.city_list',
        data: {'state': state}
    );
  }

  Future<Response> getStateByCountry(String country) async {
    return await postApi(
      url: '/mba.master.state_list',
      data: {'country': country},
    );
  }

  Future<Response> getSkills() async {
    return await postApi(
      url: '/mba.master.skill_list',
      data: {},
    );
  }

  Future<Response> syncActivity(List<WSSadhanaActivity> wsSadhanaActivity) async {
    Map<String, dynamic> data = {'activity': wsSadhanaActivity.map((v) => v.toJson()).toList() };
    Response res = await postApi(url: '/mba.sadhana.sync', data: data);
    return res;
    /*Response res = new http.Response("{\r\n    \"message\": {\r\n        \"data\": [\r\n            {\r\n                \"name\": \"Samayik\",\r\n                \"data\": [\r\n                    {\r\n                        \"value\": \"1\",\r\n                        \"remark\": null,\r\n                        \"date\": \"2019-05-25\"\r\n                    },\r\n                    {\r\n                        \"value\": \"1\",\r\n                        \"remark\": null,\r\n                        \"date\": \"2019-05-24\"\r\n                    },\r\n                    {\r\n                        \"value\": \"1\",\r\n                        \"remark\": null,\r\n                        \"date\": \"2019-05-23\"\r\n                    },\r\n                    {\r\n                        \"value\": \"0\",\r\n                        \"remark\": null,\r\n                        \"date\": \"2019-05-22\"\r\n                    }\r\n                ]\r\n            },\r\n            {\r\n                \"name\": \"Vanchan\",\r\n                \"data\": [\r\n                    {\r\n                        \"value\": \"5\",\r\n                        \"remark\": null,\r\n                        \"date\": \"2019-05-25\"\r\n                    }\r\n                ]\r\n            },\r\n            {\r\n                \"name\": \"Seva\",\r\n                \"data\": [\r\n                    {\r\n                        \"value\": \"5\",\r\n                        \"remark\": null,\r\n                        \"date\": \"2019-05-25\"\r\n                    }\r\n                ]\r\n            },\r\n            {\r\n                \"name\": \"G. Satsang\",\r\n                \"data\": [\r\n                    {\r\n                        \"value\": \"1\",\r\n                        \"remark\": null,\r\n                        \"date\": \"2019-05-25\"\r\n                    }\r\n                ]\r\n            },\r\n            {\r\n                \"name\": \"Vidhi\",\r\n                \"data\": [\r\n                    {\r\n                        \"value\": \"0\",\r\n                        \"remark\": null,\r\n                        \"date\": \"2019-05-25\"\r\n                    }\r\n                ]\r\n            }\r\n        ]\r\n    }\r\n}",
        200);
    return new Future.delayed(const Duration(seconds: 15), () => res);*/
  }

  Future<Response> generateToken(String mht_id) async {
    Map<String, dynamic> data = {'mht_id': mht_id};
    Response res = await postApi(url: '/mba.user.generate_token', data: data);
    return res;
  }

  Future<Response> register(Register register) async {
    Map<String, dynamic> data = register.toJson();
    Response res = await postApi(url: '/mba.user.update_mba_profile', data: data);
    //Response res = Response("", 200);
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
    Response res = await postApi(url: '/mba.user.save_one_signal_token', data: data);
    return res;
  }

  Future<http.Response> getAppSetting() async {
    http.Response res = await getApi(url: '/mba.sadhana.settings');
    return res;
  }

  Future<http.Response> getMBASchedule(String center, String date) async {
    Map<String, dynamic> data = {'center': center, 'date' : date };
    http.Response res = await postApi(url: '/mba.schedule.get_schedule', data: data);
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


}
