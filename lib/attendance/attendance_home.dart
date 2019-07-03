import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:sadhana/attendance/model/session.dart';
import 'package:sadhana/attendance/model/user_role.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/app_response_parser.dart';
import 'package:sadhana/utils/appsharedpref.dart';
import 'package:sadhana/widgets/base_state.dart';
import 'package:sadhana/wsmodel/appresponse.dart';

class DummyData {
  String name;
  bool isPresent;

  DummyData(this.name, this.isPresent);
}

class AttendanceHomePage extends StatefulWidget {
  static const String routeName = '/attendance_home';

  @override
  AttendanceHomePageState createState() => AttendanceHomePageState();
}

class AttendanceHomePageState extends BaseState<AttendanceHomePage> {
  bool _selectAll = false;
  static DateTime today = DateTime.now();
  ApiService _api = ApiService();
  Session session;
  Map<String, Attendance> mbaAttendance;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    startLoading();
    UserRole userRole = await AppSharedPrefUtil.getUserRole();
    if (userRole != null) {
      Response res = await _api.getMBAAttendance(
          DateFormat(WSConstant.DATE_FORMAT).format(today), userRole.groupName);
      AppResponse appResponse =
          AppResponseParser.parseResponse(res, context: context);
      if (appResponse.status == WSConstant.SUCCESS_CODE) {
        session = Session.fromJson(appResponse.data);
        print(session);
      }
    }
    stopLoading();
  }

  static List<DummyData> data = [
    DummyData("Divyang", false),
    DummyData("Milan", false),
    DummyData("Kamlesh", false),
    DummyData("Gurav", false),
    DummyData("Parth", false),
    DummyData("Laxit", false),
    DummyData("Vijay", false),
    DummyData("Devandra", false),
    DummyData("Darshan", false),
  ];

  @override
  Widget pageToDisplay() {
    cardView(index) {
      return Container(
        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Card(
          elevation: 3,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 6, left: 20, bottom: 6),
                child: Text(
                  data[index].name,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Checkbox(
                onChanged: (bool value) {
                  data[index].isPresent = value;
                },
                value: data[index].isPresent,
              )
            ],
          ),
        ),
      );
    }

    list() {
      return Container(
        padding: EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            return cardView(index);
          },
        ),
      );
    }

    ;

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text('AttendanceHome Page'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Container(
            color: Colors.blueGrey,
            child: Card(
              elevation: 8,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 6, left: 20, bottom: 6),
                    child: Text(
                      'Select All',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Checkbox(
                    onChanged: (bool value) {
                      _selectAll = value;
                    },
                    value: _selectAll,
                  )
                ],
              ),
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person_add),
            onPressed: () {
              print('ADD_PERSON');
            },
          ),
          IconButton(
            icon: AnimatedIcon(
              progress: AlwaysStoppedAnimation<double>(0.0),
              icon: AnimatedIcons.menu_home,
            ),
            onPressed: () {
              print('More !!!');
            },
          )
        ],
      ),
      body: SafeArea(child: list()),
    );
  }
}
