import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/screens/Profile/profilescreen.dart';
import 'package:social_media_app/screens/chatroom/chatroom.dart';
import 'package:social_media_app/screens/feed/feed.dart';
import 'package:social_media_app/screens/homepage/homepagehelpers.dart';
import 'package:social_media_app/services/firebaseoperations.dart';

import '../../constraints.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

late FirebaseOperation firebaseOperation;

class _HomepageState extends State<Homepage> {
  ConstantColors constantColors = ConstantColors();
  final PageController homepageController = PageController();
  int pageindex = 0;
  String imgNm = "";
  @override
  void initState() {
    Provider.of<FirebaseOperation>(context, listen: false)
        .initUserData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kContentColorLightTheme,
      body: PageView(
        controller: homepageController,
        children: [
          Feed(),
          Chatroom(),
          ProfileScreen(),
        ],
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (page) {
          setState(() {
            pageindex = page;
          });
        },
      ),
      bottomNavigationBar: Provider.of<HomepageHelpers>(context, listen: false)
          .bottomNavBar(pageindex, homepageController, context),
    );
  }
}
