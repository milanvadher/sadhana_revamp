import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sadhana/comman.dart';
import 'package:sadhana/commonvalidation.dart';
import 'package:sadhana/constant/wsconstants.dart';
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
  final mhtIdController = TextEditingController();
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
  String profileData;

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
            profileData = appResponse.data.toString();
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

  @override
  Widget build(BuildContext context) {
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

    Widget buildStep2() {
      return Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text('$profileData'),
          ),
        ),
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
                setState(() {
                  stepState = [
                    StepState.complete,
                    StepState.complete,
                    StepState.editing,
                    StepState.disabled
                  ];
                  currantStep += 1;
                });
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
            // setState(() {
            //   if (currantStep < loginSteps.length - 1) {
            //     currantStep += 1;
            //     isActiveStep[currantStep] = true;
            //   } else {
            //     currantStep = 0;
            //   }
            // });
          },
          onStepTapped: (value) {
            setState(() {
              currantStep = value;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget pageToDisplay() {
    // TODO: implement pageToDisplay
    return null;
  }
}
