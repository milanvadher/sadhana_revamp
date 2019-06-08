import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sadhana/auth/registration/Inputs/text-input.dart';

class ChangeMobileDialog extends StatefulWidget {
  final Widget title;
  final EdgeInsets titlePadding;
  final Widget confirmWidget;
  final Widget cancelWidget;
  final String remark;

  ChangeMobileDialog({
    this.title,
    this.titlePadding,
    Widget confirmWidget,
    Widget cancelWidget,
    this.remark = "",
  })  : confirmWidget = confirmWidget ?? new Text("OK"),
        cancelWidget = cancelWidget ?? new Text("CANCEL");

  @override
  _ChangeMobileDialogControllerState createState() => _ChangeMobileDialogControllerState();

}

class _ChangeMobileDialogControllerState extends State<ChangeMobileDialog> {
  final textInputCtrl = TextEditingController();

  _ChangeMobileDialogControllerState();

  @override
  void initState() {
    super.initState();
    textInputCtrl.text = widget.remark;
  }

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 0),
      title: Text('Change Mobile Request'),
      titlePadding: widget.titlePadding,
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: TextInputField(
                labelText: 'New Mobile',
                isRequiredValidation: true,
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
                    onPressed: () => Navigator.of(context).pop(textInputCtrl.text),
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
