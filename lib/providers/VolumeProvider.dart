import 'package:flutter/material.dart';

class VolumeProvider with ChangeNotifier {
  double _volume = 1.0;

  double get volume => _volume;

  void setVolume(double vol) {
    _volume = vol;
    notifyListeners();
  }
}