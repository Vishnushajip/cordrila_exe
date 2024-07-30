import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeProvider with ChangeNotifier {
  String _employeeCode = '';
  String _employeeName = '';
  String _currentPassword = '';
  bool _isLoading = false;

  String get employeeCode => _employeeCode;
  String get employeeName => _employeeName;
  String get currentPassword => _currentPassword;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> fetchEmployeeDetails(String empCode) async {
    _setLoading(true);
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('USERS')
          .where('EmpCode', isEqualTo: empCode)
          .get();

      if (querySnapshot.docs.isEmpty) {
        _employeeCode = empCode;
        _employeeName = 'Employee not found';
        _currentPassword = '';
      } else {
        _employeeCode = querySnapshot.docs.first['EmpCode'];
        _employeeName = querySnapshot.docs.first['Employee Name'];
        _currentPassword = querySnapshot.docs.first['Password'];
      }
    } catch (e) {
      _employeeCode = empCode;
      _employeeName = 'Error fetching employee details';
      _currentPassword = '';
    } finally {
      _setLoading(false);
    }
  }
}
