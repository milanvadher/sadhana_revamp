import 'package:flutter/material.dart';
import 'package:sadhana/constant/constant.dart';
import 'package:sadhana/constant/sadhanatype.dart';
import 'package:sadhana/dao/sadhanadao.dart';
import 'package:sadhana/model/sadhana.dart';
import 'package:sadhana/widgets/color_picker_dialog.dart';

class CreateSadhanaDialog extends StatefulWidget {
  final Function crateSadhana;

  CreateSadhanaDialog(this.crateSadhana);

  @override
  _CreateSadhanaDialogState createState() => new _CreateSadhanaDialogState();
}

class _CreateSadhanaDialogState extends State<CreateSadhanaDialog> {
  final sadhanaNameCtrl = TextEditingController();
  int radioValue = 0;
  List<Color> _mainColor = Constant.colors[0];
  Brightness theme;
  SadhanaDAO sadhanaDAO = SadhanaDAO();

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context).brightness;
    void _openDialog() {
      showDialog(
        context: context,
        builder: (_) {
          return ColorPickerDialog.getColorPickerDialog(context, _mainColor, (color) {
            setState(() {
              _mainColor = color;
            });
          });
        },
      );
    }

    return SimpleDialog(
      contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 10),
      title: Text('Add New Sadhana'),
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
                groupValue: radioValue,
                onChanged: (int value) {
                  print(value);
                  setState(() {
                    radioValue = value;
                  });
                },
              ),
              new Text(
                'Yes / No',
                style: new TextStyle(fontSize: 16.0),
              ),
              new Radio(
                value: 1,
                groupValue: radioValue,
                onChanged: (int value) {
                  print(value);
                  setState(() {
                    radioValue = value;
                  });
                },
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

  onOKClick() {
    print(sadhanaNameCtrl.text);
    print(radioValue);
    Sadhana sadhana = Sadhana(
        sadhanaName: sadhanaNameCtrl.text,
        lColor: _mainColor[0],
        dColor: _mainColor[1],
        sadhanaIndex: 0,
        sadhanaType: radioValue == 0 ? SadhanaType.BOOLEAN : SadhanaType.NUMBER,
        sadhanaData: new Map(),
    );
    sadhanaDAO.insert(sadhana);
    setState(() {
      widget.crateSadhana(sadhana);
    });
    Navigator.pop(context);
  }
}
