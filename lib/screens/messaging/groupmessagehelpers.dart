import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/constraints.dart';
import 'package:social_media_app/screens/homepage/homepage.dart';
import 'package:social_media_app/services/authentication.dart';
import 'package:social_media_app/services/firebaseoperations.dart';
import 'package:timeago/timeago.dart' as timeago;

class GroupMessageHelpers extends ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  bool hasMemberJoined = false;
  bool get getHasMemBerJoined => hasMemberJoined;

  late String lastMessageTime;
  String get getLastMessageTime => lastMessageTime;
  showMessage(
      {required BuildContext context,
      required DocumentSnapshot documentSnapshot,
      required String AdminUserUid}) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chatroom")
            .doc(documentSnapshot.id)
            .collection("messages")
            .orderBy("time", descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snasphot) {
          if (snasphot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              reverse: true,
              children: snasphot.data!.docs.map((DocumentSnapshot docSnapshot) {
                Map<String, dynamic> data =
                    docSnapshot.data()! as Map<String, dynamic>;
                showLastMessageTime(data["time"]);
                return Container(
                  margin: EdgeInsets.only(top: 4.0),
                  height: data["message"] != null
                      ? MediaQuery.of(context).size.height * 0.12
                      : MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  // color: Colors.red,
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 60.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Container(
                                constraints: BoxConstraints(
                                  maxHeight: data["message"] != null
                                      ? MediaQuery.of(context).size.height *
                                          0.12
                                      : MediaQuery.of(context).size.height *
                                          0.4,
                                  maxWidth: data["message"] != null
                                      ? MediaQuery.of(context).size.width * 0.8
                                      : MediaQuery.of(context).size.width * 0.9,
                                ),
                                decoration: BoxDecoration(
                                  color: Provider.of<Authentication>(context,
                                                  listen: false)
                                              .getUserId ==
                                          data["useruid"]
                                      ? constantColors.blueColor
                                          .withOpacity(0.8)
                                      : constantColors.blueGreyColor,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 12.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 150.0,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 8.0),
                                              child: Text(
                                                data["username"],
                                                style: TextStyle(
                                                  color:
                                                      constantColors.greenColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.0,
                                                ),
                                              ),
                                            ),
                                            Provider.of<Authentication>(context,
                                                            listen: false)
                                                        .getUserId ==
                                                    AdminUserUid
                                                ? Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8.0),
                                                    child: Icon(
                                                      FontAwesomeIcons
                                                          .chessKing,
                                                      color: constantColors
                                                          .yellowColor,
                                                      size: 12,
                                                    ),
                                                  )
                                                : Container(
                                                    width: 0.0,
                                                    height: 0.0,
                                                  ),
                                          ],
                                        ),
                                      ),
                                      data["message"] != null
                                          ? Text(
                                              data["message"],
                                              style: TextStyle(
                                                color:
                                                    constantColors.whiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.0,
                                              ),
                                            )
                                          : Container(
                                              height: 90,
                                              width: 100,
                                              child: Image.network(
                                                data["sticker"],
                                              ),
                                            ),
                                      Container(
                                        width: 80.0,
                                        child: Text(
                                          lastMessageTime,
                                          style: TextStyle(
                                            fontSize: 10.0,
                                            color: constantColors.whiteColor,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                          top: 0,
                          child: Provider.of<Authentication>(context,
                                          listen: false)
                                      .getUserId ==
                                  data["useruid"]
                              ? Container(
                                  child: Column(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: constantColors.blueColor,
                                          size: 18.0,
                                        ),
                                        onPressed: () {},
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          FontAwesomeIcons.trashAlt,
                                          color: constantColors.redColor,
                                          size: 18.0,
                                        ),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  width: 0.0,
                                  height: 0.0,
                                )),
                      Positioned(
                        left: 40,
                        child:
                            Provider.of<Authentication>(context, listen: false)
                                        .getUserId ==
                                    data["useruid"]
                                ? Container(
                                    width: 0.0,
                                    height: 0.0,
                                  )
                                : CircleAvatar(
                                    backgroundColor: constantColors.darkColor,
                                    backgroundImage:
                                        NetworkImage(data["userimage"]),
                                  ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }
        });
  }

  sendMessage(BuildContext context, DocumentSnapshot documentSnapshot,
      TextEditingController msgController) {
    return FirebaseFirestore.instance
        .collection("chatroom")
        .doc(documentSnapshot.id)
        .collection("messages")
        .add({
      "message": msgController.text,
      "time": Timestamp.now(),
      "useruid": Provider.of<Authentication>(context, listen: false).getUserId,
      "username":
          Provider.of<FirebaseOperation>(context, listen: false).initUserName,
      "useremail":
          Provider.of<FirebaseOperation>(context, listen: false).initUserEmail,
      "userimage":
          Provider.of<FirebaseOperation>(context, listen: false).initUserImage,
    });
  }

  Future checkIfJoined(BuildContext context, String chatRoomName,
      String chatRoomAdminUid) async {
    return FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatRoomName)
        .collection("members")
        .doc(Provider.of<Authentication>(context, listen: false).getUserId)
        .get()
        .then((value) {
      Map<String, dynamic> data = value.data() as Map<String, dynamic>;
      hasMemberJoined = false;
      print("Initial State $hasMemberJoined");
      if (data["joined"] != null) {
        hasMemberJoined = data["joined"];
        print("Final State $hasMemberJoined");
        notifyListeners();
      }
      if (Provider.of<Authentication>(context, listen: false).getUserId ==
          chatRoomAdminUid) {
        hasMemberJoined = true;
        notifyListeners();
      }
    });
  }

  askToJoin(BuildContext context, String roomName) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: constantColors.darkColor,
            title: Text(
              "Join? $roomName",
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
                    color: constantColors.whiteColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationColor: constantColors.whiteColor,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    PageTransition(
                        child: Homepage(),
                        type: PageTransitionType.bottomToTop),
                  );
                },
              ),
              MaterialButton(
                child: Text(
                  "Yes",
                  style: TextStyle(
                    color: constantColors.whiteColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  FirebaseFirestore.instance
                      .collection("chatroom")
                      .doc(roomName)
                      .collection("members")
                      .doc(Provider.of<Authentication>(context, listen: false)
                          .userUid)
                      .set(
                    {
                      "joined": true,
                      "username":
                          Provider.of<FirebaseOperation>(context, listen: false)
                              .initUserName,
                      "userimage":
                          Provider.of<FirebaseOperation>(context, listen: false)
                              .initUserImage,
                      "useruid":
                          Provider.of<Authentication>(context, listen: false)
                              .userUid,
                      "time ": Timestamp.now(),
                    },
                  ).whenComplete(() {
                    Navigator.of(context).pop();
                  });
                },
              ),
            ],
          );
        });
  }

  showSticker(BuildContext context, String chatroomId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.easeIn,
            height: MediaQuery.of(context).size.height * 0.5,
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
                  padding: const EdgeInsets.symmetric(horizontal: 105.0),
                  child: Divider(
                    thickness: 4,
                    color: constantColors.whiteColor,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: constantColors.blueColor),
                        ),
                        child: Image.asset("assets/welcome_image.png"),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("stickers")
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return GridView(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot documentSnapshot) {
                            Map<String, dynamic> data =
                                documentSnapshot.data() as Map<String, dynamic>;

                            return GestureDetector(
                              child: Container(
                                height: 40,
                                width: 40,
                                child: Image.network(
                                  data["image"],
                                ),
                              ),
                              onTap: () {
                                sendSticker(context, data["image"], chatroomId);
                              },
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

  sendSticker(
      BuildContext context, String stickerImageUrl, String chatrommId) async {
    await FirebaseFirestore.instance
        .collection("chatroom")
        .doc(chatrommId)
        .collection("messages")
        .add({
      "sticker": stickerImageUrl,
      "username":
          Provider.of<FirebaseOperation>(context, listen: false).initUserName,
      "userimage":
          Provider.of<FirebaseOperation>(context, listen: false).initUserImage,
      "time": Timestamp.now(),
      "useruid": Provider.of<Authentication>(context, listen: false).getUserId,
    });
  }

  showLastMessageTime(dynamic timeData) {
    Timestamp time = timeData;
    DateTime dateTime = time.toDate();
    lastMessageTime = timeago.format(dateTime);
    print(lastMessageTime);
  }
}
