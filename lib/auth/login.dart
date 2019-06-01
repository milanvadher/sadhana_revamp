import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sadhana/comman.dart';
import 'package:sadhana/commonvalidation.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/model/profile.dart';
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
  final mhtIdController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  bool _autoValidate = false;
  ApiService api = new ApiService();
  int currantStep = 0;
  List<Step> loginSteps = [];
  List<StepState> stepState = [
    StepState.editing,
    StepState.disabled,
    StepState.disabled,
    StepState.disabled
  ];
  Profile profileData;
  int registerMethod = 0;

  _login() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print('Login');
      setState(() {
        isOverlay = true;
      });
      try {
        Response res = await api.postApi(
          url: '/mba.user.user_profile',
          data: {'mht_id': mhtIdController.text.toString()},
        );
        AppResponse appResponse =
            AppResponseParser.parseResponse(res, context: context);
        if (appResponse.status == WSConstant.SUCCESS_CODE) {
          print('***** Login Data ::: ');
          print(appResponse.data);
          setState(() {
            profileData = Profile.fromJson(appResponse.data);
            stepState = [
              StepState.complete,
              StepState.editing,
              StepState.disabled,
              StepState.disabled
            ];
            currantStep += 1;
          });
        }
        //  Navigator.pop(context);
        //  Navigator.pushReplacementNamed(
        //    context,
        //    HomePage.routeName,
        //  );
      } catch (error) {
        print(error);
        CommonFunction.displayErrorDialog(context: context);
        setState(() {
          isOverlay = false;
        });
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  _sendOtp() async {
    if (registerMethod == 0 && _formKeyMobile.currentState.validate() ||
        registerMethod == 1 && _formKeyEmail.currentState.validate()) {
      registerMethod == 0
          ? _formKeyMobile.currentState.save()
          : _formKeyEmail.currentState.validate();
      print('Send OTP');
      setState(() {
        isOverlay = true;
      });
      try {
        Response res = await api.postApi(url: '/mba.user.send_otp', data: {
          "mht_id": mhtIdController.text,
          "email": emailController.text,
          "mobile_no_1": mobileController.text,
        });
        AppResponse appResponse =
            AppResponseParser.parseResponse(res, context: context);
        if (appResponse.status == WSConstant.SUCCESS_CODE) {
          print('***** OTP Data ::: ');
          print(appResponse.data);
          setState(() {
            stepState = [
              StepState.complete,
              StepState.complete,
              StepState.editing,
              StepState.disabled
            ];
            currantStep += 1;
          });
        }
        //  Navigator.pop(context);
        //  Navigator.pushReplacementNamed(
        //    context,
        //    HomePage.routeName,
        //  );
      } catch (error) {
        print(error);
        CommonFunction.displayErrorDialog(context: context);
        setState(() {
          isOverlay = false;
        });
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget getTitleAndName({@required String title, @required String value}) {
      return Container(
        padding: EdgeInsets.all(5),
        child: Row(
          children: <Widget>[
            Container(
              width: 100,
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

    Widget booleanPoint({@required String text, TextStyle textStyle}) {
      return Wrap(
        children: <Widget>[
          Icon(Icons.rounded_corner),
          Text(text, style: textStyle ?? textStyle)
        ],
      );
    }

    Widget buildStep1() {
      return Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // // Image
            // Container(
            //   padding: const EdgeInsets.all(30.0),
            //   child: Image.asset(
            //     'images/logo_dada.png',
            //     height: 140,
            //   ),
            // ),
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
                keyboardType: TextInputType.text,
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
                    value: profileData != null
                        ? '${profileData.email.substring(0, 2)}******@${profileData.email.substring(profileData.email.indexOf('@') + 1, profileData.email.indexOf('@') + 3)}******${profileData.email.substring(profileData.email.lastIndexOf('.'), profileData.email.length)}'
                        : "",
                  ),
                ],
              ),
            ),
          ),
          Card(
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
      return Center(
        child: Text('Verify Here'),
      );
    }

    Widget buildStep4() {
      return Center(
        child: Text('You are done'),
      );
    }

    loginSteps = [
      Step(
          title: Text('Start'),
          content: buildStep1(),
          isActive: currantStep == 0,
          state: stepState[0]),
      Step(
          title: Text('Activate'),
          content: buildStep2(),
          isActive: currantStep == 1,
          state: stepState[1]),
      Step(
          title: Text('Verify'),
          content: buildStep3(),
          isActive: currantStep == 2,
          state: stepState[2]),
      Step(
          title: Text('Linked'),
          content: buildStep4(),
          isActive: currantStep == 3,
          state: stepState[3]),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SafeArea(
        child: Stepper(
          type: StepperType.horizontal,
          steps: loginSteps,
          currentStep: currantStep,
          onStepContinue: () {
            switch (currantStep) {
              case 0:
                _login();
                break;
              case 1:
                _sendOtp();
                break;
              case 2:
                setState(() {
                  stepState = [
                    StepState.complete,
                    StepState.complete,
                    StepState.complete,
                    StepState.editing,
                  ];
                  currantStep += 1;
                });
                break;
              case 3:
                setState(() {
                  stepState = [
                    StepState.editing,
                    StepState.disabled,
                    StepState.disabled,
                    StepState.disabled,
                  ];
                  currantStep = 0;
                });
                break;
            }
          },
          onStepTapped: (value) {
            // setState(() {
            //   currantStep = value;
            // });
          },
        ),
      ),
    );
  }

  @override
  Widget pageToDisplay() {
    return null;
  }
}
