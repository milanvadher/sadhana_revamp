import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  const TextInputField({
    Key key,
    this.labelText,
    this.valueText,
    this.enabled,
    this.onSaved,
    this.hintText,
    this.validation,
    this.isRequiredValidation = false,
    this.autoFocus = false,
  }) : super(key: key);

  final String labelText;
  final String valueText;
  final String hintText;
  final bool enabled;
  final bool autoFocus;
  final bool isRequiredValidation;
  final Function(String) onSaved;
  final Function(String) validation;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      alignment: Alignment.bottomLeft,
      child: TextFormField(
        autofocus: autoFocus,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
          hintText: hintText?? 'Enter a $labelText',
        ),
        initialValue: valueText,
        enabled: enabled,
        keyboardType: TextInputType.text,
        onSaved: (value) {
          if(onSaved != null)
            onSaved(value);
          return value;
        },
        validator: (value) {
          if (isRequiredValidation && (value == null || value.trim().isEmpty)) {
            return  '$labelText is required';
          }
          if(validation != null)
            return validation(value);
        },
      ),
    );
  }
}
