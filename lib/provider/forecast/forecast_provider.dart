import 'package:bizcopilot_flutter/utils/extension_utils.dart';
import 'package:flutter/widgets.dart';

import '../../data/api/api_service.dart';
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

  // Fetch Sale Forecast
  Future<void> getSaleForecast() async {
    try {
      _saleResultState = SaleForecastLoadingState();
      notifyListeners();

      final result = await _apiServices.getSaleForecast("", "");
      _saleResultState = SaleForecastLoadedState(result);
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

      final result = await _apiServices.getExpenseForecast("", "");
      _expenseResultState = ExpenseForecastLoadedState(result);
      notifyListeners();
    } catch (e) {
      _expenseResultState = ExpenseForecastErrorState(e.getMessage());
      notifyListeners();
    }
  }
}
