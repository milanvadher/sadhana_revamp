import 'package:collection/collection.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:sadhana/auth/registration/Inputs/number-input.dart';
import 'package:sadhana/auth/registration/Inputs/radio-input.dart';
import 'package:sadhana/auth/registration/Inputs/text-input.dart';
import 'package:sadhana/auth/registration/Inputs/time-input.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/constant/sadhanatype.dart';
import 'package:sadhana/dao/sadhanadao.dart';
import 'package:sadhana/model/cachedata.dart';
import 'package:sadhana/model/sadhana.dart';
import 'package:sadhana/notification/app_local_notification.dart';
import 'package:sadhana/sadhana/time-table.dart';
import 'package:sadhana/utils/apputils.dart';
import 'package:sadhana/widgets/color_picker_dialog.dart';

final today = DateTime.now();

class CreateSadhanaDialog extends StatefulWidget {
  final Function onDone;
  Sadhana sadhana;
  bool isEditMode;

  CreateSadhanaDialog({this.sadhana, this.isEditMode = false, this.onDone});

  @override
  _CreateSadhanaDialogState createState() => new _CreateSadhanaDialogState();
}

class _CreateSadhanaDialogState extends State<CreateSadhanaDialog> {
  String name;
  String des;
  int radioValue = 0;
  int target = 1;
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  Brightness theme;
  SadhanaDAO sadhanaDAO = SadhanaDAO();
  List<Color> _mainColor = Constant.colors[0];
  Sadhana sadhana;
  bool isPreloaded = false;
  Color color;
  final formats = {
    //InputType.both: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
    //InputType.date: DateFormat('yyyy-MM-dd'),
    InputType.time: DateFormat(Constant.APP_TIME_FORMAT),
  };
  final InputType inputType = InputType.time;
  DateTime reminderTime;
  AppLocalNotification appLocalNotification = new AppLocalNotification();
  String operation;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    sadhana = widget.sadhana;
    if (sadhana != null) {
      isPreloaded = sadhana.isPreloaded;
      name = sadhana.sadhanaName;
      des = sadhana.description;
      radioValue = sadhana.type.index;
      target = sadhana.targetValue;
      reminderTime = sadhana.reminderTime;
      _mainColor = [sadhana.lColor, sadhana.dColor];
    }
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context).brightness;
    if (sadhana != null)
      color = theme == Brightness.light ? sadhana.lColor : sadhana.dColor;
    operation = widget.isEditMode ? 'Edit' : 'Create';
    //AppLocalNotification.initAppLocalNotification(context);
    return Scaffold(
      appBar: AppBar(
        actionsIconTheme: Theme.of(context).copyWith().accentIconTheme.copyWith(
            color: theme == Brightness.light ? Colors.white : Colors.black),
        iconTheme: Theme.of(context).copyWith().iconTheme.copyWith(
            color: theme == Brightness.light ? Colors.white : Colors.black),
        backgroundColor: color,
        // centerTitle: true,
        title: Text('$operation Sadhana',
            style: TextStyle(
                color:
                    theme == Brightness.light ? Colors.white : Colors.black)),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          children: <Widget>[sadhanaCreateEditForm()],
        ),
      ),
    );
  }

  Widget sadhanaCreateEditForm() {
    return Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: Column(
          children: <Widget>[
            TextInputField(
              onSaved: (value) {
                name = value;
              },
              labelText: 'Name',
              valueText: name,
              enabled: isPreloaded ? false : true,
              isRequiredValidation: true,
              validation: validateName,
            ),
            TextInputField(
              onSaved: (value) {
                des = value;
              },
              labelText: 'Question',
              valueText: des,
              hintText: 'e.g. Have you done sadhana today?',
              enabled: isPreloaded ? false : true,
              isRequiredValidation: true,
            ),
            widget.isEditMode
                ? Container()
                : RadioInput(
                    handleRadioValueChange: _onChangeType,
                    lableText: 'Type',
                    radioValue: radioValue,
                    radioData: [
                      {'lable': 'Yes / No', 'value': 0},
                      {'lable': 'Number', 'value': 1},
                    ],
                  ),
            radioValue == 1
                ? NumberInput(
                    isRequiredValidation: true,
                    enabled: !isPreloaded,
                    labelText: 'Target',
                    valueText: target.toString(),
                    onSaved: (double value) {
                      target = value.toInt();
                    },
                    validation: validateTarget,
                  )
                : Container(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: OutlineButton(
                padding: EdgeInsets.all(0),
                onPressed: _openDialog,
                child: ListTile(
                  title: const Text('Change Color'),
                  trailing: CircleAvatar(
                    backgroundColor: theme == Brightness.light
                        ? _mainColor[0]
                        : _mainColor[1],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: DateTimePickerFormField(
                inputType: inputType,
                format: formats[inputType],
                editable: false,
                initialTime: reminderTime != null
                    ? TimeOfDay(
                        hour: reminderTime.hour,
                        minute: reminderTime.minute,
                      )
                    : TimeOfDay(hour: 7, minute: 0),
                decoration: InputDecoration(
                  labelText: 'Reminder',
                  hasFloatingPlaceholder: true,
                  hintText: "Reminder",
                ),
                onChanged: (dt) => setState(
                      () {
                        if (dt != null) {
                          reminderTime = dt;
                        }
                      },
                    ),
              ),
            ),
            // TimeInput(
            //   enable: true,
            //   labelText: 'Reminder',
            //   selectedTime: null,
            //   selectTime: (TimeOfDay time) {
            //     setState(() {
            //       reminderTime = DateTime(
            //         today.year,
            //         today.month,
            //         today.day,
            //         time.hour,
            //         time.minute,
            //       );
            //     });
            //   },
            // ),
            // Padding(
            //   padding: EdgeInsets.symmetric(vertical: 5),
            //   child: Container(
            //     margin: const EdgeInsets.only(left: 8.0),
            //     padding: const EdgeInsets.symmetric(vertical: 8.0),
            //     // decoration: InputDecoration(
            //     //   labelText: labelText,
            //     //   enabled: enable,
            //     //   border: OutlineInputBorder(),
            //     // ),
            //     child: InkWell(
            //       onTap: () {
            //         showTimePicker(
            //           context: context,
            //           initialTime: reminderTime != null
            //               ? TimeOfDay(
            //                   hour: reminderTime.hour,
            //                   minute: reminderTime.minute,
            //                 )
            //               : TimeOfDay(hour: 7, minute: 0),
            //         ).then<void>((TimeOfDay value) {
            //           if (value != null)
            //             setState(() {
            //               if (value != null) {
            //                 reminderTime = DateTime(
            //                   today.year,
            //                   today.month,
            //                   today.day,
            //                   value.hour,
            //                   value.minute,
            //                 );
            //               }
            //             });
            //         });
            //       },
            //       child: Row(
            //         children: <Widget>[
            //           Text(reminderTime != null
            //               ? '${DateFormat(Constant.APP_TIME_FORMAT).format(reminderTime)}'
            //               : ""),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  onPressed: onOKClick,
                  color: color,
                  child: Text('$operation',
                      style: TextStyle(
                          color: theme == Brightness.light
                              ? Colors.white
                              : Colors.black)),
                ),
                OutlineButton(
                  highlightedBorderColor: color,
                  textColor: color,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
              ],
            )
          ],
        ));
  }

  String validateName(String value) {
    value = value.trim();
    bool isCheckSadhanaExist = false;
    if (!widget.isEditMode)
      isCheckSadhanaExist = true;
    else if (sadhana != null &&
        !AppUtils.equalsIgnoreCase(sadhana.sadhanaName, value))
      isCheckSadhanaExist = true;
    if (isCheckSadhanaExist && AppUtils.isSadhanaExist(value)) {
      return 'Sadhana with $name name is already exists.';
    }
  }

  String validateTarget(double value) {
    if (value < 1) {
      return 'Invalid Target value.';
    }
  }

  String _getReminderText() {
    return reminderTime != null
        ? new DateFormat(Constant.APP_TIME_FORMAT).format(reminderTime)
        : "Reminder";
  }

  void _onChangeType(dynamic value) {
    setState(() {
      radioValue = value;
    });
  }

  void _openDialog() {
    _addColorIfNotExist();
    showDialog(
      context: context,
      builder: (_) {
        return ColorPickerDialog.getColorPickerDialog(
            context, _mainColor, _onColorSelected);
      },
    );
  }

  _addColorIfNotExist() {
    bool isPresent = false;
    for (List<Color> c in Constant.colors) {
      if (IterableEquality().equals(c, _mainColor)) {
        isPresent = true;
        break;
      }
    }
    if (!isPresent) Constant.colors.add(_mainColor);
  }

  _onColorSelected(List<Color> colors) {
    setState(() {
      _mainColor = colors;
    });
  }

  onOKClick() async {
    _formKey.currentState.save();
    if (_formKey.currentState.validate()) {
      //_formKey.currentState.save();
      name = name.trim();
      if (sadhana == null) {
        int index = CacheData.getSadhanas().length;
        sadhana = Sadhana(
          sadhanaName: name,
          description: des,
          lColor: _mainColor[0],
          dColor: _mainColor[1],
          index: index,
          targetValue: target,
          type: radioValue == 0 ? SadhanaType.BOOLEAN : SadhanaType.NUMBER,
        );
      } else {
        sadhana.sadhanaName = name;
        sadhana.description = des;
        sadhana.lColor = _mainColor[0];
        sadhana.dColor = _mainColor[1];
        sadhana.type =
            radioValue == 0 ? SadhanaType.BOOLEAN : SadhanaType.NUMBER;
      }
      sadhana.reminderTime = reminderTime;
      if (sadhana.type == SadhanaType.NUMBER)
        sadhana.targetValue = target;
      else
        sadhana.targetValue = 1;
      await sadhanaDAO.insertOrUpdate(sadhana);
      scheduleLocalNotification();
      widget.onDone(sadhana);
      Navigator.pop(context);
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void scheduleLocalNotification() {
    if (sadhana.reminderTime != null) {
      Time time =
          Time(sadhana.reminderTime.hour, sadhana.reminderTime.minute, 0);
      appLocalNotification.scheduleSadhanaDailyAtTime(sadhana, time);
    }
  }
}
