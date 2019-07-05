import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:sadhana/attendance/model/session.dart';
import 'package:sadhana/attendance/model/user_role.dart';
import 'package:sadhana/auth/registration/Inputs/date-input.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/setup/numberpicker.dart';
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

enum PopUpMenu { harder, smarter, selfStarter, tradingCharter }

class AttendanceHomePageState extends BaseState<AttendanceHomePage> {
  bool _selectAll = false;
  static DateTime today = DateTime.now();
  ApiService _api = ApiService();
  Session session;
  Map<String, Attendance> mbaAttendance;
  PopUpMenu _popUpMenu;
  DateTime todaysDate = DateTime.now();
  final _dvdForm = GlobalKey();
  String _dvdType;
  String _dvdNumber;
  String _dvdRemarks;

  @override
  void initState() {
    super.initState();
    // loadData();
  }

  // loadData() async {
  //   startLoading();
  //   UserRole userRole = await AppSharedPrefUtil.getUserRole();
  //   if (userRole != null) {
  //     Response res = await _api.getMBAAttendance(
  //         DateFormat(WSConstant.DATE_FORMAT).format(today), userRole.groupName);
  //     AppResponse appResponse =
  //         AppResponseParser.parseResponse(res, context: context);
  //     if (appResponse.status == WSConstant.SUCCESS_CODE) {
  //       session = Session.fromJson(appResponse.data);
  //       print(session);
  //     }
  //   }
  //   stopLoading();
  // }

  static List<DummyData> data = [
    DummyData("Divyang", false),
    DummyData("Milan", false),
    DummyData("Kamlesh", false),
    DummyData("Gaurav", false),
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

    submitForm() {}

    Future<void> _askedToLead() async {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              title: Center(
                child: Text('MBA DVD Details'),
              ),
              children: <Widget>[
                Builder(
                  builder: (BuildContext context) => Form(
                      key: _dvdForm,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text('Type'),
                                SizedBox(
                                  width: 20,
                                ),
                                Radio(
                                  value: 'satsang',
                                  groupValue: _dvdType,
                                  onChanged: (value) {
                                    setState(() {
                                      _dvdType = value;
                                    });
                                  },
                                ),
                                Text('satsang'),
                                Radio(
                                  value: 'Parayan',
                                  groupValue: _dvdType,
                                  onChanged: (value) {
                                    setState(() {
                                      _dvdType = value;
                                    });
                                  },
                                ),
                                Text('Parayan'),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: <Widget>[
                                Text('DVD'),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 4,
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    onChanged: (val) =>
                                        setState(() => _dvdNumber = val),
                                    decoration:
                                        InputDecoration(labelText: 'Number'),
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 4,
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    onChanged: (val) =>
                                        setState(() => _dvdNumber = val),
                                    decoration:
                                        InputDecoration(labelText: 'Part'),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: <Widget>[
                                Text('Remark'),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  width: 150,
                                  child: TextField(
                                    keyboardType: TextInputType.text,
                                    onChanged: (val) =>
                                        setState(() => _dvdRemarks = val),
                                    decoration:
                                        InputDecoration(labelText: 'Remark'),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                RaisedButton(
                                  onPressed: () {
                                    submitForm();
                                    Navigator.pop(context);
                                  },
                                  child: Text('Submit'),
                                ),
                                RaisedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancle'),
                                ),
                              ],
                            )
                          ],
                        ),
                      )),
                )
              ],
            );
          });
    }

    Future<void> _selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950, 1),
        lastDate: DateTime.now(),
      );
      print(picked);
    }

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: InkWell(
          onTap: () => _selectDate(context),
          child: Container(
            width: MediaQuery.of(context).size.width / 2,
            child: Center(
              child: Text(
                new DateFormat('MMM dd yyy').format(todaysDate),
                style: TextStyle(fontSize: 25),
              ),
            ),
          ),
        ),
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
          PopupMenuButton<PopUpMenu>(
            onSelected: (PopUpMenu result) {
              setState(() {
                _popUpMenu = result;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<PopUpMenu>>[
              const PopupMenuItem<PopUpMenu>(
                value: PopUpMenu.harder,
                child: Text('Working a lot harder'),
              ),
              const PopupMenuItem<PopUpMenu>(
                value: PopUpMenu.smarter,
                child: Text('Being a lot smarter'),
              ),
              const PopupMenuItem<PopUpMenu>(
                value: PopUpMenu.selfStarter,
                child: Text('Being a self-starter'),
              ),
              const PopupMenuItem<PopUpMenu>(
                value: PopUpMenu.tradingCharter,
                child: Text('Placed in charge of trading charter'),
              ),
            ],
            icon: Icon(Icons.menu),
          ),
        ],
      ),
      body: SafeArea(child: list()),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(shape: BoxShape.circle),
        child: FloatingActionButton(
          onPressed: () => _askedToLead(),
          backgroundColor: Colors.red.shade800,
          child: Container(
            height: 70,
            child: Icon(
              Icons.disc_full,
              size: 40,
              color: Colors.white,
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
        ),
      ),
    );
  }
}
