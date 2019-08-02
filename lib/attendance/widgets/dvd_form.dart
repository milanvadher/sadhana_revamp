import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sadhana/attendance/model/dvd_info.dart';
import 'package:sadhana/attendance/model/session.dart';
import 'package:sadhana/auth/registration/Inputs/radio-input.dart';
import 'package:sadhana/common.dart';
import 'package:sadhana/utils/apputils.dart';

class DVDForm extends StatefulWidget {
  final Session session;
  final Function(DVDInfo) onDVDSubmit;
  final bool isReadOnly;

  const DVDForm({Key key, @required this.session, this.onDVDSubmit, this.isReadOnly = true}) : super(key: key);

  @override
  _DVDFormState createState() => _DVDFormState();
}

class _DVDFormState extends State<DVDForm> {
  DVDInfo dvdInfo;
  final GlobalKey<FormState> _dvdForm = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    dvdInfo = DVDInfo.fromSession(widget.session);
  }

  final double paddingBtwInput = 15;
  final double widthOfTex = 20;
  final EdgeInsets contentPaddingForTextInput = EdgeInsets.all(12);

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _dvdForm,
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text('Type'),
                  RadioInputItem(
                    radioValue: dvdInfo.dvdType,
                    radioData: [
                      {'label': 'Satsang', 'value': 'Satsang'},
                      {'label': 'Parayan', 'value': 'Parayan'},
                    ],
                    handleRadioValueChange: widget.isReadOnly
                        ? null
                        : (value) {
                            setState(() {
                              dvdInfo.dvdType = value;
                            });
                          },
                  ),
                ],
              ),
              SizedBox(height: paddingBtwInput),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: <Widget>[
                    Text('DVD'),
                    SizedBox(width: 20),
                    Container(
                      width: MediaQuery.of(context).size.width / 4,
                      child: buildNumberInputField(
                        label: 'Number',
                        initialValue: dvdInfo.dvdNo,
                        onSaved: (val) => setState(() => dvdInfo.dvdNo = !AppUtils.isNullOrEmpty(val) ? int.parse(val) : null),
                      ),
                    ),
                    SizedBox(width: 2),
                    Container(
                      width: MediaQuery.of(context).size.width / 4,
                      child: buildNumberInputField(
                        label: 'Part',
                        initialValue: dvdInfo.dvdPart,
                        onSaved: (val) => setState(() => dvdInfo.dvdPart = !AppUtils.isNullOrEmpty(val) ? int.parse(val) : null),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: paddingBtwInput),
              TextFormField(
                enabled: !widget.isReadOnly,
                decoration: InputDecoration(
                  labelText: 'Remarks',
                  border: OutlineInputBorder(),
                  hintText: 'Enter a Remarks',
                  contentPadding: contentPaddingForTextInput,
                ),
                initialValue: dvdInfo.remark,
                onSaved: (value) => dvdInfo.remark = value,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  !widget.isReadOnly
                      ? Container(
                          child: Row(
                            children: <Widget>[
                              RaisedButton(
                                onPressed: submitForm,
                                child: Text('Submit'),
                              ),
                              SizedBox(width: 20)
                            ],
                          ),
                        )
                      : Container(),
                  RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(widget.isReadOnly ? 'OK' : 'Cancel'),
                  ),
                ],
              )
            ],
          ),
        ));
  }

  buildNumberInputField({String label, int initialValue, Function onSaved}) {
    return TextFormField(
      enabled: !widget.isReadOnly,
      onSaved: onSaved,
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      initialValue: initialValue?.toString(),
      decoration: InputDecoration(
        labelText: label,
        contentPadding: contentPaddingForTextInput,
        counterText: "",
      ),
      keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
      maxLength: 4,
    );
  }

  submitForm() {
    _dvdForm.currentState.save();
    if (AppUtils.isNullOrEmpty(dvdInfo.remark) && dvdInfo.dvdNo == null && dvdInfo.dvdPart == null) {
      CommonFunction.alertDialog(context: context, msg: "Please fill any one Detail", type: 'error');
    } else {
      widget.onDVDSubmit(dvdInfo);
      Navigator.pop(context);
    }
  }
}
