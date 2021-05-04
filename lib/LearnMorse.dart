import 'package:flutter/material.dart';
import 'package:morse_chatter/config/size.dart';

class Learn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double h = SizeConfig.getHeight(context);
    return Container(
      height: h,
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Center(
          child: Image.asset(
            'assets/learnMorse.jpg',
          ),
        ),
      ),
    );
  }
}
