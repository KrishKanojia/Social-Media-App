import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/screens/landingpage/landingutils.dart';
import 'package:social_media_app/services/authentication.dart';

class FirebaseOperation extends ChangeNotifier {
  late UploadTask ImageUploadTask;
  late String initUserEmail, initUserName, initUserImage;

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

  Future initUserData<DocumentSnapshot>(BuildContext context) async {
    return await FirebaseFirestore.instance
        .collection("allusers")
        .doc(Provider.of<Authentication>(context, listen: false).getUserId)
        .get()
        .then((doc) async {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      print("Fetching User Data ");
      initUserName = data['username'];
      initUserEmail = data['useremail'];
      initUserImage = data['userimage'];
      print(initUserName);
      print(initUserImage);
      notifyListeners();
    });
  }
}
