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
          // TODO: refatorar sem esse map
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

  Future<Map<String, dynamic>> getSampleById(String sampleId) async {
    Map<String, dynamic> foundSample = {};
    await db.collection("samples")
        .where("id", isEqualTo: sampleId)
        .get()
        .then((querySnapshot) async {
      final samples = querySnapshot.docs;
      for (var sample in samples) {
        Map<String, dynamic> providerData = await getProviderById(sample.data()["provider"]);

        foundSample = {
          ...sample.data(),
          "providerData": providerData
        };
      }
    }, onError: (e) {
      debugPrint("Error querying database: $e");
    });
    return foundSample;
  }

  Future<Map<String, dynamic>> getProviderById(String providerId) async {
    Map<String, dynamic> foundProvider = {};
    await db.collection("users")
        .where("id", isEqualTo: providerId)
        .get()
        .then((querySnapshot) async {
      final users = querySnapshot.docs;
      for (var user in users) {
        foundProvider = user.data();
      }
    }, onError: (e) {
      debugPrint("Error querying database: $e");
    });
    return foundProvider;
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


          if (index != -1) {
            favoriteProviders.removeAt(index);
            favProvidersIds.removeAt(idIndex);
            notifyListeners();
          } else {
            favoriteProviders.add(newFavoriteProvider);
            favProvidersIds.add(newFavoriteProvider["id"]);
            notifyListeners();
          }

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
        debugPrint("Error querying database in addRemoveFavoriteProvider: $e");
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

  void addRemoveFavoriteSample(String newFavoriteSampleId, BuildContext context) async {
    try {
      await db.collection("users")
          .where("id", isEqualTo: auth.currentUser!.uid)
          .get()
          .then((querySnapshot) async {
        final users = querySnapshot.docs;
        for (var user in users) {
          favSamplesIds = List.from(user["favoriteSamples"]);

          int idIndex = favSamplesIds.indexWhere((id) => id == newFavoriteSampleId);

          if (idIndex != -1) {
            favSamplesIds.removeAt(idIndex);
            notifyListeners();
          } else {
            favSamplesIds.add(newFavoriteSampleId);
            notifyListeners();
          }

          await db.collection("users")
              .doc(auth.currentUser!.uid)
              .update({"favoriteSamples": favSamplesIds})
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

  Future<void>getFavoriteSamples() async {
    favoriteSamples = [];
    favSamplesIds = [];
    // notifyListeners();
    try{
      await db.collection("users")
          .where("id", isEqualTo: auth.currentUser!.uid)
          .get()
          .then((querySnapshot) async {
        final users = querySnapshot.docs;
        for (var user in users) {
          for(var sampleId in user["favoriteSamples"]) {
            Map<String, dynamic> favSample = await getSampleById(sampleId);
            if (favSample["publicationStatus"] == "Public") {
              favSamplesIds.add(sampleId);
              favoriteSamples.add(favSample);
            }
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