import 'package:flutter/material.dart';
import 'package:sadhana/common.dart';
import 'package:sadhana/commonvalidation.dart';
import 'package:sadhana/model/logindatastate.dart';
import 'package:sadhana/model/profile.dart';
import 'package:sadhana/utils/apputils.dart';

class ActivateWidget extends StatefulWidget {
  final LoginState loginState;
  final Function onMobileChangeClick;
  const ActivateWidget({Key key, @required this.loginState, this.onMobileChangeClick}) : super(key: key);

  @override
  _ActivateWidgetState createState() => _ActivateWidgetState();
}

class _ActivateWidgetState extends State<ActivateWidget> {
  Profile profileData;
  LoginState loginState;
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loginState = widget.loginState;
  }

  @override
  Widget build(BuildContext context) {
    loginState = widget.loginState;
    profileData = widget.loginState.profileData;
    return profileData != null
        ? Column(
            children: <Widget>[
              _buildMBAInfo(),
              _buildNote(),
              _buildRadioWidget(),
              _inputForm(),
              AppUtils.isNullOrEmpty(profileData.mobileNo1) ? Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: new FlatButton(
                    child: new Text(
                      'Mobile change request ?',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: widget.onMobileChangeClick,
                  ),
                ),
              ): Container(),
            ],
          )
        : Container();
  }

  Widget _buildMBAInfo() {
    double screenWidth = MediaQuery.of(context).size.width;
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        alignment: Alignment.bottomLeft,
        child: Column(
          children: <Widget>[
            CommonFunction.getTitleAndName(screenWidth: screenWidth, title: 'Mht Id', value: '${profileData.mhtId}'),
            CommonFunction.getTitleAndName(screenWidth: screenWidth, title: 'Full name', value: getFullName()),
            CommonFunction.getTitleAndName(screenWidth: screenWidth, title: 'Mobile', value: getMobileNumber()),
            CommonFunction.getTitleAndName(screenWidth: screenWidth, title: 'Email', value: getEmailId()),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioWidget() {
    return Card(
      child: Container(
        child: Column(
          children: <Widget>[
            _buildRadioRow(
              icon: Icon(Icons.call),
              label: 'Mobile Number',
              radioValue: 0,
            ),
            Divider(height: 0),
            _buildRadioRow(
              icon: Icon(Icons.email),
              label: 'Email Id',
              radioValue: 1,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRadioRow({Icon icon, String label, int radioValue}) {
    return ListTile(
      title: Text(label),
      leading: icon,
      trailing: Radio(
        groupValue: loginState.registerMethod,
        onChanged: (value) {
          setState(() {
            onRadioValueChange(radioValue);
          });
        },
        value: radioValue,
      ),
      onTap: () {
        onRadioValueChange(radioValue);
      },
    );
  }

  void onRadioValueChange(int selectedValue) {
    setState(() {
      loginState.registerMethod = selectedValue;
      if(loginState.registerMethod == 0)
        loginState.email = '';
      else
        loginState.mobileNo = '';
    });
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  Widget _inputForm() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      alignment: Alignment.bottomLeft,
      child: loginState.registerMethod == 0
          ? TextFormField(
              controller: mobileController,
              //initialValue: loginState.mobileNo.toString(),
              validator: mobileValidation,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                icon: Icon(Icons.call),
                border: OutlineInputBorder(),
                labelText: 'Mobile Number',
              ),
              maxLines: 1,
              maxLength: 10,
              onSaved: (value) => loginState.mobileNo = value,
            )
          : TextFormField(
              controller: emailController,
              //initialValue: loginState.email,
              validator: emailValidation,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                icon: Icon(Icons.email),
                border: OutlineInputBorder(),
                labelText: 'Email Id',
              ),
              maxLines: 1,
              onSaved: (value) => loginState.email = value,
            ),
    );
  }

  static String mobileValidation(String value) {
    if (value.isEmpty) {
      return 'Mobile no. is required';
    } else if (value.length != 10) {
      return 'Enter valid Mobile no./Email';
    }
    return null;
  }

  // email Validation
  static String emailValidation(String value) {
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) {
      return 'Email is required';
    } else if (!regex.hasMatch(value)) {
      return 'Enter valid Email/Mobile';
    }
    return null;
  }
  Widget _buildNote() {
    return Card(
      // color: Colors.purple.shade50,
      child: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Enter the Mobile Number or the Email ID as specified on the I-Card = ${profileData.mhtId}',
              ),
            ),
            Divider(height: 0),
            Container(
              padding: EdgeInsets.all(05),
              // color: Colors.red.shade100,
              child: Column(
                children: <Widget>[
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.all(0),
                    subtitle: Text(
                      'A Verification code will be send to the Mobile Number or on Email ID as specified on the I-Card.\n',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  ListTile(
                    subtitle: Text(
                      'If Mobile Number or Email Id is diffrent from specified on I-Card then please contact MBA Office for updation',
                      style: TextStyle(color: Colors.red),
                    ),
                    dense: true,
                    contentPadding: EdgeInsets.all(0),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String getMobileNumber() {
    if (!AppUtils.isNullOrEmpty(profileData.mobileNo1))
      return '${profileData.mobileNo1.substring(0, 2)}******${profileData.mobileNo1.substring(profileData.mobileNo1.length - 2, profileData.mobileNo1.length)}';
    return '';
  }

  String getFullName() {
    String fullName = '';
    if (profileData != null) {
      if (!AppUtils.isNullOrEmpty(profileData.firstName)) {
        fullName = '${profileData.firstName.substring(0, 2)}******';
      }
      if (!AppUtils.isNullOrEmpty(profileData.lastName) && profileData.lastName.length > 2) {
        if(profileData.lastName.length > 2)
          fullName = fullName + '${profileData.lastName.substring(0, 2)}******';
        else
          fullName = fullName + ' ${profileData.lastName}';
      }
    }
    return fullName;
  }

  String getEmailId() {
    try {
      if (!AppUtils.isNullOrEmpty(profileData.email))
        return '${profileData.email.substring(0, 2)}******'
            '@${profileData.email.substring(profileData.email.indexOf('@') + 1, profileData.email.indexOf('@') + 3)}******${profileData.email.substring(
          profileData.email.lastIndexOf('.'),
          profileData.email.length,
        )}';
    } catch (e, s) {
      print(e);
      print(s);
    }
    return "";
  }
}
