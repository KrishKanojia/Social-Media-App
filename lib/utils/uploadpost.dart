import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/constraints.dart';
import 'package:social_media_app/services/authentication.dart';
import 'package:social_media_app/services/firebaseoperations.dart';

class UploadPost extends ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  TextEditingController captionController = TextEditingController(text: "");
  late File uploadPostImage;
  File get getuploadPostImage => uploadPostImage;
  late String uploadPostImageUrl;
  String get getuploadPostImageUrl => uploadPostImageUrl;
  final picker = ImagePicker();

  late UploadTask imageUploadTask;

  Future pickUploadPostImage(BuildContext context, ImageSource source) async {
    final uploadPostImageVal = await picker.pickImage(source: source);
    uploadPostImageVal == null
        ? print("Select Image")
        : uploadPostImage = File(uploadPostImageVal.path);
    print("The Path of UserImage ${uploadPostImage.path}");

    uploadPostImage != null
        ? showUploadPostImage(context)
        : print("Image Upload Error");
    notifyListeners();
  }

  selectPostImageType(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              color: constantColors.blueGreyColor,
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
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: constantColors.whiteColor,
                        ),
                      ),
                      onPressed: () {
                        pickUploadPostImage(context, ImageSource.gallery);
                      },
                    ),
                    MaterialButton(
                      color: constantColors.blueColor,
                      child: Text(
                        "Camera",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: constantColors.whiteColor,
                        ),
                      ),
                      onPressed: () {
                        pickUploadPostImage(context, ImageSource.camera);
                      },
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }

  Future uploadImagePostToFirebase() async {
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child("posts/${uploadPostImage.path}/${TimeOfDay.now()}");
    imageUploadTask = imageReference.putFile(uploadPostImage);
    await imageUploadTask.whenComplete(() {
      print("Image Uploaded Successfully!");
    });

    imageReference.getDownloadURL().then((imgUrl) {
      uploadPostImageUrl = imgUrl;
      print(uploadPostImageUrl);
    });
    notifyListeners();
  }

  showUploadPostImage(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              color: constantColors.blueGreyColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    thickness: 4.0,
                    color: constantColors.whiteColor,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                  height: 200,
                  width: 400,
                  child: Image.file(uploadPostImage),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      child: Text(
                        "Reselect",
                        style: TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        selectPostImageType(context);
                      },
                    ),
                    MaterialButton(
                      color: constantColors.blueColor,
                      child: Text(
                        "Confirm Image",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        uploadImagePostToFirebase().whenComplete(() {
                          editPostSheet(context);
                          print("Image Uploaded");
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  editPostSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: constantColors.blueGreyColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 150.0),
                child: Divider(
                  thickness: 4.0,
                  color: constantColors.whiteColor,
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.image_aspect_ratio,
                              color: constantColors.greenColor,
                            ),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.fit_screen_outlined,
                              color: constantColors.yellowColor,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 200,
                      width: 300,
                      child: Image.file(
                        uploadPostImage,
                        fit: BoxFit.contain,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: Image.asset("assets/welcome_image.png"),
                    ),
                    Container(
                      height: 110,
                      width: 5,
                      color: constantColors.blueColor,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      height: 120,
                      width: 330,
                      child: TextField(
                        maxLines: 5,
                        textCapitalization: TextCapitalization.words,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(100)
                        ],
                        maxLength: 100,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        controller: captionController,
                        style: TextStyle(
                          color: constantColors.whiteColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          hintText: "Add A Caption...",
                          hintStyle: TextStyle(
                            color: constantColors.whiteColor,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              MaterialButton(
                child: Text(
                  "Share",
                  style: TextStyle(
                    color: constantColors.whiteColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                color: constantColors.blueColor,
                onPressed: () async {
                  print("Sharing Content");
                  Provider.of<FirebaseOperation>(context, listen: false)
                      .uploadPostData(captionController.text, {
                    "caption": captionController.text,
                    "postimage": getuploadPostImageUrl,
                    "username":
                        Provider.of<FirebaseOperation>(context, listen: false)
                            .initUserName,
                    "userimage":
                        Provider.of<FirebaseOperation>(context, listen: false)
                            .initUserImage,
                    "useruid":
                        Provider.of<Authentication>(context, listen: false)
                            .getUserId,
                    "time": Timestamp.now(),
                    "useremail":
                        Provider.of<FirebaseOperation>(context, listen: false)
                            .initUserEmail,
                  }).whenComplete(() {
                    Navigator.pop(context);
                  });
                },
              )
            ]),
          );
        });
  }
}
