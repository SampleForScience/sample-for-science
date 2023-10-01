import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sample/routes/app_pages.dart';

class LoginController extends GetxController {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  UserCredential? userCredential;

  Future<bool> userFound() async {
    await db.collection("users")
      .where("id", isEqualTo: "auth.currentUser!.uid")
      .get()
      .then((querySnapshot) {
        if(querySnapshot.size > 0) {
          return true;
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    return false;
  }

  Future<void> signInWithGoogle() async {
    if (auth.currentUser != null) {
      try {
        await auth.signOut();
        Get.snackbar(
          "Desconectado",
          "",
          backgroundColor: Colors.white,
        );
        update();
        Get.offAndToNamed(Routes.LOGIN);
        await googleSignIn.signOut();
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
      update();

      bool registered = await userFound();

      if (registered) {
        await db.collection("users").doc(auth.currentUser!.uid)
        .set(
          {
            "id": auth.currentUser!.uid,
            "name": auth.currentUser!.displayName,
            "email": auth.currentUser!.email
          }
        ).then((_) {
            debugPrint("User saved");
            Get.offAndToNamed(Routes.DASHBOARD);
          }
        ).onError((e, _) {
          debugPrint("Error saving user: $e");
        });
      }

      Get.offAndToNamed(Routes.DASHBOARD);
    }
    debugPrint('userCredential: $userCredential');
    debugPrint('auth: $auth');
    debugPrint('email: ${userCredential!.user!.email}');

    update();
  }

  Future<bool> checkUserLoggedIn() async {
    return auth.currentUser != null;
  }
}