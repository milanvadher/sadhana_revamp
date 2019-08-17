import 'package:flutter/material.dart';
import 'package:sadhana/model/profile.dart';

class MobileChangeRequestSuccessWidget extends StatelessWidget {
  final Profile profileData;

  const MobileChangeRequestSuccessWidget({Key key, this.profileData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: CircleAvatar(
            child: Icon(
              Icons.done,
              size: 80,
              color: Colors.white,
            ),
            minRadius: 50,
            backgroundColor: Colors.green,
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Text(
            'Your Request is successfully sent.',
            style: TextStyle(fontSize: 30),
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Text(
            'You Will be notified within 24hr',
            style: TextStyle(fontSize: 15, color: Colors.green),
          ),
        ),
      ],
    );
  }
}
