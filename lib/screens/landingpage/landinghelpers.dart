import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/constraints.dart';
import 'package:social_media_app/screens/homepage/homepage.dart';
import 'package:social_media_app/screens/landingpage/landingservices.dart';
import 'package:social_media_app/screens/landingpage/landingutils.dart';
import 'package:social_media_app/services/authentication.dart';

class LandingHelpers extends ChangeNotifier {
  Widget googleBtn({
    required Color color,
    required IconData icon,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        Provider.of<Authentication>(context, listen: false)
            .signinWithGoogle()
            .whenComplete(() {
          Navigator.pushReplacement(
              context,
              PageTransition(
                  child: Homepage(), type: PageTransitionType.leftToRight));
        });
      },
      child: Container(
        decoration: BoxDecoration(
            // color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color)),
        width: 80,
        height: 40,
        child: Icon(
          icon,
          color: color,
        ),
      ),
    );
  }

  Widget emailBtn({
    required Color color,
    required IconData icon,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        emailAuthSheet(context: context);
      },
      child: Container(
        decoration: BoxDecoration(
            // color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color)),
        width: 80,
        height: 40,
        child: Icon(
          icon,
          color: color,
        ),
      ),
    );
  }

  emailAuthSheet({required BuildContext context}) {
    ConstantColors constantColors = ConstantColors();
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.blueGreyColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: Form(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Provider.of<LandingServices>(context, listen: false)
                    .passwordlessSignIn(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      color: constantColors.redColor,
                      child: Text(
                        "Log In",
                        style: TextStyle(
                          fontSize: 18,
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Provider.of<LandingServices>(context, listen: false)
                            .loginSheet(context);
                      },
                    ),
                    MaterialButton(
                      color: constantColors.blueColor,
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 18,
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Provider.of<LandingUtils>(context, listen: false)
                            .showImageOption(context);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
