import 'package:flutter/material.dart';

import '../../constraints.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  ConstantColors constantColors = ConstantColors();
  final PageController homepageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kContentColorLightTheme,
      body: Center(
        child: Text(
          "Home Page",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
