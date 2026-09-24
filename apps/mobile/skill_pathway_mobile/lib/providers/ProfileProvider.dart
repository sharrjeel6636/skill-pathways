import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  String _name = "Sharjeel";
  String get name => _name;

  void setName(String name) {
    _name = name;
    notifyListeners();
  }
}
