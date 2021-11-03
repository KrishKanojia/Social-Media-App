import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/screens/feed/feedhelpers.dart';

class Feed extends StatelessWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: Provider.of<FeedHelpers>(context, listen: false).appBar(context),
      body: Provider.of<FeedHelpers>(context, listen: false).FeedBody(context),
    );
  }
}
