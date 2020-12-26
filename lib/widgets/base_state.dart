import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sadhana/constant/colors.dart';
import 'package:sadhana/widgets/background_gredient.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  bool isLoading = false;
  bool isOverlay = false;
  Brightness theme;
  BuildContext context;
  double mobileWidth;

  void startLoading() {
    setState(() {
      isLoading = true;
    });
  }

  void stopLoading() {
    setState(() {
      isLoading = false;
    });
  }

  void startOverlay() {
    setState(() {
      isOverlay = true;
    });
  }

  void stopOverlay() {
    setState(() {
      isOverlay = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context).brightness;
    this.context = context;
    mobileWidth = MediaQuery.of(context).size.width;
    return new Stack(
        children: <Widget>[
          !isLoading ? pageToDisplay() : buildLoading(),
          isOverlay ? buildLoading() : new Container(),
        ],
      );
  }

  Widget buildLoading() {
    return new Stack(
      children: [
        new Opacity(
          opacity: 0.5,
          child: const ModalBarrier(
            dismissible: false,
            color: kQuizBrown900,
          ),
        ),
        new Center(
          child: SpinKitRing(
            color: kQuizBackgroundWhite,
            size: 60.0,
          ),
        ),
      ],
    );
  }

  Widget pageToDisplay();
}
