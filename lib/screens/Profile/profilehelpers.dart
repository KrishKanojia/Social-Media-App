import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/constraints.dart';
import 'package:social_media_app/screens/landingpage/landingpage.dart';
import 'package:social_media_app/services/authentication.dart';

class ProfileHelpers extends ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  Widget ProfileHeader(
      BuildContext context, DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.25,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            // color: Colors.green,
            width: 180,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 60.0,
                    backgroundImage: NetworkImage(
                      data["userimage"],
                    ),
                  ),
                ),
                Text(
                  data["username"],
                  style: TextStyle(
                      fontSize: 16,
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      EvaIcons.email,
                      color: constantColors.greenColor,
                    ),
                    Text(
                      data["useremail"],
                      style: TextStyle(
                          fontSize: 12,
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            // color: Colors.blue,
            width: 180,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: constantColors.darkColor,
                          borderRadius: BorderRadius.circular(15)),
                      height: 70,
                      width: 80,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "0",
                            style: TextStyle(
                                fontSize: 28,
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Followers",
                            style: TextStyle(
                                fontSize: 12,
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 70,
                      width: 80,
                      decoration: BoxDecoration(
                          color: constantColors.darkColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "0",
                            style: TextStyle(
                                fontSize: 28,
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Following",
                            style: TextStyle(
                                fontSize: 12,
                                color: constantColors.whiteColor,
                                fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 70,
                  width: 80,
                  decoration: BoxDecoration(
                      color: constantColors.darkColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "0",
                        style: TextStyle(
                            fontSize: 28,
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Post",
                        style: TextStyle(
                            fontSize: 12,
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget divider() {
    return Center(
      child: SizedBox(
        height: 25,
        width: 350,
        child: Divider(
          color: constantColors.whiteColor,
        ),
      ),
    );
  }

  Widget ProfileMiddle(BuildContext context, dynamic snapshot) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              // color: Colors.pink,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  FontAwesomeIcons.userAstronaut,
                  color: constantColors.yellowColor,
                  size: 16,
                ),
                Text(
                  "Recently Added",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: constantColors.whiteColor,
                  ),
                )
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.darkColor.withOpacity(0.4),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ],
      ),
    );
  }

  Widget ProfileFooter(BuildContext context, dynamic snapshot) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          height: MediaQuery.of(context).size.height * 0.53,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: constantColors.darkColor.withOpacity(
              0.4,
            ),
          ),
          child: Image.asset("assets/welcome_image.png")),
    );
  }

  LogOutDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: constantColors.darkColor,
            title: Text(
              "Log Out VirtualLife?",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: constantColors.whiteColor,
              ),
            ),
            actions: [
              MaterialButton(
                child: Text(
                  "No",
                  style: TextStyle(
                    fontSize: 18,
                    color: constantColors.whiteColor,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                    decorationColor: constantColors.whiteColor,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              MaterialButton(
                child: Text(
                  "Yes",
                  style: TextStyle(
                    fontSize: 18,
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Provider.of<Authentication>(context, listen: false)
                      .LogOutViaEmail();
                  Navigator.of(context).pushReplacement(
                    PageTransition(
                      child: LandingPage(),
                      type: PageTransitionType.bottomToTop,
                    ),
                  );
                },
              ),
            ],
          );
        });
  }
}
