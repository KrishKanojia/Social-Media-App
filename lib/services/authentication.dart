import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  late String userUid;
  String get getUserId => userUid;

  Future signIntoAccount(
      {required String email, required String password}) async {
    UserCredential userCredential =
        await auth.signInWithEmailAndPassword(email: email, password: password);

    userUid = userCredential.user!.uid;
    print(userUid);
    notifyListeners();
  }

  Future registerAccount(
      {required String email, required String password}) async {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);

    userUid = userCredential.user!.uid;
    print("Created new User Account $userUid");

    notifyListeners();
  }

  Future LogOutViaEmail() async {
    return auth.signOut();
  }

  Future signinWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final AuthCredential authCredential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(authCredential);

    final User? user = userCredential.user;
    assert(user!.uid != null);
    userUid = user!.uid;
    print("Google Sign In => $userUid");
  }

  Future SignOutGoogle() async {
    return googleSignIn.signOut();
  }
}
