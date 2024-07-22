import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WelcomeMessageProvider extends ChangeNotifier {
  String _welcomeMessage = "";
  bool _isLoading = true;
  bool _updateRequired = false;

  String get welcomeMessage => _welcomeMessage;
  bool get isLoading => _isLoading;
  bool get updateRequired => _updateRequired;

  WelcomeMessageProvider() {
    fetchWelcomeMessage();
  }

  Future<void> fetchWelcomeMessage() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot snapshot =
        await firestore.collection('Update').doc('Jpd9ptJT6f1o57Fr7Xbl').get();

    if (snapshot.exists && snapshot.data() != null) {
      var data = snapshot.data() as Map<String, dynamic>;
      if (data.containsKey('Welcome')) {
        _welcomeMessage = data['Welcome'];
      } else {
        _welcomeMessage = "";
      }

      if (data.containsKey('Remote') && data['Remote'] == true) {
        _updateRequired = true;
      }
    } else {
      _welcomeMessage = "Welcome message not available.";
    }
    _isLoading = false;
    notifyListeners();
  }
}