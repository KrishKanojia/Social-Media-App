import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/services/firebaseoperations.dart';

class LandingUtils extends ChangeNotifier {
  final picker = ImagePicker();

  late File UserImage;
  File get getUserImage => UserImage;

  late String UserImageUrl;
  String get getUserImageUrl => UserImageUrl;

  Future pickUserImage(BuildContext context, ImageSource source) async {
    final PickedUserImage = await picker.pickImage(source: source);
    PickedUserImage == null
        ? print("Select Image")
        : UserImage = File(PickedUserImage.path);
    print("The Path of UserAvator ${UserImage.path}");

    UserImage != null
        ? Provider.of<FirebaseOperation>(context, listen: false)
            .uploadUserImage(context)
        : print("Image Upload Error");
    notifyListeners();
  }
}
