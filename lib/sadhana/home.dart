import 'package:flutter/material.dart';
import 'package:sadhana/auth/login.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/sadhana/sadhanaEdit.dart';
import 'package:sadhana/sadhana/time-table.dart';
import '../attendance/attendance_home.dart';
import '../setup/numberpicker.dart';
import 'package:sadhana/common.dart';

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
  static DateTime today = new DateTime.now();
  static int durationInDays = Constant.displayDays;
  List<SadhanaHeading> titleHeader = [
    SadhanaHeading(
      title: '<<' + Constant.monthName[today.month - 1] + '>>',
      isHeading: true,
    ),
  ];
  List<SadhanaData> sadhanaData = [
    SadhanaData(isHeading: true),
  ];
  List<List<dynamic>> userSadhanaData = [];
  List _userSadhanaData = [];

  double headerWidth = 150.0;

  void handleOptionClick(String value) {
    print(value);
    switch (value) {
      case 'save_excel':
        {
          print('$userSadhanaData');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Sadhana Data'),
                content: Wrap(
                  children: <Widget>[
                    Text(
                      '$_userSadhanaData',
                      overflow: TextOverflow.clip,
                    )
                  ],
                ),
              );
            },
          );
        }
        break;

      case 'share_excel':
        {
          Navigator.pushNamed(context, TimeTablePage.routeName);
        }
        break;

      case 'options':
        {
          print('On press options');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => widget.optionsPage),
          );
        }
        break;

      case 'attendance':
        {
          Navigator.pushNamed(context, AttendanceHomePage.routeName);
        }
        break;
    }
  }

  static Widget _headerListData(String weekDay, int date) {
    return Container(
      height: 60,
      width: 48,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(weekDay, textScaleFactor: 0.7),
            Text('$date', textScaleFactor: 0.9)
          ],
        ),
      ),
    );
  }

  static Widget _headerList() {
    return Card(
      elevation: 10,
      margin: EdgeInsets.fromLTRB(0, 0, 5, 4),
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(durationInDays, (int index) {
            DateTime day = today.subtract(new Duration(days: index));
            return _headerListData(Constant.weekName[day.weekday - 1], day.day);
          }),
        ),
      ),
    );
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

  /// Add new Sadhana at end
  void createSadhana({
    @required SadhanaType type,
    @required String title,
    @required List<Color> color,
  }) {
    int index = titleHeader.length - 1;
    titleHeader.add(SadhanaHeading(
      title: title,
      color: color,
      type: type,
      index: index,
    ));
    userSadhanaData.add([]);
    Map<String, dynamic> _data = {
      'id': index,
      'name': title,
      'color': color,
      'date': DateTime.now(),
      'sadhanaData': []
    };
    _userSadhanaData.add(_data);
    for (int i = 0; i < durationInDays; i++) {
      type == SadhanaType.BOOLEAN
          ? userSadhanaData[index].add(false)
          : userSadhanaData[index].add(0);
      _userSadhanaData[index]['sadhanaData'].add([
        DateTime.now().subtract(Duration(days: i)),
        type == SadhanaType.BOOLEAN ? false : 0,
        ""
      ]);
    }
    sadhanaData.add(SadhanaData(
      index: index,
      color: color,
      type: type,
    ));
  }

  @override
  void initState() {
    super.initState();
    createSadhana(
      type: SadhanaType.BOOLEAN,
      title: 'Samayik',
      color: Constant.colors[0],
    );
    createSadhana(
      type: SadhanaType.NUMBER,
      title: 'Vanchan',
      color: Constant.colors[3],
    );
    createSadhana(
      type: SadhanaType.BOOLEAN,
      title: 'Vidhi',
      color: Constant.colors[7],
    );
    createSadhana(
      type: SadhanaType.BOOLEAN,
      title: 'G. Satsang',
      color: Constant.colors[8],
    );
    createSadhana(
      type: SadhanaType.NUMBER,
      title: 'Seva',
      color: Constant.colors[12],
    );
  }

  @override
  Widget build(BuildContext context) {
    Brightness theme = Theme.of(context).brightness;

    double mobileWidth = MediaQuery.of(context).size.width;

    Widget _horizontalList(
        int sadhanaIndex, List<Color> color, SadhanaType type) {
      return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        margin: EdgeInsets.fromLTRB(0, 4, 4, 4),
        child: Container(
          height: 50,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                durationInDays,
                (int index) {
                  return type == SadhanaType.BOOLEAN
                      ? InkWell(
                          onTap: () {
                            setState(() {
                              _userSadhanaData[sadhanaIndex]['sadhanaData']
                                      [index][1] =
                                  !_userSadhanaData[sadhanaIndex]['sadhanaData']
                                      [index][1];
                            });
                          },
                          child: Container(
                            width: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color[theme == Brightness.light ? 0 : 1]
                                  .withAlpha(_userSadhanaData[sadhanaIndex]
                                          ['sadhanaData'][index][1]
                                      ? 20
                                      : 0),
                              border: Border.all(
                                color: theme == Brightness.light
                                    ? color[0]
                                    : color[1],
                                width: 2,
                                style: _userSadhanaData[sadhanaIndex]
                                        ['sadhanaData'][index][1]
                                    ? BorderStyle.solid
                                    : BorderStyle.none,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                width: 48,
                                child: _userSadhanaData[sadhanaIndex]
                                        ['sadhanaData'][index][1]
                                    ? Icon(
                                        Icons.done,
                                        size: 20.0,
                                        color: theme == Brightness.light
                                            ? color[0]
                                            : color[1],
                                      )
                                    : Icon(
                                        Icons.close,
                                        size: 20.0,
                                        color: Colors.grey,
                                      ),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          width: 34,
                          margin: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color[theme == Brightness.light ? 0 : 1]
                                .withAlpha(_userSadhanaData[sadhanaIndex]
                                            ['sadhanaData'][index][1] !=
                                        0
                                    ? 20
                                    : 0),
                            border: Border.all(
                              color: theme == Brightness.light
                                  ? color[0]
                                  : color[1],
                              width: 2,
                              style: _userSadhanaData[sadhanaIndex]
                                          ['sadhanaData'][index][1] !=
                                      0
                                  ? BorderStyle.solid
                                  : BorderStyle.none,
                            ),
                          ),
                          child: Container(
                            width: 48,
                            child: Center(
                              child: FlatButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () {
                                  showDialog<List>(
                                      context: context,
                                      builder: (_) {
                                        return new NumberPickerDialog.integer(
                                          title: Text(
                                            'Change No. of ' +
                                                (sadhanaIndex == 1
                                                    ? 'page'
                                                    : 'hour'),
                                          ),
                                          color: theme == Brightness.light
                                              ? color[0]
                                              : color[1],
                                          initialIntegerValue:
                                              _userSadhanaData[sadhanaIndex]
                                                  ['sadhanaData'][index][1],
                                          minValue: 0,
                                          maxValue:
                                              sadhanaIndex == 1 ? 100 : 24,
                                          remark: _userSadhanaData[sadhanaIndex]
                                              ['sadhanaData'][index][2],
                                        );
                                      }).then(
                                    (List onValue) {
                                      if (onValue != null &&
                                          onValue[0] != null) {
                                        setState(
                                          () {
                                            _userSadhanaData[sadhanaIndex]
                                                    ['sadhanaData'][index][1] =
                                                onValue[0];
                                            _userSadhanaData[sadhanaIndex]
                                                    ['sadhanaData'][index][2] =
                                                onValue[1];
                                          },
                                        );
                                      }
                                    },
                                  );
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      _userSadhanaData[sadhanaIndex]
                                              ['sadhanaData'][index][1]
                                          .toString(),
                                      style: TextStyle(
                                          color: _userSadhanaData[sadhanaIndex]
                                                          ['sadhanaData'][index]
                                                      [1] !=
                                                  0
                                              ? theme == Brightness.light ? color[0] : color[1]
                                              : Colors.grey),
                                    ),
                                    CircleAvatar(
                                      maxRadius: _userSadhanaData[sadhanaIndex]
                                                  ['sadhanaData'][index][2] !=
                                              ""
                                          ? 2
                                          : 0,
                                      backgroundColor: theme == Brightness.light
                                          ? color[0]
                                          : color[1],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                },
              ),
            ),
          ),
//          decoration: BoxDecoration(
//            border: BorderDirectional(
//              bottom: BorderSide(
//                  width: 1.0,
//                  color: theme == Brightness.light ? color[0] : color[1]),
//              top: BorderSide(
//                  width: 1.0,
//                  color: theme == Brightness.light ? color[0] : color[1]),
//              end: BorderSide(
//                  width: 1.0,
//                  color: theme == Brightness.light ? color[0] : color[1]),
//            ),
//          ),
        ),
      );
    }

    Widget _createHeading(
      int index,
      String title,
      List<Color> color,
      SadhanaType type,
    ) {
      return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        margin: EdgeInsets.fromLTRB(4, 4, 0, 4),
        child: Container(
          height: 50,
          alignment: Alignment(-1, 0),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: MaterialButton(
                minWidth: headerWidth,
                padding: EdgeInsets.all(0),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SadhanaEditPage(
                          title: title,
                          color:
                              theme == Brightness.light ? color[0] : color[1],
                          appBarColor: color[0],
                          type: type),
                      fullscreenDialog: true,
                    ),
                  );
                },
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 5.0),
                      child: Icon(Icons.data_usage,
                          color:
                              theme == Brightness.light ? color[0] : color[1]),
                    ),
                    Container(
                      width: headerWidth - 54,
                      child: Tooltip(
                        message: '$title',
                        child: Text(
                          '$title',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: theme == Brightness.light
                                  ? color[0]
                                  : color[1]),
                        ),
                      ),
                    )
                  ],
                )),
          ),
