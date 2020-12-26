import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sadhana/auth/registration/family_info_widget.dart';
import 'package:sadhana/auth/registration/personal_info_widget.dart';
import 'package:sadhana/auth/registration/professional_info_widget.dart';
import 'package:sadhana/auth/registration/seav_info_widget.dart';
import 'package:sadhana/common.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/model/register.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/app_response_parser.dart';
import 'package:sadhana/utils/appsharedpref.dart';
import 'package:sadhana/widgets/base_state.dart';
import 'package:sadhana/wsmodel/appresponse.dart';

enum UpdateProfilePageType { BASIC, Family, Professional, Seva }

class ProfileUpdatePage extends StatefulWidget {
  final UpdateProfilePageType pageType;
  final Register mbaProfile;
  final Function onProfileEdit;
  final Function onCancel;

  const ProfileUpdatePage({Key key, this.pageType, this.mbaProfile, this.onProfileEdit, this.onCancel}) : super(key: key);

  @override
  _ProfileUpdatePageState createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends BaseState<ProfileUpdatePage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ApiService api = new ApiService();

  @override
  Widget pageToDisplay() {
    return WillPopScope(
      onWillPop: () async {
        if (widget.onCancel != null) widget.onCancel();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: Text(getTitle())),
        body: Padding(
          padding: EdgeInsets.only(top: 20),
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Column(
                  children: <Widget>[
                    Form(
                      key: formKey,
                      autovalidate: false,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: getPage(),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: onUpdateClick,
                          child: Text('Update'),
                        ),
                        OutlineButton(
                          onPressed: () {
                            if (widget.onCancel != null) widget.onCancel();
                            Navigator.pop(context);
                          },
                          child: Text('Cancel'),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void onUpdateClick() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      await updateMBAProfile();
    } else {
      CommonFunction.alertDialog(
        context: context,
        msg: "Please fill details for required fields",
        title: '',
        type: 'error',
      );
    }
  }

  Future<void> updateMBAProfile() async {
    startOverlay();
    try {
      print(widget.mbaProfile.toJson());
      if(widget.pageType == UpdateProfilePageType.BASIC) {
        if(widget.mbaProfile.sameAsPermanentAddress)
          widget.mbaProfile.currentAddress = widget.mbaProfile.permanentAddress;
      }
      Response res = await api.updateMBAProfile(widget.mbaProfile);
      AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
      if (appResponse.status == WSConstant.SUCCESS_CODE) {
        await AppSharedPrefUtil.saveMBAProfile(widget.mbaProfile);
        CommonFunction.alertDialog(
            context: context,
            msg: "Your Profile Updated successfully.",
            type: 'success',
            doneButtonFn: () {
              Navigator.pop(context);
              Navigator.pop(context);
              if (widget.onProfileEdit != null) widget.onProfileEdit();
            });
      }
    } catch (e, s) {
      print(e);
      print(s);
      CommonFunction.displayErrorDialog(context: context);
    }
    stopOverlay();
  }

  getPage() {
    switch (widget.pageType) {
      case UpdateProfilePageType.BASIC:
        return PersonalInfoWidget(
          register: widget.mbaProfile,
          startLoading: () {},
          stopLoading: () {},
          profileEdit: true,
        );
      case UpdateProfilePageType.Family:
        return FamilyInfoWidget(
          register: widget.mbaProfile,
          startLoading: startLoading,
          stopLoading: stopLoading,
          profileEdit: true,
        );
      case UpdateProfilePageType.Professional:
        return ProfessionalInfoWidget(
          register: widget.mbaProfile,
          startLoading: () {},
          stopLoading: () {},
        );
      case UpdateProfilePageType.Seva:
        return SevaInfoWidget(
          register: widget.mbaProfile,
          startLoading: startOverlay,
          stopLoading: stopOverlay,
        );
    }
  }

  getTitle() {
    switch (widget.pageType) {
      case UpdateProfilePageType.BASIC:
        return 'Basic';
      case UpdateProfilePageType.Family:
        return 'Family';
      case UpdateProfilePageType.Professional:
        return 'Professional';
      case UpdateProfilePageType.Seva:
        return 'Seva';
    }
  }
}
