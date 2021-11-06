import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/screens/Profile/profilehelpers.dart';
import 'package:social_media_app/screens/altprofile/alt_profile_helpers.dart';
import 'package:social_media_app/screens/feed/feedhelpers.dart';
import 'package:social_media_app/screens/homepage/homepagehelpers.dart';
import 'package:social_media_app/screens/landingpage/landinghelpers.dart';
import 'package:social_media_app/screens/landingpage/landingpage.dart';
import 'package:social_media_app/screens/landingpage/landingservices.dart';
import 'package:social_media_app/screens/landingpage/landingutils.dart';
import 'package:social_media_app/screens/splashscreen/splashscreen.dart';
import 'package:social_media_app/services/authentication.dart';
import 'package:social_media_app/services/firebaseoperations.dart';
import 'package:social_media_app/utils/postoptions.dart';
import 'package:social_media_app/utils/uploadpost.dart';

import 'constraints.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Virtual Life',
        theme: ThemeData(
            accentColor: kContentColorLightTheme,
            fontFamily: 'Poppins',
            canvasColor: Colors.transparent),
        home: SplashScreen(),
      ),
      providers: [
        ChangeNotifierProvider(
          create: (_) => Authentication(),
        ),
        ChangeNotifierProvider(
          create: (_) => LandingServices(),
        ),
        ChangeNotifierProvider(
          create: (_) => LandingHelpers(),
        ),
        ChangeNotifierProvider(
          create: (_) => FirebaseOperation(),
        ),
        ChangeNotifierProvider(
          create: (_) => LandingUtils(),
        ),
        ChangeNotifierProvider(
          create: (_) => HomepageHelpers(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileHelpers(),
        ),
        ChangeNotifierProvider(
          create: (_) => FeedHelpers(),
        ),
        ChangeNotifierProvider(
          create: (_) => UploadPost(),
        ),
        ChangeNotifierProvider(
          create: (_) => PostFunctions(),
        ),
        ChangeNotifierProvider(
          create: (_) => AltProfileHelpers(),
        ),
      ],
    );
  }
}
