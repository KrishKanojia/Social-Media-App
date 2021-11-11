import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/constraints.dart';
import 'package:social_media_app/screens/chatroom/chatroomhelpers.dart';

class Chatroom extends StatelessWidget {
  final ConstantColors constantColors = ConstantColors();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: constantColors.darkColor.withOpacity(0.6),
          centerTitle: true,
          title: RichText(
            text: TextSpan(
              text: 'Chat ',
              style: TextStyle(
                fontFamily: "Poppins",
                color: constantColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
              children: [
                TextSpan(
                  text: 'Box',
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
          leading: IconButton(
            icon: Icon(
              FontAwesomeIcons.plus,
              color: constantColors.greenColor,
            ),
            onPressed: () {
              Provider.of<ChatroomHelpers>(context, listen: false)
                  .showCreateChatroomSheet(context);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                EvaIcons.moreVertical,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: constantColors.blueGreyColor,
          child: Icon(
            FontAwesomeIcons.plus,
            color: constantColors.greenColor,
          ),
          onPressed: () {
            Provider.of<ChatroomHelpers>(context, listen: false)
                .showCreateChatroomSheet(context);
          },
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Provider.of<ChatroomHelpers>(context, listen: false)
              .showChatrooms(context),
        ));
  }
}
