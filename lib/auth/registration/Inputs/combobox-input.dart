import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class ComboboxInput extends StatelessWidget {
  ComboboxInput({
    this.handleValueSelect,
    this.lableText,
    this.listData,
    this.selectedData,
    this.onDelete,
  });

  // final String text;
  final Function handleValueSelect;
  final Function onDelete;
  final String lableText;
  final List<String> listData;
  final List<dynamic> selectedData;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      alignment: Alignment.bottomLeft,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SimpleAutoCompleteTextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: lableText,
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
