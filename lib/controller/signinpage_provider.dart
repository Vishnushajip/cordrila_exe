import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier {
  TextEditingController empCodeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  bool get isPasswordVisible => _isPasswordVisible;

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  @override
  void dispose() {
    empCodeController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
