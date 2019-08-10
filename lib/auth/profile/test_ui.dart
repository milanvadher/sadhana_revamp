import 'package:flutter/material.dart';
import 'package:sadhana/auth/registration/Inputs/text-input.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  List<String> data = ["dfdsdf", "d", "", "", "", "", "", "", "", "", ""];

  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  String value = "KK";
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: ListView(children: List.generate(
            15,
                (index) => getWidget(index),
          ),/*[
            Container(
              child: Column(
                children: List.generate(
                  15,
                  (index) => getWidget(index),
                ),
              ),
            )
          ]*/),
        ),
      ),
    );
  }

  Widget getWidget(int index) {
    print(index);
    return Padding(
      padding: EdgeInsets.all(15),
      child: TextFormField(
        initialValue: value,
        onSaved: (val) => value = val,
      ),
    );
  }
}
