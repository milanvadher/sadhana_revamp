/*
import 'package:flutter/material.dart';

class DisableEnableRadio extends StatelessWidget {

  Function(int) onValue;
  bool _isEnabled = ture;
  DisableEnableRadio(this.onValue, this._isEnabled);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Disable & Enable RadioButton Example"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: RadioListTile(
                groupValue: _currentIndex,
                title: Text("Radio Text"),
                value: 1,
                onChanged: _isEnabled
                    ? (val) {
                  setState(() {
                    _currentIndex = val;
                  });
                }
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}*/
