import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SampleProvider extends ChangeNotifier {
  final db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> mySamples = [];
  List<Map<String, dynamic>>favoriteProviders = [];
  List<String> favProvidersIds = [];
  List<Map<String, dynamic>>favoriteSamples = [];
  List<String> favSamplesIds = [];

  Future<void>getMySamples() async {
    mySamples = [];
    notifyListeners();

    late Map<String, dynamic> sampleData;
    try{
      await db.collection("samples")
          .where("provider", isEqualTo: auth.currentUser!.uid)
          .get()
          .then((querySnapshot) async {
        final samples = querySnapshot.docs;
        for (var sample in samples) {
          sampleData = {
            "id": sample.data()["id"],
            "provider": sample.data()["provider"],
            "number": sample.data()["number"],
            "code": sample.data()["code"],
            "formula": sample.data()["formula"],
            "keywords": sample.data()["keywords"],
            "type": sample.data()["type"],
            "otherType": sample.data()["otherType"],
            "morphology": sample.data()["morphology"],
            "otherMorphology": sample.data()["otherMorphology"],
            "previousDiffraction": sample.data()["previousDiffraction"],
            "previousThermal": sample.data()["previousThermal"],
            "previousOptical": sample.data()["previousOptical"],
            "otherPrevious": sample.data()["otherPrevious"],
            "doi": sample.data()["doi"],
            "suggestionDiffraction": sample.data()["suggestionDiffraction"],
            "suggestionThermal": sample.data()["suggestionThermal"],
            "suggestionOptical": sample.data()["suggestionOptical"],
            "otherSuggestions": sample.data()["otherSuggestions"],
            "hazardous": sample.data()["hazardous"],
            "animals": sample.data()["animals"],
            "image": sample.data()["image"],
            "publicationStatus": sample.data()["publicationStatus"],
            "registration": sample.data()["registration"],
            "ProviderData": sample.data()["providerData"],
          };
          mySamples.add(sampleData);
          notifyListeners();
        }
      }, onError: (e) {
        debugPrint("Error completing: $e");
      });
    } catch(e) {
      debugPrint('error in getMySample(): $e');
    }
  }

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

          // debugPrint(favProvidersIds.toString());

          if (index != -1) {
            favoriteProviders.removeAt(index);
            favProvidersIds.removeAt(idIndex);
            notifyListeners();
          } else {
            favoriteProviders.add(newFavoriteProvider);
            favProvidersIds.add(newFavoriteProvider["id"]);
            notifyListeners();
          }

          // debugPrint(favProvidersIds.toString());

          await db.collection("users")
              .doc(auth.currentUser!.uid)
              .update({"favoriteProviders": favoriteProviders})
              .then((_) {
            debugPrint("Favorite updated");
          }).onError((e, _) {
            debugPrint("Error updating favorite: $e");
          });

          getFavoriteProviders();
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
    favProvidersIds = [];
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

  // TODO: Adicionar só id das amostras
  void addRemoveFavoriteSample(Map<String, dynamic> newFavoriteSample, BuildContext context) async {
    try {
      await db.collection("users")
          .where("id", isEqualTo: auth.currentUser!.uid)
          .get()
          .then((querySnapshot) async {
        final users = querySnapshot.docs;
        for (var user in users) {
          var favoriteSamples = List.from(user["favoriteSamples"]);

          int index = favoriteSamples.indexWhere((list) => list["id"] == newFavoriteSample["id"]);
          int idIndex = favSamplesIds.indexWhere((list) => list == newFavoriteSample["id"]);

          if (index != -1) {
            favoriteSamples.removeAt(index);
            favSamplesIds.removeAt(idIndex);
            notifyListeners();
          } else {
            favoriteSamples.add(newFavoriteSample);
            favSamplesIds.add(newFavoriteSample["id"]);
            notifyListeners();
          }

          await db.collection("users")
              .doc(auth.currentUser!.uid)
              .update({"favoriteSamples": favoriteSamples})
              .then((_) {
            debugPrint("Favorite samples updated");
          }).onError((e, _) {
            debugPrint("Error updating favorite samples: $e");
          });

          getFavoriteSamples();
        }
      }, onError: (e) {
        debugPrint("Error querying database: $e");
      });
    } catch (e) {
      debugPrint('Error in addRemoveFavoriteSample(): $e');
    }
  }

  // TODO: Buscar amostras por id e mostrar se publivationStatus for Public
  Future<void>getFavoriteSamples() async {
    favoriteSamples = [];
    favSamplesIds = [];
    notifyListeners();
    try{
      await db.collection("users")
          .where("id", isEqualTo: auth.currentUser!.uid)
          .get()
          .then((querySnapshot) async {
        final users = querySnapshot.docs;
        for (var user in users) {
          favoriteSamples = [...user["favoriteSamples"]];

          for (var favSample in user["favoriteSamples"]) {
            favSamplesIds.add(favSample["id"]);
          }

          notifyListeners();
        }
      }, onError: (e) {
        debugPrint("Error completing: $e");
      });
    } catch(e) {
      debugPrint('error in getFavoriteSamples(): $e');
    }
  }
}