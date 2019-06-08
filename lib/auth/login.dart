import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sadhana/auth/registration/registration.dart';
import 'package:sadhana/comman.dart';
import 'package:sadhana/commonvalidation.dart';
import 'package:sadhana/constant/colors.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/model/profile.dart';
import 'package:sadhana/model/register.dart';
import 'package:sadhana/sadhana/home.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/app_response_parser.dart';
import 'package:sadhana/widgets/base_state.dart';
import 'package:sadhana/wsmodel/appresponse.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  const LoginPage({
    Key key,
    this.optionsPage,
  }) : super(key: key);

  final Widget optionsPage;

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends BaseState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyMobile = GlobalKey<FormState>();
  final _formKeyEmail = GlobalKey<FormState>();
  final _formKeyOtp = GlobalKey<FormState>();
  final mhtIdController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final otpController = TextEditingController();
  bool _autoValidate = false;
  ApiService api = new ApiService();
  int currantStep = 0;
  List<Step> loginSteps = [];
  List<StepState> stepState = [
    StepState.editing,
    StepState.disabled,
    StepState.disabled,
    StepState.disabled,
  ];
  Profile profileData;
  OtpData otpData;
  int registerMethod = 0;

  _login(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print('Login');
      startLoading();
      try {
        Response res = await api.getUserProfile(mhtIdController.text);
        AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
        if (appResponse.status == WSConstant.SUCCESS_CODE) {
          print('***** Login Data ::: ');
          print(appResponse.data);
          setState(() {
            profileData = Profile.fromJson(appResponse.data);
            stepState = [StepState.complete, StepState.editing, StepState.disabled, StepState.disabled];
            currantStep += 1;
            FocusScope.of(context).requestFocus(new FocusNode());
          });
        }
      } catch (e, s) {
        print(e);
        print(s);
        CommonFunction.displayErrorDialog(context: context);
        stopLoading();
      }
      stopLoading();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  _sendOtp(BuildContext context) async {
    if (registerMethod == 0 && _formKeyMobile.currentState.validate() || registerMethod == 1 && _formKeyEmail.currentState.validate()) {
      registerMethod == 0 ? _formKeyMobile.currentState.save() : _formKeyEmail.currentState.validate();
      if (await _sendOTPAPICall()) {
        setState(() {
          stepState = [StepState.complete, StepState.complete, StepState.editing, StepState.disabled];
          currantStep += 1;
          FocusScope.of(context).requestFocus(new FocusNode());
        });
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  _resendOtp() async {
    await _sendOTPAPICall();
  }

  Future<bool> _sendOTPAPICall() async {
    print('Send OTP');
    startLoading();
    try {
      Response res = await api.sendOTP(mhtIdController.text, emailController.text, mobileController.text);
      AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
      if (appResponse.status == WSConstant.SUCCESS_CODE) {
        print('***** OTP Data ::: ');
        print(appResponse.data);
        otpData = OtpData.fromJson(appResponse.data);
        stopLoading();
        return true;
      }
    } catch (e, s) {
      print(e);
      print(s);
      stopLoading();
      CommonFunction.displayErrorDialog(context: context);
    }
    stopLoading();
    return false;
  }

  _verify(BuildContext context) async {
    if (_formKeyOtp.currentState.validate()) {
      _formKeyOtp.currentState.save();
      print('Verify');
      startLoading();
      if (true) {
      //if (otpController.text == otpData.otp.toString()) {
        setState(() {
          stepState = [
            StepState.complete,
            StepState.complete,
            StepState.complete,
            StepState.editing,
          ];
          currantStep += 1;
          FocusScope.of(context).requestFocus(new FocusNode());
        });
      } else {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text('Verification Failed'),
              content: Text('Entered OTP does not match !!! '),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Retry'),
                )
              ],
            );
          },
        );
      }
      stopLoading();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  @override
  Widget pageToDisplay() {
    //mhtIdController.text = '78241';
    //mobileController.text = '9429520961';
    //otpController.text = '123456';
    Widget getTitleAndName({@required String title, @required String value}) {
      return Container(
        padding: EdgeInsets.all(5),
        child: Row(
          children: <Widget>[
            Container(
              width: 80,
              child: Text(
                '$title : ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              child: Text(
                '$value',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
      );
    }

    Widget buildStep1() {
      return Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  Text(
                    'Enter Your I-Card Number',
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      'Please enter Mahatma I-Card/Temporary Id (\'Z\') Number to Proceed:',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            // MHT ID
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              alignment: Alignment.bottomLeft,
              child: TextFormField(
                controller: mhtIdController,
                validator: CommonValidation.mhtIdValidation,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                  labelText: 'Mht ID',
                ),
                maxLines: 1,
              ),
            ),
          ],
        ),
      );
    }

    Widget loginForm() {
      switch (registerMethod) {
        case 0:
          // Contact No
          return Form(
            key: _formKeyMobile,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              alignment: Alignment.bottomLeft,
              child: TextFormField(
                controller: mobileController,
                validator: CommonValidation.mobileValidation,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: const InputDecoration(
                  icon: Icon(Icons.call),
                  border: OutlineInputBorder(),
                  labelText: 'Mobile Number',
                ),
                maxLines: 1,
              ),
            ),
          );
          break;
        default:
          // Email
          return Form(
            key: _formKeyEmail,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              alignment: Alignment.bottomLeft,
              child: TextFormField(
                controller: emailController,
                validator: CommonValidation.emailValidation,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                  labelText: 'Email Id',
                ),
                maxLines: 1,
              ),
            ),
          );
          break;
      }
    }

    Widget buildStep2() {
      return Column(
        children: <Widget>[
          Card(
            child: Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.bottomLeft,
              child: Column(
                children: <Widget>[
                  getTitleAndName(
                    title: 'Mht Id',
                    value: profileData != null ? '${profileData.mhtId}' : "",
                  ),
                  getTitleAndName(
                    title: 'Full name',
                    value: profileData != null
                        ? '${profileData.firstName.substring(0, 2)}****** ${profileData.lastName.substring(0, 2)}******'
                        : "",
                  ),
                  getTitleAndName(
                    title: 'Mobile',
                    value: profileData != null
                        ? '${profileData.mobileNo1.substring(0, 2)}******${profileData.mobileNo1.substring(profileData.mobileNo1.length - 2, profileData.mobileNo1.length)}'
                        : "",
                  ),
                  getTitleAndName(
                    title: 'Email',
                    value: profileData != null ? profileData.email.trim().isNotEmpty ? getEmailId() : "" : "",
                  ),
                ],
              ),
            ),
          ),
          Card(
            // color: Colors.purple.shade50,
            child: Container(
              padding: EdgeInsets.all(5),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Enter the Mobile Number or the Email ID as specified on the I-Card = ${profileData != null ? profileData.mhtId : ""}',
                    ),
                  ),
                  Divider(
                    height: 0,
                  ),
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
          ),
          Card(
            child: Container(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text('Mobile Number'),
                    leading: Icon(Icons.call),
                    trailing: Radio(
                      groupValue: registerMethod,
                      onChanged: (value) {
                        setState(() {
                          registerMethod = value;
                          FocusScope.of(context).requestFocus(new FocusNode());
                        });
                      },
                      value: 0,
                    ),
                    onTap: () {
                      setState(() {
                        registerMethod = 0;
                        FocusScope.of(context).requestFocus(new FocusNode());
                      });
                    },
                  ),
                  Divider(
                    height: 0,
                  ),
                  ListTile(
                    title: Text('Email Id'),
                    leading: Icon(Icons.email),
                    trailing: Radio(
                      groupValue: registerMethod,
                      onChanged: (value) {
                        setState(() {
                          registerMethod = value;
                          FocusScope.of(context).requestFocus(new FocusNode());
                        });
                      },
                      value: 1,
                    ),
                    onTap: () {
                      setState(() {
                        registerMethod = 1;
                        FocusScope.of(context).requestFocus(new FocusNode());
                      });
                    },
                  )
                ],
              ),
            ),
          ),
          loginForm()
        ],
      );
    }

    Widget buildStep3() {
      return Form(
        key: _formKeyOtp,
        autovalidate: _autoValidate,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Enter Verification Code',
                style: TextStyle(fontSize: 25),
              ),
            ),
            // OTP
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              alignment: Alignment.bottomLeft,
              child: TextFormField(
                controller: otpController,
                validator: CommonValidation.otpValidation,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  icon: Icon(Icons.phonelink_lock),
                  border: OutlineInputBorder(),
                  labelText: 'Enter OTP',
                ),
                maxLines: 1,
              ),
            ),
            // Resend Verification code
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: OutlineButton(
                  child: Text('Resend Verification Code'),
                  onPressed: _resendOtp,
                ),
              ),
            ),
            // Back
            Center(
              child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    children: <Widget>[
                      OutlineButton(
                        child: Text('Restart'),
                        onPressed: () {
                          setState(() {
                            mhtIdController.clear();
                            mobileController.clear();
                            emailController.clear();
                            otpController.clear();
                            stepState = [
                              StepState.editing,
                              StepState.disabled,
                              StepState.disabled,
                              StepState.disabled,
                            ];
                            currantStep = 0;
                          });
                        },
                      ),
                      new FlatButton(
                        child: new Text(
                          'Mobile change?',
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/forgotPassword');
                        },
                      ),
                    ],
                  )),
            )
          ],
        ),
      );
    }

    Widget buildStep4() {
      return Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: CircleAvatar(
              child: Icon(
                Icons.done,
                size: 80,
                color: Colors.white,
              ),
              minRadius: 50,
              backgroundColor: Colors.green,
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              'You are successfully verified\n',
              style: TextStyle(fontSize: 30),
            ),
          ),
          Card(
            child: Container(
              padding: const EdgeInsets.all(15),
              alignment: Alignment.bottomLeft,
              child: Column(
                children: <Widget>[
                  getTitleAndName(
                    title: 'Mht Id',
                    value: profileData != null ? '${profileData.mhtId}' : "",
                  ),
                  getTitleAndName(
                    title: 'Full name',
                    value: profileData != null ? '${profileData.firstName} ${profileData.lastName}' : "",
                  ),
                  getTitleAndName(
                    title: 'Mobile',
                    value: profileData != null ? '${profileData.mobileNo1}' : "",
                  ),
                  getTitleAndName(
                    title: 'Email',
                    value: profileData != null ? '${profileData.email}' : "",
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    loginSteps = [
      Step(
        title: Text('Start'),
        content: buildStep1(),
        isActive: currantStep == 0,
        state: stepState[0],
      ),
      Step(
        title: Text('Activate'),
        content: buildStep2(),
        isActive: currantStep == 1,
        state: stepState[1],
      ),
      Step(
        title: Text('Verify'),
        content: buildStep3(),
        isActive: currantStep == 2,
        state: stepState[2],
      ),
      Step(
        title: Text('Linked'),
        content: buildStep4(),
        isActive: currantStep == 3,
        state: stepState[3],
      ),
    ];

    return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Login'),
          ),
          body: SafeArea(
            child: Stepper(
              type: StepperType.vertical,
              steps: loginSteps,
              currentStep: currantStep,
              onStepContinue: onSetupContinue,
              onStepTapped: (value) {
                // setState(() {
                //   currantStep = value;
                // });
              },
            ),
          ),
        )
    );
  }

  String getEmailId() {
    try {
      return '${profileData.email.substring(0, 2)}******@${profileData.email.substring(profileData.email.indexOf('@') + 1, profileData.email.indexOf('@') + 3)}******${profileData.email.substring(profileData.email.lastIndexOf('.'), profileData.email.length)}';
    } catch (e, s) {
      print(e);
      print(s);
    }
    return "";
  }

  void onSetupContinue() {
    switch (currantStep) {
      case 0:
        _login(context);
        break;
      case 1:
        _sendOtp(context);
        break;
      case 2:
        _verify(context);
        break;
      case 3:
        if (otpData.profile.registered == 0) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => RegistrationPage(
                      registrationData: otpData.profile,
                    ),
              ));
        } else {
          if (otpData.isLoggedIn == 1) {
            CommonFunction.alertDialog(
                context: context,
                msg:
                    "You are already logged in other device. You will be logout from that device, Do you want to still process in this device?",
                doneButtonText: 'Yes',
                doneButtonFn: goToHomePage);
          }
        }
        break;
    }
  }

  goToHomePage() async {
    Navigator.pop(context);
    if (await CommonFunction.registerUser(register: otpData.profile, context: context)) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }
  }

  void changeMobilePopup() async {

  }
}
