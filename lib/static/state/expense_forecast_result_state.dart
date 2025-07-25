import 'package:bizcopilot_flutter/data/model/response/forecast_response.dart';

sealed class ExpenseForecastResultState {}

class ExpenseForecastNoneState extends ExpenseForecastResultState {}

class ExpenseForecastLoadingState extends ExpenseForecastResultState {}

class ExpenseForecastErrorState extends ExpenseForecastResultState {
  final String error;

  ExpenseForecastErrorState(this.error);
}

class ExpenseForecastLoadedState extends ExpenseForecastResultState {
  final ForecastResponse data;

  ExpenseForecastLoadedState(this.data);
}
