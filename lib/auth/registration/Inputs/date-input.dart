import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sadhana/auth/login/validate_widget.dart';
import 'package:sadhana/common.dart';
import 'package:sadhana/constant/constant.dart';

class DateInput extends StatelessWidget {
  DateInput(
      {Key key,
      this.labelText,
      this.selectedDate,
      this.selectDate,
      this.enable = true,
      this.viewMode = false,
      this.viewModeTitleWidth,
      this.isFutureAllow = false,
      this.isRequiredValidation = false})
      : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final ValueChanged<DateTime> selectDate;
  final bool enable;
  final bool isRequiredValidation;
  final bool viewMode;
  final bool isFutureAllow;
  final double viewModeTitleWidth;
  BuildContext context;

  buildDateInputPicker(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 4,
          child: InkWell(
            onTap: enable
                ? () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _selectDate(context);
                  }
                : null,
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: isRequiredValidation ? '$labelText *' : labelText,
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
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1950, 1),
      lastDate: isFutureAllow ? DateTime(2099,1) : DateTime.now(),
    );
    if (picked != null && picked != selectedDate) selectDate(picked);
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Container(
      padding: EdgeInsets.symmetric(vertical: !viewMode ? 10.0 : 5),
      alignment: Alignment.bottomLeft,
      child: viewMode ? viewModeWidget() : editModeWidget(),
    );
  }

  Widget editModeWidget() {
    return ValidateInput(
      labelText: labelText,
      isRequiredValidation: isRequiredValidation,
      inputWidget: buildDateInputPicker(context),
      selectedValue: selectedDate,
    );
  }

  Widget viewModeWidget() {
    double screenWidth = MediaQuery.of(context).size.width;
    return CommonFunction.getTitleAndNameForProfilePage(
      screenWidth: screenWidth,
      title: labelText,
      value: selectedDate != null ? Constant.APP_DATE_FORMAT.format(selectedDate) : '',
      titleWidth: viewModeTitleWidth,
    );
  }
}
