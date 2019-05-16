import 'package:flutter/material.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/constant/sadhanatype.dart';
import 'package:sadhana/dao/sadhanadao.dart';
import 'package:sadhana/model/sadhana.dart';
import 'package:sadhana/widgets/color_picker_dialog.dart';

class CreateSadhanaDialog extends StatefulWidget {
  final Function onDone;
  Sadhana sadhana;
  CreateSadhanaDialog({this.sadhana,this.onDone});

  @override
  _CreateSadhanaDialogState createState() => new _CreateSadhanaDialogState();
}

class _CreateSadhanaDialogState extends State<CreateSadhanaDialog> {
  final sadhanaNameCtrl = TextEditingController();
  int radioValue = 0;
  Brightness theme;
  SadhanaDAO sadhanaDAO = SadhanaDAO();
  bool isEditMode = false;
  Sadhana sadhana;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.sadhana == null) {
      widget.sadhana = new Sadhana(name: "",
        type: SadhanaType.BOOLEAN,
        lColor: Constant.colors[0][0],
        dColor: Constant.colors[0][1],);
    }
    sadhana = Sadhana.clone(widget.sadhana);
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context).brightness;
    return SimpleDialog(
      contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 10),
      title: Text( isEditMode ? 'Add New Sadhana' : 'Edit Sadhana'),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: TextField(
            controller: sadhanaNameCtrl,
            onChanged: (value) {
              setState(() {});
            },
            decoration: InputDecoration(
              labelText: 'Sadhana name',
              border: OutlineInputBorder(),
              hintText: 'Please enter a Sadhana name',
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Radio(
                value: 0,
                groupValue: sadhana.type.index,
                onChanged: onChangeType,
              ),
              new Text(
                'Yes / No',
                style: new TextStyle(fontSize: 16.0),
              ),
              new Radio(
                value: 1,
                groupValue: sadhana.type.index,
                onChanged: onChangeType,
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
                backgroundColor: theme == Brightness.light ? sadhana.lColor : sadhana.dColor,
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

  void onChangeType(int value) {
    setState(() {
      sadhana.type = value == 0 ? SadhanaType.BOOLEAN : SadhanaType.NUMBER;
    });
  }

  void _openDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return ColorPickerDialog.getColorPickerDialog(context, sadhana.getColors(), (color) {
          setState(() {
            sadhana.setColors(color);
          });
        });
      },
    );
  }

  onOKClick() {
    print(sadhanaNameCtrl.text);
    print(radioValue);
    sadhana.name = sadhanaNameCtrl.text;
    sadhana.index = 1;
    sadhanaDAO.insertOrUpdate(sadhana);
    setState(() {
      widget.onDone(sadhana);
    });
    Navigator.pop(context);
  }
}
