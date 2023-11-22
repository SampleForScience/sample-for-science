import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  final db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  List<Map<String, dynamic>>favoriteProviders = [];
  List<String> favProvidersIds = [];
  List<Map<String, dynamic>>favoriteSamples = [];
  // implementar comparação comos id também nas amostras
  List<String> favSamplesIds = [];

  void addRemoveFavoriteProvider(Map<String, dynamic> newFavoriteProvider, BuildContext context) async {
    try {
      await db.collection("users")
          .where("id", isEqualTo: auth.currentUser!.uid)
          .get()
          .then((querySnapshot) async {
        final users = querySnapshot.docs;
        for (var user in users) {
          var favoriteProviders = List.from(user["favoriteProviders"]);

          int index = favoriteProviders.indexWhere((list) => list["id"] == newFavoriteProvider["id"]);
          int idIndex = favProvidersIds.indexWhere((list) => list == newFavoriteProvider["id"]);

          debugPrint(favProvidersIds.toString());

          if (index != -1) {
            favoriteProviders.removeAt(index);
            favProvidersIds.removeAt(idIndex);
          } else {
            favoriteProviders.add(newFavoriteProvider);
            favProvidersIds.add(newFavoriteProvider["id"]);
          }

          debugPrint(favProvidersIds.toString());

          await db.collection("users")
              .doc(auth.currentUser!.uid)
              .update({"favoriteProviders": favoriteProviders})
              .then((_) {
            debugPrint("Favorite updated");
          }).onError((e, _) {
            debugPrint("Error updating favorite: $e");
          });
          // TODO: atualizar favoritos sem mudar de página
          notifyListeners();
          // Future.delayed(Duration.zero, (){
          //   Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
          // });
        }
      }, onError: (e) {
        debugPrint("Error querying database: $e");
      });
    } catch (e) {
      debugPrint('Error in addRemoveFavoriteProvider(): $e');
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
          for (var id in user["favoriteProviders"]) {
            favProvidersIds.add(id["id"]);
            debugPrint(favProvidersIds.toString());
          }
          notifyListeners();
        }
      }, onError: (e) {
        debugPrint("Error completing: $e");
      });
    } catch(e) {
      debugPrint('error in getFavoriteProviders(): $e');
    }
  }

  void addRemoveFavoriteSample(Map<String, dynamic> newFavoriteSample, BuildContext context) async {
    try {
      await db.collection("users")
          .where("id", isEqualTo: auth.currentUser!.uid)
          .get()
          .then((querySnapshot) async {
        final users = querySnapshot.docs;
        for (var user in users) {
          var favoriteSamples = List.from(user["favoriteSamples"]);

          var index = favoriteSamples.indexWhere((list) => list["id"] == newFavoriteSample["id"]);

          if (index != -1) {
            favoriteSamples.removeAt(index);
          } else {
            favoriteSamples.add(newFavoriteSample);
          }

          await db.collection("users")
              .doc(auth.currentUser!.uid)
              .update({"favoriteSamples": favoriteSamples})
              .then((_) {
            debugPrint("Favorite samples updated");
          }).onError((e, _) {
            debugPrint("Error updating favorite samples: $e");
          });
          // TODO: atualizar favoritos sem mudar de página
          notifyListeners();
          // Future.delayed(Duration.zero, (){
          //   Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
          // });
        }
      }, onError: (e) {
        debugPrint("Error querying database: $e");
      });
    } catch (e) {
      debugPrint('Error in addRemoveFavoriteSample(): $e');
    }
  }

  Future<void>getFavoriteSamples() async {
    favoriteSamples = [];
    notifyListeners();
    try{
      await db.collection("users")
          .where("id", isEqualTo: auth.currentUser!.uid)
          .get()
          .then((querySnapshot) async {
        final users = querySnapshot.docs;
        for (var user in users) {
          favoriteSamples = [...user["favoriteSamples"]];
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