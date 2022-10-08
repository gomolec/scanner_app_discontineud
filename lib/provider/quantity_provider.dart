import 'package:flutter/material.dart';

class QuantityProvider extends ChangeNotifier {
  int actualValue = 0;
  int previousValue = 0;

  void setActual(int value) {
    if (value >= 0) {
      actualValue = value;
      notifyListeners();
    }
  }

  void setPrevious(int value) {
    if (value >= 0) {
      previousValue = value;
      notifyListeners();
    }
  }

  void setToPreviousValue() {
    actualValue = previousValue;
    notifyListeners();
  }

  void increment() {
    actualValue++;
    notifyListeners();
  }

  void decrement() {
    if (actualValue >= 0) {
      actualValue--;
      notifyListeners();
    }
  }
}
