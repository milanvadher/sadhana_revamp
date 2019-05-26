import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:sadhana/comman.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/constant/sadhanatype.dart';
import 'package:sadhana/dao/sadhanadao.dart';
import 'package:sadhana/model/cachedata.dart';
import 'package:sadhana/model/sadhana.dart';
import 'package:sadhana/notification/app_local_notification.dart';
import 'package:sadhana/utils/apputils.dart';
import 'package:sadhana/widgets/color_picker_dialog.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class CreateSadhanaDialog extends StatefulWidget {
  final Function onDone;
  Sadhana sadhana;
  bool isEditMode;

  CreateSadhanaDialog({this.sadhana, this.isEditMode = false, this.onDone});

  @override
  _CreateSadhanaDialogState createState() => new _CreateSadhanaDialogState();
}

class _CreateSadhanaDialogState extends State<CreateSadhanaDialog> {
  final nameCtrl = TextEditingController();
  final desCtrl = TextEditingController();
  int radioValue = 0;
  Brightness theme;
  SadhanaDAO sadhanaDAO = SadhanaDAO();
  List<Color> _mainColor = Constant.colors[0];
  Sadhana sadhana;
  bool isPreloaded = false;
  final formats = {
    //InputType.both: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
    //InputType.date: DateFormat('yyyy-MM-dd'),
    InputType.time: DateFormat("hh:mm a"),
  };
  final InputType inputType = InputType.time;
  DateTime reminderTime;
  AppLocalNotification appLocalNotification = new AppLocalNotification();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    sadhana = widget.sadhana;
    if (sadhana != null) {
      isPreloaded = sadhana.isPreloaded;
      nameCtrl.text = sadhana.sadhanaName;
      desCtrl.text = sadhana.description;
      radioValue = sadhana.type.index;
      reminderTime = sadhana.reminderTime;
      _mainColor = [sadhana.lColor, sadhana.dColor];
    }
  }

  @override
  Widget build(BuildContext context) {
    //AppLocalNotification.initAppLocalNotification(context);
    theme = Theme.of(context).brightness;
    return SimpleDialog(
      contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 10),
      title: Text(widget.isEditMode ? 'Edit Sadhana' : 'Create Sadhana'),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: TextField(
            controller: nameCtrl,
            onChanged: (value) {
              setState(() {});
            },
            enabled: isPreloaded ? false : true,
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
              hintText: 'Enter a Sadhana name',
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: TextField(
            controller: desCtrl,
            onChanged: (value) {
              setState(() {});
            },
            enabled: isPreloaded ? false : true,
            decoration: InputDecoration(
              labelText: 'Question',
              border: OutlineInputBorder(),
              hintText: 'e.g. Have you done sadhana today?',
            ),
          ),
        ),
        widget.isEditMode
            ? Container()
            : Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Radio(
                      value: 0,
                      groupValue: radioValue,
                      onChanged: !isPreloaded ? _onChangeType : null,
                    ),
                    new Text(
                      'Yes / No',
                      style: new TextStyle(fontSize: 16.0),
                    ),
                    new Radio(
                      value: 1,
                      groupValue: radioValue,
                      onChanged: !isPreloaded ? _onChangeType : null,
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
                backgroundColor: theme == Brightness.light ? _mainColor[0] : _mainColor[1],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: DateTimePickerFormField(
            inputType: inputType,
            format: formats[inputType],
            editable: false,
            initialTime:
                reminderTime != null ? TimeOfDay(hour: reminderTime.hour, minute: reminderTime.minute) : TimeOfDay(hour: 7, minute: 0),
            decoration: InputDecoration(labelText: _getReminderText(), hasFloatingPlaceholder: false),
            onChanged: (dt) => setState(() {
                  if (dt != null) {
                    reminderTime = dt;
                  }
                }),
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
              onPressed: !disableOKButton() ? onOKClick : null,
              child: Text('Add'),
            )
          ],
        )
      ],
    );
  }

  String _getReminderText() {
    return reminderTime != null ? new DateFormat(Constant.timeDisplayFormat).format(reminderTime) : "Off";
  }

  void _onChangeType(int value) {
    setState(() {
      radioValue = value;
    });
  }

  bool disableOKButton() {
    return nameCtrl.text == null || nameCtrl.text.isEmpty || desCtrl.text == null || desCtrl.text.isEmpty;
  }

  void _openDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return ColorPickerDialog.getColorPickerDialog(context, _mainColor, _onColorSelected);
      },
    );
  }

  _onColorSelected(List<Color> colors) {
    setState(() {
      _mainColor = colors;
    });
  }

  onOKClick() {
    if (validate()) {
      if (sadhana == null) {
        int index = CacheData.getSadhanas().length;
        sadhana = Sadhana(
          sadhanaName: nameCtrl.text,
          description: desCtrl.text,
          lColor: _mainColor[0],
          dColor: _mainColor[1],
          index: index,
          type: radioValue == 0 ? SadhanaType.BOOLEAN : SadhanaType.NUMBER,
        );
      } else {
        sadhana.sadhanaName = nameCtrl.text;
        sadhana.description = desCtrl.text;
        sadhana.lColor = _mainColor[0];
        sadhana.dColor = _mainColor[1];
        sadhana.type = radioValue == 0 ? SadhanaType.BOOLEAN : SadhanaType.NUMBER;
      }
      sadhana.reminderTime = reminderTime;
      sadhanaDAO.insertOrUpdate(sadhana);
      scheduleLocalNotification();
      widget.onDone(sadhana);
      Navigator.pop(context);
    }
  }

  void scheduleLocalNotification() {
    if (sadhana.reminderTime != null) {
      Time time = Time(sadhana.reminderTime.hour, sadhana.reminderTime.minute, 0);
      appLocalNotification.scheduleSadhanaDailyAtTime(sadhana, time);
    }
  }

  bool validate() {
    bool isCheckSadhanaExist = false;
    if (!widget.isEditMode)
      isCheckSadhanaExist = true;
    else if (sadhana != null && !AppUtils.equalsIgnoreCase(sadhana.sadhanaName, nameCtrl.text)) isCheckSadhanaExist = true;
    if (isCheckSadhanaExist && AppUtils.isSadhanaExist(nameCtrl.text)) {
      CommonFunction.alertDialog(
        context: context,
        msg: 'Sadhana with ${nameCtrl.text} name is already exists.',
        barrierDismissible: false,
      );
      return false;
    }
    return true;
  }
}
