import 'package:flutter/material.dart';
import 'package:sadhana/model/sadhana.dart';
import 'package:sadhana/sadhana/sadhanaEdit.dart';

class NameHeading extends StatelessWidget {
  final double headerWidth;
  final Sadhana sadhana;
  final Function onClick;
  Brightness theme;
  BuildContext context;
  NameHeading({this.headerWidth = 150.0, @required this.sadhana, this.onClick});

  @override
  Widget build(BuildContext context) {
    String title = sadhana.sadhanaName;
    this.context = context;
    theme = Theme.of(context).brightness;
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
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
                    child: Icon(Icons.data_usage, color: theme == Brightness.light ? sadhana.lColor : sadhana.dColor),
                  ),
                  Container(
                    // width: headerWidth - 54,
                    child: Tooltip(
                      message: '$title',
                      child: Text(
                        '$title',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: theme == Brightness.light ? sadhana.lColor : sadhana.dColor),
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

  _onSadhanaHeadingClick() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SadhanaEditPage(sadhana: sadhana,),
        fullscreenDialog: true,
      ),
    );
  }

}
