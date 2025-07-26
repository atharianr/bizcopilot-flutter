import 'package:bizcopilot_flutter/data/model/chart_model.dart';
import 'package:bizcopilot_flutter/data/model/chart_range_model.dart';

sealed class ExpenseForecastResultState {}

class ExpenseForecastNoneState extends ExpenseForecastResultState {}

class ExpenseForecastLoadingState extends ExpenseForecastResultState {}

class ExpenseForecastErrorState extends ExpenseForecastResultState {
  final String error;

  ExpenseForecastErrorState(this.error);
}

class ExpenseForecastLoadedState extends ExpenseForecastResultState {
  final List<ChartModel> listData;
  final List<ChartRangeModel> listRangeData;
  final String summary;

  ExpenseForecastLoadedState(this.listData, this.listRangeData, this.summary);
}
