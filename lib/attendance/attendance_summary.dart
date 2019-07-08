import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sadhana/attendance/model/attendance_summary.dart';
import 'package:sadhana/attendance/model/user_role.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/app_response_parser.dart';
import 'package:sadhana/utils/appsharedpref.dart';
import 'package:sadhana/widgets/base_state.dart';
import 'package:sadhana/wsmodel/appresponse.dart';

class AttendanceSummaryPage extends StatefulWidget {
  static const String routeName = '/attendance_summary';

  @override
  _AttendanceSummaryPageState createState() => _AttendanceSummaryPageState();
}

class _AttendanceSummaryPageState extends BaseState<AttendanceSummaryPage> {
  String _searchText = "";
  List<AttendanceSummary> filteredSummary = new List();
  List<AttendanceSummary> allSummary = new List();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Attendance Summary');
  final TextEditingController _filter = new TextEditingController();
  ApiService _api = ApiService();
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
          filteredSummary = allSummary;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  void loadData() async {
    startLoading();
    UserRole userRole = await AppSharedPrefUtil.getUserRole();
    if (userRole != null) {
      Response res = await _api.getAttendanceSummary("Group 1");
      AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
      if (appResponse.status == WSConstant.SUCCESS_CODE) {
        allSummary = AttendanceSummary.fromJsonList(appResponse.data);
        filteredSummary = allSummary;
        print(filteredSummary);
      }
    }
    stopLoading();
  }

  void _filteredSummary() async {
    if (_searchText.isNotEmpty) {
      setState(() {
        filteredSummary =
            filteredSummary.where((summary) => summary.name.toLowerCase().contains(_searchText.toLowerCase())).toList(growable: true);
      });
    }
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
        filteredSummary = allSummary;
        _filter.clear();
      }
    });
  }

  @override
  Widget pageToDisplay() {
    _filteredSummary();
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
      body: _buildListView(),
    );
  }

  _buildListView() {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: ListView.builder(
        itemCount: filteredSummary.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildCardView(filteredSummary[index]);
        },
      ),
    );
  }

  _buildCardView(AttendanceSummary data) {
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
              child: Text(data.name),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                color: Colors.blueGrey,
              ),
              width: 50,
              height: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '${((data.presentDates / data.totalAttendanceDates) * 100).toInt().toString()} %',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    '${data.presentDates}/${data.totalAttendanceDates}',
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
}
