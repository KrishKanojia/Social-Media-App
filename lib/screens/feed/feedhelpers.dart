import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/constraints.dart';
import 'package:social_media_app/services/authentication.dart';
import 'package:social_media_app/utils/postoptions.dart';
import 'package:social_media_app/utils/uploadpost.dart';

class FeedHelpers extends ChangeNotifier {
  ConstantColors constantColors = ConstantColors();

  appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: RichText(
        text: TextSpan(
          text: 'Virtual',
          style: TextStyle(
            fontFamily: "Poppins",
            color: constantColors.whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
          children: [
            TextSpan(
              text: 'Feed',
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
      actions: [
        IconButton(
          icon: Icon(
            Icons.camera_enhance_outlined,
            color: constantColors.greenColor,
          ),
          onPressed: () {
            Provider.of<UploadPost>(context, listen: false)
                .selectPostImageType(context);
          },
        ),
      ],
    );
  }

  Widget FeedBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: constantColors.darkColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
            ),
          ),
          child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("posts").snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SizedBox(
                      height: 500,
                      width: 400,
                      child: Lottie.asset("assets/animations/loading.json"),
                    ),
                  );
                }

                return loadPost(context, snapshot);
              }),
        ),
      ),
    );
  }

  Widget loadPost(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView(
        children: snapshot.data!.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

      return Container(
        height: MediaQuery.of(context).size.height * 0.65,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(top: 10),
        // color: Colors.pink,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
              child: Row(
                children: [
                  GestureDetector(
                    child: CircleAvatar(
                      radius: 20.0,
                      backgroundColor: constantColors.transperant,
                      backgroundImage: NetworkImage(data["userimage"]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              data["caption"],
                              style: TextStyle(
                                color: constantColors.greenColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
                            child: RichText(
                              text: TextSpan(
                                text: data["username"],
                                style: TextStyle(
                                  color: constantColors.blueColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                      text: " , 12 hours ago",
                                      style: TextStyle(
                                        color: constantColors.lightColor
                                            .withOpacity(0.8),
                                      ))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                // color: Colors.green,
                height: MediaQuery.of(context).size.height * 0.46,
                width: MediaQuery.of(context).size.width,
                child: FittedBox(
                  child: Image.network(
                    data["postimage"],
                    scale: 2.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 20.0),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          child: Icon(
                            FontAwesomeIcons.heart,
                            color: constantColors.redColor,
                            size: 22.0,
                          ),
                          onLongPress: () {
                            Provider.of<PostFunctions>(context, listen: false)
                                .showLikes(context);
                          },
                          onTap: () {
                            print("Adding Like...");
                            Provider.of<PostFunctions>(context, listen: false)
                                .addLike(
                                    context,
                                    data["caption"],
                                    Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUserId);
                          },
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("posts")
                              .doc(data["caption"])
                              .collection("likes")
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              return Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(
                                  snapshot.data!.docs.length.toString(),
                                  style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          child: Icon(
                            FontAwesomeIcons.comment,
                            color: constantColors.blueColor,
                            size: 22.0,
                          ),
                          onTap: () {
                            Provider.of<PostFunctions>(context, listen: false)
                                .showCommentSheet(
                              context,
                              document,
                              data["caption"],
                            );
                          },
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "0",
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          child: Icon(
                            FontAwesomeIcons.award,
                            color: constantColors.yellowColor,
                            size: 22.0,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "0",
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Provider.of<Authentication>(context, listen: false)
                              .getUserId ==
                          data["useruid"]
                      ? IconButton(
                          icon: Icon(
                            EvaIcons.moreVertical,
                            color: constantColors.whiteColor,
                          ),
                          onPressed: () {},
                        )
                      : Container(
                          height: 0,
                          width: 0,
                        ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList());
  }
}
