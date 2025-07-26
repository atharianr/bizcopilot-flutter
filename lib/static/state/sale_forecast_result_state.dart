import '../../data/model/chart_model.dart';
import '../../data/model/chart_range_model.dart';

sealed class SaleForecastResultState {}

class SaleForecastNoneState extends SaleForecastResultState {}

class SaleForecastLoadingState extends SaleForecastResultState {}

class SaleForecastErrorState extends SaleForecastResultState {
  final String error;

  SaleForecastErrorState(this.error);
}

class SaleForecastLoadedState extends SaleForecastResultState {
  final List<ChartModel> listData;
  final List<ChartRangeModel> listRangeData;
  final String summary;

  SaleForecastLoadedState(this.listData, this.listRangeData, this.summary);
}
