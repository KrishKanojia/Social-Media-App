import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/screens/landingpage/landingutils.dart';
import 'package:social_media_app/services/authentication.dart';

class FirebaseOperation extends ChangeNotifier {
  late UploadTask ImageUploadTask;
  late String initUserEmail, initUserName;
  String initUserImage =
      "https://toppng.com/uploads/preview/clear-png-11553956476xuvdl9amaq.png";

  Future uploadUserImage(BuildContext context) async {
    Reference imageReference = FirebaseStorage.instance.ref().child(
        'userProfileImage/${Provider.of<LandingUtils>(context, listen: false).getUserImage.path}/${TimeOfDay.now()}');
    ImageUploadTask = imageReference.putFile(
        Provider.of<LandingUtils>(context, listen: false).getUserImage);
    await ImageUploadTask.whenComplete(() {
      print("Image Uploaded Successfully!");
    });
    imageReference.getDownloadURL().then((url) {
      Provider.of<LandingUtils>(context, listen: false).UserImageUrl =
          url.toString();
      print(
          "The User Profile Image => ${Provider.of<LandingUtils>(context, listen: false).UserImageUrl.toString()}");
      notifyListeners();
    });
  }

  Future createUserCollection(BuildContext context, dynamic data) async {
    return FirebaseFirestore.instance
        .collection("allusers")
        .doc(Provider.of<Authentication>(context, listen: false).getUserId)
        .set(data);
  }

  Future initUserData(BuildContext context) async {
    return
        // StreamBuilder<DocumentSnapshot>(
        //     stream: FirebaseFirestore.instance
        //         .collection('allusers')
        //         .d(Provider.of<Authentication>(context, listen: false).getUserId,)
        //         .snapshots(),
        //     builder:
        //         (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        //       if (snapshot.hasData) {
        //         _currentName = snapshot.data['name'];
        //         return Text(snapshot.data['name']);
        //       }
        //       //this will load first
        //       return CircularProgressIndicator();
        //     });
        //
        FirebaseFirestore.instance
            .collection("allusers")
            .doc(
              Provider.of<Authentication>(context, listen: false).getUserId,
            )
            .get()
            .then(
      (doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        print("Fetching User Data ");

        initUserName = data['username'];
        initUserEmail = data['useremail'];
        initUserImage = data['userimage'];
        print(initUserName);
        print(initUserImage);
        notifyListeners();
      },
    );
  }

  Future uploadPostData(String postid, dynamic data) {
    return FirebaseFirestore.instance.collection("posts").doc(postid).set(data);
  }

  Future deleteUserData(String userId, dynamic collection) async {
    return FirebaseFirestore.instance
        .collection(collection)
        .doc(userId)
        .delete();
  }

  Future addReward(String postId, dynamic data) async {
    return FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("rewards")
        .add(data);
  }

  Future updatedCaption(String postId, dynamic data) async {
    return FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .update(data);
  }
}
