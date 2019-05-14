import 'package:flutter/material.dart';
import 'package:sadhana/constant/colors.dart';

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
            kBackgroundGrediant1,
            kBackgroundGrediant2,
          ],
        ),
      ),
      child: child,
    );
  }
}
