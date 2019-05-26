import 'package:flutter/material.dart';

class DropDownInput extends StatelessWidget {
  const DropDownInput({
    Key key,
    @required this.labelText,
    @required this.valueText,
    @required this.items,
    this.isRequiredValidation = false,
    @required this.onChange,
    this.enabled = true,
  }) : super(key: key);

  final String labelText;
  final valueText;
  final List items;
  final bool isRequiredValidation;
  final Function onChange;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      alignment: Alignment.bottomLeft,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
          enabled: enabled,
        ),
        isEmpty: items == null,
        child: DropdownButtonHideUnderline(
          child: new IgnorePointer(
            ignoring: !enabled,
            child: new DropdownButton<dynamic>(
              isExpanded: true,
              isDense: true,
              items: items.map((value) {
                return new DropdownMenuItem<dynamic>(
                  value: value,
                  child: new Text(value.toString()),
                );
              }).toList(),
              onChanged: (value) {
                FocusScope.of(context).requestFocus(new FocusNode());
                onChange(value);
              },
              value: valueText,
            ),
          ),
        ),
      ),
    );
  }
}
