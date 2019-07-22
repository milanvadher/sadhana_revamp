import 'package:flutter/material.dart';

class ActionItem extends StatelessWidget {
  const ActionItem(this.icon, this.iconColor, this.text, this.onTap, this.subtitle);
  final IconData icon;
  final List<Color> iconColor;
  final String text;
  final VoidCallback onTap;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    Brightness theme = Theme.of(context).brightness;
    return Column(
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(
            child: Icon(
              icon,
              color: theme == Brightness.light ? iconColor[0] : iconColor[1],
            ),
            backgroundColor: theme == Brightness.light ? iconColor[0].withAlpha(20) : iconColor[1].withAlpha(20),
          ),
          title: Text(text),
          subtitle: Text(subtitle),
          trailing: Icon(Icons.chevron_right),
          onTap: onTap,
        ),
        Divider(height: 0),
      ],
    );
  }
}