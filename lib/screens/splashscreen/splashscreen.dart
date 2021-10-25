import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:social_media_app/screens/landingpage/landingpage.dart';

import '../../constraints.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  ConstantColors constantColors = ConstantColors();
  @override
  void initState() {
    Timer(
        Duration(seconds: 1),
        () => Navigator.pushReplacement(
              context,
              PageTransition(
                  child: LandingPage(), type: PageTransitionType.leftToRight),
            ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kContentColorLightTheme,
      body: Center(
        child: RichText(
          text: TextSpan(
              text: "Virtual",
              style: TextStyle(
                fontFamily: "Poppins",
                color: constantColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              ),
              children: [
                TextSpan(
                  text: "Life",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: constantColors.blueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 34.0,
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
