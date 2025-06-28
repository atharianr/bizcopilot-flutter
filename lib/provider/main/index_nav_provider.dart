import 'package:flutter/widgets.dart';

import '../../static/bottom_nav/bottom_nav.dart';

class IndexNavProvider extends ChangeNotifier {
  int _indexBottomNavBar = 0;

  int get indexBottomNavBar => _indexBottomNavBar;

  set setIndexBottomNavBar(int value) {
    if (value != BottomNav.add.index) {
      _indexBottomNavBar = value;
      notifyListeners();
    }
  }
}
