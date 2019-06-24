import 'package:flutter/material.dart';
import 'package:sadhana/constant/colors.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/model/cachedata.dart';
import 'package:sadhana/utils/app_setting_util.dart';
import 'package:sadhana/widgets/base_state.dart';
import 'package:url_launcher/url_launcher.dart';

class _LinkText extends GestureDetector {
  _LinkText({TextStyle style, String url, String text})
      : super(
          child: Container(
            margin: EdgeInsets.all(1),
            padding: EdgeInsets.all(1),
            child: Text(
              text ?? url,
              style: style,
            ),
            decoration: new BoxDecoration(
              border: new Border(
                bottom:
                    new BorderSide(color: Colors.blue, style: BorderStyle.solid),
              ),
            ),
          ),
          onTap: () {
            launch(url);
          },
        );
}

final TextStyle linkStyle = TextStyle(
  color: Colors.blue,
  decoration: TextDecoration.none
 );

class About extends StatefulWidget {
  static const String routeName = '/about';
  @override
  AboutState createState() {
    return new AboutState();
  }
}

class AboutState extends BaseState<About> {
  String appVersion = '';
  String mhtid = '';
  AboutState() {
    isLoading = true;
    AppSettingUtil.getAppVersion().then((version) {
      setState(() {
        appVersion = version;
        isLoading = false;
      });
    });
    CacheData.getUserProfile().then((profile) {
      setState(() {
        mhtid = profile.mhtId;
      });
    });
  }

  @override
  Widget pageToDisplay() {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
      ),
      body: ListView(
        children: <Widget>[
          Image.asset('images/about_logo.jpg',),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.all(5),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Version: ",),
                    Text(appVersion),
                  ],
                ),
                SizedBox(height: 20),
                Text("Links", style: TextStyle(fontSize: 18),),
                SizedBox(height: 30),
                Text("For any query email us @", style: TextStyle(fontSize: 14),),
                SizedBox(height: 10),
                _LinkText(
                  style: linkStyle,
                  text: Constant.MBA_MAILID,
                  url: "mailto:" + Constant.MBA_MAILID +"?subject=Feedback%20of%20Sadhana",
                ),
                SizedBox(height: 40),
                Text("Send Bug Report to us with screenshots @", style: TextStyle(fontSize: 14),),
                SizedBox(height: 10),
                _LinkText(
                  style: linkStyle,
                  text: "mbaapps@googlegroups.com",
                  url: "mailto:" + Constant.MBA_MAILID + "?subject=Bug%20Report%20of%20Sadhana",
                ),
                SizedBox(height: 30),
                Text("MHT ID: $mhtid", style: TextStyle(fontSize: 14),),
              ],
            ),
          )
        ]
      ));
  }
}