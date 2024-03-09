import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleSignInHandler {
  BuildContext context;
  AppleSignInHandler(this.context);

  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  late bool registered;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  UserCredential? userCredential;

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) =>
    charset[random.nextInt(charset.length)]).join();
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> signInWithApple() async {
    try{
      // final rawNonce = generateNonce();
      // final nonce = sha256ofString(rawNonce);
      //
      // final credential = await SignInWithApple.getAppleIDCredential(
      //     scopes: [
      //       AppleIDAuthorizationScopes.email,
      //       AppleIDAuthorizationScopes.fullName,
      //     ],
      //     webAuthenticationOptions: WebAuthenticationOptions(
      //         clientId: "br.uff.sampleforscienceid",
      //         redirectUri: Uri.parse("https://sampletest-4273e.firebaseapp.com/__/auth/handler")
      //     ),
      //     nonce: nonce
      // );
      //
      // print("=====================================================================");
      // print(credential);
      // print("=====================================================================");


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
}


// import 'dart:io';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'dart:convert';
// import 'dart:math';
//
// import 'package:crypto/crypto.dart';
// import 'package:flutter/material.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
//
// class AppleSignInHandler {
//   BuildContext context;
//   AppleSignInHandler(this.context);
//
//   String generateNonce([int length = 32]) {
//     const charset =
//         '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
//     final random = Random.secure();
//     return List.generate(length, (_) =>
//     charset[random.nextInt(charset.length)]).join();
//   }
//
//   String sha256ofString(String input) {
//     final bytes = utf8.encode(input);
//     final digest = sha256.convert(bytes);
//     return digest.toString();
//   }
//
//   Future<User?> signInWithApple() async {
//     try {
//       /// You have to put your service id here which you can find in previous steps
//       /// or in the following link: https://developer.apple.com/account/resources/identifiers/list/serviceId
//       String clientID = 'br.uff.sampleforscienceid';
//
//       /// Now you have to put the redirectURL which you received from Glitch Server
//       /// make sure you only copy the part till "https://<GLITCH PROVIDED UNIQUE NAME>.glitch.me/"
//       /// and append the following part to it "callbacks/sign_in_with_apple"
//       ///
//       /// It will look something like this
//       /// https://<GLITCH PROVIDED UNIQUE NAME>.glitch.me/callbacks/sign_in_with_apple
//       String redirectURL = "https://sampletest-4273e.firebaseapp.com/__/auth/handler";
//           // 'https://faithful-carbonated-gojirasaurus.glitch.me/callbacks/sign_in_with_apple';
//
//       /// Generates a Random String from 1-9 and A-Z characters.
//       final rawNonce = generateNonce();
//
//       /// We are convering that rawNonce into SHA256 for security purposes
//       /// In our login.
//       final nonce = sha256ofString(rawNonce);
//
//       final appleCredential = await SignInWithApple.getAppleIDCredential(
//
//         /// Scopes are the values that you are requiring from
//         /// Apple Server.
//         scopes: [
//           AppleIDAuthorizationScopes.email,
//           AppleIDAuthorizationScopes.fullName,
//         ],
//         nonce: Platform.isIOS ? nonce : null,
//
//         /// We are providing Web Authentication for Android Login,
//         /// Android uses web browser based login for Apple.
//         webAuthenticationOptions: Platform.isIOS
//             ? null
//             : WebAuthenticationOptions(
//           clientId: clientID,
//           redirectUri: Uri.parse(redirectURL),
//         ),
//       );
//
//       final AuthCredential appleAuthCredential = OAuthProvider('apple.com').credential(
//         idToken: appleCredential.identityToken,
//         rawNonce: Platform.isIOS ? rawNonce : null,
//         accessToken: Platform.isIOS ? null : appleCredential.authorizationCode,
//       );
//
//       /// Once you are successful in generating Apple Credentials,
//       /// We pass them into the Firebase function to finally sign in.
//       UserCredential userCredential =
//       await FirebaseAuth.instance.signInWithCredential(appleAuthCredential);
//
//       Navigator.pushNamedAndRemoveUntil(context, '/search', (route) => false);
//
//       print(userCredential);
//       return userCredential.user;
//
//     } catch (e) {
//       rethrow;
//     }
//   }
// }