//          decoration: BoxDecoration(
//            border: BorderDirectional(
//              bottom: BorderSide(
//                  width: 1.0,
//                  color: theme == Brightness.light ? color[0] : color[1]),
//              top: BorderSide(
//                  width: 1.0,
//                  color: theme == Brightness.light ? color[0] : color[1]),
//              start: BorderSide(
//                  width: 1.0,
//                  color: theme == Brightness.light ? color[0] : color[1]),
//            ),
//          ),
        ),
      );
    }

    _addNewSadhana() {
      showDialog(
          context: context,
          builder: (_) => CreateSadhanaDialog(createSadhana)).then((value) {
        setState(() {});
      });
    }

    Widget home = Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.all(10),
          child: Image.asset('images/logo_dada.png'),
        ),
        title: Text('Sadhana'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.sync),
            onPressed: () {
              Navigator.pushNamed(context, LoginPage.routeName);
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
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: headerWidth,
                  child: Column(
                    children: titleHeader.map((heading) {
                      return heading.isHeading
                          ? _mainHeaderTitle(heading.title)
                          : _createHeading(
                              heading.index,
                              heading.title,
                              heading.color,
                              heading.type,
                            );
                    }).toList(),
                  ),
                ),
                Container(
                  width: mobileWidth - headerWidth,
                  child: Container(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          Column(
                            children: sadhanaData.map((sadhana) {
                              return sadhana.isHeading
                                  ? _headerList()
                                  : _horizontalList(
                                      sadhana.index,
                                      sadhana.color,
                                      sadhana.type,
                                    );
                            }).toList(),
                          ),
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

    return home;
  }
}

