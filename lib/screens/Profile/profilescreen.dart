import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/constraints.dart';
import 'package:social_media_app/screens/Profile/profilehelpers.dart';
import 'package:social_media_app/screens/landingpage/landingpage.dart';
import 'package:social_media_app/services/authentication.dart';

class ProfileScreen extends StatelessWidget {
  ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark, // st
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: RichText(
          text: TextSpan(
            text: 'My ',
            style: TextStyle(
              fontFamily: "Poppins",
              color: constantColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
            children: [
              TextSpan(
                text: 'Profile',
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: constantColors.blueColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
        ),
        leading: IconButton(
          icon: Icon(
            EvaIcons.settings2,
            color: constantColors.blueColor,
          ),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(
              EvaIcons.logOutOutline,
              color: constantColors.greenColor,
            ),
            onPressed: () {
              Provider.of<ProfileHelpers>(context, listen: false)
                  .LogOutDialog(context);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor.withOpacity(0.6),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("allusers")
                    .doc(Provider.of<Authentication>(context, listen: false)
                        .getUserId)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Column(children: [
                      Provider.of<ProfileHelpers>(context, listen: false)
                          .ProfileHeader(context, snapshot.data!),
                      Provider.of<ProfileHelpers>(context, listen: false)
                          .divider(),
                      Provider.of<ProfileHelpers>(context, listen: false)
                          .ProfileMiddle(context, snapshot.data!),
                      Provider.of<ProfileHelpers>(context, listen: false)
                          .ProfileFooter(context, snapshot.data!),
                    ]);
                  }
                }),
          ),
        ),
      ),
    );
  }
}
