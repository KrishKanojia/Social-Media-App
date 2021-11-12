import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/constraints.dart';
import 'package:social_media_app/screens/messaging/groupmessage.dart';
import 'package:social_media_app/services/authentication.dart';
import 'package:social_media_app/services/firebaseoperations.dart';

class ChatroomHelpers extends ChangeNotifier {
  String ChatroomAvatorUrl = "";
  late String ChatroomId;
  String get getChatroomAvatorUrl => ChatroomAvatorUrl;
  String get getChatroomId => ChatroomId;

  ConstantColors constantColors = ConstantColors();
  final TextEditingController ChatNameController = TextEditingController();

  showChatroomDetails(BuildContext context, DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data =
        documentSnapshot.data()! as Map<String, dynamic>;
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.3,
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
                  padding: EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    color: constantColors.whiteColor,
                    thickness: 4.0,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: constantColors.blueColor,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Members",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: constantColors.whiteColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: MediaQuery.of(context).size.width,
                  // color: constantColors.redColor,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: constantColors.yellowColor,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Admin",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: constantColors.whiteColor,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: constantColors.transperant,
                          backgroundImage: NetworkImage(data["userimage"]),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            data["username"],
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: constantColors.whiteColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  showCreateChatroomSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: constantColors.darkColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      color: constantColors.whiteColor,
                      thickness: 4.0,
                    ),
                  ),
                  Text(
                    "Select Chatroom Avator",
                    style: TextStyle(
                      color: constantColors.greenColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("chatroomIcons")
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              Map<String, dynamic> data = documentSnapshot
                                  .data()! as Map<String, dynamic>;

                              return GestureDetector(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 16.0),
                                  child: Container(
                                    height: 10,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                      color: ChatroomAvatorUrl == data["image"]
                                          ? constantColors.blueColor
                                          : constantColors.transperant,
                                    )),
                                    child: Image.network(data["image"]),
                                  ),
                                ),
                                onTap: () {
                                  ChatroomAvatorUrl = data["image"];
                                  print(ChatroomAvatorUrl);
                                },
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextField(
                          controller: ChatNameController,
                          style: TextStyle(
                            color: constantColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                          decoration: InputDecoration(
                            hintText: "Enter Chatroom ID",
                            hintStyle: TextStyle(
                              color: constantColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          textCapitalization: TextCapitalization.words,
                        ),
                      ),
                      FloatingActionButton(
                        backgroundColor: constantColors.blueGreyColor,
                        child: Icon(
                          FontAwesomeIcons.plus,
                          color: constantColors.yellowColor,
                        ),
                        onPressed: () async {
                          Provider.of<FirebaseOperation>(context, listen: false)
                              .submitChatroomData(
                            ChatNameController.text,
                            {
                              "roomavator": getChatroomAvatorUrl,
                              "time": Timestamp.now(),
                              "roomname": ChatNameController.text,
                              "username": Provider.of<FirebaseOperation>(
                                      context,
                                      listen: false)
                                  .initUserName,
                              "useremail": Provider.of<FirebaseOperation>(
                                      context,
                                      listen: false)
                                  .initUserEmail,
                              "userimage": Provider.of<FirebaseOperation>(
                                      context,
                                      listen: false)
                                  .initUserImage,
                              "useruid": Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserId,
                            },
                          ).whenComplete(() {
                            Navigator.of(context).pop();
                          });
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  showChatrooms(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("chatroom").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snasphot) {
          if (snasphot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                height: 200.0,
                width: 200.0,
                child: Lottie.asset("assets/animations/loading.json"),
              ),
            );
          } else {
            return ListView(
              children:
                  snasphot.data!.docs.map((DocumentSnapshot documentSnapshot) {
                Map<String, dynamic> data =
                    documentSnapshot.data()! as Map<String, dynamic>;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: constantColors.transperant,
                    backgroundImage: NetworkImage(
                      data["roomavator"],
                    ),
                  ),
                  title: Text(
                    data["roomname"],
                    style: TextStyle(
                      color: constantColors.whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  subtitle: Text(
                    "Last message",
                    style: TextStyle(
                      color: constantColors.greenColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  trailing: Text(
                    "2 hours ago",
                    style: TextStyle(
                      color: constantColors.greenColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10.0,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushReplacement(PageTransition(
                        child: GroupMessage(
                          docSnapshot: documentSnapshot,
                        ),
                        type: PageTransitionType.leftToRight));
                  },
                  onLongPress: () {
                    showChatroomDetails(context, documentSnapshot);
                  },
                );
              }).toList(),
            );
          }
        });
  }
}
