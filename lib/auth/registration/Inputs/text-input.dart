import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  const TextInputField({
    Key key,
    this.labelText,
    this.valueText,
    this.enabled,
    this.isRequiredValidation = false,
  }) : super(key: key);

  final String labelText;
  final String valueText;
  final bool enabled;
  final bool isRequiredValidation;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      alignment: Alignment.bottomLeft,
      child: TextFormField(
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
        initialValue: valueText,
        enabled: enabled,
        keyboardType: TextInputType.text,
        onSaved: (value) {
          return value;
        },
        validator: (value) {
          if (isRequiredValidation && value.isEmpty) {
            return labelText + ' is required';
          }
        },
      ),
    );
  }
}
