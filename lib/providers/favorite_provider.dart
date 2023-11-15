import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  final db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  List<Map<String, dynamic>>favoriteProviders = [];

  void addRemoveFavoriteProvider(Map<String, dynamic> newFavoriteProvider, BuildContext context) async {
    favoriteProviders = [];
    try{
      await db.collection("users")
          .where("id", isEqualTo: auth.currentUser!.uid)
          .get()
          .then((querySnapshot) async {
        final users = querySnapshot.docs;
        for (var user in users) {
          if (user["favoriteProviders"].any((list) => list["id"] == newFavoriteProvider["id"])) {
            favoriteProviders.removeWhere((list) => list["id"] == newFavoriteProvider["id"]);
            notifyListeners();
            Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
          } else {
            favoriteProviders = [...user["favoriteProviders"], newFavoriteProvider];
            notifyListeners();
            Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
          }
        }
      }, onError: (e) {
        debugPrint("Error completing: $e");
      });

      await db.collection("users")
          .doc(auth.currentUser!.uid)
          .update({"favoriteProviders": favoriteProviders})
          .then((_) {
        debugPrint("New favorite saved");
      }).onError((e, _) {
        debugPrint("Error saving sample: $e");
      });
    } catch(e) {
      debugPrint('error in getFavoriteProviders(): $e');
    }
  }

  Future<void>getFavoriteProviders() async {
    favoriteProviders = [];
    notifyListeners();
    try{
      await db.collection("users")
          .where("id", isEqualTo: auth.currentUser!.uid)
          .get()
          .then((querySnapshot) async {
        final users = querySnapshot.docs;
        for (var user in users) {
          favoriteProviders = [...user["favoriteProviders"]];
          notifyListeners();
        }
      }, onError: (e) {
        debugPrint("Error completing: $e");
      });
    } catch(e) {
      debugPrint('error in getFavoriteProviders(): $e');
    }
  }
}