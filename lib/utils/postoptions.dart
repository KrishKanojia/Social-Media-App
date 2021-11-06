import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/constraints.dart';
import 'package:social_media_app/services/authentication.dart';
import 'package:social_media_app/services/firebaseoperations.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostFunctions extends ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  TextEditingController commentController = TextEditingController();
  String imageTimePosted = "";
  TextEditingController captionController = TextEditingController();
  String get getimageTimePosted => imageTimePosted;

  showTimeAgo(dynamic timedata) {
    Timestamp time = timedata;
    DateTime dateTime = time.toDate();
    imageTimePosted = timeago.format(dateTime);
    print(imageTimePosted);
    // notifyListeners();
  }

  showPostOption(BuildContext context, String postId) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.1,
              decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
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
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(
                          color: constantColors.blueColor,
                          child: Text(
                            "Edit Caption",
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    child: Center(
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 300.0,
                                            height: 50.0,
                                            child: TextField(
                                              decoration: InputDecoration(
                                                hintText: "Add New Caption",
                                                hintStyle: TextStyle(
                                                  color:
                                                      constantColors.whiteColor,
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              controller: captionController,
                                            ),
                                          ),
                                          FloatingActionButton(
                                            backgroundColor:
                                                constantColors.redColor,
                                            child: Icon(
                                                FontAwesomeIcons.fileUpload,
                                                color:
                                                    constantColors.whiteColor),
                                            onPressed: () {
                                              Provider.of<FirebaseOperation>(
                                                      context,
                                                      listen: false)
                                                  .updatedCaption(postId, {
                                                "caption":
                                                    captionController.text,
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                        ),
                        MaterialButton(
                          color: constantColors.redColor,
                          child: Text(
                            "Delete Post",
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: constantColors.darkColor,
                                    title: Text(
                                      "Delete This Post?",
                                      style: TextStyle(
                                        color: constantColors.whiteColor,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    actions: [
                                      MaterialButton(
                                        child: Text(
                                          "No",
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor:
                                                constantColors.whiteColor,
                                            color: constantColors.whiteColor,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      MaterialButton(
                                        color: constantColors.redColor,
                                        child: Text(
                                          "Yes",
                                          style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        onPressed: () {
                                          Provider.of<FirebaseOperation>(
                                                  context,
                                                  listen: false)
                                              .deleteUserData(postId, 'posts')
                                              .whenComplete(() {
                                            Navigator.pop(context);
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future addLike(BuildContext context, String postId, String subDocId) async {
    return FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("likes")
        .doc(subDocId)
        .set({
      "like": FieldValue.increment(1),
      "username":
          Provider.of<FirebaseOperation>(context, listen: false).initUserName,
      "useruid": Provider.of<Authentication>(context, listen: false).getUserId,
      "userimage":
          Provider.of<FirebaseOperation>(context, listen: false).initUserImage,
      "useremail":
          Provider.of<FirebaseOperation>(context, listen: false).initUserEmail,
      "timeago": Timestamp.now(),
    });
  }

  Future addComment(BuildContext context, String postId, String comment) async {
    return FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("comments")
        .doc(comment)
        .set({
      "comment": comment,
      "username":
          Provider.of<FirebaseOperation>(context, listen: false).initUserName,
      "useruid": Provider.of<Authentication>(context, listen: false).getUserId,
      "userimage":
          Provider.of<FirebaseOperation>(context, listen: false).initUserImage,
      "useremail":
          Provider.of<FirebaseOperation>(context, listen: false).initUserEmail,
      "timeago": Timestamp.now(),
    });
  }

  showCommentSheet(
      BuildContext context, DocumentSnapshot documentSnapshot, String docId) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 150.0),
                      child: Divider(
                        thickness: 4.0,
                        color: constantColors.whiteColor,
                      ),
                    ),
                    Container(
                      width: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: constantColors.whiteColor),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          "Comments",
                          style: TextStyle(
                            color: constantColors.blueColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("posts")
                              .doc(docId)
                              .collection("comments")
                              .orderBy("timeago")
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              return ListView(
                                children: snapshot.data!.docs
                                    .map((DocumentSnapshot documentSnapshot) {
                                  Map<String, dynamic> data = documentSnapshot
                                      .data() as Map<String, dynamic>;
                                  return Container(
                                    // color: Colors.green,
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: GestureDetector(
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      constantColors
                                                          .blueGreyColor,
                                                  radius: 15.0,
                                                  backgroundImage: NetworkImage(
                                                      data["userimage"]),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Container(
                                                child: Text(
                                                  data["username"],
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: constantColors
                                                        .whiteColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      FontAwesomeIcons.arrowUp,
                                                      color: constantColors
                                                          .blueColor,
                                                      size: 12.0,
                                                    ),
                                                    onPressed: () {},
                                                  ),
                                                  Text(
                                                    "0",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14.0,
                                                      color: constantColors
                                                          .whiteColor,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      FontAwesomeIcons.reply,
                                                      color: constantColors
                                                          .yellowColor,
                                                      size: 12.0,
                                                    ),
                                                    onPressed: () {},
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Row(
                                            children: [
                                              IconButton(
                                                icon: Icon(
                                                  Icons
                                                      .arrow_forward_ios_outlined,
                                                  color:
                                                      constantColors.blueColor,
                                                  size: 12,
                                                ),
                                                onPressed: () {},
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.7,
                                                child: Text(
                                                  data["comment"],
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: constantColors
                                                        .whiteColor,
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  FontAwesomeIcons.trashAlt,
                                                  color:
                                                      constantColors.redColor,
                                                  size: 16,
                                                ),
                                                onPressed: () {},
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          color: constantColors.darkColor
                                              .withOpacity(0.2),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              );
                            }
                          }),
                    ),
                    Container(
                      width: 400,
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            // color: Colors.red,
                            width: 300,
                            height: 20,
                            child: TextField(
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                hintText: "Add Comment...",
                                hintStyle: TextStyle(
                                  color: constantColors.whiteColor,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              controller: commentController,
                              style: TextStyle(
                                color: constantColors.whiteColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          FloatingActionButton(
                            backgroundColor: constantColors.greenColor,
                            child: Icon(
                              FontAwesomeIcons.comment,
                              color: constantColors.whiteColor,
                            ),
                            onPressed: () {
                              print("Adding Comment");
                              Map<String, dynamic> data = documentSnapshot
                                  .data() as Map<String, dynamic>;
                              addComment(context, data["caption"],
                                      commentController.text)
                                  .whenComplete(() {
                                commentController.clear();
                                notifyListeners();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  showLikes(BuildContext context, String postId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                topLeft: Radius.circular(12),
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
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: constantColors.whiteColor),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Center(
                    child: Text(
                      "Likes",
                      style: TextStyle(
                        color: constantColors.blueColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("posts")
                        .doc(postId)
                        .collection("likes")
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
                            Map<String, dynamic> data = documentSnapshot.data()!
                                as Map<String, dynamic>;
                            return GestureDetector(
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(data["userimage"]),
                                ),
                                title: Text(
                                  data["username"],
                                  style: TextStyle(
                                    color: constantColors.blueColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                subtitle: Text(
                                  data["useremail"],
                                  style: TextStyle(
                                    color: constantColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                  ),
                                ),
                                trailing: Provider.of<Authentication>(context,
                                                listen: false)
                                            .getUserId ==
                                        data["useruid"]
                                    ? Container(
                                        width: 0.0,
                                        height: 0.0,
                                      )
                                    : MaterialButton(
                                        color: constantColors.blueColor,
                                        child: Text(
                                          "Follow",
                                          style: TextStyle(
                                            color: constantColors.whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        onPressed: () {},
                                      ),
                              ),
                              onTap: () {},
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  showReward(BuildContext context, String postId) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.2,
          decoration: BoxDecoration(
            color: constantColors.blueGreyColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
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
              Container(
                width: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: constantColors.whiteColor),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Text(
                    "Rewards",
                    style: TextStyle(
                      color: constantColors.blueColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("awards")
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
                            Map<String, dynamic> data = documentSnapshot.data()!
                                as Map<String, dynamic>;
                            return GestureDetector(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Container(
                                    height: 50,
                                    width: 50,
                                    child: Image.network(data["image"])),
                              ),
                              onTap: () async {
                                print(data["image"]);
                                await Provider.of<FirebaseOperation>(context,
                                        listen: false)
                                    .addReward(postId, {
                                  "username": Provider.of<FirebaseOperation>(
                                          context,
                                          listen: false)
                                      .initUserName,
                                  "useremail": Provider.of<FirebaseOperation>(
                                          context,
                                          listen: false)
                                      .initUserEmail,
                                  "useruid": Provider.of<Authentication>(
                                          context,
                                          listen: false)
                                      .getUserId,
                                  "timeago": Timestamp.now(),
                                  "award": data["image"],
                                });
                              },
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
