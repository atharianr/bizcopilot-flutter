import 'package:bizcopilot_flutter/static/state/monthly_reports_result_state.dart';
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
      final reports = result.data?.getMonthlyReports?.reports ?? [];
      _resultState = DailyReportsLoadedState(reports);
      notifyListeners();
    } catch (e) {
      _resultState = DailyReportsErrorState(e.getMessage());
      notifyListeners();
    }
  }

  MonthlyReportsResultState _monthlyReportsResultState =
      MonthlyReportsNoneState();

  MonthlyReportsResultState get monthlyReportsResultState =>
      _monthlyReportsResultState;

  Future<void> getMonthlyReports() async {
    try {
      _monthlyReportsResultState = MonthlyReportsLoadingState();
      notifyListeners();

      final result = await _apiServices.getDailyReports(30);
      final monthlyReports = result.data?.getMonthlyReports?.reports ?? [];
      _monthlyReportsResultState = MonthlyReportsLoadedState(monthlyReports);
      notifyListeners();
    } catch (e) {
      _monthlyReportsResultState = MonthlyReportsErrorState(e.getMessage());
      notifyListeners();
    }
  }
}
