import 'package:flutter/material.dart';
import 'package:sadhana/comman.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/constant/sadhanatype.dart';
import 'package:sadhana/dao/sadhanadao.dart';
import 'package:sadhana/model/cachedata.dart';
import 'package:sadhana/model/sadhana.dart';
import 'package:sadhana/utils/apputils.dart';
import 'package:sadhana/widgets/color_picker_dialog.dart';

class CreateSadhanaDialog extends StatefulWidget {
  final Function onDone;
  Sadhana sadhana;
  bool isEditMode;
  CreateSadhanaDialog({this.sadhana, this.isEditMode = false, this.onDone});

  @override
  _CreateSadhanaDialogState createState() => new _CreateSadhanaDialogState();
}

class _CreateSadhanaDialogState extends State<CreateSadhanaDialog> {
  final sadhanaNameCtrl = TextEditingController();
  int radioValue = 0;
  Brightness theme;
  SadhanaDAO sadhanaDAO = SadhanaDAO();
  List<Color> _mainColor = Constant.colors[0];
  Sadhana sadhana;
  bool isPreloaded = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    sadhana = widget.sadhana;
    if (sadhana != null) {
      isPreloaded = sadhana.isPreloaded;
      sadhanaNameCtrl.text = sadhana.name;
      radioValue = sadhana.type.index;
      _mainColor = [sadhana.lColor, sadhana.dColor];
    }
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context).brightness;
    return SimpleDialog(
      contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 10),
      title: Text(widget.isEditMode ? 'Edit JIO' : 'Add New JIO'),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: TextField(
            controller: sadhanaNameCtrl,
            onChanged: (value) {
              setState(() {});
            },
            enabled: isPreloaded ? false : true,
            decoration: InputDecoration(
              labelText: 'Sadhana name',
              border: OutlineInputBorder(),
              hintText: 'Please enter a Sadhana name',
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
              onPressed: sadhanaNameCtrl.text != "" ? onOKClick : null,
              child: Text('Add'),
            )
          ],
        )
      ],
    );
  }

  void _onChangeType(int value) {
    setState(() {
      radioValue = value;
    });
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
          name: sadhanaNameCtrl.text,
          lColor: _mainColor[0],
          dColor: _mainColor[1],
          index: index,
          type: radioValue == 0 ? SadhanaType.BOOLEAN : SadhanaType.NUMBER,
        );
      } else {
        sadhana.name = sadhanaNameCtrl.text;
        sadhana.lColor = _mainColor[0];
        sadhana.dColor = _mainColor[1];
        sadhana.type = radioValue == 0 ? SadhanaType.BOOLEAN : SadhanaType.NUMBER;
      }
      sadhanaDAO.insertOrUpdate(sadhana);
      widget.onDone(sadhana);
      Navigator.pop(context);
    }
  }

  bool validate() {
    bool isCheckSadhanaExist = false;
    if (!widget.isEditMode)
      isCheckSadhanaExist = true;
    else if (sadhana != null && !AppUtils.equalsIgnoreCase(sadhana.name, sadhanaNameCtrl.text)) isCheckSadhanaExist = true;
    if (isCheckSadhanaExist && AppUtils.isSadhanaExist(sadhanaNameCtrl.text)) {
      CommonFunction.alertDialog(
        context: context,
        msg: 'Sadhana with ${sadhanaNameCtrl.text} name is already exists.',
        barrierDismissible: false,
      );
      return false;
    }
    return true;
  }
}
