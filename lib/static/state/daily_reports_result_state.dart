import 'package:bizcopilot_flutter/data/model/response/daily_reports_response.dart';

sealed class DailyReportsResultState {}

class DailyReportsNoneState extends DailyReportsResultState {}

class DailyReportsLoadingState extends DailyReportsResultState {}

class DailyReportsErrorState extends DailyReportsResultState {
  final String error;

  DailyReportsErrorState(this.error);
}

class DailyReportsLoadedState extends DailyReportsResultState {
  final List<DailyReports> data;

  DailyReportsLoadedState(this.data);
}
