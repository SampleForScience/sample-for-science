import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sample/utils/test_emails.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SignInHandler {
  BuildContext context;
  SignInHandler(this.context);

  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  late bool registered;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  UserCredential? userCredential;
  List<String> testEmails = [];

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
      testEmails = emails;

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

      if (testEmails.contains(auth.currentUser!.email)) {
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
      } else {
        await FirebaseAuth.instance.signOut();
        Navigator.pushNamed(context, '/testing');
      }
    }
  }

  Future<void> signInWithApple() async {
    final db = FirebaseFirestore.instance;
    late bool registered;

    if (Platform.isIOS) {
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

      try{
        final rawNonce = generateNonce();
        final nonce = sha256ofString(rawNonce);

        final credential = await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
            webAuthenticationOptions: WebAuthenticationOptions(
                clientId: "br.uff.sampleforscienceid",
                redirectUri: Uri.parse("https://sampletest-4273e.firebaseapp.com/__/auth/handler")
            ),
            nonce: nonce
        );

        print("=================================== credential ===================================");
        print(credential);
        print("=================================== credential ===================================");

        // Create an `OAuthCredential` from the credential returned by Apple.
        final appleOauthProvider = OAuthProvider(
          "apple.com",
        );

        appleOauthProvider.setScopes([
          'email',
          'name',
        ]);

        final oauthCredential = appleOauthProvider.credential(
          idToken: credential.identityToken,
          rawNonce: rawNonce,
        );

        UserCredential auth = await FirebaseAuth.instance.signInWithCredential(oauthCredential);
        if (auth.user != null) {
          if (auth.user != null) {
            if (auth.user?.email == null &&
                credential.email != null) {
              await auth.user?.updateEmail(credential.email!);
            }

            if (auth.user?.displayName == null &&
                credential.givenName != null &&
                credential.familyName != null) {
              await auth.user?.updateDisplayName(
                  '${credential.givenName} ${credential.familyName}');
            }
          }

          String? displayName = auth.user?.displayName;
          String? email = auth.user?.email;
          String? uid = auth.user?.uid;
          String? photoUrl = auth.user?.photoURL??"";

          print("=================================== user ===================================");
          print("displayName: $displayName");
          print("email: $email");
          print("uid: $uid");
          print("photoUrl: $photoUrl");
          print("Logado");
          print("=================================== user ===================================");

          if (email != null && email.endsWith("privaterelay.appleid.com")) {
            await auth.user!.delete();
            Navigator.pushNamedAndRemoveUntil(context, '/instructions', (route) => false);
          } else {
            testEmails = emails;

            if (testEmails.contains(email)) {
              registered = await userFound();

              if (!registered) {
                await db.collection("users").doc(uid)
                    .set(
                    {
                      "id": uid,
                      "name": displayName,
                      "email": email,
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
            } else {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, '/testing');
            }
          }
        }
        else {
          FirebaseAuth.instance.signOut();
          print("Deslogado");
        }
      } catch (e) {
        print(e);
      }
    } else {
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

          if (email != null && email.endsWith("privaterelay.appleid.com")) {
            await auth.user!.delete();
            Navigator.pushNamedAndRemoveUntil(context, '/instructions', (route) => false);
          } else {
            testEmails = emails;

            if (testEmails.contains(email)) {
              registered = await userFound();

              if (!registered) {
                await db.collection("users").doc(auth.user!.uid)
                    .set(
                    {
                      "id": auth.user!.uid,
                      "name": auth.user!.displayName,
                      "email": auth.user!.email,
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
            } else {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, '/testing');
            }
          }
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

  Future<bool> checkUserLoggedIn() async {
    return auth.currentUser != null;
  }
}