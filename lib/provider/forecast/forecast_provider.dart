import 'package:bizcopilot_flutter/utils/extension_utils.dart';
import 'package:flutter/widgets.dart';

import '../../data/api/api_service.dart';
import '../../data/model/response/forecast_response.dart';
import '../../static/state/expense_forecast_result_state.dart';
import '../../static/state/sale_forecast_result_state.dart';

class ForecastProvider extends ChangeNotifier {
  final ApiServices _apiServices;

  ForecastProvider(this._apiServices);

  // Sale Forecast State
  SaleForecastResultState _saleResultState = SaleForecastNoneState();

  SaleForecastResultState get saleResultState => _saleResultState;

  // Expense Forecast State
  ExpenseForecastResultState _expenseResultState = ExpenseForecastNoneState();

  ExpenseForecastResultState get expenseResultState => _expenseResultState;

  // Common helper for building summary text
  String _buildFullSummary(AnalysisResult? analysis) {
    final summary = analysis?.summary ?? '';
    final recommendations = (analysis?.recommendations ?? [])
        .map((e) => '• $e')
        .join('\n');
    final narrative = analysis?.narrative ?? '';

    return '''
$summary

Recommendations:
$recommendations

$narrative
'''.trim();
  }

  // Fetch Sale Forecast
  Future<void> getSaleForecast() async {
    _saleResultState = SaleForecastLoadingState();
    notifyListeners();

    try {
      final result = await _apiServices.getSaleForecast("-6.2088", "106.8456");
      final fullSummary = _buildFullSummary(result.monthlyData?.analysisResult);

      _saleResultState = SaleForecastLoadedState(result, fullSummary);
    } catch (e) {
      _saleResultState = SaleForecastErrorState(e.getMessage());
    }

    notifyListeners();
  }

  // Fetch Expense Forecast
  Future<void> getExpenseForecast() async {
    _expenseResultState = ExpenseForecastLoadingState();
    notifyListeners();

    try {
      final result = await _apiServices.getExpenseForecast(
        "-6.2088",
        "106.8456",
      );
      final fullSummary = _buildFullSummary(result.monthlyData?.analysisResult);

      _expenseResultState = ExpenseForecastLoadedState(result, fullSummary);
    } catch (e) {
      _expenseResultState = ExpenseForecastErrorState(e.getMessage());
    }

    notifyListeners();
  }
}
