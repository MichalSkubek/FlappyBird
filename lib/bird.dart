import 'package:flutter/material.dart';

class MyBird extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'lib/images/flappyBird.png',
      width: 60,
      height: 60,
    );
  }
}
