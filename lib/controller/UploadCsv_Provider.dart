import 'package:flutter/foundation.dart';

class ExcelUploadProvider extends ChangeNotifier {
  Uint8List? _pickedFileBytes;
  String _uploadStatus = '';

  Uint8List? get pickedFileBytes => _pickedFileBytes;
  String get uploadStatus => _uploadStatus;

  void setPickedFileBytes(Uint8List? bytes) {
    _pickedFileBytes = bytes;
    notifyListeners();
  }

  void setUploadStatus(String status) {
    _uploadStatus = status;
    notifyListeners();
  }
}
