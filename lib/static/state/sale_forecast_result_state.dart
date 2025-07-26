import 'package:bizcopilot_flutter/data/model/response/forecast_response.dart';

sealed class SaleForecastResultState {}

class SaleForecastNoneState extends SaleForecastResultState {}

class SaleForecastLoadingState extends SaleForecastResultState {}

class SaleForecastErrorState extends SaleForecastResultState {
  final String error;

  SaleForecastErrorState(this.error);
}

class SaleForecastLoadedState extends SaleForecastResultState {
  final ForecastResponse data;
  final String summary;

  SaleForecastLoadedState(this.data, this.summary);
}
