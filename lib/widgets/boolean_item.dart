import 'package:flutter/material.dart';

class BooleanItem extends StatelessWidget {
  const BooleanItem(this.icon, this.iconColor, this.title, this.value, this.onChanged, {this.switchKey});

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
      leading: CircleAvatar(
        child: Icon(
          icon,
          color: iconColor,
        ),
        backgroundColor: iconColor.withAlpha(20),
      ),
      title: Text(title),
      subtitle: Text('Customise app theme'),
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
