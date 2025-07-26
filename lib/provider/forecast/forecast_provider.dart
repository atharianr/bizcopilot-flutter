import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';

import '../../data/api/api_service.dart';
import '../../data/model/chart_model.dart';
import '../../data/model/chart_range_model.dart';
import '../../data/model/response/forecast_response.dart';
import '../../static/state/expense_forecast_result_state.dart';
import '../../static/state/sale_forecast_result_state.dart';
import '../../utils/extension_utils.dart';
import '../../utils/location_service.dart';

class ForecastProvider extends ChangeNotifier {
  final ApiServices _apiServices;

  ForecastProvider(this._apiServices);

  // Sale
  SaleForecastResultState _saleResultState = SaleForecastNoneState();

  SaleForecastResultState get saleResultState => _saleResultState;

  // Expense
  ExpenseForecastResultState _expenseResultState = ExpenseForecastNoneState();

  ExpenseForecastResultState get expenseResultState => _expenseResultState;

  Future<(String, String)> _resolveLatLong({String? lat, String? long}) async {
    if (lat != null && long != null) return (lat, long);

    try {
      final Position pos = await LocationService.getCurrentLocation();
      return (pos.latitude.toString(), pos.longitude.toString());
    } catch (e) {
      // Fallback (Jakarta) – replace with what you want
      debugPrint('Location error: $e. Falling back to default coords.');
      return ("-6.2088", "106.8456");
    }
  }

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

  Future<void> getSaleForecast({String? lat, String? long}) async {
    _saleResultState = SaleForecastLoadingState();
    notifyListeners();

    try {
      final (resolvedLat, resolvedLong) = await _resolveLatLong(
        lat: lat,
        long: long,
      );

      final result = await _apiServices.getSaleForecast(
        resolvedLat,
        resolvedLong,
      );

      final saleForecast = result.monthlyData?.forecastData;

      final saleForecastList =
          saleForecast
              ?.map((e) => ChartModel(DateTime.parse(e.x ?? ""), e.yhat ?? 0.0))
              .toList() ??
          [];

      final saleForecastRangeList =
          saleForecast
              ?.map(
                (e) => ChartRangeModel(
                  DateTime.parse(e.x ?? ""),
                  e.yhatLower ?? 0.0,
                  e.yhatUpper ?? 0.0,
                ),
              )
              .toList() ??
          [];

      final fullSummary = _buildFullSummary(result.monthlyData?.analysisResult);

      _saleResultState = SaleForecastLoadedState(
        saleForecastList,
        saleForecastRangeList,
        fullSummary,
      );
    } catch (e) {
      _saleResultState = SaleForecastErrorState(e.getMessage());
    }

    notifyListeners();
  }

  Future<void> getExpenseForecast({String? lat, String? long}) async {
    _expenseResultState = ExpenseForecastLoadingState();
    notifyListeners();

    try {
      final (resolvedLat, resolvedLong) = await _resolveLatLong(
        lat: lat,
        long: long,
      );

      final result = await _apiServices.getExpenseForecast(
        resolvedLat,
        resolvedLong,
      );

      final expenseForecast = result.monthlyData?.forecastData;

      final expenseForecastList =
          expenseForecast
              ?.map((e) => ChartModel(DateTime.parse(e.x ?? ""), e.yhat ?? 0.0))
              .toList() ??
          [];

      final expenseForecastRangeList =
          expenseForecast
              ?.map(
                (e) => ChartRangeModel(
                  DateTime.parse(e.x ?? ""),
                  e.yhatLower ?? 0.0,
                  e.yhatUpper ?? 0.0,
                ),
              )
              .toList() ??
          [];

      final fullSummary = _buildFullSummary(result.monthlyData?.analysisResult);

      _expenseResultState = ExpenseForecastLoadedState(
        expenseForecastList,
        expenseForecastRangeList,
        fullSummary,
      );
    } catch (e) {
      _expenseResultState = ExpenseForecastErrorState(e.getMessage());
    }

    notifyListeners();
  }
}