class CreateSadhanaDialog extends StatefulWidget {
  final Function crateSadhana;

  CreateSadhanaDialog(this.crateSadhana);

  @override
  _CreateSadhanaDialogState createState() => new _CreateSadhanaDialogState();
}

class _CreateSadhanaDialogState extends State<CreateSadhanaDialog> {
  final sadhanaNameCtrl = TextEditingController();
  int radioValue = 0;
  List<Color> _mainColor = Constant.colors[0];

  @override
  Widget build(BuildContext context) {
    Brightness theme = Theme.of(context).brightness;
    void _openDialog() {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(6.0),
            title: Text('Select Color'),
            content: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Wrap(
                alignment: WrapAlignment.center,
                runSpacing: 10,
                spacing: 10,
                children: Constant.colors.map((c) {
                  return Container(
                    height: 50,
                    width: 50,
                    child: FlatButton(
                      padding: EdgeInsets.all(0),
                      shape: CircleBorder(),
                      onPressed: () {
                        setState(() {
                          _mainColor = c;
                        });
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor:
                            theme == Brightness.light ? c[0] : c[1],
                        child: c == _mainColor
                            ? Icon(Icons.done, size: 30, color: Colors.black)
                            : Container(),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
      );
    }

    return SimpleDialog(
      contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 10),
      title: Text('Add New Sadhana'),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: TextField(
            controller: sadhanaNameCtrl,
            onChanged: (value) {
              setState(() {});
            },
            decoration: InputDecoration(
              labelText: 'Sadhana name',
              border: OutlineInputBorder(),
              hintText: 'Please enter a Sadhana name',
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Radio(
                value: 0,
                groupValue: radioValue,
                onChanged: (int value) {
                  print(value);
                  setState(() {
                    radioValue = value;
                  });
                },
              ),
              new Text(
                'Yes / No',
                style: new TextStyle(fontSize: 16.0),
              ),
              new Radio(
                value: 1,
                groupValue: radioValue,
                onChanged: (int value) {
                  print(value);
                  setState(() {
                    radioValue = value;
                  });
                },
              ),
              new Text(
                'Number',
                style: new TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: OutlineButton(
            padding: EdgeInsets.all(0),
            onPressed: _openDialog,
            child: ListTile(
              title: const Text('Change Color'),
              trailing: CircleAvatar(
                backgroundColor:
                    theme == Brightness.light ? _mainColor[0] : _mainColor[1],
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            FlatButton(
              onPressed: sadhanaNameCtrl.text != ""
                  ? () {
                      print(sadhanaNameCtrl.text);
                      print(radioValue);
                      setState(() {
                        widget.crateSadhana(
                          type: radioValue == 0
                              ? SadhanaType.BOOLEAN
                              : SadhanaType.NUMBER,
                          title: sadhanaNameCtrl.text,
                          color: _mainColor,
                        );
                      });
                      Navigator.pop(context);
                    }
                  : null,
              child: Text('Add'),
            )
          ],
        )
      ],
    );
  }
}

class SadhanaHeading {
  int index;
  String title;
  SadhanaType type;
  List<Color> color;
  bool isHeading;

  SadhanaHeading(
      {this.index,
      this.title,
      this.type = SadhanaType.BOOLEAN,
      this.color,
      this.isHeading = false});
}

class SadhanaData {
  int index;
  SadhanaType type;
  List<Color> color;
  bool isHeading;

  SadhanaData(
      {this.index,
      this.type = SadhanaType.BOOLEAN,
      this.color,
      this.isHeading = false});
}

class EveryDayData {
  int sadhanaId;
  DateTime date;
  String sadhanaName;
  List progressData;

  EveryDayData(
      {this.sadhanaId, this.date, this.sadhanaName, this.progressData});
}
