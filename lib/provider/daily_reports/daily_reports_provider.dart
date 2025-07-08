import 'package:bizcopilot_flutter/utils/extension_utils.dart';
import 'package:flutter/widgets.dart';

import '../../data/api/api_service.dart';
import '../../static/state/daily_reports_result_state.dart';

class DailyReportsProvider extends ChangeNotifier {
  final ApiServices _apiServices;

  DailyReportsProvider(this._apiServices);

  DailyReportsResultState _resultState = DailyReportsNoneState();

  DailyReportsResultState get resultState => _resultState;

  Future<void> getDailyReports() async {
    try {
      _resultState = DailyReportsLoadingState();
      notifyListeners();

      final result = await _apiServices.getDailyReports();
      _resultState = DailyReportsLoadedState(
        result.data?.getMonthlyReports?.reports ?? [],
      );
      notifyListeners();
    } catch (e) {
      _resultState = DailyReportsErrorState(e.getMessage());
      notifyListeners();
    }
  }
}
