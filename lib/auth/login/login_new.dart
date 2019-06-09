import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sadhana/auth/login/activate_widget.dart';
import 'package:sadhana/auth/login/linked.dart';
import 'package:sadhana/auth/login/start.dart';
import 'package:sadhana/auth/login/verify.dart';
import 'package:sadhana/auth/registration/registration.dart';
import 'package:sadhana/auth/registration/registration_step.dart';
import 'package:sadhana/comman.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/model/logindatastate.dart';
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
  final _mobileChange = TextEditingController();
  bool _mobileChangeRequestStart = false;
  bool _autoValidate = false;
  ApiService api = new ApiService();
  int currentStep = 0;
  List<Step> loginSteps = [];
  Profile profileData;
  OtpData otpData;
  int registerMethod = 0;
  ScrollController _scrollController = new ScrollController();
  List<AppStep> appSteps;
  LoginState loginState;
  @override
  initState() {
    super.initState();
    loginState = LoginState();
    appSteps = [
      AppStep(
        title: "Start",
        builder: StartWidget(
          loginState: loginState,
        ),
      ),
      AppStep(
        title: "Activate",
        builder: ActivateWidget(
          loginState: loginState,
        ),
      ),
      AppStep(
        title: "Verify",
        builder: VerifyWidget(
          loginState: loginState,
        ),
      ),
      AppStep(
        title: "Linked",
        builder: LinkedWidget(
          profileData: loginState.profileData,
        ),
      ),

    ];
    loginSteps = getSteps(appSteps);
  }

  List<Step> getSteps(List<AppStep> appSteps) {
    return appSteps
        .asMap()
        .map((index, value) =>
        MapEntry(index, _buildStep(index, value)))
        .values
        .toList();
  }

  _buildStep(int index, AppStep regStep) {
    return Step(
      title: Text(regStep.title),
      content: Form(
        key: regStep.formKey,
        autovalidate: _autoValidate,
        child: regStep.builder,
      ),
      isActive: currentStep == index,
    );
  }

  @override
  Widget pageToDisplay() {
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
              controlsBuilder: buildController,
              currentStep: currentStep,
              onStepContinue: onStepContinue,
            ),
          ),
        ));
  }

  _login(BuildContext context) async {
    print('Login');
    startLoading();
    try {
      Response res = await api.getUserProfile(loginState.mhtId);
      AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
      if (appResponse.status == WSConstant.SUCCESS_CODE) {
        print('***** Login Data ::: ');
        print(appResponse.data);
        setState(() {
          profileData = Profile.fromJson(appResponse.data);
        });
      }
    } catch (e, s) {
      print(e);
      print(s);
      CommonFunction.displayErrorDialog(context: context);
    }
    stopLoading();
  }

  Future<bool> _sendOtp(BuildContext context) async {
    print('Send OTP');
    if ((loginState.registerMethod == 0 &&
        loginState.mobileNo != profileData.mobileNo1) ||
        (loginState.registerMethod == 1 && loginState.email != profileData.email)) {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Details did not match'),
            content: Text(
                'Entered Mobile No / Email Id does not match with I-Card Mobile No / Email Id !!! '),
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
    } else {
      if (await _sendOTPAPICall()) {
        return true;
      }
    }
    return false;
  }
  _resendOtp() async {
    await _sendOTPAPICall();
  }

  Future<bool> _sendOTPAPICall() async {
    print('Send OTP');
    startLoading();
    try {
      Response res = await api.sendOTP(
          mhtIdController.text, emailController.text, mobileController.text);
      AppResponse appResponse =
      AppResponseParser.parseResponse(res, context: context);
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
      CommonFunction.displayErrorDialog(context: context);
    }
    stopLoading();
    return false;
  }

  _verify(BuildContext context) async {
    print('Verify');
    //if (true) {
    if (otpController.text == otpData.otp.toString()) {
      return true;
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
  }

  void scrollToTop() {
    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  void onStepCancel() {
    currentStep--;
  }

  Widget buildController(BuildContext context,
      {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          RaisedButton(
            onPressed: onStepContinue,
            child: Text(currentStep != loginSteps.length - 1
                ? 'CONTINUE'
                : _mobileChangeRequestStart ? 'RESTART' : 'CONTINUE'),
          ),
          SizedBox(
            width: 10,
          ),
          currentStep == 1
              ? FlatButton(
            onPressed: onStepCancel,
            child: const Text('BACK'),
          )
              : Container()
        ],
      ),
    );
  }

  void onStepContinue() {
    setState(() {
      GlobalKey<FormState> formKey = appSteps[currentStep].formKey;
      if (!formKey.currentState.validate()) {
        return;
      }
      formKey.currentState.save();
      FocusScope.of(context).requestFocus(new FocusNode());
      stepOperation();
      if (currentStep < appSteps.length - 1)
        currentStep++;
      scrollToTop();
    });
  }

  void stepOperation() {
    switch (currentStep) {
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
        if (_mobileChangeRequestStart) {
          return setState(() {
            loginState.mhtId = '';
            loginState.mobileNo = null;
            loginState.email = '';
            loginState.otp = '';
            _mobileChangeRequestStart = false;
            currentStep = 0;
          });
        }
        //if (true) {
        if (otpData.profile.registered == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => RegistrationPage(
                registrationData: otpData.profile,
              ),
            ),
          );
        } else {
          if (otpData.isLoggedIn == 1) {
            CommonFunction.alertDialog(
              context: context,
              msg:
              "You are already logged in other device. You will be logout from that device, Do you want to still process in this device?",
              doneButtonText: 'Yes',
              doneButtonFn: goToHomePage,
            );
          }
        }
        break;
    }
  }

  goToHomePage() async {
    Navigator.pop(context);
    if (await CommonFunction.registerUser(
        register: otpData.profile, context: context)) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }
  }
}
