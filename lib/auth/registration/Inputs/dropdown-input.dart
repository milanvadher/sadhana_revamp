import 'package:flutter/material.dart';

class DropDownInput extends StatefulWidget {
  DropDownInput({
    Key key,
    @required this.labelText,
    @required this.valueText,
    @required items,
    this.isRequiredValidation = false,
    @required this.onChange,
    this.enabled = true,
  }) : this.valuesByLabel = Map.fromIterable(items, key: (v) => (v).toString(), value: (v) => v),
      super(key: key);

  const DropDownInput.fromMap({
    Key key,
    @required this.labelText,
    @required this.valueText,
    @required this.valuesByLabel,
    this.isRequiredValidation = false,
    @required this.onChange,
    this.enabled = true,
  }) : super(key: key);

  final String labelText;
  final valueText;
  final Map<String,dynamic> valuesByLabel;
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
        isEmpty: widget.valuesByLabel == null || widget.valuesByLabel.isEmpty,
        child: DropdownButtonHideUnderline(
          child: new IgnorePointer(
            ignoring: !widget.enabled,
            child: new DropdownButton<dynamic>(
              isExpanded: true,
              isDense: true,
              items:  getDropDownMenuItem(widget.valuesByLabel),
              onChanged: (value) {
                FocusScope.of(context).requestFocus(new FocusNode());
                widget.onChange(value);
              },
              value: widget.valuesByLabel.values.contains(widget.valueText) ? widget.valueText : null,
            ),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem> getDropDownMenuItem(Map<String, dynamic> valuesByLabel) {
    List<DropdownMenuItem> items = [];
    valuesByLabel.forEach((label, value) {
      items.add(DropdownMenuItem<dynamic>(value: value, child: new Text(label)));
    });
    return items;
  }
}