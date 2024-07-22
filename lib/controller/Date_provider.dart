import 'package:flutter/material.dart';

class DateProvider with ChangeNotifier {
  DateTime? _selectedDate;
  TextEditingController _timedateController = TextEditingController();

  DateTime? get selectedDate => _selectedDate;
  TextEditingController get timedateController => _timedateController;

  void setDate(DateTime date) {
    _selectedDate = date;
    _timedateController.text =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    notifyListeners();
  }
}
