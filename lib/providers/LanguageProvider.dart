import 'package:flutter/material.dart';

class Languageprovider with ChangeNotifier {
  bool _isChiFriendly = false;

  bool get isChiFriendly => _isChiFriendly;

  void toggleFriendly(bool isChi) {
    _isChiFriendly = isChi;
    notifyListeners();
  }
}