import 'package:flutter/material.dart';

class QuantityProvider extends ChangeNotifier {
  int actualValue;
  int previousValue;

  QuantityProvider({
    required this.actualValue,
    required this.previousValue,
  });

  void setValue(int value) {
    if (value > 0) {
      actualValue = value;
      notifyListeners();
    }
  }

  void setPreviousValue() {
    actualValue = previousValue;
    notifyListeners();
  }

  void increment() {
    actualValue++;
    notifyListeners();
  }

  void decrement() {
    if (actualValue > 0) {
      actualValue--;
      notifyListeners();
    }
  }
}
