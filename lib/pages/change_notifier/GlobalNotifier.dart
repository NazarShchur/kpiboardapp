import 'package:flutter/cupertino.dart';

class GlobalNotifier extends ChangeNotifier {
  Map<String, dynamic> filters = {};

  void setFilter(Map<String, dynamic> filters) {
    this.filters = filters;
    notifyListeners();
  }

  void update() {
     notifyListeners();
  }
}