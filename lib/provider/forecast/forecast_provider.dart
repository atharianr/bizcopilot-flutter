import 'package:bizcopilot_flutter/utils/extension_utils.dart';
import 'package:flutter/widgets.dart';

import '../../data/api/api_service.dart';
import '../../screen/forecast/forecast_screen.dart';
import '../../static/state/expense_forecast_result_state.dart';
import '../../static/state/sale_forecast_result_state.dart';

class ForecastProvider extends ChangeNotifier {
  final ApiServices _apiServices;

  ForecastProvider(this._apiServices);

  // Sale Forecast State
  SaleForecastResultState _saleResultState = SaleForecastNoneState();

  SaleForecastResultState get saleResultState => _saleResultState;

  String _saleForecastSummary = "";

  String get saleForecastSummary => _saleForecastSummary;

  // Expense Forecast State
  ExpenseForecastResultState _expenseResultState = ExpenseForecastNoneState();

  ExpenseForecastResultState get expenseResultState => _expenseResultState;

  String _expenseForecastSummary = "";

  String get expenseForecastSummary => _expenseForecastSummary;

  // Fetch Sale Forecast
  Future<void> getSaleForecast() async {
    try {
      _saleResultState = SaleForecastLoadingState();
      notifyListeners();

      final result = await _apiServices.getSaleForecast("-6.2088", "106.8456");
      _saleResultState = SaleForecastLoadedState(result);
      _saleForecastSummary = result.monthlyData?.analysisResult?.summary ?? "";
      notifyListeners();
    } catch (e) {
      _saleResultState = SaleForecastErrorState(e.getMessage());
      notifyListeners();
    }
  }

  // Fetch Expense Forecast
  Future<void> getExpenseForecast() async {
    try {
      _expenseResultState = ExpenseForecastLoadingState();
      notifyListeners();

      final result = await _apiServices.getExpenseForecast(
        "-6.2088",
        "106.8456",
      );
      _expenseResultState = ExpenseForecastLoadedState(result);
      _expenseForecastSummary =
          result.monthlyData?.analysisResult?.summary ?? "";
      notifyListeners();
    } catch (e) {
      _expenseResultState = ExpenseForecastErrorState(e.getMessage());
      notifyListeners();
    }
  }
}
