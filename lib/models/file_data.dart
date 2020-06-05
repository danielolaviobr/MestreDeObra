import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FileData extends ChangeNotifier {
  String _downloadUrl;
  String _name;
  String _fileType;
  String _updated;

  get data => {
        'downloadUrl': _downloadUrl,
        'name': _name,
        'fileType': _fileType,
        'updated': _updated,
      };

  void updateData(downloadUrl, name, fileType, updated) {
    _downloadUrl = downloadUrl;
    _name = name;
    _fileType = fileType;
    _updated = updated;
    notifyListeners();
  }
}
