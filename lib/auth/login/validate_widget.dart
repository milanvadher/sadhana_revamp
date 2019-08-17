import 'package:flutter/material.dart';

class ValidateInput<T> extends StatefulWidget {
  final bool isRequiredValidation;
  T selectedValue;
  String labelText;
  Widget inputWidget;
  Function validator;
  Function onSave;
  ValidateInput(
      {Key key,
      @required this.selectedValue,
      @required this.inputWidget,
      this.isRequiredValidation = false,
      @required this.labelText,
      this.validator,
      this.onSave})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ValidateInputState();
  }
}

class ValidateInputState extends State<ValidateInput> {
  dynamic selectedValue;
  @override
  Widget build(BuildContext context) {
    selectedValue = widget.selectedValue;
    return FormField<dynamic>(
      initialValue: selectedValue,
      validator: (value) {
        if (widget.isRequiredValidation) {
          if (selectedValue == null) {
            return "Select ${widget.labelText}";
          }
          if(widget.validator != null)
            return widget.validator(value);
        }
        return null;
      },
      onSaved: (value) {
        if (widget.onSave != null) widget.onSave(value);
      },
      builder: (
        FormFieldState<dynamic> state,
      ) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            widget.inputWidget,
            state.hasError
                ? Text(
                    state.errorText,
                    style: TextStyle(color: Colors.redAccent.shade700, fontSize: 12.0),
                  )
                : Container(),
          ],
        );
      },
    );
  }
}
