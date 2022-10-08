import 'package:flutter/material.dart';

class SearchBarProvider extends ChangeNotifier {
  bool isSearching = false;
  String searchQuery = '';

  void toggleSearching() {
    isSearching = !isSearching;
    searchQuery = '';
    notifyListeners();
  }

  void updateQuery(String query) {
    searchQuery = query;
    notifyListeners();
  }
}
