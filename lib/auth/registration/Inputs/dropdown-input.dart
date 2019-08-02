import 'package:flutter/material.dart';
import 'package:sadhana/auth/login/validate_widget.dart';
import 'package:sadhana/common.dart';

class DropDownInput extends StatefulWidget {
  DropDownInput({
    Key key,
    @required this.labelText,
    @required this.valueText,
    @required items,
    this.isRequiredValidation = false,
    @required this.onChange,
    this.enabled = true,
    this.viewMode = false,
    this.viewModeTitleWidth,
  })  : this.valuesByLabel = Map.fromIterable(items, key: (v) => (v).toString(), value: (v) => v),
        super(key: key);

  const DropDownInput.fromMap({
    Key key,
    @required this.labelText,
    @required this.valueText,
    @required this.valuesByLabel,
    this.isRequiredValidation = false,
    @required this.onChange,
    this.enabled = true,
    this.viewMode = false,
    this.viewModeTitleWidth,
  }) : super(key: key);

  final String labelText;
  final valueText;
  final Map<String, dynamic> valuesByLabel;
  final bool isRequiredValidation;
  final Function onChange;
  final bool enabled;
  final bool viewMode;
  final double viewModeTitleWidth;

  @override
  State<StatefulWidget> createState() {
    return DropDownInputState();
  }
}

class DropDownInputState extends State<DropDownInput> {
  dynamic selectedValue;

  @override
  Widget build(BuildContext context) {
    selectedValue = widget.valuesByLabel.values.contains(widget.valueText) ? widget.valueText : null;
    return Container(
      padding: EdgeInsets.symmetric(vertical: !widget.viewMode ? 10.0 : 5),
      alignment: Alignment.bottomLeft,
      child: widget.viewMode ? viewModeWidget() : editModeWidget(),
    );
  }

  Widget editModeWidget() {
    return ValidateInput(
      labelText: widget.labelText,
      isRequiredValidation: widget.isRequiredValidation,
      inputWidget: _buildDropDown(),
      selectedValue: selectedValue,
    );
  }

  Widget viewModeWidget() {
    double screenWidth = MediaQuery.of(context).size.width;
    return CommonFunction.getTitleAndNameForProfilePage(
      screenWidth: screenWidth,
      title: widget.labelText,
      value: widget.valueText.toString(),
      titleWidth: widget.viewModeTitleWidth,
    );
  }

  _buildDropDown() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      alignment: Alignment.bottomLeft,
      child: InputDecorator(
        decoration: InputDecoration(
            labelText: selectedValue != null ? widget.labelText : null,
            hasFloatingPlaceholder: true,
            border: OutlineInputBorder(),
            enabled: widget.enabled,
            hintText: widget.labelText),
        //isEmpty: widget.valuesByLabel == null || widget.valuesByLabel.isEmpty,
        child: DropdownButtonHideUnderline(
          child: new IgnorePointer(
            ignoring: !widget.enabled,
            child: new DropdownButton<dynamic>(
              isExpanded: true,
              isDense: true,
              hint: Text('Select ${widget.labelText}'),
              items: getDropDownMenuItem(widget.valuesByLabel),
              onChanged: (value) {
                selectedValue = value;
                FocusScope.of(context).requestFocus(new FocusNode());
                widget.onChange(value);
              },
              value: selectedValue,
            ),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem> getDropDownMenuItem(Map<String, dynamic> valuesByLabel) {
    List<DropdownMenuItem> items = [];
    if (valuesByLabel != null) {
      valuesByLabel.forEach((label, value) {
        items.add(DropdownMenuItem<dynamic>(value: value, child: new Text(label)));
      });
    }
    return items;
  }
}
