import 'package:flutter/material.dart';

class UpdateProvider with ChangeNotifier {
  double _progress = 0.0;
  bool _isUpdateAlertShown = false;
  bool _isUpdating = false;

  double get progress => _progress;
  bool get isUpdateAlertShown => _isUpdateAlertShown;
  bool get isUpdating => _isUpdating;

  void setProgress(double value) {
    _progress = value;
    notifyListeners();
  }

  void setUpdateAlertShown(bool value) {
    _isUpdateAlertShown = value;
    notifyListeners();
  }

  void setUpdating(bool value) {
    _isUpdating = value;
    notifyListeners();
  }
}
