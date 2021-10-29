import 'package:flutter/material.dart';
import 'package:social_media_app/constraints.dart';

class FeedHelpers extends ChangeNotifier {
  ConstantColors constantColors = ConstantColors();

  appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: RichText(
        text: TextSpan(
          text: 'Virtual',
          style: TextStyle(
            fontFamily: "Poppins",
            color: constantColors.whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
          children: [
            TextSpan(
              text: 'Feed',
              style: TextStyle(
                fontFamily: "Poppins",
                color: constantColors.blueColor,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.camera_enhance_outlined,
            color: constantColors.greenColor,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  // Widget FeedBody(BuildContext context) {
  //   return SingleChildScrollView(
  //     child: Container(
  //       decoration: BoxD,
  //     ),
  //   );

  // }
}
