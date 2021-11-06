import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:social_media_app/constraints.dart';
import 'package:social_media_app/screens/homepage/homepage.dart';

class AltProfileHelpers extends ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  appBar(BuildContext context) {
    return AppBar(
      backgroundColor: constantColors.blueGreyColor.withOpacity(0.4),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_rounded,
          color: constantColors.whiteColor,
        ),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            PageTransition(
                child: Homepage(), type: PageTransitionType.leftToRight),
          );
        },
      ),
      centerTitle: true,
      title: RichText(
        text: TextSpan(
          text: "Virtual",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: constantColors.whiteColor,
            fontSize: 20.0,
          ),
          children: [
            TextSpan(
              text: " Life",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: constantColors.blueColor,
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            EvaIcons.moreVertical,
            color: constantColors.whiteColor,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              PageTransition(
                  child: Homepage(), type: PageTransitionType.leftToRight),
            );
          },
        ),
      ],
    );
  }

  Widget HeaderProfile(
      BuildContext context, DocumentSnapshot docSnasphot, String useruid) {
    Map<String, dynamic> data = docSnasphot.data() as Map<String, dynamic>;
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
}
