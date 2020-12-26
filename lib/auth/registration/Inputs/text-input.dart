import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sadhana/common.dart';

class TextInputField extends StatelessWidget {
  TextInputField({
    Key key,
    this.labelText,
    this.valueText,
    this.enabled = true,
    this.onSaved,
    this.hintText,
    this.validation,
    this.textInputType = TextInputType.text,
    this.isRequiredValidation = false,
    this.autoFocus = false,
    this.padding,
    this.contentPadding,
    this.viewMode = false,
    this.inputFormatters,
    this.viewModeTitleWidth,
    this.maxLength,
    this.showCounter = true,
    this.prefixIcon,
  }) : super(key: key);

  final String labelText;
  final String valueText;
  final String hintText;
  final bool viewMode;
  final int maxLength;
  final bool showCounter;
  final bool enabled;
  final bool autoFocus;
  final bool isRequiredValidation;
  final TextInputType textInputType;
  final Function(String) onSaved;
  final Function(String) validation;
  final EdgeInsetsGeometry contentPadding;
  final EdgeInsetsGeometry padding;
  final List<TextInputFormatter> inputFormatters;
  final Widget prefixIcon;
  BuildContext context;
  final double viewModeTitleWidth;
  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Container(
      padding: padding ?? EdgeInsets.symmetric(vertical: !viewMode ? 10.0 : 5),
      alignment: Alignment.bottomLeft,
      child: viewMode ? viewModeWidget() : editModeWidget(),
    );
  }

  Widget viewModeWidget() {
    double screenWidth = MediaQuery.of(context).size.width;
    return CommonFunction.getTitleAndNameForProfilePage(screenWidth: screenWidth, title: labelText, value: valueText, titleWidth: viewModeTitleWidth);/*Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("$labelText  :", textScaleFactor: 1.2, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
        Padding(
          padding: EdgeInsets.only(top: 2, left: 10),
          child: Text(valueText, textScaleFactor: 1.1),
        ),
      ],
    );*/
  }

  Widget editModeWidget() {
    return TextFormField(
      style: TextStyle(
        color: !enabled ? Theme.of(context).copyWith().disabledColor : Theme.of(context).textTheme.copyWith().title.color,
      ),
      autofocus: autoFocus,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: isRequiredValidation ? "$labelText *" : labelText,
        border: OutlineInputBorder(),
        hintText: hintText ?? 'Enter a $labelText',
        contentPadding: contentPadding,
        prefixIcon : prefixIcon,
        counterText: showCounter ? null : '',
      ),
      initialValue: valueText,
      maxLength: maxLength,
      enabled: enabled,
      inputFormatters: inputFormatters,
      keyboardType: textInputType,
      onSaved: (value) {
        if (onSaved != null) onSaved(value);
        return value;
      },
      validator: (value) {
        if (isRequiredValidation && (value == null || value.trim().isEmpty)) {
          return '$labelText is required';
        }
        if (validation != null) return validation(value);
      },
    );
  }
}
