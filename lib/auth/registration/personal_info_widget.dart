import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:sadhana/auth/registration/Inputs/address_input.dart';
import 'package:sadhana/auth/registration/Inputs/date-input.dart';
import 'package:sadhana/auth/registration/Inputs/dropdown-input.dart';
import 'package:sadhana/auth/registration/Inputs/number-input.dart';
import 'package:sadhana/auth/registration/Inputs/text-input.dart';
import 'package:sadhana/comman.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/model/country.dart';
import 'package:sadhana/model/register.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/app_response_parser.dart';
import 'package:sadhana/wsmodel/appresponse.dart';

class PersonalInfoWidget extends StatefulWidget {
  final Register register;
  final Function startLoading;
  final Function stopLoading;
  const PersonalInfoWidget({
    Key key,
    @required this.register,
    @required this.startLoading,
    @required this.stopLoading,
  }) : super(key: key);

  @override
  _PersonalInfoWidgetState createState() => _PersonalInfoWidgetState();
}

class _PersonalInfoWidgetState extends State<PersonalInfoWidget> {
  Register _register;
  List<bool> isExpandedAddress = [true, false];
  var dateFormatter = new DateFormat(WSConstant.DATE_FORMAT);
  List<String> countryList = [];
  ApiService api = new ApiService();
  @override
  void initState() {
    super.initState();
    loadCountries();
  }

  loadCountries() async {
    try {
      Response res = await api.getAllCountries();
      AppResponse appResponse =
          AppResponseParser.parseResponse(res, context: context);
      if (appResponse.status == WSConstant.SUCCESS_CODE) {
        countryList = [];
        if (mounted) {
          setState(() {
            Country.fromJsonList(appResponse.data).forEach((item) {
              countryList.add(item.name);
            });
          });
        }
      }
    } catch (error, s) {
      print(error);
      print(s);
      CommonFunction.displayErrorDialog(context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    _register = widget.register;
    isExpandedAddress[1] = !_register.sameAsPermanentAddress;
    return Column(
      children: <Widget>[
        // MhtId
        TextInputField(
          enabled: false,
          labelText: 'Mht Id',
          valueText: _register.mhtId,
        ),
        // FullName
        TextInputField(
          enabled: false,
          labelText: 'Full Name',
          valueText:
              '${_register.firstName} ${_register.middleName ?? ""} ${_register.lastName}',
        ),
        // Mobile
        NumberInput(
          enabled: false,
          labelText: 'Mobile',
          valueText: _register.mobileNo1,
        ),
        NumberInput(
          labelText: 'Alternate Mobile',
          valueText: _register.mobileNo2,
        ),
        // Email
        TextInputField(
          enabled: true,
          labelText: 'Email',
          valueText: _register.email,
          onSaved: (value) => _register.email = value,
          isRequiredValidation: true,
          validation: CommonFunction.emailValidation,
        ),
        // Center
        TextInputField(
          enabled: false,
          labelText: 'Center',
          valueText: _register.center,
        ),
        // B_date
        DateInput(
          labelText: 'Birth Date',
          selectedDate:
              _register.bDate == null ? null : DateTime.parse(_register.bDate),
          selectDate: (DateTime date) {
            setState(() {
              _register.bDate = dateFormatter.format(date);
            });
          },
        ),
        // G_date
        DateInput(
          labelText: 'Gnan Date',
          selectedDate:
              _register.gDate == null ? null : DateTime.parse(_register.gDate),
          selectDate: (DateTime date) {
            setState(() {
              _register.gDate = dateFormatter.format(date);
            });
          },
        ),
        // Blood Group
        DropDownInput(
          items: ['A-', 'A+', 'B-', 'B+', 'AB-', 'AB+', 'O-', 'O+'],
          labelText: 'Blood Group',
          valueText: _register.bloodGroup,
          onChange: (value) {
            setState(() {
              _register.bloodGroup = value;
            });
          },
        ),
        // T-shirt Size
        DropDownInput(
          items: ['S', 'M', 'L', 'XL', 'XXL', 'XXXL'],
          labelText: 'T-shirt Size',
          valueText: _register.tshirtSize,
          onChange: (value) {
            setState(() {
              _register.tshirtSize = value;
            });
          },
        ),
        // Permanent Address
        new ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              isExpandedAddress[0] = !isExpandedAddress[0];
            });
          },
          children: [
            ExpansionPanel(
              canTapOnHeader: true,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(title: Text('Permanent Address'));
              },
              isExpanded: isExpandedAddress[0],
              body: AddressInput(
                address: _register.permanentAddress,
                countryList: countryList,
                startLoading: widget.startLoading,
                stopLoading: widget.stopLoading,
              ),
            ),
          ],
        ),
        // Copy checkbox
        Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: <Widget>[
              Text('Same as Permenent Address'),
              Checkbox(
                value: _register.sameAsPermanentAddress,
                onChanged: (value) {
                  setState(() {
                    _register.sameAsPermanentAddress = value;
                    if(_register.sameAsPermanentAddress)
                      isExpandedAddress[1] = false;
                  });
                },
              ),
            ],
          ),
        ),
        // Current Address
        new ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            if (!_register.sameAsPermanentAddress) {
              setState(() {
                isExpandedAddress[1] = !isExpandedAddress[1];
              });
            }
          },
          children: [
            ExpansionPanel(
              canTapOnHeader: true,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text(
                    'Current Address',
                    style: TextStyle(
                      color: _register.sameAsPermanentAddress
                          ? Colors.grey
                          : Theme.of(context).textTheme.copyWith().title.color,
                    ),
                  ),
                );
              },
              isExpanded: isExpandedAddress[1],
              body: isExpandedAddress[1]
                  ? AddressInput(
                      address: _register.currentAddress,
                      countryList: countryList,
                      startLoading: widget.startLoading,
                      stopLoading: widget.stopLoading,
                    )
                  : Container(),
            ),
          ],
        ),
      ],
    );
  }
}
