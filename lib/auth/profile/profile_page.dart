import 'package:flutter/material.dart';
import 'package:sadhana/auth/registration/Inputs/text-input.dart';
import 'package:sadhana/auth/registration/family_info_widget.dart';
import 'package:sadhana/auth/registration/personal_info_widget.dart';
import 'package:sadhana/auth/registration/professional_info_widget.dart';
import 'package:sadhana/model/register.dart';
import 'package:sadhana/utils/appsharedpref.dart';
import 'package:sadhana/widgets/base_state.dart';
import 'package:sadhana/widgets/scrollable_tabs.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends BaseState<ProfilePage> {
  Register registrationData;
  List<TabPage> pages = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    AppSharedPrefUtil.getRegisterProfile().then((reg) {
      setState(() {
        this.registrationData = reg;
      });
    });
  }

  @override
  Widget pageToDisplay() {
    return ScrollableTabsDemo(
          title: "Profile",
          actions: _buildActions(),
          pages: [
            TabPage(
              text: 'Basic',
              content: buildContent(
                PersonalInfoWidget(
                  register: registrationData,
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
                  register: registrationData,
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
                  register: registrationData,
                  startLoading: startOverlay,
                  stopLoading: stopOverlay,
                  viewMode: true,
                ),
              ),
            )
          ],
        );
  }

  Widget buildContent(Widget content) {
    return ListView(
      children: <Widget>[
        registrationData != null
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
        onPressed: _onRefresh,
        tooltip: 'Refresh',
      ),
      IconButton(
        icon: Icon(Icons.power_settings_new),
        onPressed: _onRefresh,
        tooltip: 'logout',
      )
    ];
  }

  void _onEditClick() {}

  void _onRefresh() {}
}

class _Page {
  const _Page({this.icon, this.text, this.content});

  final IconData icon;
  final String text;
  final Widget content;
}
