import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  const TextInputField({
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
  }) : super(key: key);

  final String labelText;
  final String valueText;
  final String hintText;
  final bool enabled;
  final bool autoFocus;
  final bool isRequiredValidation;
  final TextInputType textInputType;
  final Function(String) onSaved;
  final Function(String) validation;
  final EdgeInsetsGeometry contentPadding;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding?? const EdgeInsets.symmetric(vertical: 10.0),
      alignment: Alignment.bottomLeft,
      child: TextFormField(
        style: TextStyle(
          color: !enabled ? Theme.of(context).copyWith().disabledColor : Theme.of(context).textTheme.copyWith().title.color,
        ),
        autofocus: autoFocus,
        decoration: InputDecoration(
          labelText: isRequiredValidation ? "$labelText *" : labelText,
          border: OutlineInputBorder(),
          hintText: hintText ?? 'Enter a $labelText',
          contentPadding: contentPadding,
        ),
        initialValue: valueText,
        enabled: enabled,
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
      ),
    );
  }
}