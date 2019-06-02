import 'package:flutter/material.dart';

class DropDownInput extends StatefulWidget {
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
  State<StatefulWidget> createState() {
    return DropDownInputState();
  }
}

class DropDownInputState extends State<DropDownInput> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      alignment: Alignment.bottomLeft,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: widget.labelText,
          border: OutlineInputBorder(),
          enabled: widget.enabled,
        ),
        isEmpty: widget.items == null,
        child: DropdownButtonHideUnderline(
          child: new IgnorePointer(
            ignoring: !widget.enabled,
            child: new DropdownButton<dynamic>(
              isExpanded: true,
              isDense: true,
              items: widget.items.map((value) {
                return new DropdownMenuItem<dynamic>(
                  value: value,
                  child: new Text(value.toString()),
                );
              }).toList(),
              onChanged: (value) {
                FocusScope.of(context).requestFocus(new FocusNode());
                widget.onChange(value);
              },
              value: widget.items.contains(widget.valueText) ? widget.valueText : null,
            ),
          ),
        ),
      ),
    );
  }
}