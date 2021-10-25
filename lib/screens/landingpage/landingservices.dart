import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/constraints.dart';
import 'package:social_media_app/screens/homepage/homepage.dart';
import 'package:social_media_app/services/authentication.dart';

class LandingServices extends ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  Widget passwordlessSignIn(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("allusers").snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView(
                children: snapshot.data!.docs
                    .map((DocumentSnapshot documentSnapshot) {
                  Map<String, dynamic> data =
                      documentSnapshot.data() as Map<String, dynamic>;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        data["userimage"],
                      ),
                    ),
                    title: Text(
                      data["username"],
                      style: TextStyle(
                          color: constantColors.greenColor,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      data["useremail"],
                      style: TextStyle(
                          color: constantColors.whiteColor, fontSize: 12),
                    ),
                    trailing: Icon(
                      FontAwesomeIcons.trashAlt,
                      color: constantColors.redColor,
                    ),
                  );
                }).toList(),
              );
            }
          }),
    );
  }

  signUpSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.55,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: constantColors.blueColor,
                    radius: 80.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: userNameController,
                      decoration: InputDecoration(
                        hintText: "Enter Name",
                        hintStyle: TextStyle(
                          fontSize: 16.0,
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 18.0,
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: userEmailController,
                      decoration: InputDecoration(
                        hintText: "Enter Email",
                        hintStyle: TextStyle(
                          fontSize: 16.0,
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 18.0,
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: userPasswordController,
                      decoration: InputDecoration(
                        hintText: "Enter Password",
                        hintStyle: TextStyle(
                          fontSize: 16.0,
                          color: constantColors.whiteColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 18.0,
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Spacer(),
                  FloatingActionButton(
                    backgroundColor: constantColors.blueColor,
                    child: Icon(FontAwesomeIcons.check,
                        color: constantColors.whiteColor),
                    onPressed: () {
                      if (userEmailController.text.isNotEmpty &&
                          userNameController.text.isNotEmpty &&
                          userPasswordController.text.isNotEmpty) {
                        Provider.of<Authentication>(context, listen: false)
                            .registerAccount(
                                email: userEmailController.text,
                                password: userPasswordController.text)
                            .whenComplete(() => Navigator.of(context)
                                .pushReplacement(PageTransition(
                                    child: Homepage(),
                                    type: PageTransitionType.bottomToTop)));
                      } else {
                        warningText(context, "Fill All Fields!");
                      }
                    },
                  ),
                  Spacer(),
                ],
              ),
            ),
          );
        });
  }

  signInSheet(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: userEmailController,
                    decoration: InputDecoration(
                      hintText: "Enter Email",
                      hintStyle: TextStyle(
                        fontSize: 16.0,
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 18.0,
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: userPasswordController,
                    decoration: InputDecoration(
                      hintText: "Enter Password",
                      hintStyle: TextStyle(
                        fontSize: 16.0,
                        color: constantColors.whiteColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 18.0,
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Spacer(),
                FloatingActionButton(
                  backgroundColor: constantColors.redColor,
                  child: Icon(FontAwesomeIcons.check,
                      color: constantColors.whiteColor),
                  onPressed: () {
                    if (userEmailController.text.isNotEmpty &&
                        userPasswordController.text.isNotEmpty) {
                      Provider.of<Authentication>(context, listen: false)
                          .signIntoAccount(
                              email: userEmailController.text,
                              password: userPasswordController.text)
                          .whenComplete(() => Navigator.of(context)
                              .pushReplacement(PageTransition(
                                  child: Homepage(),
                                  type: PageTransitionType.bottomToTop)));
                    } else {
                      warningText(context, "Fill All Fields!");
                    }
                  },
                ),
                Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }

  warningText(BuildContext context, String warning) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                warning,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins'),
              ),
            ),
          );
        });
  }
}
