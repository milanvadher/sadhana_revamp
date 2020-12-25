import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sadhana/attendance/model/dvd_info.dart';
import 'package:sadhana/attendance/model/session.dart';
import 'package:sadhana/common.dart';
import 'package:sadhana/utils/apputils.dart';

class DVDForm extends StatefulWidget {
  final Session session;
  final Function(DVDInfo) onDVDSubmit;
  final bool isReadOnly;
  final List<DVDInfo> dvds;

  const DVDForm(
      {Key key,
      @required this.session,
      @required this.dvds,
      this.onDVDSubmit,
      this.isReadOnly = true})
      : super(key: key);

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
    if (dvdInfo.dvdPart == null) {dvdInfo = null;}
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
              SizedBox(height: paddingBtwInput),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 80,
                child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Dvd',
                      border: OutlineInputBorder(),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton(
                        isExpanded: true,
                        items: buildDropdownList(),
                        onChanged: (newVal) => setState(() => dvdInfo = newVal),
                        value: dvdInfo,
                  ),
                      ),
                    ),
                ),
              ),
              SizedBox(height: paddingBtwInput),
              TextFormField(
                enabled: !widget.isReadOnly,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Remarks',
                  border: OutlineInputBorder(),
                  hintText: 'Enter a Remarks',
                  contentPadding: contentPaddingForTextInput,
                ),
                initialValue: dvdInfo == null ? "" : dvdInfo.remark,
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
                                child: Text('Save'),
                              ),
                              SizedBox(width: 20)
                            ],
                          ),
                        )
                      : Container(),
                  OutlineButton(
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

  buildDropdownList(){
    return widget.dvds.map((dvd) {
      return DropdownMenuItem<DVDInfo>(
        child: Text(dvd.dvdType + " " + dvd.dvdNo.toString()),
        value: dvd,
      );
    }).toList();
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
    if (AppUtils.isNullOrEmpty(dvdInfo.remark) && 
        dvdInfo.dvdPart == null) {
      CommonFunction.alertDialog(
          context: context, msg: "Please fill any one Detail", type: 'error');
    } else {
      widget.onDVDSubmit(dvdInfo);
      Navigator.pop(context);
    }
  }
}