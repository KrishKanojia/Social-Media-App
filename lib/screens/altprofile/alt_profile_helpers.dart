import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/constraints.dart';
import 'package:social_media_app/screens/homepage/homepage.dart';
import 'package:social_media_app/services/authentication.dart';
import 'package:social_media_app/services/firebaseoperations.dart';
import 'package:social_media_app/utils/postoptions.dart';

import 'alt_profile.dart';

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
      BuildContext context, DocumentSnapshot docSnapshot, String useruid) {
    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.33,
      child: Column(
        children: [
          Row(
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
                        GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                                color: constantColors.darkColor,
                                borderRadius: BorderRadius.circular(15)),
                            height: 70,
                            width: 80,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection("allusers")
                                      .doc(data["useruid"])
                                      .collection("followers")
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      return Text(
                                        snapshot.data!.docs.length.toString(),
                                        style: TextStyle(
                                            fontSize: 28,
                                            color: constantColors.whiteColor,
                                            fontWeight: FontWeight.bold),
                                      );
                                    }
                                  },
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
                          onTap: () {
                            checkFollowerSheet(context, docSnapshot);
                          },
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
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection("allusers")
                                    .doc(data["useruid"])
                                    .collection("following")
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else {
                                    return Text(
                                      snapshot.data!.docs.length.toString(),
                                      style: TextStyle(
                                          fontSize: 28,
                                          color: constantColors.whiteColor,
                                          fontWeight: FontWeight.bold),
                                    );
                                  }
                                },
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
          Container(
            height: MediaQuery.of(context).size.height * 0.07,
            width: MediaQuery.of(context).size.width,
            // color: constantColors.redColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  color: constantColors.blueColor,
                  child: Text(
                    "Follow",
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  onPressed: () {
                    Provider.of<FirebaseOperation>(context, listen: false)
                        .followUser(
                      useruid,
                      Provider.of<Authentication>(context, listen: false)
                          .getUserId,
                      {
                        "username": Provider.of<FirebaseOperation>(context,
                                listen: false)
                            .initUserName,
                        "userimage": Provider.of<FirebaseOperation>(context,
                                listen: false)
                            .initUserImage,
                        "useremail": Provider.of<FirebaseOperation>(context,
                                listen: false)
                            .initUserEmail,
                        "useruid":
                            Provider.of<Authentication>(context, listen: false)
                                .getUserId,
                        "timeago": Timestamp.now(),
                      },
                      Provider.of<Authentication>(context, listen: false)
                          .getUserId,
                      useruid,
                      {
                        "username": data["username"],
                        "userimage": data["userimage"],
                        "useremail": data["useremail"],
                        "useruid": data["useruid"],
                        "timeago": Timestamp.now(),
                      },
                    )
                        .whenComplete(() {
                      followedNotification(context, data["username"]);
                    });
                  },
                ),
                MaterialButton(
                  color: constantColors.blueColor,
                  child: Text(
                    "Message",
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  onPressed: () {},
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
    Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: constantColors.darkColor.withOpacity(
            0.4,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("allusers")
              .doc(data["useruid"])
              .collection("posts")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  // mainAxisSpacing: 2,
                  crossAxisCount: 2,
                ),
                children: snapshot.data!.docs
                    .map((DocumentSnapshot documentSnapshot) {
                  Map<String, dynamic> postdata =
                      documentSnapshot.data()! as Map<String, dynamic>;
                  return GestureDetector(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      width: MediaQuery.of(context).size.width,
                      child: FittedBox(
                        child: Image.network(postdata["postimage"]),
                      ),
                    ),
                    onTap: () {
                      showPostDetail(context, documentSnapshot);
                    },
                  );
                }).toList(),
              );
            }
          },
        ),
      ),
    );
  }

  followedNotification(BuildContext context, String name) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.darkColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Text(
                  "Followed $name",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: constantColors.whiteColor,
                  ),
                ),
              ],
            ),
          );
        });
  }

  checkFollowerSheet(BuildContext context, dynamic snapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                )),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("allusers")
                  .doc(snapshot["useruid"])
                  .collection("followers")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView(
                    children: snapshot.data!.docs
                        .map((DocumentSnapshot documentSnapshot) {
                      Map<String, dynamic> data =
                          documentSnapshot.data()! as Map<String, dynamic>;
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListTile(
                          onTap: () {
                            if (data["useruid"] !=
                                Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserId) {
                              Navigator.of(context).pushReplacement(
                                PageTransition(
                                    child: AltProfile(
                                      useruid: data["useruid"],
                                    ),
                                    type: PageTransitionType.topToBottom),
                              );
                            }
                          },
                          leading: CircleAvatar(
                            backgroundColor: constantColors.darkColor,
                            backgroundImage: NetworkImage(data["userimage"]),
                          ),
                          title: Text(
                            data["username"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: constantColors.whiteColor,
                              fontSize: 18.0,
                            ),
                          ),
                          subtitle: Text(
                            data["useremail"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: constantColors.yellowColor,
                              fontSize: 14.0,
                            ),
                          ),
                          trailing: data["useruid"] ==
                                  Provider.of<Authentication>(context,
                                          listen: false)
                                      .getUserId
                              ? Container(
                                  width: 0.0,
                                  height: 0.0,
                                )
                              : MaterialButton(
                                  color: constantColors.blueColor,
                                  child: Text(
                                    "Unfollow",
                                    style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                  onPressed: () {},
                                ),
                        );
                      }
                    }).toList(),
                  );
                }
              },
            ),
          );
        });
  }

  showPostDetail(BuildContext context, DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;

    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.darkColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  child: FittedBox(child: Image.network(data["postimage"])),
                ),
                Text(
                  data["caption"],
                  style: TextStyle(
                    color: constantColors.whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20.0),
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
                                Provider.of<PostFunctions>(context,
                                        listen: false)
                                    .showLikes(context, data["caption"]);
                              },
                              onTap: () {
                                print("Adding Like...");
                                Provider.of<PostFunctions>(context,
                                        listen: false)
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
                                  return Center(
                                      child: CircularProgressIndicator());
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
                                Provider.of<PostFunctions>(context,
                                        listen: false)
                                    .showCommentSheet(
                                  context,
                                  snapshot,
                                  data["caption"],
                                );
                              },
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("posts")
                                  .doc(data["caption"])
                                  .collection("comments")
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
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
                                FontAwesomeIcons.award,
                                color: constantColors.yellowColor,
                                size: 22.0,
                              ),
                              onLongPress: () {
                                Provider.of<PostFunctions>(context,
                                        listen: false)
                                    .showRewardSheet(
                                  context,
                                  data["caption"],
                                );
                              },
                              onTap: () {
                                Provider.of<PostFunctions>(context,
                                        listen: false)
                                    .showReward(
                                  context,
                                  data["caption"],
                                );
                              },
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("posts")
                                  .doc(data["caption"])
                                  .collection("rewards")
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
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
                      Spacer(),
                      Provider.of<Authentication>(context, listen: false)
                                  .getUserId ==
                              data["useruid"]
                          ? IconButton(
                              icon: Icon(
                                EvaIcons.moreVertical,
                                color: constantColors.whiteColor,
                              ),
                              onPressed: () {
                                Provider.of<PostFunctions>(context,
                                        listen: false)
                                    .showPostOption(context, data["caption"]);
                              },
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
        });
  }
}
