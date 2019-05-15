import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:sadhana/auth/login.dart';
import 'package:sadhana/auth/registration/registration.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/constant/sadhanatype.dart';
import 'package:sadhana/dao/sadhanadao.dart';
import 'package:sadhana/model/activity.dart';
import 'package:sadhana/model/sadhana.dart';
import 'package:sadhana/sadhana/sadhanaEdit.dart';
import 'package:sadhana/sadhana/time-table.dart';
import 'package:sadhana/utils/appcsvutils.dart';
import 'package:sadhana/utils/appsharedpref.dart';
import 'package:sadhana/widgets/base_state.dart';
import 'package:sadhana/widgets/checkmarkbutton.dart';
import 'package:sadhana/widgets/create_sadhana_dialog.dart';
import 'package:sadhana/widgets/nameheading.dart';
import 'package:sadhana/widgets/numberbutton.dart';
import 'package:sadhana/widgets/sadhana_horizontal_panel.dart';
import '../attendance/attendance_home.dart';
import '../setup/numberpicker.dart';
import 'package:sadhana/commonvalidation.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  const HomePage({
    Key key,
    this.optionsPage,
  }) : super(key: key);

  final Widget optionsPage;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  static DateTime now = new DateTime.now();
  DateTime today = new DateTime(now.year, now.month, now.day);
  static int durationInDays = Constant.displayDays;
  List<Sadhana> tmpSadhanas = new List();
  List<Sadhana> sadhanas = new List();
  DateTime selectedDate = DateTime.now();
  DateTime initialDate = DateTime.now();
  double headerWidth = 150.0;
  Brightness theme;
  BuildContext context;
  double mobileWidth;
  SadhanaDAO sadhanaDAO = SadhanaDAO();
  int sadhanaIndex = 0;

  void addSadhana({
    @required int id,
    @required SadhanaType type,
    @required String title,
    @required List<Color> color,
  }) {
    tmpSadhanas.add(Sadhana(
        sadhanaName: title,
        lColor: color[0],
        dColor: color[1],
        sadhanaType: type,
        sadhanaData: new Map(),
        sadhanaIndex: sadhanaIndex++));
  }

  @override
  void initState() {
    super.initState();
    loadSadhana();
  }

  void loadSadhana() async {
    await createPreloadedSadhana();
    sadhanaDAO.getAll().then((dbSadhanas) {
      setState(() {
        sadhanas.addAll(dbSadhanas);
      });
    });
  }

  void addNewSadhana(Sadhana sadhana) {
    sadhanas.add(sadhana);
  }

  void loadPreloadedSadhana() {
    addSadhana(
      id: 1,
      type: SadhanaType.BOOLEAN,
      title: 'Samayik',
      color: Constant.colors[0],
    );
    addSadhana(id: 2, type: SadhanaType.NUMBER, title: 'Vanchan', color: Constant.colors[3]);
    addSadhana(id: 3, type: SadhanaType.BOOLEAN, title: 'Vidhi', color: Constant.colors[7]);
    addSadhana(id: 4, type: SadhanaType.BOOLEAN, title: 'G. Satsang', color: Constant.colors[8]);
    addSadhana(id: 5, type: SadhanaType.NUMBER, title: 'Seva', color: Constant.colors[12]);
  }

  void createPreloadedSadhana() async {
    if (!await AppSharedPrefUtil.isCreatedPreloadedSadhana()) {
      loadPreloadedSadhana();
      tmpSadhanas.forEach((sadhana) {
        sadhanaDAO.insert(sadhana);
      });
      AppSharedPrefUtil.saveCreatedPreloadedSadhana(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context).brightness;
    this.context = context;
    mobileWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.all(10),
          child: Image.asset('images/logo_dada.png'),
        ),
        title: Text('Sadhana'),
        actions: _buildActions(),
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: headerWidth,
                  child: Column(
                    children: _buildLeftPanel(),
                  ),
                ),
                Container(
                  width: mobileWidth - headerWidth,
                  child: Container(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          Column(children: _buildRightPanelWidget()),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _addNewSadhana() {
    showDialog(context: context, builder: (_) => CreateSadhanaDialog(addNewSadhana)).then((value) {
      setState(() {});
    });
  }

  List<Widget> _buildLeftPanel() {
    List<Widget> widgets = new List();
    widgets.add(_mainHeaderTitle('<<' + Constant.monthName[today.month - 1] + '>>'));
    List<Widget> sadhanaHeadings = sadhanas.map((sadhana) {
      return NameHeading(headerWidth: headerWidth, sadhana: sadhana);
    }).toList();
    widgets.addAll(sadhanaHeadings);
    return widgets;
  }

  Widget _mainHeaderTitle(title) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 4),
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: Container(
        height: 60,
        width: headerWidth + 10,
        child: Center(
          child: Text(
            title,
            overflow: TextOverflow.fade,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildRightPanelWidget() {
    List<DateTime> daysToDisplay = getDaysToDisplay();
    List<Widget> rightWidgets = new List();
    rightWidgets.add(_headerList(daysToDisplay));
    List<Widget> activityWidgets = sadhanas.map((sadhana) {
      return SadhanaHorizontalPanel(sadhana: sadhana, daysToDisplay: daysToDisplay);
    }).toList();
    rightWidgets.addAll(activityWidgets);
    return rightWidgets;
  }

  getDaysToDisplay() {
    return List.generate(durationInDays, (int index) {
      return today.subtract(new Duration(days: index));
    });
  }

  Widget _headerListData(String weekDay, int date) {
    return Container(
      height: 60,
      width: 48,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[Text(weekDay, textScaleFactor: 0.7), Text('$date', textScaleFactor: 0.9)],
        ),
      ),
    );
  }

  Widget _headerList(List<DateTime> daysToDisplay) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.fromLTRB(0, 0, 5, 4),
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: daysToDisplay.map((day) {
            return _headerListData(Constant.weekName[day.weekday - 1], day.day);
          }).toList(),
        ),
      ),
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.sync),
        onPressed: () {
          Navigator.pushNamed(context, RegistrationPage.routeName);
        },
        tooltip: 'Sync Data',
      ),
      IconButton(
        icon: Icon(Icons.add),
        onPressed: _addNewSadhana,
        tooltip: 'Add new Sadhana',
      ),
      PopupMenuButton(
        onSelected: (value) {
          handleOptionClick(value);
        },
        tooltip: 'Press to get more options',
        itemBuilder: (BuildContext context) {
          return [
            PopupMenuItem(
              child: ListTile(
                trailing: Icon(Icons.save_alt, color: Colors.red),
                title: Text('Save as Excel'),
              ),
              value: 'save_excel',
            ),
            PopupMenuItem(
              child: ListTile(
                trailing: Icon(Icons.share, color: Colors.green),
                title: Text('Share Excel'),
              ),
              value: 'share_excel',
            ),
            PopupMenuItem(
              child: ListTile(
                trailing: Icon(Icons.settings, color: Colors.blueGrey),
                title: Text('Options'),
              ),
              value: 'options',
            ),
            PopupMenuItem(
              child: ListTile(
                trailing: Icon(Icons.data_usage, color: Colors.orange),
                title: Text('Attendance App'),
              ),
              value: 'attendance',
            ),
          ];
        },
      )
    ];
  }

  void handleOptionClick(String value) {
    print(value);
    switch (value) {
      case 'save_excel':
        onSaveExcel();
        break;
      case 'share_excel':
        Navigator.pushNamed(context, TimeTablePage.routeName);
        break;
      case 'options':
        print('On press options');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => widget.optionsPage),
        );
        break;
      case 'attendance':
        Navigator.pushNamed(context, AttendanceHomePage.routeName);
        break;
    }
  }

  void onSaveExcel() {
    showMonthPicker(context: context, initialDate: selectedDate ?? initialDate).then((date) => generateCSV(date));
  }

  generateCSV(date) async {
    List<Activity> activities = new List();
    activities.add(Activity(sadhanaId: 12, sadhanaDate: DateTime.now(), sadhanaValue: 1, remarks: 'Test'));
    activities.add(Activity(sadhanaId: 13, sadhanaDate: DateTime.now(), sadhanaValue: 1, remarks: 'Test'));
    activities.add(Activity(sadhanaId: 14, sadhanaDate: DateTime.now(), sadhanaValue: 1, remarks: 'Test'));
    selectedDate = date;
    String file = await AppCSVUtils.generateCSV(activities);
    print(file);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Wrap(
            children: <Widget>[
              Text(
                'Your File is successuflly created, Path: $file',
                overflow: TextOverflow.clip,
              )
            ],
          ),
        );
      },
    );
  }
}
