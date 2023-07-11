import 'package:flutter/material.dart';
import '../../constants/constants.dart';

class FilledCard extends StatelessWidget {

  final double height;

  const FilledCard({super.key, this.height = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/money_back.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      width: double.infinity,
      height: height,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: w * 0.1, vertical: 0),
        child: Image.asset('assets/images/piggy_logo.png'),
      ),
    );
  }
}
