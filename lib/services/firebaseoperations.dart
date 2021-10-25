import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/screens/landingpage/landingutils.dart';

class FirebaseOperation extends ChangeNotifier {
  late UploadTask ImageUploadTask;

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
}
