import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sadhana/attendance/mba_attendance_history.dart';
import 'package:sadhana/attendance/model/attendance_summary.dart';
import 'package:sadhana/attendance/model/user_role.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/app_response_parser.dart';
import 'package:sadhana/utils/appsharedpref.dart';
import 'package:sadhana/widgets/base_state.dart';
import 'package:sadhana/widgets/title_with_subtitle.dart';
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
  UserRole _userRole;
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
    _userRole = await AppSharedPrefUtil.getUserRole();
    if (_userRole != null) {
      Response res = await _api.getAttendanceSummary(_userRole.groupName);
      AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
      if (appResponse.status == WSConstant.SUCCESS_CODE) {
        allSummary = AttendanceSummary.fromJsonList(appResponse.data['details']);
        if(allSummary == null)
          allSummary = [];
        filteredSummary = allSummary;
        setTitle();
        print(filteredSummary);
      }
    }
    stopLoading();
  }

  void _filteredSummary() async {
    if (_searchText.isNotEmpty) {
      setState(() {
        filteredSummary = filteredSummary
            .where((summary) => summary.name.toLowerCase().contains(_searchText.toLowerCase()))
            .toList(growable: true);
      });
    }
  }

  void _onSearchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          autofocus: true,
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
        setTitle();
        filteredSummary = allSummary;
        _filter.clear();
      }
    });
  }

  setTitle() {
    _appBarTitle = AppTitleWithSubTitle(title: 'Attendance Summary', subTitle: _userRole.groupTitle,);
  }

  @override
  Widget pageToDisplay() {
    _filteredSummary();
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        centerTitle: true,
        title: _appBarTitle,
        actions: <Widget>[
          IconButton(
            icon: _searchIcon,
            onPressed: _onSearchPressed,
          ),
        ],
      ),
      body: SafeArea(child: _buildListView()),
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
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Card(
        elevation: 5,
        child: ListTile(
          onTap: () {
            onListTileClick(data);
          },
          contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
          dense: true,
          title: Text(data.name),
          trailing: Container(
            decoration: BoxDecoration(
              color: Colors.red.shade500,
            ),
            width: 60,
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
        ),
      ),
    );
  }

  onListTileClick(AttendanceSummary summary) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => MBAAttendanceHistory(mhtID: summary.mhtId, name: summary.name,),
    ),);
  }
}
