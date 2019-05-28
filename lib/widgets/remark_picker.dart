import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ReamarkPickerDialog extends StatefulWidget {
  final Widget title;
  final EdgeInsets titlePadding;
  final Widget confirmWidget;
  final Widget cancelWidget;
  final String remark;

  ReamarkPickerDialog({
    this.title,
    this.titlePadding,
    Widget confirmWidget,
    Widget cancelWidget,
    this.remark = "",
  })  : confirmWidget = confirmWidget ?? new Text("OK"),
        cancelWidget = cancelWidget ?? new Text("CANCEL");

  @override
  _ReamarkPickerDialogControllerState createState() => _ReamarkPickerDialogControllerState();

}

class _ReamarkPickerDialogControllerState extends State<ReamarkPickerDialog> {
  final remarkCtrl = TextEditingController();

  _ReamarkPickerDialogControllerState();

  @override
  void initState() {
    super.initState();
    remarkCtrl.text = widget.remark;
  }

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 0),
      title: widget.title,
      titlePadding: widget.titlePadding,
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: TextField(
                controller: remarkCtrl,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  labelText: 'Remark',
                  border: OutlineInputBorder(),
                  hintText: 'Enter remarks',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: widget.cancelWidget,
                  ),
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(remarkCtrl.text),
                    child: widget.confirmWidget,
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
