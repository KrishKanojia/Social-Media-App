import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/constraints.dart';
import 'package:social_media_app/services/authentication.dart';
import 'package:social_media_app/services/firebaseoperations.dart';

class PostFunctions extends ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  TextEditingController commentController = TextEditingController();
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
                    height: MediaQuery.of(context).size.height * 0.62,
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
                                  height:
                                      MediaQuery.of(context).size.height * 11,
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          GestureDetector(
                                            child: CircleAvatar(
                                              backgroundColor:
                                                  constantColors.blueGreyColor,
                                              radius: 15.0,
                                              backgroundImage: NetworkImage(
                                                  data["userimage"]),
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Container(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      data["username"],
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: constantColors
                                                            .whiteColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          Container(
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  icon: Icon(
                                                    FontAwesomeIcons.arrowUp,
                                                    color: constantColors
                                                        .blueColor,
                                                  ),
                                                  onPressed: () {},
                                                ),
                                                Text(
                                                  "0",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12.0,
                                                    color: constantColors
                                                        .whiteColor,
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    FontAwesomeIcons.reply,
                                                    color: constantColors
                                                        .yellowColor,
                                                  ),
                                                  onPressed: () {},
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    FontAwesomeIcons.trashAlt,
                                                    color:
                                                        constantColors.redColor,
                                                  ),
                                                  onPressed: () {},
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                Icons
                                                    .arrow_forward_ios_outlined,
                                                color: constantColors.blueColor,
                                                size: 12,
                                              ),
                                              onPressed: () {},
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Text(
                                                data["comment"],
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  color:
                                                      constantColors.whiteColor,
                                                ),
                                              ),
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
                          height: 30,
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
                            Map<String, dynamic> data =
                                documentSnapshot.data() as Map<String, dynamic>;
                            addComment(context, data["caption"],
                                commentController.text);
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

  showLikes(BuildContext context) {
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
              ],
            ),
          );
        });
  }
}
