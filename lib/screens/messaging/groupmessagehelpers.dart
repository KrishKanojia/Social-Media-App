import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/constraints.dart';
import 'package:social_media_app/services/authentication.dart';
import 'package:social_media_app/services/firebaseoperations.dart';

class GroupMessageHelpers extends ChangeNotifier {
  ConstantColors constantColors = ConstantColors();

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
}
