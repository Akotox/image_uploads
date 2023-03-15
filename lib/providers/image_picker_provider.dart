
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageNotifier extends ChangeNotifier {
  List<XFile> _images = [];

  List<XFile> get images => _images;

  void addImage(XFile image) {
    _images.add(image);
    notifyListeners();
  }

  void removeImage(int index) {
    _images.removeAt(index);
    notifyListeners();
  }

  void removeAll() {
    _images.clear();
    notifyListeners();
  }
}
