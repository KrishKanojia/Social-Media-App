import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/constraints.dart';
import 'package:social_media_app/services/firebaseoperations.dart';

class HomepageHelpers extends ChangeNotifier {
  ConstantColors constantColors = ConstantColors();
  Widget bottomNavBar(
      int index, PageController controller, BuildContext context) {
    return CustomNavigationBar(
      currentIndex: index,
      bubbleCurve: Curves.bounceIn,
      scaleCurve: Curves.decelerate,
      selectedColor: constantColors.blueColor,
      unSelectedColor: constantColors.whiteColor,
      strokeColor: constantColors.blueColor,
      scaleFactor: 0.5,
      iconSize: 30,
      onTap: (value) {
        index = value;
        controller.jumpToPage(value);
        notifyListeners();
      },
      backgroundColor: Color(0xff040307),
      items: [
        CustomNavigationBarItem(icon: Icon(EvaIcons.home)),
        CustomNavigationBarItem(icon: Icon(Icons.message_outlined)),
        CustomNavigationBarItem(
            icon: CircleAvatar(
          radius: 35.0,
          backgroundColor: constantColors.blueGreyColor,
          backgroundImage: NetworkImage(
              Provider.of<FirebaseOperation>(context, listen: false)
                  .initUserImage),
        )),
      ],
    );
  }
}
