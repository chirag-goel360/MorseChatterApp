import 'package:flutter/material.dart';

class Learn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Image.asset('assets/learnMorse.jpg'),
        ),
      ),
    );
  }
}