import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sadhana/auth/registration/Inputs/dropdown-input.dart';
import 'package:sadhana/auth/registration/Inputs/text-input.dart';
import 'package:sadhana/comman.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/model/city.dart';
import 'package:sadhana/model/register.dart';
import 'package:sadhana/model/state.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/app_response_parser.dart';
import 'package:sadhana/wsmodel/appresponse.dart';

class AddressInput extends StatefulWidget {
  final Address address;
  List<String> countryList;
  Function startLoading;
  Function stopLoading;
  AddressInput({@required this.address, @required this.countryList, @required this.startLoading, @required this.stopLoading});

  @override
  _AddressInputState createState() => _AddressInputState();
}

class _AddressInputState extends State<AddressInput> {
  Address address;
  List<String> countryList = [];
  List<StateList> stateList = [];
  List<City> cityList = [];
  ApiService api = new ApiService();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    address = widget.address;
    Future.delayed(Duration(seconds: 1), () {
      try {
        if (address.country != null && address.country.trim().isNotEmpty) {
          getStateByCountry(country: address.country);
        }
        if (address.state != null && address.state.trim().isNotEmpty) {
          getCityByState(state: address.state);
        }
      } catch(e,s) {
        print(e);print(s);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    address = widget.address;
    countryList = widget.countryList;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          // Address Line 1
          TextInputField(
            enabled: true,
            labelText: 'Address Line 1',
            valueText: address?.addressLine1,
            onSaved: (value) => address.addressLine1 = value,
            isRequiredValidation: true,
          ),
          // Address Line 2
          TextInputField(
            enabled: true,
            labelText: 'Address Line 2',
            valueText: address?.addressLine2,
            onSaved: (value) => address.addressLine2 = value,
          ),
          // Country
          DropDownInput(
            labelText: "Country",
            items: countryList ?? [],
            onChange: (value) {
              setState(() {
                if(value != null)
                  address.country = value;
              });
              getStateByCountry(country: value, resetState: true);
            },
            valueText: address.country ?? "",
          ),
          // State
          DropDownInput.fromMap(
            labelText: "State",
            valuesByLabel: stateList != null
                ? new Map.fromIterable(stateList, key: (v) => (v as StateList).state, value: (v) => (v as StateList).name)
                : {},
            onChange: (value) {
              setState(() {
                if(value != null)
                  address.state = value;
              });
              getCityByState(state: value, resetCity: true);
            },
            valueText: address.state ?? "",
            isRequiredValidation: address.country != null ? true : false,
          ),
          // City
          DropDownInput.fromMap(
            labelText: "City",
            valuesByLabel:
                cityList != null ? new Map.fromIterable(cityList, key: (v) => (v as City).city, value: (v) => (v as City).name) : {},
            onChange: (value) {
              setState(() {
                if(value != null)
                  address.city = value;
              });
            },
            valueText: address.city ?? "",
            isRequiredValidation: address.country != null ? true : false,
          ),
          // Pincode
          TextInputField(
            enabled: true,
            labelText: 'Pincode',
            valueText: address.pincode,
            onSaved: (value) => address.pincode = value,
            isRequiredValidation: address.country != null ? true : false,
          ),
        ],
      ),
    );
  }

  getStateByCountry({@required String country, bool resetState = false}) async {
    try {
      widget.startLoading();
      Response res = await api.getStateByCountry(country);
      AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
      List<StateList> states = StateList.fromJsonList(appResponse.data);
      if (appResponse.status == WSConstant.SUCCESS_CODE) {
        setState(() {
          if(resetState) {
            address.state = null;
            address.city = null;
          }
          stateList = states;
        });
      }
      widget.stopLoading();
    } catch (error, s) {
      print(error);
      print(s);
      CommonFunction.displayErrorDialog(context: context);
    }
    widget.stopLoading();
  }

  getCityByState({@required String state, bool resetCity = false}) async {
    try {
      widget.startLoading();
      Response res = await api.getCityByState(state);
      AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
      List<City> cities = City.fromJsonList(appResponse.data);
      if (appResponse.status == WSConstant.SUCCESS_CODE) {
        setState(() {
          if(resetCity)
            address.city = null;
          cityList = cities;
        });
      }
      widget.stopLoading();
    } catch (error, s) {
      print(error);
      print(s);
      CommonFunction.displayErrorDialog(context: context);
    }
    widget.stopLoading();
  }
}
