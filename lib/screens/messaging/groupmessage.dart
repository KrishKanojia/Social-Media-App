import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/constraints.dart';
import 'package:social_media_app/screens/chatroom/chatroom.dart';
import 'package:social_media_app/screens/homepage/homepage.dart';
import 'package:social_media_app/screens/messaging/groupmessagehelpers.dart';
import 'package:social_media_app/services/authentication.dart';

class GroupMessage extends StatefulWidget {
  final DocumentSnapshot docSnapshot;
  GroupMessage({required this.docSnapshot});

  @override
  _GroupMessageState createState() => _GroupMessageState();
}

class _GroupMessageState extends State<GroupMessage> {
  final ConstantColors constantColors = ConstantColors();

  late double height, width;
  late Map<String, dynamic> data;
  TextEditingController messageController = TextEditingController();
  @override
  void initState() {
    data = widget.docSnapshot.data()! as Map<String, dynamic>;
    Provider.of<GroupMessageHelpers>(context, listen: false)
        .checkIfJoined(context, widget.docSnapshot.id, data["useruid"])
        .whenComplete(() {
      if (Provider.of<GroupMessageHelpers>(context, listen: false)
              .getHasMemBerJoined ==
          false) {
        Timer(
            Duration(milliseconds: 10),
            () => Provider.of<GroupMessageHelpers>(context, listen: false)
                .askToJoin(context, widget.docSnapshot.id));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: constantColors.darkColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: constantColors.darkColor.withOpacity(0.6),
        title: Container(
          // color: constantColors.redColor,
          width: width * 0.5,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: constantColors.transperant,
                backgroundImage: NetworkImage(
                  data["roomavator"],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data["roomname"],
                      style: TextStyle(
                        color: constantColors.whiteColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("chatroom")
                          .doc(widget.docSnapshot.id)
                          .collection("members")
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (ConnectionState.waiting ==
                            snapshot.connectionState) {
                          return CircularProgressIndicator();
                        } else {
                          return Text(
                            "${snapshot.data!.docs.length.toString()} members",
                            style: TextStyle(
                              color: constantColors.greenColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: constantColors.whiteColor,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              PageTransition(
                child: Homepage(),
                type: PageTransitionType.leftToRight,
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              EvaIcons.logInOutline,
              color: constantColors.redColor,
            ),
            onPressed: () {},
          ),
          Provider.of<Authentication>(context, listen: false).getUserId ==
                  data["useruid"]
              ? IconButton(
                  icon: Icon(
                    EvaIcons.moreVertical,
                    color: constantColors.whiteColor,
                  ),
                  onPressed: () {},
                )
              : Container(),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: constantColors.darkColor,
          child: Column(
            children: [
              AnimatedContainer(
                // color: constantColors.redColor,
                height: height * 0.82,
                width: width,
                duration: Duration(seconds: 1),
                curve: Curves.bounceIn,
                child: Provider.of<GroupMessageHelpers>(context, listen: false)
                    .showMessage(
                        context: context,
                        documentSnapshot: widget.docSnapshot,
                        AdminUserUid: data["useruid"]),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  color: constantColors.darkColor,
                  child: Row(
                    children: [
                      GestureDetector(
                        child: CircleAvatar(
                          radius: 18.0,
                          backgroundColor: constantColors.transperant,
                          backgroundImage: AssetImage(
                            "assets/welcome_image.png",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Container(
                          // color: constantColors.greenColor,
                          width: width * 0.7,
                          child: TextField(
                            controller: messageController,
                            style: TextStyle(
                              color: constantColors.whiteColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              hintText: "Drop a hi ...",
                              hintStyle: TextStyle(
                                color: constantColors.greenColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      FloatingActionButton(
                        backgroundColor: constantColors.blueColor,
                        child: Icon(
                          Icons.send_sharp,
                          color: constantColors.whiteColor,
                        ),
                        onPressed: () {
                          if (messageController.text.isNotEmpty) {
                            Provider.of<GroupMessageHelpers>(context,
                                    listen: false)
                                .sendMessage(context, widget.docSnapshot,
                                    messageController);
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
