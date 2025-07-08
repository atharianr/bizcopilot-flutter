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

      final allReports = result.data?.getMonthlyReports?.reports ?? [];

      // Filter today's reports
      final today = DateTime.now();
      final todayReports =
          allReports.where((report) {
            if (report.createdAt == null) return false;
            try {
              final createdDate = DateTime.parse(report.createdAt!);
              return createdDate.year == today.year &&
                  createdDate.month == today.month &&
                  createdDate.day == today.day;
            } catch (_) {
              return false;
            }
          }).toList();

      _resultState = DailyReportsLoadedState(todayReports, allReports);
      notifyListeners();
    } catch (e) {
      _resultState = DailyReportsErrorState(e.getMessage());
      notifyListeners();
    }
  }
}
