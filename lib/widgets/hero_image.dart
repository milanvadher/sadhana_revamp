import 'package:flutter/material.dart';
import 'package:sadhana/constant/colors.dart';

class HeroImage extends StatelessWidget {
  Image image;
  double maxRadius;
  Color backgroundColor;
  String heroTag;

  HeroImage({@required this.image, this.maxRadius = 45, this.backgroundColor = kQuizMain50, this.heroTag = "heroimage.png"});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Hero(
        tag: heroTag,
        child: IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: image == null
                ? null
                : () {
                    _onProfileImageClick(context);
                  }),
      ),
    );
  }

  void _onProfileImageClick(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => Scaffold(
            body: Center(
              child: Hero(
                tag: heroTag,
                child: image,
              ),
            ),
            backgroundColor: kQuizMain400,
          ),
    ));
  }
}
