import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sadhana/auth/login/activate_widget.dart';
import 'package:sadhana/auth/login/linked.dart';
import 'package:sadhana/auth/login/mobile_request_success.dart';
import 'package:sadhana/auth/login/start.dart';
import 'package:sadhana/auth/login/verify.dart';
import 'package:sadhana/auth/registration/registration.dart';
import 'package:sadhana/auth/registration/registration_request.dart';
import 'package:sadhana/common.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/model/logindatastate.dart';
import 'package:sadhana/model/profile.dart';
import 'package:sadhana/model/register.dart';
import 'package:sadhana/model/registration_request.dart';
import 'package:sadhana/sadhana/home.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/app_response_parser.dart';
import 'package:sadhana/utils/apputils.dart';
import 'package:sadhana/widgets/base_state.dart';
import 'package:sadhana/wsmodel/appresponse.dart';

import 'mobile_change_widget.dart';

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
  bool _autoValidate = false;
  ApiService api = new ApiService();
  int currentStep = 0;

  List<Step> get loginSteps => getSteps();
  OtpData otpData;
  ScrollController _scrollController = new ScrollController();
  LoginState loginState;
  List<GlobalKey<FormState>> formKeys = List.generate(4, (index) => GlobalKey());

  @override
  initState() {
    super.initState();
    loginState = LoginState();
  }

  List<Step> getSteps() {
    return [
      _buildStep(
        index: 0,
        title: 'Start',
        body: StartWidget(loginState: loginState),
      ),
      _buildStep(
        index: 1,
        title: 'Activate',
        body: ActivateWidget(
            loginState: loginState,
            onMobileChangeClick: () {
              onMobileChangeClick();
              currentStep++;
            }),
      ),
      _buildStep(
        index: 2,
        title: loginState.mobileChangeRequestStart ? 'Mobile Change' : 'Verify',
        body: loginState.mobileChangeRequestStart
            ? ChangeMobileWidget(loginState: loginState)
            : VerifyWidget(
                loginState: loginState,
                resendOtp: _resendOtp,
                onMobileChangeClick: onMobileChangeClick,
              ),
      ),
      _buildStep(
        index: 3,
        title: loginState.mobileChangeRequestStart ? 'Success' : 'Linked',
        body: loginState.mobileChangeRequestStart
            ? MobileChangeRequestSuccessWidget()
            : LinkedWidget(profileData: loginState.profileData),
      ),
    ];
  }

  void onMobileChangeClick() {
    setState(() {
      loginState.mobileChangeRequestStart = true;
    });
  }

  Step _buildStep({int index, String title, Widget body}) {
    return Step(
      title: Text(title),
      content: Form(
        key: formKeys[index],
        autovalidate: _autoValidate,
        child: body,
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
            child: ListView(
              controller: _scrollController,
              children: <Widget>[
                Stepper(
                  physics: ClampingScrollPhysics(),
                  type: StepperType.vertical,
                  steps: loginSteps,
                  controlsBuilder: buildController,
                  currentStep: currentStep,
                  onStepContinue: onStepContinue,
                  onStepCancel: onStepCancel,
                )
              ],
            ),
          ),
        ));
  }

  Widget buildController(BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          RaisedButton(
            onPressed: onStepContinue,
            child:
                Text(currentStep != loginSteps.length - 1 ? 'CONTINUE' : loginState.mobileChangeRequestStart ? 'RESTART' : 'CONTINUE'),
          ),
          SizedBox(
            width: 10,
          ),
          currentStep == 1 || currentStep == 2
              ? FlatButton(
                  onPressed: onStepCancel,
                  child: const Text('BACK'),
                )
              : Container()
        ],
      ),
    );
  }

  void onStepContinue() async {
    GlobalKey<FormState> formKey = formKeys[currentStep];
    if (!formKey.currentState.validate()) {
      return;
    }
    formKey.currentState.save();
    FocusScope.of(context).requestFocus(new FocusNode());
    if (await stepOperation()) {
      setState(() {
        if (currentStep < loginSteps.length - 1) currentStep++;
      });
      //scrollToTop();
    }
  }

  void onStepCancel() {
    if (currentStep == 2) loginState.mobileChangeRequestStart = false;
    setState(() {
      currentStep--;
    });
  }

  void scrollToTop() {
    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  Future<bool> stepOperation() async {
    switch (currentStep) {
      case 0: //Start
        return await _loadUserProfile(context);
        break;
      case 1: //Activate
        return await _sendOtp(context);
        break;
      case 2: //Verify
        if (loginState.mobileChangeRequestStart)
          return await submitMobileChangeReq();
        else
          return _verify(context);
        break;
      case 3:
        onSubmit();
        break;
    }
    return false;
  }

  void onSubmit() {
    if (loginState.mobileChangeRequestStart) {
      return restart();
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
          showCancelButton: true,
          cancelButtonText: 'No',
          doneCancelFn: () {
            Navigator.pop(context);
            restart();
          },
          doneButtonFn: goToHomePage,
        );
      } else {
        goToHomePage();
      }
    }
  }

  void restart() {
    /*setState(() {
      loginState.reset();
      currentStep = 0;
    });*/
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  Future<bool> _loadUserProfile(BuildContext context) async {
    print('Login');
    if (await AppUtils.isInternetConnected()) {
      startOverlay();
      try {
        /*try {
          loginState.intMhtId = int.parse(loginState.intMhtId).toString();
        } catch (e,s) {
          print(e); print(s);
        }*/
        Response res = await api.getUserProfile(loginState.mhtId);
        AppResponse appResponse = AppResponseParser.parseResponse(res, context: context, showDialog: false);
        print(appResponse.status);
        if (appResponse.status == WSConstant.SUCCESS_CODE) {
          print('***** Login Data ::: ');
          print(appResponse.data);
          setState(() {
            loginState.profileData = Profile.fromJson(appResponse.data);
            loginState = loginState;
          });
          stopOverlay();
          return true;
        } else if (appResponse.status == WSConstant.CODE_ENTITY_NOT_FOUND) {
          print('inside data');
          RegistrationRequest registrationRequest = await getRegistrationRequest(loginState.mhtId);
          String msg;
          String doneButtonText;
          bool allow = true;
          if(registrationRequest == null) {
            msg = "Your Mht Id is not registered with us, Pls Check again, "
                "If it is correct and you are Dada's MBA then Kindly click Register button to enter registration details.";
            doneButtonText = "Register";
          } else {
            if(AppUtils.equalsIgnoreCase(registrationRequest.status,WSConstant.REJECTED)) {
              msg = "Your registration request is already rejected.";
              doneButtonText = "OK";
              allow = false;
            } else {
              msg = "You have already raised registration request. Do You want to update request?";
              doneButtonText = "Yes";
            }
          }
          CommonFunction.alertDialog(
              context: context,
              msg: msg,
              showCancelButton: true,
              doneButtonText: doneButtonText,
              doneButtonFn: () {
                Navigator.pop(context);
                if(allow)
                  Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationRequestPage(mhtId: loginState.mhtId,request: registrationRequest,)));
              });
        }
      } catch (e, s) {
        print(e);
        print(s);
        CommonFunction.displayErrorDialog(context: context);
      }
      stopOverlay();
    } else {
      CommonFunction.displayInternetNotAvailableDialog(context: context);
    }
    return false;
  }

  Future<RegistrationRequest> getRegistrationRequest(String mhtId) async {
    RegistrationRequest request;
    await CommonFunction.tryCatchAsync(context, () async {
      Response res = await api.getRegRequest(mhtId);
      AppResponse appResponse = AppResponseParser.parseResponse(res, context: context, showDialog: false);
      if (appResponse.isSuccess && appResponse.data != null) {
        setState(() {
          List<RegistrationRequest> regRequestList = RegistrationRequest.fromJsonList(appResponse.data['profile']);
          if(regRequestList.isNotEmpty) {
            setState(() {
              request = regRequestList.first;
            });
          }
        });
      }
    });
    return request;
  }

  Future<bool> _sendOtp(BuildContext context) async {
    print('Send OTP');
    if ((loginState.registerMethod == 0 && loginState.mobileNo != loginState.profileData.mobileNo1) ||
        (loginState.registerMethod == 1 && loginState.email != loginState.profileData.email)) {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Details did not match'),
            content: Text('Entered Mobile No / Email Id does not match with I-Card Mobile No / Email Id !!! '),
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
    startOverlay();
    try {
      Response res = await api.sendOTP(loginState.mhtId, loginState.email, loginState.mobileNo);
      AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
      if (appResponse.status == WSConstant.SUCCESS_CODE) {
        print('***** OTP Data ::: ');
        print(appResponse.data);
        otpData = OtpData.fromJson(appResponse.data);
        stopOverlay();
        return true;
      }
    } catch (e, s) {
      print(e);
      print(s);
      CommonFunction.displayErrorDialog(context: context);
    }
    stopOverlay();
    return false;
  }

  bool _verify(BuildContext context) {
    //if (true) {
    if (loginState.otp == otpData.otp.toString()) {
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
    return false;
  }

  Future<bool> submitMobileChangeReq() async {
    try {
      if(loginState.profileData.mobileNo1 == loginState.newMobile) {
        CommonFunction.alertDialog(context: context, type: 'error', msg: "Your old mobile number and new mobile are same.");
        return false;
      }
      startOverlay();
      Response res = await api.changeMobile(loginState.mhtId, loginState.profileData.mobileNo1, loginState.newMobile);
      AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
      if (appResponse != null && appResponse.status == WSConstant.SUCCESS_CODE) {
        stopOverlay();
        return true;
      }
    } catch (e, s) {
      print(e);
      print(s);
      CommonFunction.displayErrorDialog(context: context);
    }
    stopOverlay();
    return false;
  }

  goToHomePage() async {
    Navigator.pop(context);
    if (await CommonFunction.registerUser(register: otpData.profile, context: context)) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(optionsPage: CommonFunction.appOptionsPage,),
        ),
      );
    }
  }
}
