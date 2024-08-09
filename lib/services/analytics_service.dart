import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class AnalyticsService {
  static final _instance = FirebaseAnalytics.instance;

  static Future<void> appOpen() async {
    _instance.logAppOpen().then((value) => debugPrint("appOpen ++"));
  }

  static Future<void> signUp(String signUpMethod) async {
    await _instance.logSignUp(signUpMethod: signUpMethod).then((value) => debugPrint("signUp ++"));
  }

  static Future<void> logIn(String loginMethod) async {
    await _instance.logLogin(loginMethod: loginMethod).then((value) => debugPrint("logIn ++"));
  }

  static Future<void> search(String searchTerm) async {
    await _instance.logSearch(searchTerm: searchTerm).then((value) => debugPrint("search {searchTerm: $searchTerm} ++"));
  }

  static Future<void> screenView(String screenName) async {
    await _instance.logScreenView(screenName: screenName).then((value) => debugPrint("screenView {screenName: $screenName} ++"));
  }

  static Future<void> viewItem(String item, String provider) async {
    await _instance.logViewItem(parameters: {"item": item, "provider": provider}).then((value) => debugPrint("viewItem {item: $item, provider: $provider}++"));
  }
}