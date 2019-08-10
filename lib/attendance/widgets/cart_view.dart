import 'package:flutter/material.dart';
import 'package:sadhana/attendance/model/session.dart';
import 'package:sadhana/auth/registration/Inputs/text-input.dart';

class CardView extends StatefulWidget {

  final Attendance attendance;
  final bool isReadOnly;
  final bool isSimcityGroup;

  CardView(this.attendance, this.isReadOnly, this.isSimcityGroup);

  @override
  _CardViewState createState() => _CardViewState();
}

class _CardViewState extends State<CardView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Card(
          elevation: 5,
          child: Column(
            children: <Widget>[
              ListTile(
                dense: true,
                title: Text(widget.attendance.name),
                onTap: widget.isReadOnly
                    ? null
                    : () {
                  onCheck(widget.attendance);
                },
                trailing: Checkbox(
                  onChanged: widget.isReadOnly
                      ? null
                      : (val) {
                    onCheck(widget.attendance);
                  },
                  value: widget.attendance.isPresent,
                ),
              ),
              !widget.attendance.isPresent && widget.isSimcityGroup
                  ? Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
                      child: TextInputField(
                        valueText: widget.attendance.reason == null ? '' : widget.attendance.reason,
                        enabled: !widget.isReadOnly,
                        isRequiredValidation: true,
                        labelText: "Reason for Absent",
                        onSaved: (val) => widget.attendance.reason = val,
                        padding: EdgeInsets.all(0),
                        contentPadding: EdgeInsets.all(13),
                      ),
                    ),
                  ],
                ),
              )
                  : Container()
            ],
          )),
    );
  }

  onCheck(Attendance attendance) {
    setState(() {
      attendance.isPresent = !attendance.isPresent;
    });
  }
}