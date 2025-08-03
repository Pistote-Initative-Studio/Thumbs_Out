import 'package:flutter/foundation.dart';

class MatchLogic extends ChangeNotifier {
  int blueCount = 0;
  int redCount = 0;
  bool active = false;

  void start() {
    blueCount = 0;
    redCount = 0;
    active = true;
    notifyListeners();
  }

  void stop() {
    active = false;
    notifyListeners();
  }

  void tapBlue() {
    if (!active) return;
    blueCount++;
    notifyListeners();
  }

  void tapRed() {
    if (!active) return;
    redCount++;
    notifyListeners();
  }
}
