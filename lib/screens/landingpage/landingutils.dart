import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/constraints.dart';
import 'package:social_media_app/screens/landingpage/landingservices.dart';
import 'package:social_media_app/services/firebaseoperations.dart';

class LandingUtils extends ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
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
    print("The Path of UserImage ${UserImage.path}");

    // UserImage != null
    //     ? Provider.of<LandingServices>(context, listen: false)
    //         .showUserImage(context)
    //     : print("Image Upload Error");
    notifyListeners();
  }

  showImageOption(BuildContext context) async {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Form(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: constantColors.blueGreyColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        color: constantColors.blueColor,
                        child: Text(
                          "Gallery",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                        ),
                        onPressed: () {
                          pickUserImage(context, ImageSource.gallery)
                              .whenComplete(() {
                            Provider.of<LandingServices>(context, listen: false)
                                .showUserImage(context);
                            // Navigator.of(context).pop();
                          });
                        },
                      ),
                      MaterialButton(
                        color: constantColors.blueColor,
                        child: Text(
                          "Camera",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                        ),
                        onPressed: () {
                          pickUserImage(context, ImageSource.camera)
                              .whenComplete(() {
                            Navigator.of(context, rootNavigator: true).pop();

                            Provider.of<LandingServices>(context, listen: false)
                                .showUserImage(context);
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
