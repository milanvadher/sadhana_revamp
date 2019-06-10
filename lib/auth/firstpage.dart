import 'package:flutter/material.dart';
import 'package:sadhana/auth/login/login.dart';

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: new ListView(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        children: <Widget>[
          new SizedBox(height: 50.0),
          new Column(
            children: <Widget>[
              new Image.asset(
                'images/logo_dada.png',
                height: 300,
              ),
            ],
          ),
          new SizedBox(height: 30.0),
          new RaisedButton(
            child: Text('Login', style: TextStyle(color: Colors.white)),
            elevation: 4.0,
            padding: EdgeInsets.all(20.0),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => LoginPage(),
              ));
            },
          ),
          new SizedBox(height: 15.0),
          new RaisedButton(
            child: Text('Without Login', style: TextStyle(color: Colors.white)),
            elevation: 4.0,
            padding: EdgeInsets.all(20.0),
            onPressed: () {
              /*Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => LoginPage(),
              ));*/
            },
          ),
        ],
      ),
    );
  }
}

class BackgroundGredient extends StatelessWidget {
  final Widget child;

  BackgroundGredient({@required this.child}) : assert(child != null);

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.1, 0.9],
          colors: [
            Colors.white,
          ],
        ),
      ),
      child: child,
    );
  }
}
