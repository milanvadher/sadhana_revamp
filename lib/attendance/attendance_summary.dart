import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sadhana/attendance/model/monthly_summary.dart';
import 'package:sadhana/attendance/model/user_role.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/app_response_parser.dart';
import 'package:sadhana/utils/appsharedpref.dart';
import 'package:sadhana/widgets/base_state.dart';
import 'package:sadhana/wsmodel/appresponse.dart';

class AttendanceSummaryModel {
  String name;
  int totalDays;
  int presentDays;

  AttendanceSummaryModel(this.name, this.presentDays, this.totalDays);
}

class AttendanceSummaryPage extends StatefulWidget {
  static const String routeName = '/attendance_summary';

  @override
  _AttendanceSummaryPageState createState() => _AttendanceSummaryPageState();
}

class _AttendanceSummaryPageState extends BaseState<AttendanceSummaryPage> {
  String _searchText = "";
  List names = new List(); // names we get from API
  List listOfSummary = new List(); // names filtered by search text
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Attendance Summary');
  final TextEditingController _filter = new TextEditingController();
  ApiService _api = ApiService();
  
  List<AttendanceSummaryModel> data = [
    AttendanceSummaryModel('lol 01', 34, 50),
    AttendanceSummaryModel('lol 02', 14, 50),
    AttendanceSummaryModel('lol 03', 25, 50),
    AttendanceSummaryModel('lol 04', 40, 50),
    AttendanceSummaryModel('lol 05', 43, 50),
    AttendanceSummaryModel('lol 06', 28, 50),
    AttendanceSummaryModel('lol 07', 31, 50),
    AttendanceSummaryModel('lol 08', 47, 50),
    AttendanceSummaryModel('lol 09', 10, 50),
    AttendanceSummaryModel('lol 10', 39, 50),
  ];

  int month = new DateTime.now().month;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  _AttendanceSummaryPageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          listOfSummary = names;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  loadData() async {
    // startLoading();
    // UserRole userRole = await AppSharedPrefUtil.getUserRole();
    // if (userRole != null) {
    // Response res = await _api.getMBAMonthlySummary('2019-05', 'A');
    // AppResponse appResponse =
    //     AppResponseParser.parseResponse(res, context: context);
    // if (appResponse.status == WSConstant.SUCCESS_CODE) {
    //   listOfSummary = MonthlySummary.fromJsonList(appResponse.data);
    //   print(listOfSummary);
    // }
    // }
    // stopLoading();
  }

  void _getsearchedData() async {

    setState(() {
      // names = tempList;
      listOfSummary = names;
    });
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          cursorColor: Colors.white,
          keyboardType: TextInputType.text,
          style: TextStyle(color: Colors.white),
          decoration: new InputDecoration(
              border: InputBorder.none,
              labelStyle: TextStyle(color: Colors.white),
              prefixIcon: new Icon(Icons.search, color: Colors.white),
              hintStyle: TextStyle(color: Colors.white),
              hintText: 'Search...'),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Attendance Summary');
        listOfSummary = names;
        _filter.clear();
      }
    });
  }

  @override
  Widget pageToDisplay() {
    // TODO: implement build

    cardView(AttendanceSummaryModel data) {
      return Container(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  data.name,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  color: Colors.blueGrey,
                ),
                width: 50,
                height: 60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '${((data.presentDays / data.totalDays) * 100).toInt().toString()} %',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      '${data.presentDays}/${data.totalDays}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    list() {
      return Container(
        padding: EdgeInsets.only(top: 15),
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            return cardView(data[index]);
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: _appBarTitle,
        actions: <Widget>[
          IconButton(
            icon: _searchIcon,
            onPressed: _searchPressed,
          ),
        ],
      ),
      body: list(),
    );
  
  }
}
