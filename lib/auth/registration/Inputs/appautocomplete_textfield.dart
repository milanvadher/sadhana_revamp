import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';

class AppSimpleAutoCompleteTextField extends AutoCompleteTextField<String> {
  final StringCallback textChanged, textSubmitted;
  final int minLength;
  final ValueSetter<bool> onFocusChanged;
  AppSimpleAutoCompleteTextField(
      {TextStyle style,
        InputDecoration decoration: const InputDecoration(),
        this.onFocusChanged,
        this.textChanged,
        this.textSubmitted,
        this.minLength = 1,
        TextInputType keyboardType: TextInputType.text,
        @required GlobalKey<AutoCompleteTextFieldState<String>> key,
        @required List<String> suggestions,
        int suggestionsAmount: 5,
        bool submitOnSuggestionTap: true,
        bool clearOnSubmit: true,
        TextInputAction textInputAction: TextInputAction.done,
        TextCapitalization textCapitalization: TextCapitalization.sentences,
        TextEditingController controller,
      })
      : super(
      style: style,
      decoration: decoration,
      textChanged: textChanged,
      textSubmitted: textSubmitted,
      itemSubmitted: textSubmitted,
      keyboardType: keyboardType,
      key: key,
      suggestions: suggestions,
      itemBuilder: null,
      itemSorter: null,
      itemFilter: null,
      suggestionsAmount: suggestionsAmount,
      submitOnSuggestionTap: submitOnSuggestionTap,
      clearOnSubmit: clearOnSubmit,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      controller: controller
  );

  @override
  State<StatefulWidget> createState() => new AutoCompleteTextFieldState<String>(
      suggestions, textChanged, textSubmitted, onFocusChanged, itemSubmitted,
          (context, item) {
        return new Padding(padding: EdgeInsets.all(8.0), child: new Text(item));
      }, (a, b) {
    return a.compareTo(b);
  }, (item, query) {
    return item.toLowerCase().startsWith(query.toLowerCase());
  },
      suggestionsAmount,
      submitOnSuggestionTap,
      clearOnSubmit,
      minLength,
      [],
      textCapitalization,
      decoration,
      style,
      keyboardType,
      textInputAction,
      controller,
      FocusNode()
  );
}