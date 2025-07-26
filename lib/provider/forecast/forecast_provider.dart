import 'package:bizcopilot_flutter/utils/extension_utils.dart';
import 'package:flutter/widgets.dart';

import '../../data/api/api_service.dart';
import '../../data/model/chart_model.dart';
import '../../data/model/chart_range_model.dart';
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

      final saleForecast = result.monthlyData?.forecastData;

      final saleForecastList =
          saleForecast
              ?.map((e) => ChartModel(DateTime.parse(e.x ?? ""), e.yhat ?? 0.0))
              .toList();

      final saleForecastRangeList =
          saleForecast
              ?.map(
                (e) => ChartRangeModel(
                  DateTime.parse(e.x ?? ""),
                  e.yhatLower ?? 0.0,
                  e.yhatUpper ?? 0.0,
                ),
              )
              .toList();

      final fullSummary = _buildFullSummary(result.monthlyData?.analysisResult);

      _saleResultState = SaleForecastLoadedState(
        saleForecastList ?? [],
        saleForecastRangeList ?? [],
        fullSummary,
      );
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

      final expenseForecast = result.monthlyData?.forecastData;

      final expenseForecastList =
          expenseForecast
              ?.map((e) => ChartModel(DateTime.parse(e.x ?? ""), e.yhat ?? 0.0))
              .toList();

      final expenseForecastRangeList =
          expenseForecast
              ?.map(
                (e) => ChartRangeModel(
                  DateTime.parse(e.x ?? ""),
                  e.yhatLower ?? 0.0,
                  e.yhatUpper ?? 0.0,
                ),
              )
              .toList();

      final fullSummary = _buildFullSummary(result.monthlyData?.analysisResult);

      _expenseResultState = ExpenseForecastLoadedState(
        expenseForecastList ?? [],
        expenseForecastRangeList ?? [],
        fullSummary,
      );
    } catch (e) {
      _expenseResultState = ExpenseForecastErrorState(e.getMessage());
    }

    notifyListeners();
  }
}
