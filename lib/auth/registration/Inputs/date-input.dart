import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateInput extends StatelessWidget {
  const DateInput({
    Key key,
    this.labelText,
    this.selectedDate,
    this.selectDate,
    this.enable = true
  }) : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final ValueChanged<DateTime> selectDate;
  final bool enable;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1950, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) selectDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      alignment: Alignment.bottomLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: InkWell(
              onTap: enable ? () {
                FocusScope.of(context).requestFocus(new FocusNode());
                _selectDate(context);
              } : null,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: labelText,
                  enabled: enable,
                  border: OutlineInputBorder(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    selectedDate != null ? Text(DateFormat.yMMMd().format(selectedDate)) : Container(),
                    Icon(Icons.today, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
