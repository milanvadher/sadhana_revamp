import 'package:flutter/material.dart';
import 'package:sadhana/constant/constant.dart';

class ColorPickerDialog {
  static Widget getColorPickerDialog(BuildContext context, List<Color> defaultColor, Function onSelectColor) {
    Brightness theme = Theme.of(context).brightness;
    return AlertDialog(
      contentPadding: const EdgeInsets.all(6.0),
      title: Text('Select Color'),
      content: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Wrap(
          alignment: WrapAlignment.center,
          runSpacing: 10,
          spacing: 10,
          children: Constant.colors.map((c) {
            return Container(
              height: 50,
              width: 50,
              child: FlatButton(
                padding: EdgeInsets.all(0),
                shape: CircleBorder(),
                onPressed: () {
                  onSelectColor(c);
                  Navigator.pop(context);
                },
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: theme == Brightness.light ? c[0] : c[1],
                  child: c == defaultColor ? Icon(Icons.done, size: 30, color: Colors.black) : Container(),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
