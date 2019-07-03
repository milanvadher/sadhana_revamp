import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:sadhana/auth/registration/family_info_widget.dart';
import 'package:sadhana/auth/registration/personal_info_widget.dart';
import 'package:sadhana/auth/registration/professional_info_widget.dart';
import 'package:sadhana/auth/registration/registration_step.dart';
import 'package:sadhana/auth/registration/seav_info_widget.dart';
import 'package:sadhana/comman.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/model/register.dart';
import 'package:sadhana/sadhana/home.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/app_response_parser.dart';
import 'package:sadhana/widgets/base_state.dart';
import 'package:sadhana/wsmodel/appresponse.dart';

class RegistrationPage extends StatefulWidget {
  static const String routeName = '/registration';
  final Register registrationData;

  RegistrationPage({@required this.registrationData});

  @override
  RegistrationPageState createState() => RegistrationPageState();
}

class RegistrationPageState extends BaseState<RegistrationPage> {
  Register _register = new Register();
  ApiService api = new ApiService();
  int currentStep = 0;
  var dateFormatter = new DateFormat(WSConstant.DATE_FORMAT);
  List<Step> steps = [];
  bool _autoValidate = false;
  List<AppStep> registrationSteps;
  final String personalStepID = "Personal Info";
  ScrollController _scrollController = new ScrollController();

  @override
  initState() {
    super.initState();
    _register = widget.registrationData;
    registrationSteps = [
      AppStep(
        title: "Personal Information",
        id: personalStepID,
        builder: PersonalInfoWidget(
          register: _register,
          startLoading: startOverlay,
          stopLoading: stopOverlay,
        ),
      ),
      AppStep(
        title: "Family Information",
        builder: FamilyInfoWidget(
          register: _register,
          startLoading: startOverlay,
          stopLoading: stopOverlay,
        ),
      ),
      AppStep(
        title: "Professional Information",
        builder: ProfessionalInfoWidget(
          register: _register,
          startLoading: startOverlay,
          stopLoading: stopOverlay,
        ),
      ),
      AppStep(
        title: "Seva Information",
        builder: SevaInfoWidget(
          register: _register,
          startLoading: startOverlay,
          stopLoading: stopOverlay,
        ),
      ),
      
    ];
    steps = getSteps(registrationSteps);
  }

  @override
  Widget pageToDisplay() {
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Registration'),
        ),
        body: SafeArea(
          child: ListView(
            controller: _scrollController,
            children: <Widget>[
              Stepper(
                physics: ClampingScrollPhysics(),
                controlsBuilder: buildController,
                currentStep: currentStep,
                onStepContinue: onStepContinue,
                onStepCancel: () {
                  currentStep--;
                  setState(() {
                    scrollToTop();
                  });
                },
                steps: steps,
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Step> getSteps(List<AppStep> registrationSteps) {
    return registrationSteps.map((regStep) {
      return Step(
        title: Text(regStep.title),
        content: Form(
          key: regStep.formKey,
          autovalidate: _autoValidate,
          child: regStep.builder,
        ),
        isActive: true,
        //subtitle: Text('Personal Information'),
      );
    }).toList(growable: true);
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
            child:
                Text(currentStep != steps.length - 1 ? 'CONTINUE' : 'Register'),
          ),
          SizedBox(
            width: 10,
          ),
          currentStep != 0
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
      GlobalKey<FormState> formKey = registrationSteps[currentStep].formKey;
      if (!formKey.currentState.validate()) {
        CommonFunction.alertDialog(context: context, msg: "Please fill details for required fields", title: '', type: 'error',);
        return;
      }
      formKey.currentState.save();
      FocusScope.of(context).requestFocus(new FocusNode());
      if (registrationSteps[currentStep].id == personalStepID) {
        if (_register.sameAsPermanentAddress)
          _register.currentAddress = _register.permanentAddress;
      }
      if (currentStep < steps.length - 1) {
        currentStep++;
      } else {
        register();
      }
      scrollToTop();
    });
  }

  void scrollToTop() {
    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  void register() async {
    startOverlay();
    try {
      print(_register.toJson());
      _register.registered = 1;
      Response res = await api.generateToken(_register.mhtId);
      AppResponse appResponse =
          AppResponseParser.parseResponse(res, context: context);
      if (appResponse.status == WSConstant.SUCCESS_CODE) {
        if (appResponse.data != null &&
            appResponse.data.toString().isNotEmpty) {
          _register.token = appResponse.data;
          res = await api.register(_register);
          appResponse = AppResponseParser.parseResponse(res, context: context);
          if (appResponse.status == WSConstant.SUCCESS_CODE) {
            await CommonFunction.registerUser(
                register: _register, context: context, generateToken: false);
            Navigator.pushReplacementNamed(context, HomePage.routeName);
          }
        }
      }
    } catch (e, s) {
      print(e);
      print(s);
      CommonFunction.displayErrorDialog(context: context);
    }
    stopOverlay();
  }
}
