import 'package:flutter/material.dart';
import 'package:sadhana/setup/themes.dart';

class AppOptions {
  AppOptions({this.theme, this.platform});

  final AppTheme theme;
  final TargetPlatform platform;

  AppOptions copyWith({AppTheme theme}) {
    return AppOptions(theme: theme ?? this.theme, platform: platform);
  }

  @override
  String toString() {
    return '$theme';
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        text,
        style: TextStyle(color: theme.accentColor),
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  const _ActionItem(this.icon, this.iconColor, this.text, this.onTap);

  final IconData icon;
  final Color iconColor;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0),
      child: ListTile(
        leading: Icon(
          icon,
          color: iconColor,
        ),
        title: Text(text),
        trailing: Icon(Icons.arrow_right),
      ),
      onPressed: onTap,
    );
  }
}

class _ThemeItem extends StatelessWidget {
  const _ThemeItem(this.options, this.onOptionsChanged);

  final AppOptions options;
  final ValueChanged<AppOptions> onOptionsChanged;

  @override
  Widget build(BuildContext context) {
    return _BooleanItem(
      Icons.brightness_6,
      Colors.grey,
      'Dark Theme',
      options.theme == kDarkAppTheme,
      (bool value) {
        onOptionsChanged(
          options.copyWith(
            theme: value ? kDarkAppTheme : kLightAppTheme,
          ),
        );
      },
      switchKey: const Key('dark_theme'),
    );
  }
}

class _BooleanItem extends StatelessWidget {
  const _BooleanItem(
      this.icon, this.iconColor, this.title, this.value, this.onChanged,
      {this.switchKey});

  final IconData icon;
  final Color iconColor;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  // [switchKey] is used for accessing the switch from driver tests.
  final Key switchKey;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      leading: Icon(
        icon,
        color: iconColor,
      ),
      title: Text(title),
      trailing: Switch(
        key: switchKey,
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF39CEFD),
        activeTrackColor: isDark ? Colors.white30 : Colors.black26,
      ),
    );
  }
}

class AppOptionsPage extends StatelessWidget {
  const AppOptionsPage({
    Key key,
    this.options,
    this.onOptionsChanged,
  }) : super(key: key);

  final AppOptions options;
  final ValueChanged<AppOptions> onOptionsChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Options'),
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            _Heading('Settings'),
            Card(
              elevation: 3.0,
              child: Column(
                children: <Widget>[
                  _ActionItem(Icons.person, Colors.red, 'Profile', () {}),
                  _ThemeItem(options, onOptionsChanged),
                  _ActionItem(Icons.sync, Colors.blue, 'Sync Data', () {}),
                ],
              ),
            ),
          ]..addAll(<Widget>[
              _Heading('Sadhana App'),
              Card(
                elevation: 3.0,
                child: Column(
                  children: <Widget>[
                    _ActionItem(
                        Icons.info, Colors.indigo, 'About Sadhana App', () {}),
                  ],
                ),
              ),
            ]),
        ),
      ),
    );
  }
}
