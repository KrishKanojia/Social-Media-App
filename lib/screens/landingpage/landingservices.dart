import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/constraints.dart';
import 'package:social_media_app/screens/homepage/homepage.dart';
import 'package:social_media_app/screens/landingpage/landingutils.dart';
import 'package:social_media_app/services/authentication.dart';
import 'package:social_media_app/services/firebaseoperations.dart';

class LandingServices extends ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();

  showUserImage(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.3,
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
                  Spacer(),
                  CircleAvatar(
                    backgroundColor: constantColors.blueColor,
                    radius: 60.0,
                    backgroundImage: FileImage(
                      Provider.of<LandingUtils>(context, listen: false)
                          .UserImage,
                    ),
                  ),
                  Spacer(),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(
                          child: Text(
                            "Reselect",
                            style: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            Provider.of<LandingUtils>(context, listen: false)
                                .pickUserImage(context, ImageSource.gallery);
                          },
                        ),
                        MaterialButton(
                          color: constantColors.blueColor,
                          child: Text(
                            "Confirm Image",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            Provider.of<FirebaseOperation>(context,
                                    listen: false)
                                .uploadUserImage(context)
                                .whenComplete(() {
                              signUpSheet(context);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          );
        });
  }

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
                      backgroundColor: Colors.transparent,
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
                    trailing: Container(
                      // color: Colors.red,
                      width: 120,
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(
                              FontAwesomeIcons.check,
                              color: constantColors.blueColor,
                            ),
                            onPressed: () {
                              Provider.of<Authentication>(context,
                                      listen: false)
                                  .signIntoAccount(
                                      email: data["useremail"],
                                      password: data["userpassword"])
                                  .whenComplete(() {
                                Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      child: Homepage(),
                                      type: PageTransitionType.leftToRight),
                                );
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              FontAwesomeIcons.trashAlt,
                              color: constantColors.redColor,
                            ),
                            onPressed: () {
                              Provider.of<FirebaseOperation>(context,
                                      listen: false)
                                  .deleteUserData(data["useruid"], 'allusers');
                            },
                          ),
                        ],
                      ),
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
                    CircleAvatar(
                      backgroundImage: FileImage(
                        Provider.of<LandingUtils>(context, listen: false)
                            .UserImage,
                      ),
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
                              .whenComplete(() {
                            print("Creating Collection");
                            Provider.of<FirebaseOperation>(context,
                                    listen: false)
                                .createUserCollection(context, {
                              'userpassword': userPasswordController.text,
                              'useruid': Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserId,
                              'useremail': userEmailController.text,
                              'username': userNameController.text,
                              'userimage': Provider.of<LandingUtils>(context,
                                      listen: false)
                                  .UserImageUrl,
                            });
                          }).whenComplete(() => Navigator.of(context)
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
            ),
          );
        });
  }

  loginSheet(BuildContext context) {
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
