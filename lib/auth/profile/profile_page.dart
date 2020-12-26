import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sadhana/auth/profile/profile_update_page.dart';
import 'package:sadhana/auth/profile/seva_profile_page.dart';
import 'package:sadhana/auth/registration/family_info_widget.dart';
import 'package:sadhana/auth/registration/personal_info_widget.dart';
import 'package:sadhana/auth/registration/professional_info_widget.dart';
import 'package:sadhana/common.dart';
import 'package:sadhana/constant/wsconstants.dart';
import 'package:sadhana/model/register.dart';
import 'package:sadhana/service/apiservice.dart';
import 'package:sadhana/utils/app_response_parser.dart';
import 'package:sadhana/utils/appsharedpref.dart';
import 'package:sadhana/utils/apputils.dart';
import 'package:sadhana/widgets/base_state.dart';
import 'package:sadhana/widgets/scrollable_tabs.dart';
import 'package:sadhana/wsmodel/appresponse.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends BaseState<ProfilePage> {
  Register mbaProfile;
  List<TabPage> pages = [];
  ApiService api = ApiService();
  ScrollableTabsDemo scrollableTabsPage;

  @override
  void initState() {
    super.initState();
    loadData();
    _refreshFromServer(byUser: false);
  }

  loadData() async {
    AppSharedPrefUtil.getMBAProfile().then((reg) {
      setState(() {
        this.mbaProfile = reg;
      });
    });
  }

  @override
  Widget pageToDisplay() {
    return scrollableTabsPage = ScrollableTabsDemo(
      title: "Profile",
      actions: _buildActions(),
      pages: [
        TabPage(
          text: 'Basic',
          content: buildContent(
            PersonalInfoWidget(
              register: mbaProfile,
              startLoading: startLoading,
              stopLoading: stopLoading,
              viewMode: true,
            ),
          ),
        ),
        TabPage(
          text: 'Family',
          content: buildContent(
            FamilyInfoWidget(
              register: mbaProfile,
              startLoading: startLoading,
              stopLoading: stopLoading,
              viewMode: true,
            ),
          ),
        ),
        TabPage(
          text: 'Professional',
          content: buildContent(
            ProfessionalInfoWidget(
              register: mbaProfile,
              startLoading: startOverlay,
              stopLoading: stopOverlay,
              viewMode: true,
            ),
          ),
        ),
        TabPage(
          text: 'Seva',
          content: buildContent(
            SevaProfilePage(
              register: mbaProfile,
            ),
          ),
        )
      ],
    );
  }

  Widget buildContent(Widget content) {
    return ListView(
      padding: EdgeInsets.all(10),
      children: <Widget>[
        mbaProfile != null
            ? Card(
                elevation: 15,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: content,
                ),
              )
            : Container(),
      ],
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.edit),
        onPressed: _onEditClick,
        tooltip: 'Edit Profile',
      ),
      IconButton(
        icon: Icon(Icons.refresh),
        onPressed: _refreshFromServer,
        tooltip: 'Refresh',
      ),
      /*IconButton(
        icon: Icon(Icons.power_settings_new),
        onPressed: _onRefresh,
        tooltip: 'logout',
      )*/
    ];
  }

  _onEditClick() async {
    if (await AppUtils.isInternetConnected()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileUpdatePage(
                mbaProfile: mbaProfile,
                pageType: getUpdateProfilePageType(),
                onProfileEdit: _onProfileEdit,
                onCancel: _onProfileEdit,
              ),
        ),
      );
    } else {
      CommonFunction.displayInternetNotAvailableDialog(context: context);
    }
  }

  getUpdateProfilePageType() {
    switch(scrollableTabsPage.index()) {
      case 0:
        return UpdateProfilePageType.BASIC;
      case 1:
        return UpdateProfilePageType.Family;
      case 2:
        return UpdateProfilePageType.Professional;
      case 3:
        return UpdateProfilePageType.Seva;
    }
  }

  _onProfileEdit() {
    loadData();
  }

  void _refreshFromServer({bool byUser = true}) async {
    if (await AppUtils.isInternetConnected()) {
      if(byUser)
        startOverlay();
      try {
        Response res = await api.getMBAProfile();
        AppResponse appResponse = AppResponseParser.parseResponse(res, context: context);
        if (appResponse.status == WSConstant.SUCCESS_CODE) {
          OtpData otpData = OtpData.fromJson(appResponse.data);
          if (otpData != null && otpData.profile != null && otpData.profile.firstName != null) {
            mbaProfile = otpData.profile;
            await AppSharedPrefUtil.saveMBAProfile(mbaProfile);
            if(byUser)
              CommonFunction.alertDialog(context: context, msg: "Your Profile reloaded successfully.", type: 'success');
            loadData();
          }
        }
      } catch (e, s) {
        print(s);
      }
      stopOverlay();
    } else {
      if(byUser)
        CommonFunction.displayInternetNotAvailableDialog(context: context);
    }
  }
}

class _Page {
  const _Page({this.icon, this.text, this.content});

  final IconData icon;
  final String text;
  final Widget content;
}

Widget buildProfileRow(
    {@required String title, @required String value, @required BuildContext context, double viewModeTitleWidth}) {
  double screenWidth = MediaQuery.of(context).size.width;
  return Container(
    padding: EdgeInsets.symmetric(vertical: 5),
    alignment: Alignment.bottomLeft,
    child: CommonFunction.getTitleAndNameForProfilePage(
        screenWidth: screenWidth, title: title, value: value, titleWidth: viewModeTitleWidth),
  );
}
