import 'package:bizcopilot_flutter/utils/extension_utils.dart';
import 'package:flutter/widgets.dart';

import '../../data/api/api_service.dart';
import '../../static/state/home_widgets_result_state.dart';

class HomeWidgetsProvider extends ChangeNotifier {
  final ApiServices _apiServices;

  HomeWidgetsProvider(this._apiServices);

  HomeWidgetsResultState _resultState = HomeWidgetsNoneState();

  HomeWidgetsResultState get resultState => _resultState;

  Future<void> getHomeWidgets() async {
    try {
      _resultState = HomeWidgetsLoadingState();
      notifyListeners();

      final result = await _apiServices.getHomeWidgets();
      print("result -> ${result.toJson()}");
      _resultState = HomeWidgetsLoadedState(
        result.data?.getHomeWidgets?.widgets ?? [],
      );
      notifyListeners();
    } catch (e) {
      _resultState = HomeWidgetsErrorState(e.getMessage());
      notifyListeners();
    }
  }
}
