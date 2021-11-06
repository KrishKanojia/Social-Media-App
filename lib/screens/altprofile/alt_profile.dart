import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/constraints.dart';
import 'package:social_media_app/screens/altprofile/alt_profile_helpers.dart';

class AltProfile extends StatelessWidget {
  late final String useruid;
  AltProfile({required this.useruid});
  ConstantColors constantColors = ConstantColors();
  late double height, width;
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: Provider.of<AltProfileHelpers>(context, listen: false)
          .appBar(context),
      body: SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: constantColors.blueGreyColor.withOpacity(0.6),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
          ),
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("allusers")
                .doc(useruid)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Provider.of<AltProfileHelpers>(context, listen: false)
                        .HeaderProfile(context, snapshot.data!, useruid),
                    Provider.of<AltProfileHelpers>(context, listen: false)
                        .divider(),
                    Provider.of<AltProfileHelpers>(context, listen: false)
                        .ProfileMiddle(context, snapshot.data!),
                    Provider.of<AltProfileHelpers>(context, listen: false)
                        .ProfileFooter(context, snapshot.data!),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
