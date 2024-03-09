import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInHandler {
  BuildContext context;
  SignInHandler(this.context);

  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  late bool registered;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  UserCredential? userCredential;

  Future<bool> userFound() async {
    late bool found;
    await db.collection("users")
      .doc(auth.currentUser!.uid)
      .get()
      .then((docSnapshot) {
        if(docSnapshot.exists) {
          found = true;
        } else {
          found = false;
        }
      },
      onError: (e) => debugPrint("Error completing: $e"),
    );
    return found;
  }

  Future<void> signInWithGoogle() async {
    if (auth.currentUser != null) {
      try {
        await auth.signOut();
        await googleSignIn.signOut();
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        debugPrint('Deslogado');
      } catch(e) {
        debugPrint("ERRO deslogando:\n$e");
      }
    } else {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      debugPrint('googleUser: $googleUser');
      debugPrint('googleAuth: $googleAuth');
      userCredential = await auth.signInWithCredential(credential);

      registered = await userFound();

      if (!registered) {
        await db.collection("users").doc(auth.currentUser!.uid)
            .set(
            {
              "id": auth.currentUser!.uid,
              "name": auth.currentUser!.displayName,
              "email": auth.currentUser!.email,
              "institution": "",
              "department": "",
              "country": "",
              "address": "",
              "mobile": "",
              "webpage": "",
              "orcid": "",
              "google_scholar": "",
              "other": "",
              "favoriteProviders": [],
              "favoriteSamples": [],
            }
        ).then((_) {
          debugPrint("New user saved");
          Navigator.pushNamedAndRemoveUntil(context, '/search', (route) => false);
        }
        ).onError((e, _) {
          debugPrint("Error saving user: $e");
        });
      } else {
        debugPrint("User already registered");
        Navigator.pushNamedAndRemoveUntil(context, '/search', (route) => false);
      }
    }
  }

  Future<void> signInWithApple() async {
    try{
      final appleProvider = AppleAuthProvider();
      UserCredential auth = await FirebaseAuth.instance.signInWithProvider(appleProvider);

      if (auth.user != null) {
        String? displayName = auth.user?.displayName;
        String? email = auth.user?.email;
        String? uid = auth.user?.uid;
        String? photoUrl = auth.user?.photoURL??"";

        print("=====================================================================");

        print("displayName: $displayName");
        print("email: $email");
        print("uid: $uid");
        print("photoUrl: $photoUrl");
        print("Logado");

        print("=====================================================================");


        // TODO: se o email for apple..., mandar pra outra página
        Navigator.pushNamedAndRemoveUntil(context, '/search', (route) => false);
      }
      else {
        FirebaseAuth.instance.signOut();
        print("Deslogado");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> checkUserLoggedIn() async {
    return auth.currentUser != null;
  }
}