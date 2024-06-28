import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminRequestProvider with ChangeNotifier {
  List<Map<String, dynamic>> _requests = [];
  List<Map<String, dynamic>> _filteredRequests = [];
  bool _isLoading = false;
  bool _isViewed = false;

  List<Map<String, dynamic>> get requests => _requests;
  List<Map<String, dynamic>> get filteredRequests => _filteredRequests;
  bool get isLoading => _isLoading;
  bool get isViewed => _isViewed;

  Future<void> fetchRequests() async {
    _isLoading = true;
    notifyListeners();

    final querySnapshot = await FirebaseFirestore.instance.collection('requests').get();
    _requests = querySnapshot.docs.map((doc) => doc.data()).toList();
    _filteredRequests = _requests;

    _isLoading = false;
    notifyListeners();
  }

  void filterRequests(String query) {
    if (query.isEmpty) {
      _filteredRequests = _requests;
    } else {
      _filteredRequests = _requests.where((request) {
        return request['userId'].toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  Future<void> deleteRequest(String id) async {
    await FirebaseFirestore.instance.collection('requests').doc(id).delete();
    _requests.removeWhere((request) => request['id'] == id);
    _filteredRequests = _requests;
    notifyListeners();
  }

  void markAsViewed() {
    _isViewed = true;
    notifyListeners();
  }
}
