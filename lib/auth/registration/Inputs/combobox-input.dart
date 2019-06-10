import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:sadhana/auth/login/validate_widget.dart';

class ComboboxInput extends StatelessWidget {
  ComboboxInput({
    this.handleValueSelect,
    this.labelText,
    this.listData,
    this.selectedData,
    this.onDelete,
    this.isRequiredValidation,
  });

  // final String text;
  final Function handleValueSelect;
  final Function onDelete;
  final String labelText;
  final List<String> listData;
  final List<dynamic> selectedData;
  final bool isRequiredValidation;
  @override
  Widget build(BuildContext context) {
    return ValidateInput(
      labelText: labelText,
      isRequiredValidation: isRequiredValidation,
      inputWidget: buildCombobox(),
      selectedValue: selectedData,
      validator: (value) {
        if ((value as List).isEmpty) return 'Select $labelText';
      },
    );
  }

  Widget buildCombobox() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      alignment: Alignment.bottomLeft,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SimpleAutoCompleteTextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: labelText,
              ),
              key: key,
              submitOnSuggestionTap: true,
              clearOnSubmit: true,
              suggestions: listData == null ? '' : listData,
              textSubmitted: handleValueSelect,
            ),
            Container(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.start,
                children: selectedData
                    .map((item) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          child: Chip(
                            label: Text(item),
                            deleteButtonTooltipMessage: 'Click to remove',
                            deleteIcon: Icon(Icons.cancel),
                            onDeleted: () {
                              onDelete(item);
                            },
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
