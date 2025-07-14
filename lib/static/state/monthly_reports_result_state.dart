import 'package:bizcopilot_flutter/data/model/response/daily_reports_response.dart';

sealed class MonthlyReportsResultState {}

class MonthlyReportsNoneState extends MonthlyReportsResultState {}

class MonthlyReportsLoadingState extends MonthlyReportsResultState {}

class MonthlyReportsErrorState extends MonthlyReportsResultState {
  final String error;

  MonthlyReportsErrorState(this.error);
}

class MonthlyReportsLoadedState extends MonthlyReportsResultState {
  final List<Reports> reports;

  MonthlyReportsLoadedState(this.reports);
}
