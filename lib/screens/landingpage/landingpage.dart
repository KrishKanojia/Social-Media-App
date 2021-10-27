import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/screens/homepage/homepage.dart';
import 'package:social_media_app/screens/landingpage/landinghelpers.dart';
import 'package:social_media_app/services/authentication.dart';

import '../../constraints.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

late LandingHelpers _landingHelpers;

class _LandingPageState extends State<LandingPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    ConstantColors constantColors = ConstantColors();

    _landingHelpers = Provider.of<LandingHelpers>(context, listen: false);
    return Container(
      // color: kContentColorLightTheme,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            constantColors.darkColor,
            constantColors.blueGreyColor,
          ],
          // begin: Alignment.topCenter,
          // end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Spacer(
                flex: 2,
              ),
              Image.asset(
                "assets/welcome_image.png",
              ),
              Spacer(),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "Welcome to our ",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                  children: [
                    TextSpan(
                      text: "Virtual",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: constantColors.blueColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0,
                      ),
                    ),
                    TextSpan(
                      text: "Life\nSocial Media App",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _landingHelpers.emailBtn(
                    color: Colors.yellow,
                    icon: EvaIcons.emailOutline,
                    context: context,
                  ),
                  _landingHelpers.googleBtn(
                      color: Colors.red,
                      icon: EvaIcons.google,
                      context: context),
                  _landingHelpers.googleBtn(
                      color: Colors.blue,
                      icon: FontAwesomeIcons.facebookF,
                      context: context),
                ],
              ),
              Spacer(
                flex: 2,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text:
                      "By continuing you agree VirtualLife's Terms of\nServices and Privarcy Policy",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
