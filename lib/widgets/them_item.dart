import 'package:flutter/material.dart';
import 'package:sadhana/setup/options.dart';
import 'package:sadhana/setup/themes.dart';
import 'package:sadhana/widgets/boolean_item.dart';

class ThemeItem extends StatelessWidget {
  const ThemeItem(this.options, this.onOptionsChanged);

  final AppOptions options;
  final ValueChanged<AppOptions> onOptionsChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        BooleanItem(
          options.theme == kDarkAppTheme ? Icons.brightness_high : Icons.brightness_low,
          Colors.grey,
          'Dark Theme',
          options.theme == kDarkAppTheme,
          onThemeChanged,
          switchKey: const Key('dark_theme'),
        ),
        Divider(height: 0),
      ],
    );
  }

  onThemeChanged(bool value) {
    onOptionsChanged(options.copyWith(theme: value ? kDarkAppTheme : kLightAppTheme));
  }
}
