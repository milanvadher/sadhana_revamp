import 'package:flutter/material.dart';
import 'package:sadhana/common.dart';
import 'package:sadhana/model/profile.dart';

class LinkedWidget extends StatelessWidget {
  final Profile profileData;

  const LinkedWidget({Key key, this.profileData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return profileData != null
        ? Column(
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
                  'You are successfully verified\n',
                  style: TextStyle(fontSize: 30),
                  textAlign: TextAlign.center,
                ),
              ),
              Card(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    children: <Widget>[
                      CommonFunction.getTitleAndName(screenWidth: screenWidth, title: 'Mht Id', value: '${profileData.mhtId}'),
                      CommonFunction.getTitleAndName(screenWidth: screenWidth,
                          title: 'Full name', value: '${profileData.firstName} ${profileData.lastName?? ""}'),
                      CommonFunction.getTitleAndName(screenWidth: screenWidth, title: 'Mobile', value: '${profileData.mobileNo1?? ""}'),
                      CommonFunction.getTitleAndName(screenWidth: screenWidth, title: 'Email', value: '${profileData.email?? ""}'),
                    ],
                  ),
                ),
              ),
            ],
          )
        : Container();
  }
}
