import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sadhana/constant/constant.dart';

final today = DateTime.now();

class TimeInput extends StatelessWidget {
  const TimeInput(
      {Key key,
      this.labelText,
      this.selectedTime,
      this.selectTime,
      this.enable = true})
      : super(key: key);

  final String labelText;
  final TimeOfDay selectedTime;
  final ValueChanged<TimeOfDay> selectTime;
  final bool enable;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      // initialTime: selectedTime ?? DateTime.now(),
      initialTime: selectedTime ?? TimeOfDay(hour: today.hour, minute:today.minute),
    );
    if (picked != null && picked != selectedTime) selectTime(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      alignment: Alignment.bottomLeft,
      child: OutlineButton(
        padding: EdgeInsets.all(0),
        onPressed: enable
            ? () {
                FocusScope.of(context).requestFocus(new FocusNode());
                _selectTime(context);
              }
            : null,
        child: ListTile(
          title: Text(labelText),
          trailing: Text(
                selectedTime != null ? 
                  DateFormat(Constant.APP_TIME_FORMAT).format(
                    DateTime(
                      today.year,
                      today.month,
                      today.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    ),
                  ) : '',
                ),
        ),
      ),
      // child: Row(
      //   crossAxisAlignment: CrossAxisAlignment.end,
      //   children: <Widget>[
      //     Expanded(
      //       flex: 4,
      //       child: InkWell(
      //         onTap: enable
      //             ? () {
      //                 FocusScope.of(context).requestFocus(new FocusNode());
      //                 _selectTime(context);
      //               }
      //             : null,
      //         child: InputDecorator(
      //           decoration: InputDecoration(
      //             labelText: labelText,
      //             enabled: enable,
      //             border: OutlineInputBorder(),
      //             hintText: 'Remider'
      //           ),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             mainAxisSize: MainAxisSize.min,
      //             children: <Widget>[
      //               selectedTime != null
      //                   ? Text(
      //                       DateFormat(Constant.APP_TIME_FORMAT).format(
      //                         DateTime(
      //                           today.year,
      //                           today.month,
      //                           today.day,
      //                           selectedTime.hour,
      //                           selectedTime.minute,
      //                         ),
      //                       ),
      //                     )
      //                   : Text('Select Time'),
      //               Icon(Icons.timer, size: 20),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
