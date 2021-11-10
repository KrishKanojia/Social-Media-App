import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/constraints.dart';
import 'package:social_media_app/screens/altprofile/alt_profile.dart';
import 'package:social_media_app/screens/landingpage/landingpage.dart';
import 'package:social_media_app/services/authentication.dart';
import 'package:social_media_app/utils/postoptions.dart';

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
                    GestureDetector(
                      child: Container(
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
                      onTap: () {
                        checkFollowingSheet(context, documentSnapshot);
                      },
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
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
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("allusers")
                      .doc(snapshot["useruid"])
                      .collection("following")
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return ListView(
                        scrollDirection: Axis.horizontal,
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot documentSnapshot) {
                          Map<String, dynamic> data =
                              documentSnapshot.data()! as Map<String, dynamic>;
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(data["userimage"]),
                                ),
                              ),
                            );
                          }
                        }).toList(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
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
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("allusers")
              .doc(
                  Provider.of<Authentication>(context, listen: false).getUserId)
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
                  Map<String, dynamic> data =
                      documentSnapshot.data()! as Map<String, dynamic>;
                  return GestureDetector(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        width: MediaQuery.of(context).size.width,
                        child: FittedBox(
                          child: Image.network(data["postimage"]),
                        ),
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

  checkFollowingSheet(BuildContext context, dynamic snapshot) {
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
                  .collection("following")
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
                            Navigator.of(context).pushReplacement(
                              PageTransition(
                                  child: AltProfile(
                                    useruid: data["useruid"],
                                  ),
                                  type: PageTransitionType.topToBottom),
                            );
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
                          trailing: MaterialButton(
                              color: constantColors.blueColor,
                              child: Text(
                                "Unfollow",
                                style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                              onPressed: () {}),
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
