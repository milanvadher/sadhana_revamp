import 'package:flutter/material.dart';
import 'package:sadhana/commonvalidation.dart';
import 'package:sadhana/model/user.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  const LoginPage({
    Key key,
    this.optionsPage,
  }) : super(key: key);

  final Widget optionsPage;

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  List<User> testUsers = [
    User(
      firstName: "Raouf",
      lastName: "Rahiche",
      center: "Adalaj",
      mhtId: 123456,
      id: 0
    ),
    User(
      firstName: "Zaki",
      lastName: "oun",
      center: "SimCity",
      mhtId: 654321,
      id: 1
    ),
    User(
      firstName: "oussama",
      lastName: "ali",
      center: "Pakistan",
      mhtId: 111222,
      id: 2
    ),
  ];

  _login() async {
//    var user = await DBProvider.db.getUser(123456);
//    print(user.toMap());
//    if (_formKey.currentState.validate()) {
//      _formKey.currentState.save();
//      print('Login');
////      Navigator.pop(context);
////      Navigator.pushReplacementNamed(
////        context,
////        HomePage.routeName,
////      );
//    } else {
//      setState(() {
//        _autoValidate = true;
//      });
//    }
  }

  @override
  Widget build(BuildContext context) {
    Widget loginForm = Form(
      key: _formKey,
      autovalidate: _autoValidate,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Image
          Container(
            padding: const EdgeInsets.all(30.0),
            child: Image.asset(
              'images/logo_dada.png',
              height: 140,
            ),
          ),
          // MHT ID
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            alignment: Alignment.bottomLeft,
            child: TextFormField(
              validator: CommonValidation.mhtIdValidation,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Mht ID',
              ),
              maxLines: 1,
            ),
          ),
          // Password
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            alignment: Alignment.bottomLeft,
            child: TextFormField(
              validator: CommonValidation.passwordValidation,
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
              maxLines: 1,
            ),
          ),
          // Submit
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            alignment: Alignment.centerRight,
            child: RaisedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          )
        ],
      ),
    );

    Widget bottomPart = Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 25),
          child: OutlineButton(
            onPressed: () {},
            child: Text('Forgot Password ?'),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Text('Don\'t have an account?'),
        ),
        Container(
          // padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: OutlineButton(
            onPressed: () {},
            child: Text('Signup'),
          ),
        )
      ],
    );

    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        title: Text('Login'),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          children: <Widget>[loginForm, bottomPart],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
//          User rnd = testUsers[math.Random().nextInt(testUsers.length)];
//          await DBProvider.db.newUser(rnd);
//          setState(() {});
        },
      ),
    );
  }
}
