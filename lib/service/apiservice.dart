import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:sadhana/constant/sharedpref_constant.dart';
import 'package:sadhana/utils/appsharedpref.dart';
import 'package:sadhana/wsmodel/ws_sadhana_activity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final _apiUrl = 'http://52.140.97.54/api/method';

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
    String body = json.encode(data);
    print('Post Url:' + postUrl + '\tReq:' + body);
    Response res = await http.post(_apiUrl + url, body: body, headers: headers);
    print('Response:' + res.body);
    return res;
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
    Map<String, dynamic> data = {'mht_id': 123456};
    Response res = await postApi(url: '/mba.sadhana.getsadhana_activity', data: data);
    return res;
    /*Response res = new http.Response("{\r\n    \"message\": {\r\n        \"data\": [\r\n            {\r\n                \"name\": \"Samayik\",\r\n                \"data\": [\r\n                    {\r\n                        \"value\": \"1\",\r\n                        \"remark\": null,\r\n                        \"date\": \"2019-05-25\"\r\n                    },\r\n                    {\r\n                        \"value\": \"1\",\r\n                        \"remark\": null,\r\n                        \"date\": \"2019-05-24\"\r\n                    },\r\n                    {\r\n                        \"value\": \"1\",\r\n                        \"remark\": null,\r\n                        \"date\": \"2019-05-23\"\r\n                    },\r\n                    {\r\n                        \"value\": \"0\",\r\n                        \"remark\": null,\r\n                        \"date\": \"2019-05-22\"\r\n                    }\r\n                ]\r\n            },\r\n            {\r\n                \"name\": \"Vanchan\",\r\n                \"data\": [\r\n                    {\r\n                        \"value\": \"5\",\r\n                        \"remark\": null,\r\n                        \"date\": \"2019-05-25\"\r\n                    }\r\n                ]\r\n            },\r\n            {\r\n                \"name\": \"Seva\",\r\n                \"data\": [\r\n                    {\r\n                        \"value\": \"5\",\r\n                        \"remark\": null,\r\n                        \"date\": \"2019-05-25\"\r\n                    }\r\n                ]\r\n            },\r\n            {\r\n                \"name\": \"G. Satsang\",\r\n                \"data\": [\r\n                    {\r\n                        \"value\": \"1\",\r\n                        \"remark\": null,\r\n                        \"date\": \"2019-05-25\"\r\n                    }\r\n                ]\r\n            },\r\n            {\r\n                \"name\": \"Vidhi\",\r\n                \"data\": [\r\n                    {\r\n                        \"value\": \"0\",\r\n                        \"remark\": null,\r\n                        \"date\": \"2019-05-25\"\r\n                    }\r\n                ]\r\n            }\r\n        ]\r\n    }\r\n}",
        200);
    return new Future.delayed(const Duration(seconds: 15), () => res);*/
  }

  Future<Response> syncActivity(List<WSSadhanaActivity> wsSadhanaActivity) async {
    Map<String, dynamic> data = {'mht_id': "123456", 'activity': wsSadhanaActivity.map((v) => v.toJson()).toList() };
    Response res = await postApi(url: '/mba.sadhana.sync', data: data);
    return res;
    /*Response res = new http.Response("{\r\n    \"message\": {\r\n        \"data\": [\r\n            {\r\n                \"name\": \"Samayik\",\r\n                \"data\": [\r\n                    {\r\n                        \"value\": \"1\",\r\n                        \"remark\": null,\r\n                        \"date\": \"2019-05-25\"\r\n                    },\r\n                    {\r\n                        \"value\": \"1\",\r\n                        \"remark\": null,\r\n                        \"date\": \"2019-05-24\"\r\n                    },\r\n                    {\r\n                        \"value\": \"1\",\r\n                        \"remark\": null,\r\n                        \"date\": \"2019-05-23\"\r\n                    },\r\n                    {\r\n                        \"value\": \"0\",\r\n                        \"remark\": null,\r\n                        \"date\": \"2019-05-22\"\r\n                    }\r\n                ]\r\n            },\r\n            {\r\n                \"name\": \"Vanchan\",\r\n                \"data\": [\r\n                    {\r\n                        \"value\": \"5\",\r\n                        \"remark\": null,\r\n                        \"date\": \"2019-05-25\"\r\n                    }\r\n                ]\r\n            },\r\n            {\r\n                \"name\": \"Seva\",\r\n                \"data\": [\r\n                    {\r\n                        \"value\": \"5\",\r\n                        \"remark\": null,\r\n                        \"date\": \"2019-05-25\"\r\n                    }\r\n                ]\r\n            },\r\n            {\r\n                \"name\": \"G. Satsang\",\r\n                \"data\": [\r\n                    {\r\n                        \"value\": \"1\",\r\n                        \"remark\": null,\r\n                        \"date\": \"2019-05-25\"\r\n                    }\r\n                ]\r\n            },\r\n            {\r\n                \"name\": \"Vidhi\",\r\n                \"data\": [\r\n                    {\r\n                        \"value\": \"0\",\r\n                        \"remark\": null,\r\n                        \"date\": \"2019-05-25\"\r\n                    }\r\n                ]\r\n            }\r\n        ]\r\n    }\r\n}",
        200);
    return new Future.delayed(const Duration(seconds: 15), () => res);*/
  }

  Future<http.Response> getAppSetting() async {
    http.Response res = await getApi(url: '/mba.sadhana.settings');
    return res;
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
