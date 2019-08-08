import 'package:flutter/material.dart';
import 'package:sadhana/model/sadhana.dart';
import 'package:sadhana/sadhana/sadhanaEdit.dart';
import 'package:sadhana/utils/chart_utils.dart';
import 'package:sadhana/widgets/circle_progress_bar.dart';


Map<String,_NameHeadingState> listOfNamingState = Map();

_NameHeadingState nameHeadingState;
class NameHeading extends StatefulWidget {
  final double headerWidth;
  final Sadhana sadhana;
  final Function onClick;

  NameHeading({this.headerWidth = 130.0, @required this.sadhana, this.onClick});

  @override
  _NameHeadingState createState() {
    nameHeadingState = _NameHeadingState();
    listOfNamingState[sadhana.sadhanaName] = nameHeadingState;
    return nameHeadingState;
  }
}

class _NameHeadingState extends State<NameHeading> {
  Brightness theme;

  Color color;

  BuildContext context;

  @override
  Widget build(BuildContext context) {
    String title = widget.sadhana.sadhanaName;
    this.context = context;
    theme = Theme.of(context).brightness;
    color = theme == Brightness.light ? widget.sadhana.lColor : widget.sadhana.dColor;
    return Card(
      elevation: 3,
      margin: EdgeInsets.fromLTRB(4, 4, 0, 4),
      child: Container(
        height: 45,
        alignment: Alignment(-1, 0),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: MaterialButton(
              // minWidth: headerWidth,
              padding: EdgeInsets.all(0),
              onPressed: () {
                _onSadhanaHeadingClick();
              },
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 5.0),
                    child:
                    CircleProgressBar(
                      backgroundColor: Colors.grey,
                      foregroundColor: color,
                      value: getPercentage(),
                    ),
                  ),
                  Container(
                    width: widget.headerWidth - 54,
                    child: Tooltip(
                      message: '$title',
                      child: Text(
                        '$title',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: theme == Brightness.light ? widget.sadhana.lColor : widget.sadhana.dColor),
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

  getPercentage() {
    double value = ChartUtils.getScore(widget.sadhana.activitiesByDate.values.toList());
    return value / 100;
  }

  _onSadhanaHeadingClick() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SadhanaEditPage(sadhana: widget.sadhana,),
        fullscreenDialog: true,
      ),
    );
  }
}
