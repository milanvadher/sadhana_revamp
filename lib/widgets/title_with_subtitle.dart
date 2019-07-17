import 'package:flutter/material.dart';

class AppTitleWithSubTitle extends StatelessWidget {
  final String title;
  final String subTitle;

  const AppTitleWithSubTitle({Key key, this.title, this.subTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title),
        Visibility(
          visible: true,
          child: Text(
            subTitle,
            style: TextStyle(fontSize: 12.0),
          ),
        ),
      ],
    );
  }
}
